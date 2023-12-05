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

Namespace Nexus
    Partial Class PB2_MOTORP_Motor_Details : Inherits BaseRisk
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
		
		Protected Sub onValidate_GENERAL__SelectedCurrency()
        
End Sub
Protected Sub onValidate_GENERAL__ICFIELD1()
        
End Sub
Protected Sub onValidate_MOTOR__COVER_TYPE()
        If eLifecycleEvent = LifecycleEvent.Page_Load Then
        	btnBack.Visible = False
        	btnBackTop.Visible = False
        End If
End Sub
Protected Sub onValidate_MOTOR__VEHICLE_TYPE_CODE()
        If eLifecycleEvent = LifecycleEvent.Page_Load Then
        	DefaultLoggedInUserType()
        End If
        
        
End Sub
Protected Sub onValidate_MOTOR__RISK_DESCRIPTION()
        If eLifecycleEvent = LifecycleEvent.Page_Load Then
        	GetRiskTypeDetails()
        End If
        
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_GENERAL__SelectedCurrency()
    onValidate_GENERAL__ICFIELD1()
    onValidate_MOTOR__COVER_TYPE()
    onValidate_MOTOR__VEHICLE_TYPE_CODE()
    onValidate_MOTOR__RISK_DESCRIPTION()
End Sub

		    
        Protected Shadows Sub Page_Load_Currency(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	If Not IsPostBack Then
        		If Session(CNQuote) IsNot Nothing Then
        			If GENERAL__SelectedCurrency.Text = "" Then
        				'Update Currency and flag to Dataset and run default rule
        				UpdateXML("SELECTEDCURRENCY", oQuote.CurrencyCode, "GENERAL")
        				UpdateXML("ISCURRENCYCHANGED", 1, "GENERAL")
        				RunEditRules("MOTORP", True)
        				GENERAL__SelectedCurrency.Text = oQuote.CurrencyCode
        			ElseIf GENERAL__SelectedCurrency.Text <> oQuote.CurrencyCode Then
        				GENERAL__SelectedCurrency.Text = oQuote.CurrencyCode
        
        				'Update Currency and flag to Dataset and run default rule
        				UpdateXML("SELECTEDCURRENCY", oQuote.CurrencyCode, "GENERAL")
        				UpdateXML("ISCURRENCYCHANGED", 1, "GENERAL")
        				RunEditRules("MOTORP", True)
        			End If
        		End If
        	End If
        End Sub
        
        Sub UpdateXML(ByVal sFieldName As String, ByVal sFieldValue As String, ByVal sObjectName As String)
        	Dim oWebService As NexusProvider.ProviderBase = Nothing
        	Dim oDataSet As New SiriusFS.SAM.Client.DataSetControl.Application
        	'get the dataset definition
        	Dim oQuote As NexusProvider.Quote = CType(Session(CNQuote), NexusProvider.Quote)
        
        	Dim sDataSetDefinition As String = Nexus.DataSetFunctions.GetDataSetDefinition(Session(CNDataModelCode))
        	'load dataset into SAM client
        	oDataSet.LoadFromXML(sDataSetDefinition, oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset)
        
        	Dim srXMLDataset As String = oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset
        	Dim oDoc As New XmlDocument
        	oDoc.LoadXml(srXMLDataset)
        
        	Dim oxmlnode As XmlNode = oDoc.SelectSingleNode("//" & Session.Item(CNDataModelCode) & "_POLICY_BINDER/" & sObjectName)
        	oDataSet.SetPropertyValue(sObjectName & "__", sFieldName, oxmlnode.Attributes("OI").Value, sFieldValue, True)
        	oDataSet.SetPropertyValue(sObjectName & "__", "US", oxmlnode.Attributes("OI").Value, "2", True)
        
        	Dim swContent As New System.IO.StringWriter
        	Dim xmlwContent As New XmlTextWriter(swContent)
        
        	oDoc.WriteTo(xmlwContent)
        	oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset = swContent.ToString()
        
        	oDataSet.ReturnAsXML(oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset)
        
        	Session(CNQuote) = oQuote
        	xmlwContent.Close()
        	swContent.Close()
        
        End Sub
        
        ''' <summary>
        ''' Calling Default Rule File Edit
        ''' </summary>
        ''' <param name="screenCode"></param>
        ''' <param name="skipSaveToDB"></param>
        Sub RunEditRules(ByVal screenCode As String, ByVal skipSaveToDB As Boolean)
        	Dim oQuote As NexusProvider.Quote = CType(Session(CNQuote), NexusProvider.Quote)
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        
        	'check the mode to pass into rundefaultrulesedit
        	If Session(CNMTAType) IsNot Nothing And Session(CNRenewal) Is Nothing Then
        		If Session(CNMTAType) = MTAType.PERMANENT Or Session(CNMTAType) = MTAType.TEMPORARY Then
        			oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset = oWebService.RunDefaultRulesEdit(screenCode, oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset, Nothing, Nothing, "MTA", skipSaveToDB)
        		ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
        			oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset = oWebService.RunDefaultRulesEdit(screenCode, oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset, Nothing, Nothing, "MTC", skipSaveToDB)
        		ElseIf (Session(CNMTAType) = MTAType.REINSTATEMENT) Then
        			oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset = oWebService.RunDefaultRulesEdit(screenCode, oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset, Nothing, Nothing, "MTR", skipSaveToDB)
        		End If
        	ElseIf Session(CNMTAType) Is Nothing And Session(CNRenewal) IsNot Nothing Then
        		oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset = oWebService.RunDefaultRulesEdit(screenCode, oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset, Nothing, Nothing, "REN", skipSaveToDB)
        	Else
        		oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset = oWebService.RunDefaultRulesEdit(screenCode, oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset, Nothing, Nothing, "NB", skipSaveToDB)
        	End If
        End Sub
    
        REM Load User Details Information
        
        Protected Shadows Sub Page_Load_UserDetails(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	If Not IsPostBack Then
        
        		Dim oParty As NexusProvider.BaseParty = Nothing
        		Dim iCount As Integer
        		REM Retrieves Data from the User Details
        		If Session(CNParty) IsNot Nothing Then
        			If TypeOf Session(CNParty) Is NexusProvider.CorporateParty Then
        				oParty = CType(Session(CNParty), NexusProvider.CorporateParty)
        				REM Get Company Name START
        				'MTR_CLIENT__ICFIELD3.Text = DirectCast(oParty, NexusProvider.CorporateParty).CompanyName
        				REM Get Company Name
        
        			ElseIf TypeOf Session(CNParty) Is NexusProvider.PersonalParty Then
        				oParty = CType(Session(CNParty), NexusProvider.PersonalParty)
        				REM First Name & Last Name START
        				GENERAL__ICFIELD1.Text = Trim(DirectCast(oParty, NexusProvider.PersonalParty).Forename).ToString	'First Name
        				GENERAL__ICFIELD2.Text = Trim(DirectCast(oParty, NexusProvider.PersonalParty).Lastname).ToString	'Last Name
        				REM First Name & Last Name END
        			End If
        
        			REM Checks for Email Address START
        			Dim ContactDetails As NexusProvider.ContactCollection = CType(oParty.Contacts, NexusProvider.ContactCollection)
        			Try
        				For iCount = 0 To ContactDetails.Count
        					If ContactDetails.Item(iCount).OtherContactTypeCode = "Main Email Contact" Or ContactDetails.Item(iCount).OtherContactTypeCode.ToUpper = "MEMAIL" Then
        						GENERAL__ICFIELD3.Text = Trim(ContactDetails.Item(iCount).Number).ToString      'Email
        						Exit For
        					End If
        				Next
        
        			Catch AORE As ArgumentOutOfRangeException
        
        			End Try
        			REM Checks for Email Address END
        
        			REM Checks for Mobile Number START                    
        			Try
        				For iCount = 0 To ContactDetails.Count
        					If ContactDetails.Item(iCount).OtherContactTypeCode = "Cellular Telephone" Or ContactDetails.Item(iCount).OtherContactTypeCode.ToUpper = "MOBILE" Then
        						GENERAL__ICFIELD4.Text = Trim(ContactDetails.Item(iCount).Number).ToString  'MSISDN
        						Exit For
        					End If
        				Next
        
        			Catch AORE As ArgumentOutOfRangeException
        
        			End Try
        			REM Checks for Mobile Number END
        
        			REM Checks for AddressLine 1, 2 & Town START
        			Dim AddressDetails As NexusProvider.AddressCollection = CType(oParty.Addresses, NexusProvider.AddressCollection)
        			Try
        				For iCount = 0 To AddressDetails.Count
        					If AddressDetails.Item(iCount).AddressType = NexusProvider.AddressType.BusinessAddress Then
        						GENERAL__ICFIELD5.Text = Trim(AddressDetails.Item(iCount).Address1).ToString  REM Check The Type of Address the person is using / Use the primary Address Correspondent if PC Use 
        						'MTR_CLIENT__ADDRESSLINE2.Text = Trim(AddressDetails.Item(iCount).Address2).ToString  REM Check The Type of Address the person is using / Use the primary Address Correspondent if PC Use 
        						'MTR_CLIENT__TOWN.Text = Trim(AddressDetails.Item(iCount).Address3).ToString
        						Exit For
        					ElseIf AddressDetails.Item(iCount).AddressType = NexusProvider.AddressType.CorrespondenceAddress Then
        						GENERAL__ICFIELD5.Text = Trim(AddressDetails.Item(iCount).Address1).ToString  REM Check The Type of Address the person is using / Use the primary Address Correspondent if PC Use 
        						'MTR_CLIENT__ADDRESSLINE2.Text = Trim(AddressDetails.Item(iCount).Address2).ToString  REM Check The Type of Address the person is using / Use the primary Address Correspondent if PC Use
        						'MTR_CLIENT__TOWN.Text = Trim(AddressDetails.Item(iCount).Address3).ToString
        						Exit For
        					End If
        				Next
        			Catch AORE As ArgumentOutOfRangeException
        
        			End Try
        			REM Checks for AddressLine 1, 2 & Town END
        
        		End If
        	End If
        
        End Sub
    
         '**********************************************************************************************
        ' Default LoggedIn User Type
        '**********************************************************************************************
        Protected Sub DefaultLoggedInUserType()
        	Dim oUserDetails As NexusProvider.UserDetails = CType(Session(CNAgentDetails), NexusProvider.UserDetails)
        	If oUserDetails IsNot Nothing Then
        		' Added to override defualt portal id as per user type       
        		If oUserDetails IsNot Nothing Then
        			' Added to override defualt portal id as per user type       
        			If oUserDetails.Key = 0 Then
        				'Is internal user
        				GENERAL__IsBroker.Text = 0
        			Else
        				If oUserDetails.PartyType = "AG" Then
        					'Is broker user
        					GENERAL__IsBroker.Text = 1
        				Else
        					'Might be TPA
        					GENERAL__IsBroker.Text = 2
        				End If
        			End If
        		End If
        	End If
        End Sub
        
    
         Protected Sub GetRiskTypeDetails()
        	Dim oRiskType As NexusProvider.RiskType = Current.Session(CNRiskType)
        	If Session(CNRiskType) IsNot Nothing Then
        		MOTOR__VEHICLE_TYPE_CODE.Text = Trim(oRiskType.RiskCode).ToString
        		MOTOR__RISK_DESCRIPTION.Text = Trim(oRiskType.Name).ToString
        		UpdateXML("VEHICLE_TYPE_CODE", Trim(oRiskType.RiskCode).ToString, "MOTOR")
        		UpdateXML("RISK_DESCRIPTION", Trim(oRiskType.Name).ToString, "MOTOR")
        	End If
         End Sub
         
         

    End Class
End Namespace