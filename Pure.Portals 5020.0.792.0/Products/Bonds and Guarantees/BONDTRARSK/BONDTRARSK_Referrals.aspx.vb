Imports CMS.Library
Imports System.Web.Configuration.WebConfigurationManager
Imports Nexus.Library
Imports System.Web.Configuration
Imports Nexus.Utils
Imports System.Web.HttpContext
Imports Nexus.Constants.Session
Imports Nexus.Constants.Constant
Imports System.Xml.XPath
Imports System.Xml
Imports System.Data.SqlClient
Imports System.IO
Imports System.Net
Imports System.Linq


Namespace Nexus
    Partial Class PB2_BONDTRARSK_Referrals : Inherits BaseRisk
        Protected iMode As Integer
        Private coverNoteBookKey As Integer = 0
        Dim oWebService As NexusProvider.ProviderBase = Nothing
        Dim FinishButtonClick As Boolean

		Enum LifecycleEvent
            PostDataSetWrite
            PreDataSetWrite
            Page_Load
            Page_LoadComplete
            btnFinish_Click
            btnNext_Click
            Render
            Page_Init
        End Enum
        
		Public Enum DataType As Integer
            DT_Date = 1
            DT_Integer = 2
            DT_Text = 5	'Note - includes String & Label
            DT_Comment = 7
            DT_Checkbox = 20
            DT_Currency = 21
            DT_Percentage = 22
        End Enum
		
		Protected eLifecycleEvent As LifecycleEvent
		
        Public Overrides Sub PostDataSetWrite()
			eLifecycleEvent = LifecycleEvent.PostDataSetWrite
			CallRuleScripts()
        End Sub

        Public Overrides Sub PreDataSetWrite()
			eLifecycleEvent = LifecycleEvent.PreDataSetWrite
			CallRuleScripts()
        End Sub

		Protected Shadows Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
			eLifecycleEvent = LifecycleEvent.Page_Init
			CallRuleScripts()
        End Sub
        
		
		Protected Shadows Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            Me.Page.ClientScript.RegisterStartupScript(Me.GetType, "DoLogicStartup", "enableNext(false); BuildComponents(); DoLogic(true); GetLastDivPosition(); enableNext(true);", True)

            If Session(CNQuoteMode) = QuoteMode.ReQuote Then
                Session(CNQuoteMode) = QuoteMode.FullQuote
            End If

            Dim oQuote As NexusProvider.Quote = Session(CNQuote)
            FinishButtonClick = False

			eLifecycleEvent = LifecycleEvent.Page_Load
			CallRuleScripts()
			
			'If first page, remove Back and Finish buttons -- Derick 2019/07/08
			If String.IsNullOrEmpty(ctrlTabIndex.PreviousTab) Then			
				btnFinish.Visible = False
				btnBack.Visible = False			
				btnFinishTop.Visible = False
				btnBackTop.Visible = False
			End If
        End Sub
		
		Protected Shadows Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
            Dim oQuote As NexusProvider.Quote = Session(CNQuote)

            ' Output the XMLDataSet
            XMLDataSet.Text = oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset.Replace("'", "\'").Replace(vbCr, "").Replace(vbLf, "")

            ' Remove DTD Details - Comment in when Ali has made his mods
            XMLDataSet.Text = XMLDataSet.Text.Substring(0, XMLDataSet.Text.IndexOf("<!DOCTYPE DATA_SET")) & XMLDataSet.Text.Substring(XMLDataSet.Text.IndexOf("<DATA_SET"))

            ' Output the IO Number
			Dim oOI As Collections.Stack
			oOI = Session.Item(CNOI)
			If Not oOI is Nothing Then
				If oOI.Count > 0 Then
					ThisOI.Text = oOI.Peek
				End If
			End If

			eLifecycleEvent = LifecycleEvent.Page_LoadComplete
			CallRuleScripts()
		End Sub

        Protected Sub btnFinish_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinish.Click
            If Page.IsValid Then
                FinishButtonClick = True
                Dim oQuote As NexusProvider.Quote = Session(CNQuote)
                'oQuote.PolicyStatusCode = cboPolicyStatus.Value
                'If ValidTime(PCATLIN__INCEPTIONTIME.Text) = True Then
                '    POLICYHEADER__COVERSTARTDATE.Text = POLICYHEADER__COVERSTARTDATE.Text & " " & PCATLIN__INCEPTIONTIME.Text
                'End If
            End If
			eLifecycleEvent = LifecycleEvent.btnFinish_Click
			CallRuleScripts()
		End Sub

        Protected Sub btnNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
            If Page.IsValid Then
                Dim oQuote As NexusProvider.Quote = Session(CNQuote)
                'oQuote.PolicyStatusCode = cboPolicyStatus.Value
                'If ValidTime(PCATLIN__INCEPTIONTIME.Text) = True Then
                '    POLICYHEADER__COVERSTARTDATE.Text = POLICYHEADER__COVERSTARTDATE.Text & " " & PCATLIN__INCEPTIONTIME.Text
                'End If
            End If
			eLifecycleEvent = LifecycleEvent.btnNext_Click
			CallRuleScripts()
        End Sub
		
        Protected Overrides Sub Render(ByVal writer As HtmlTextWriter)
            'Dim PickListOverrideScripts As String = ("<script src='" & (ResolveClientUrl("~/App_Themes/Catlin/js/PickList.js") & "' type='text/javascript'></script>"))
            'Me.Page.ClientScript.RegisterStartupScript(Me.GetType, "PickListOverrideScripts", PickListOverrideScripts, False)
            'Me.Page.ClientScript.RegisterStartupScript(Me.GetType, "AddValuesToPickList", "addValueToList('ctl00_cntMainBody_PCATLIN__ENDORSEMENTS_PckTemplates_AvailList');", True)
            MyBase.Render(writer)
			eLifecycleEvent = LifecycleEvent.Render
			CallRuleScripts()
        End Sub

		' Fix for pressing the back button when the previous page is main details.
		Public Overrides Sub BackButtonRedirect()
            If String.IsNullOrEmpty(ctrlTabIndex.PreviousTab) = False Then
                Dim urlSegments As String() = ctrlTabIndex.PreviousTab.Split("/")

                If urlSegments.Length > 2 Then
                    Dim aspxPage As String = urlSegments(urlSegments.Length - 1)

                    For i As Integer = urlSegments.Length - 1 To 2 Step -1
                        Dim testUrl As String = String.Join("/", urlSegments, 0, i) + "/" + aspxPage

                        Dim physicalPath As String = Server.MapPath(testUrl)

                        If System.IO.File.Exists(physicalPath) Then
                            Response.Redirect(testUrl)
                            Exit For
                        End If
                    Next
                End If
            End If
        End Sub

		Protected Function GetTransactionType() As String
			If String.IsNullOrEmpty(Session(CNMTAType)) = False Then
			
				If Session(CNMTAType) = MTAType.CANCELLATION Then
					Return "MTC"
				End If

				If Session(CNMTAType) = MTAType.REINSTATEMENT Then
					Return "MTR"
				End If

				If Session(CNMTAType) = MTAType.TEMPORARY Then
					Return "MTATEMP"
				End If

				Return "MTA"
			End If
			
			'	Renewal
			If String.IsNullOrEmpty(Session(CNRenewal)) = False Then
				Return "REN"
			End If
			
			Return CType(Session.Item(Nexus.Constants.Session.CNQuote), NexusProvider.Quote).TransactionType.ToString()
		End Function

		'Remove all empty attributes which are numeric datatypes (inc checkbox)
        Protected Sub StripEmptyAttributes(ByVal sDataSetDefinition As String, ByRef xmlData As String, dataModelCode As String)

            Dim xDoc As XmlDocument = New XmlDocument()
            xDoc.LoadXml(xmlData)

            Dim DSDDoc As XmlDocument = New XmlDocument()
            DSDDoc.LoadXml(sDataSetDefinition)

            'Create a list of empty attributes.
            Dim attrList As XmlNodeList = xDoc.SelectNodes("//@*[not(string())]")

            For i As Integer = 0 To attrList.Count - 1
                Dim attr As XmlAttribute = CType(attrList(i), XmlAttribute)
                If Not attr Is Nothing Then
                    'Obtain the attribute's owner (the containing node, really)
                    Dim elem As XmlElement = attr.OwnerElement
                    If Not elem Is Nothing Then

                        'Now attempt to locate this attribute - by name - in the Data Set Definition
                        Dim selectStr = String.Format("//{0}/{0}.{1}", elem.Name, attr.Name)

                        Dim node As XmlNode = DSDDoc.SelectSingleNode(selectStr)
                        If Not node Is Nothing Then
							'Having located it, retrieve it's datatype
                            Dim data_Type_Str As String = node.Attributes.GetNamedItem("DataType").Value
                            Dim data_Type As Integer = 0

                            'Check that the retrieved datatype is indeed one of our chosen numeric ones.
                            'If so, remove the attribute.
                            If Not String.IsNullOrEmpty(data_Type_Str) AndAlso Int32.TryParse(data_Type_Str, data_Type) Then
                                Select Case data_Type
                                    Case DataType.DT_Integer, DataType.DT_Checkbox, DataType.DT_Currency, DataType.DT_Percentage
                                        elem.RemoveAttributeNode(attr)
                                End Select
                            End If
                        End If
                    End If
                End If
            Next

            xmlData = xDoc.OuterXml

        End Sub
		
		Protected Function IsLastTab() As Boolean
            IsLastTab = String.IsNullOrEmpty(ctrlTabIndex.NextTab)
        End Function
		
		Protected Sub onValidate_REFERRALS__BTREFER()
        
End Sub
Protected Sub onValidate_Button_btnSendApproval()
        		
End Sub
Protected Sub onValidate_Button_btnRequestApproval()
        		
End Sub
Protected Sub CallRuleScripts()
    onValidate_REFERRALS__BTREFER()
    onValidate_Button_btnSendApproval()
    onValidate_Button_btnRequestApproval()
End Sub

		    
        Private Sub CreateDeclinedTask(sender As Object, e As EventArgs) Handles btnFinish.Click, btnNext.Click, btnFinishTop.Click, btnNextTop.Click
        	Dim sGroupCode As String = String.Empty
        	Dim NumDeclinedRefs As Integer = 0
        	Dim sRefStatusCode As String = String.Empty
        	Dim oQuote As NexusProvider.Quote = CType(Session(CNQuote), NexusProvider.Quote)
        	Dim sDataSetDefinition As String = Nexus.DataSetFunctions.GetDataSetDefinition(Current.Session(CNDataModelCode))
        	Dim sDataSet As String = oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset
        	Dim objDataSet As New SiriusFS.SAM.Client.DataSetControl.Application
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        	Dim sXMLDataset As String = DirectCast(oQuote.Risks(0).XMLDataset, System.Object)
        	Dim sCurrentUserLevel As String = "U" & REFERRALS__UserLevel.Text
        	
        	Try
        		objDataSet.LoadFromXML(sDataSetDefinition, sDataSet)
        		'Loop through  referrals and check if there are any declined referrals
        		If objDataSet.Risk.Item("REFERRALS").Count("REFERRAL_DETAILS") > 0 Then
        			For iCount = 1 To objDataSet.Risk.Item("REFERRALS").Count("REFERRAL_DETAILS")
        				sRefStatusCode = GetPMLookupItemCodefromID("UDL_REF_STATUS", objDataSet.Risk.Item("REFERRALS").Item("REFERRAL_DETAILS", iCount).Item("RefStatus").Value)
        				If sRefStatusCode = "DECLINED" Then
        					NumDeclinedRefs = NumDeclinedRefs + 1
        				End If
        			Next iCount
        		End If
        	Catch
        	Finally
        		objDataSet = Nothing
        		oQuote = Nothing
        		oWebService = Nothing
        	End Try
        			
        	sGroupCode = "U" & REFERRALS__MinimumApprovalLevel.Text
        	If NumDeclinedRefs > 0 Then
        		If sGroupCode = sCurrentUserLevel Then
        			Call CreateDeclinedWorkManager(sGroupCode)
        		End If
        	End If
        End Sub
        
        Private Sub CreateDeclinedWorkManager(ByVal sGroupCode As String)
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        	Dim oworkManagerCollection As New NexusProvider.WorkManagerCollection
        	Dim oWorkManager As New NexusProvider.WorkManager
        	Dim oParty As NexusProvider.BaseParty = Session.Item(CNParty)
        	Dim oUserDetails As NexusProvider.UserDetails = Session(CNAgentDetails)
        	Dim sOpen As String = Session(CNWMMode)
        	Dim oClaimOpen As NexusProvider.ClaimOpen = Session.Item(CNClaim)
        	oWorkManager.DueDate = DateTime.Now.Date
        	oWorkManager.Client = "System"
        	Dim sInsuredName As String = String.Empty
        	Dim sSenderName As String = GetValue("GENERAL", "LOGGEDINUSERFULLNAME")
        	Dim sTransactionType As String = GetTransactionType()
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        
        	'Get Insured's Name               
        	Select Case True
        		Case TypeOf oParty Is NexusProvider.CorporateParty
        			With CType(oParty, NexusProvider.CorporateParty)
        				sInsuredName = .CompanyName
        				oWorkManager.Client = .ClientSharedData.ShortName.Trim()
        			End With
        
        		Case TypeOf oParty Is NexusProvider.PersonalParty
        			With CType(oParty, NexusProvider.PersonalParty)
        				sInsuredName = .Title & " " & .Forename & " " & .Lastname
        				oWorkManager.Client = .ClientSharedData.ShortName.Trim()
        			End With
        	End Select
        
        	If sTransactionType = "NB" Or sTransactionType = "MTA" Then
        		oWorkManager.Description = sSenderName & " has declined quote no " & oQuote.InsuranceFileRef & " for " & sInsuredName & ". Please review the quote details."
        		If sTransactionType = "NB" Then
        			oWorkManager.Task = "UNDERNB"
        		End If
        		If sTransactionType = "MTA" Then
        			oWorkManager.Task = "UnderMTA"
        		End If
        		oWorkManager.TaskGroup = "UNDER"
        	ElseIf sTransactionType = "REN" Then
        		oWorkManager.Description = sSenderName & " has declined quote no " & oQuote.InsuranceFileRef & " for " & sInsuredName & ". Please review the quote details."
        		oWorkManager.Task = "RENAMEND"
        		oWorkManager.TaskGroup = "UWRENEWAL"
        	End If
        	oWorkManager.AllocationUserGroup = "SFORU"
        	oWorkManager.AllocationUser = "(Any Group Member)"
        	oWorkManager.IsUrgent = True
        	oWorkManager.IsUrgentForUpdate = 1
        	oWorkManager.IsComplete = False
        	oWorkManager.IsTaskReview = False
        	If Session(CNQuote) IsNot Nothing Then
        		Dim oWmrk As New NexusProvider.KeyData
        		oWmrk.KeyName = "INSURANCEFILEKEY"
        		oWmrk.KeyValue = oQuote.InsuranceFileKey
        		oWorkManager.KeyData.Add(oWmrk)
        	End If
        
        	Try
        		If oWorkManager.TaskGroup IsNot Nothing Then
        			oWebService.CreateWmTask(oWorkManager)
        		End If
        	Catch ex As System.Exception
        	Finally
        		oWebService = Nothing
        	End Try
        
        End Sub
    
        
                Private Sub btnSendApproval_Click(sender As Object, e As EventArgs) Handles btnSendApproval.Click
                    Dim sURLNew As String = HttpContext.Current.Request.Url.ToString()
                    WriteRisk()
                    Call ApproveReferral()
        
                    'Update all controls with data from the new dataset
                    If HttpContext.Current.Session.IsCookieless Then
                        Dim iIndex As Integer = sURLNew.IndexOf(AppSettings("WebRoot"))
                        iIndex = iIndex + Convert.ToInt16(Convert.ToString(AppSettings("WebRoot")).Length)
                        sURLNew = sURLNew.Insert(iIndex, "(S(" & Session.SessionID.ToString() + "))/")
                        Response.Redirect(sURLNew)
                    Else
                        Response.Redirect(sURLNew)
                    End If
                    ScriptManager.RegisterStartupScript(Me, [GetType](), "showalert", "alert('Approval Sent');", True)
        
                End Sub
        
                Private Sub ApproveReferral()
                    Dim sGroupCode As String = String.Empty
                    Dim strEmailAddresses As String
                    Dim oQuote As NexusProvider.Quote = CType(Session(CNQuote), NexusProvider.Quote)
                    Dim sDataSetDefinition As String = Nexus.DataSetFunctions.GetDataSetDefinition(Current.Session(CNDataModelCode))
                    Dim sDataSet As String = oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset
                    Dim objDataSet As New SiriusFS.SAM.Client.DataSetControl.Application
                    Dim dToday = DateTime.Now
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                    Dim sUser As String = String.Empty
                    Dim sUserFullName As String = String.Empty
                    Dim oUserDetails As NexusProvider.UserDetails
                    Dim sXMLDataset As String = DirectCast(oQuote.Risks(0).XMLDataset, System.Object)
                    Dim sURL = String.Empty
                    Dim sRefStatusCode As String = String.Empty
                    Dim iRefStatusId As Integer = GetListId("PMLookup", "UDL_REF_STATUS", "APPROVED")
                    Try
                        objDataSet.LoadFromXML(sDataSetDefinition, sDataSet)
                        'Loop through  referrals
                        If objDataSet.Risk.Item("REFERRALS").Count("REFERRAL_DETAILS") > 0 Then
                            For iCount = 1 To objDataSet.Risk.Item("REFERRALS").Count("REFERRAL_DETAILS")
                                sRefStatusCode = GetPMLookupItemCodefromID("UDL_REF_STATUS", objDataSet.Risk.Item("REFERRALS").Item("REFERRAL_DETAILS", iCount).Item("RefStatus").Value)
                                If sRefStatusCode = "AWAITAPPRO" Then
                                    objDataSet.Risk.Item("REFERRALS").Item("REFERRAL_DETAILS", iCount).Item("RefApprovalNote").Value = objDataSet.Risk.Item("REFERRALS").Item("ApproverComment").Value
                                    objDataSet.Risk.Item("REFERRALS").Item("REFERRAL_DETAILS", iCount).Item("RefApprovalBy").Value = objDataSet.Risk.Item("GENERAL").Item("LoggedInUserFullName").Value
                                    objDataSet.Risk.Item("REFERRALS").Item("REFERRAL_DETAILS", iCount).Item("RefDateApproved").Value = objDataSet.Risk.Item("POLICY").Item("ApprovalDate").Value
                                    objDataSet.Risk.Item("REFERRALS").Item("REFERRAL_DETAILS", iCount).Item("RefTimeApproved").Value = dToday.ToShortDateString()
                                    objDataSet.Risk.Item("REFERRALS").Item("REFERRAL_DETAILS", iCount).Item("RefStatus").Value = iRefStatusId
                                    sUser = objDataSet.Risk.Item("REFERRALS").Item("REFERRAL_DETAILS", iCount).Item("ReferralOrigin").Value.ToString
                                    sUserFullName = objDataSet.Risk.Item("REFERRALS").Item("REFERRAL_DETAILS", iCount).Item("ReferralOriginName").Value.ToString
                                End If
                            Next iCount
                            objDataSet.ReturnAsXML(sDataSet)
                            oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset = sDataSet
                            Session(CNQuote) = oQuote
                        End If
                        If sUser <> "" Then
                            oUserDetails = oWebService.GetUserDetails(sUser)
                            sGroupCode = oUserDetails.AvailableUsergroups(0).Code.Trim()
                            strEmailAddresses = oUserDetails.EmailAddress
                            Call CreateWorkManagerForGenerator(sGroupCode, sUser)
                            If Not strEmailAddresses Is Nothing Then
                                Call SendEmailToGenerator(strEmailAddresses.ToString, sUserFullName)
                            End If
        
                        End If
                    Catch
                    Finally
                        objDataSet = Nothing
                        oQuote = Nothing
                        oWebService = Nothing
                        oUserDetails = Nothing
                    End Try
        
                End Sub
        
                Protected Sub SendEmailToGenerator(ByVal sRecipientEmail As String, ByVal sRecipientName As String)
        
                    Dim oParty As NexusProvider.BaseParty = Session.Item(CNParty)
                    Dim sSubject As String = String.Empty
                    Dim sMessage As String = String.Empty
                    Dim sCCemail As String = String.Empty
                    Dim sbCCemail As String = String.Empty
                    Dim sDefaultSenderEmail = "NoReply@ssp.com"
                    Dim sSenderEmail As String = String.Empty
                    Dim sSenderName As String = GetValue("GENERAL", "LOGGEDINUSERFULLNAME")
                    Dim sInsuredName As String = String.Empty
                    Dim bEmailSent As Boolean = False
                    Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        
                    'Get logged in user Name
                    If Session(CNAgentDetails) IsNot Nothing Then
                        'get the logged in user name from session
                        If CType(Session(CNAgentDetails), NexusProvider.UserDetails).EmailAddress.ToString <> "" Then
                            sSenderEmail = CType(Session(CNAgentDetails), NexusProvider.UserDetails).EmailAddress.ToString
                        Else
                            sSenderEmail = sDefaultSenderEmail
                        End If
        
                        sbCCemail = sSenderEmail
                    End If
        
                    'Get Insured's Name               
                    Select Case True
        
                        Case TypeOf oParty Is NexusProvider.CorporateParty
                            With CType(oParty, NexusProvider.CorporateParty)
                                sInsuredName = .CompanyName
                            End With
        
                        Case TypeOf oParty Is NexusProvider.PersonalParty
                            With CType(oParty, NexusProvider.PersonalParty)
                                sInsuredName = .Title & " " & .Forename & " " & .Lastname
                            End With
                    End Select
        
        
                    'Receipient
                    sCCemail = sSenderEmail
        
                    'Build e-mail subject          
                    sSubject = "Policy Referral - " & oQuote.InsuranceFileRef & " for " & sInsuredName
        
        
                    'Build e-mail subject          
                    sMessage = "Hi " & sRecipientName & vbCrLf & vbCrLf
                    sMessage = sMessage & "Quotation reference " & oQuote.InsuranceFileRef & " for " & sInsuredName & " which you referred for approval has been actioned. Please proceed to finalise the quote."
                    sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                    sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
        
                    'set up the job to send emails to the requested addresses
                    'create an html file on the disk in the temp docs directory, with contents taken from the body textbox
                    Dim sFileName As String = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).TempFileLocation & "\" & Guid.NewGuid.ToString & ".html"
                    Dim emailBodyFile As New System.IO.StreamWriter(sFileName)
        
                    'form html formatted string by replacing line breaks with "<br />" and adding basic html tags
                    Dim sHtml As String = "<html><body>" & Replace(Convert.ToString(sMessage), Chr(13) & Chr(10), "<br />") & "</body></html>"
                    emailBodyFile.Write(sHtml)
                    emailBodyFile.Close()
        
                    Dim xlJob As System.Xml.Linq.XElement =
                                                               <BACKGROUND_JOB>
                                                                   <JOB jobtype="DOCUPACK">
                                                                       <PARAMETERS>
                                                                           <PARAMETER name="emailTo" value=<%= sRecipientEmail %>/>
                                                                           <PARAMETER name="emailCc" value=<%= sCCemail %>/>
                                                                           <PARAMETER name="emailSubject" value=<%= sSubject %>/>
                                                                           <PARAMETER name="Destination" value="email"/>
                                                                           <PARAMETER name="path" value=<%= sFileName %>/>
                                                                           <PARAMETER name="PartyCnt" value=<%= oParty.Key %>/>
                                                                           <PARAMETER name="InsuranceFileCnt" value=<%= oQuote.InsuranceFileKey %>/>
                                                                       </PARAMETERS>
                                                                       <ITEMS>
                                                                       </ITEMS>
                                                                   </JOB>
                                                               </BACKGROUND_JOB>
        
        
                    Dim strJob As String = xlJob.ToString 'this will be used as input to the WFC Service call
                    Dim sDescription As String = "Referral Action Email"
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        
                    'call WCF Service to queue the docs for Archiving
                    Dim iBackgroundJobID As Integer = oWebService.CreateBackgroundJob(sDescription, strJob, Now.Date)
        
                    oQuote = Nothing
                    oWebService = Nothing
                End Sub
        
                Private Sub CreateWorkManagerForGenerator(ByVal sGroupCode As String, ByRef sUser As String)
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                    Dim oworkManagerCollection As New NexusProvider.WorkManagerCollection
                    Dim oWorkManager As New NexusProvider.WorkManager
                    Dim oParty As NexusProvider.BaseParty = Session.Item(CNParty)
                    Dim oUserDetails As NexusProvider.UserDetails = Session(CNAgentDetails)
                    Dim sOpen As String = Session(CNWMMode)
                    Dim oClaimOpen As NexusProvider.ClaimOpen = Session.Item(CNClaim)
                    oWorkManager.DueDate = DateTime.Now.Date
                    oWorkManager.Client = "System"
                    Dim sInsuredName As String
                    Dim sTransactionType As String = GetTransactionType()
                    Dim oQuote As NexusProvider.Quote = Session(CNQuote)
                    Dim sXMLDataset As String = DirectCast(oQuote.Risks(0).XMLDataset, System.Object)
        
                    'Get Insured's Name               
                    Select Case True
        
                        Case TypeOf oParty Is NexusProvider.CorporateParty
                            With CType(oParty, NexusProvider.CorporateParty)
                                sInsuredName = .CompanyName
                                oWorkManager.Client = .ClientSharedData.ShortName.Trim()
                            End With
        
                        Case TypeOf oParty Is NexusProvider.PersonalParty
                            With CType(oParty, NexusProvider.PersonalParty)
                                sInsuredName = .Title & " " & .Forename & " " & .Lastname
                                oWorkManager.Client = .ClientSharedData.ShortName.Trim()
                            End With
                    End Select
        
                    If sTransactionType = "NB" Or sTransactionType = "MTA" Then
                        oWorkManager.Description = "Quote number " + oQuote.InsuranceFileRef + " which you referred for approval has been actioned. Please proceed to finalise the quote"
                        If sTransactionType = "NB" Then
                            oWorkManager.Task = "UNDERNB"
                        End If
                        If sTransactionType = "MTA" Then
                            oWorkManager.Task = "UnderMTA"
                        End If
                        oWorkManager.TaskGroup = "UNDER"
                    ElseIf sTransactionType = "REN" Then
                        oWorkManager.Description = "Renewal Quote number " + oQuote.InsuranceFileRef + " which you referred for approval has been actioned. Please proceed to finalise the quote"
                        oWorkManager.Task = "RENAMEND"
                        oWorkManager.TaskGroup = "UWRENEWAL"
                    End If
                    oWorkManager.AllocationUserGroup = "SFORU"
                    oWorkManager.AllocationUser = "(Any Group Member)"
        
                    oWorkManager.IsUrgent = True
                    oWorkManager.IsUrgentForUpdate = 1
                    oWorkManager.IsComplete = False
                    oWorkManager.IsTaskReview = False
                    If Session(CNQuote) IsNot Nothing Then
                        Dim oWmrk As New NexusProvider.KeyData
                        oWmrk.KeyName = "INSURANCEFILEKEY"
                        oWmrk.KeyValue = oQuote.InsuranceFileKey
                        oWorkManager.KeyData.Add(oWmrk)
                    End If
        
                    Try
                        If oWorkManager.TaskGroup IsNot Nothing Then
                            oWebService.CreateWmTask(oWorkManager)
                        End If
                    Catch ex As System.Exception
                    Finally
                        oWebService = Nothing
                        oworkManagerCollection = Nothing
                        oParty = Nothing
                        oWorkManager = Nothing
                        sXMLDataset = Nothing
                        oQuote = Nothing
                    End Try
        
                End Sub
        
    
              Private Sub btnRequestApproval_Click(sender As Object, e As EventArgs) Handles btnRequestApproval.Click
                    Dim sGroupCode As String = String.Empty
                    Dim sURLNew As String = HttpContext.Current.Request.Url.ToString()
                    sGroupCode = "U" & REFERRALS__MinimumApprovalLevel.Text
                    Call RequestApproval(sGroupCode)
        
                    'Update all controls with data from the new dataset
                    If HttpContext.Current.Session.IsCookieless Then
                        Dim iIndex As Integer = sURLNew.IndexOf(AppSettings("WebRoot"))
                        iIndex = iIndex + Convert.ToInt16(Convert.ToString(AppSettings("WebRoot")).Length)
                        sURLNew = sURLNew.Insert(iIndex, "(S(" & Session.SessionID.ToString() + "))/")
                        Response.Redirect(sURLNew)
                    Else
                        Response.Redirect(sURLNew)
                    End If
                    ScriptManager.RegisterStartupScript(Me, [GetType](), "showalert", "alert('Request Sent');", True)
                End Sub
        
        
                Private Sub RequestApproval(ByVal sGroupCode As String)
                    Dim oQuote As NexusProvider.Quote = CType(Session(CNQuote), NexusProvider.Quote)
                    Dim sDataSetDefinition As String = Nexus.DataSetFunctions.GetDataSetDefinition(Current.Session(CNDataModelCode))
                    Dim sDataSet As String = oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset
                    Dim objDataSet As New SiriusFS.SAM.Client.DataSetControl.Application
                    Dim dToday = DateTime.Now
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                    Dim oUserDetails As NexusProvider.UserDetails
                    Dim oUsersList As NexusProvider.UserCollection
        
        
                    Dim sXMLDataset As String = DirectCast(oQuote.Risks(0).XMLDataset, System.Object)
                    Dim sURL = String.Empty
                    Dim sRefStatusCode As String = String.Empty
                    Dim iRefStatusId As Integer = GetListId("PMLookup", "UDL_REF_STATUS", "AWAITAPPRO")
        
                    Try
                        objDataSet.LoadFromXML(sDataSetDefinition, sDataSet)
        
                        If sGroupCode <> "" Then
                            ' oUsersList = oWebService.GetUserGroupUsers(sGroupCode, DateTime.Now(), True, True)
                            ' If oUsersList IsNot Nothing Then
                                ' For iUserCount As Integer = 0 To oUsersList.Count - 1
                                    ' If oUsersList(iUserCount).EmailAddress <> "" Then
                                        ' SendApprovalRequest(oUsersList(iUserCount).EmailAddress, oUsersList(iUserCount).FullName)
                                    ' End If
                                ' Next
                            ' End If
                            Call CreateWorkManager(sGroupCode)
                            End If
        
                            'Loop through  referrals and update referral status to awaiting approval
                            If objDataSet.Risk.Item("REFERRALS").Count("REFERRAL_DETAILS") > 0 Then
                            For iCount = 1 To objDataSet.Risk.Item("REFERRALS").Count("REFERRAL_DETAILS")
                                sRefStatusCode = GetPMLookupItemCodefromID("UDL_REF_STATUS", objDataSet.Risk.Item("REFERRALS").Item("REFERRAL_DETAILS", iCount).Item("RefStatus").Value)
                                If sRefStatusCode = "APPREQ" Then
                                    objDataSet.Risk.Item("REFERRALS").Item("REFERRAL_DETAILS", iCount).Item("RefStatus").Value = iRefStatusId
                                End If
                            Next iCount
                            objDataSet.ReturnAsXML(sDataSet)
                            oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset = sDataSet
                            Session(CNQuote) = oQuote
                        End If
                    Catch
                    Finally
                        objDataSet = Nothing
                        oQuote = Nothing
                        oWebService = Nothing
                        oUserDetails = Nothing
                        sURL = Request.Url.AbsoluteUri
                        Response.Redirect(sURL)
                    End Try
        
                End Sub
        
        
                Protected Sub SendApprovalRequest(ByVal sRecipientEmail As String, ByVal sRecipientName As String)
                    Dim oParty As NexusProvider.BaseParty = Session.Item(CNParty)
                    Dim sSubject As String = String.Empty
                    Dim sMessage As String = String.Empty
                    Dim sCCemail As String = String.Empty
                    Dim sbCCemail As String = String.Empty
                    Dim sEmailServer = AppSettings("SMTPServer")
                    Dim sDefaultSenderEmail = "NoReply@ssp.com"
                    Dim sSenderEmail As String = String.Empty
                    Dim sInsuredName As String = String.Empty
                    Dim sSenderName As String = GetValue("GENERAL", "LOGGEDINUSERFULLNAME")
        
                    Dim bEmailSent As Boolean = False
                    Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        
                    'Get Insured's Name               
                    Select Case True
        
                        Case TypeOf oParty Is NexusProvider.CorporateParty
                            With CType(oParty, NexusProvider.CorporateParty)
                                sInsuredName = .CompanyName
                            End With
        
                        Case TypeOf oParty Is NexusProvider.PersonalParty
                            With CType(oParty, NexusProvider.PersonalParty)
                                sInsuredName = .Title & " " & .Forename & " " & .Lastname
                            End With
                    End Select
        
        
                    'Receipient
                    sCCemail = sSenderEmail
        
                    'Build e-mail subject          
                    sSubject = "Policy Referral - " & oQuote.InsuranceFileRef & " for " & sInsuredName
                    sMessage = "Hi " & sRecipientName & vbCrLf & vbCrLf
                    sMessage = sMessage & "Please have a look at Quotation reference " & oQuote.InsuranceFileRef & " for " & sInsuredName & " which has been referred to the authorisation group."
                    sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                    sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
        
                    'set up the job to send emails to the requested addresses
                    'create an html file on the disk in the temp docs directory, with contents taken from the body textbox
                    Dim sFileName As String = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).TempFileLocation & "\" & Guid.NewGuid.ToString & ".html"
                    Dim emailBodyFile As New System.IO.StreamWriter(sFileName)
        
                    'form html formatted string by replacing line breaks with "<br />" and adding basic html tags
                    Dim sHtml As String = "<html><body>" & Replace(Convert.ToString(sMessage), Chr(13) & Chr(10), "<br />") & "</body></html>"
                    emailBodyFile.Write(sHtml)
                    emailBodyFile.Close()
        
                    Dim xlJob As System.Xml.Linq.XElement =
                                                               <BACKGROUND_JOB>
                                                                   <JOB jobtype="DOCUPACK">
                                                                       <PARAMETERS>
                                                                           <PARAMETER name="emailTo" value=<%= sRecipientEmail %>/>
                                                                           <PARAMETER name="emailCc" value=<%= sCCemail %>/>
                                                                           <PARAMETER name="emailSubject" value=<%= sSubject %>/>
                                                                           <PARAMETER name="Destination" value="email"/>
                                                                           <PARAMETER name="path" value=<%= sFileName %>/>
                                                                           <PARAMETER name="PartyCnt" value=<%= oParty.Key %>/>
                                                                           <PARAMETER name="InsuranceFileCnt" value=<%= oQuote.InsuranceFileKey %>/>
                                                                       </PARAMETERS>
                                                                       <ITEMS>
                                                                       </ITEMS>
                                                                   </JOB>
                                                               </BACKGROUND_JOB>
        
        
                    Dim strJob As String = xlJob.ToString 'this will be used as input to the WFC Service call
                    Dim sDescription As String = "Referral Request Email"
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        
                    'call WCF Service to queue the docs for Archiving
                    Dim iBackgroundJobID As Integer = oWebService.CreateBackgroundJob(sDescription, strJob, Now.Date)
        
                    oQuote = Nothing
                    oWebService = Nothing
                End Sub
        
                Private Sub CreateWorkManager(ByVal sGroupCode As String)
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                    Dim oworkManagerCollection As New NexusProvider.WorkManagerCollection
                    Dim oWorkManager As New NexusProvider.WorkManager
                    Dim oParty As NexusProvider.BaseParty = Session.Item(CNParty)
                    Dim oUserDetails As NexusProvider.UserDetails = Session(CNAgentDetails)
                    Dim sOpen As String = Session(CNWMMode)
                    Dim oClaimOpen As NexusProvider.ClaimOpen = Session.Item(CNClaim)
                    oWorkManager.DueDate = DateTime.Now.Date
                    oWorkManager.Client = "System"
                    Dim sInsuredName As String = String.Empty
                    Dim sSenderName As String = GetValue("GENERAL", "LOGGEDINUSERFULLNAME")
                    Dim sTransactionType As String = GetTransactionType()
                    Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        
                    'Get Insured's Name               
                    Select Case True
        
                        Case TypeOf oParty Is NexusProvider.CorporateParty
                            With CType(oParty, NexusProvider.CorporateParty)
                                sInsuredName = .CompanyName
                                oWorkManager.Client = .ClientSharedData.ShortName.Trim()
                            End With
        
                        Case TypeOf oParty Is NexusProvider.PersonalParty
                            With CType(oParty, NexusProvider.PersonalParty)
                                sInsuredName = .Title & " " & .Forename & " " & .Lastname
                                oWorkManager.Client = .ClientSharedData.ShortName.Trim()
                            End With
                    End Select
        
                    If sTransactionType = "NB" Or sTransactionType = "MTA" Then
                        oWorkManager.Description = sSenderName & " has referred quote no " & oQuote.InsuranceFileRef & " for " & sInsuredName & " and it's awaiting action."
                        If sTransactionType = "NB" Then
                            oWorkManager.Task = "UNDERNB"
                        End If
                        If sTransactionType = "MTA" Then
                            oWorkManager.Task = "UnderMTA"
                        End If
                        oWorkManager.TaskGroup = "UNDER"
                    ElseIf sTransactionType = "REN" Then
                        oWorkManager.Description = sSenderName & " has referred quote no " & oQuote.InsuranceFileRef & " for " & sInsuredName & " And it 's awaiting review."
                        oWorkManager.Task = "RENAMEND"
                        oWorkManager.TaskGroup = "UWRENEWAL"
                    End If
                    oWorkManager.AllocationUserGroup = "SFORU"
                    oWorkManager.AllocationUser = "(Any Group Member)"
                    oWorkManager.IsUrgent = True
                    oWorkManager.IsUrgentForUpdate = 1
                    oWorkManager.IsComplete = False
                    oWorkManager.IsTaskReview = False
                    If Session(CNQuote) IsNot Nothing Then
                        Dim oWmrk As New NexusProvider.KeyData
                        oWmrk.KeyName = "INSURANCEFILEKEY"
                        oWmrk.KeyValue = oQuote.InsuranceFileKey
                        oWorkManager.KeyData.Add(oWmrk)
                    End If
        
                    Try
                        If oWorkManager.TaskGroup IsNot Nothing Then
                            oWebService.CreateWmTask(oWorkManager)
                        End If
                    Catch ex As System.Exception
                    Finally
                        oWebService = Nothing
                    End Try
        
                End Sub
        
                ''' <summary>
                ''' Gets a list item code given an ID
                ''' </summary>
                ''' <param name="sListCode"></param>
                ''' <param name="iItemId"></param>
                ''' <returns></returns>
                ''' <remarks></remarks>
                Protected Function GetPMLookupItemCodefromID(ByVal sListCode As String, ByVal iItemId As String) As String
                    Dim sItemCode As String = String.Empty
        
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                    Dim oList As New NexusProvider.LookupListCollection
        
                    ' sam call to retreive the list of items from UDL
                    oList = oWebService.GetList(NexusProvider.ListType.PMLookup, sListCode, False, False)
        
                    ' Get code for ID
                    For iListCount As Integer = 0 To oList.Count - 1
                        If oList(iListCount).Key = iItemId Then
                            sItemCode = oList(iListCount).Code
                            Exit For
                        End If
                    Next
                    Return sItemCode
                End Function

    End Class
End Namespace