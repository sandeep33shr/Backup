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
    Partial Class PB2_MOTORP_Premium_Summary : Inherits BaseRisk
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

                If Session(CNMTAType) = MTAType.TEMPORARY OrElse Session(CNMTAType) = MTAType.PERMANENT Then
                    Return "MTA"
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
		
		Protected Sub onValidate_lbl_Header_Four()
        
        If eLifecycleEvent = LifecycleEvent.Page_Init AndAlso Session(CNMode) <> Mode.View Then
        CalculatePremiums()
        End If
        
        
End Sub
Protected Sub onValidate_MOTOR__CPOLEND()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_lbl_Header_Four()
    onValidate_MOTOR__CPOLEND()
End Sub

		    
        
        'Calls the any rating rule configured (VBScript/PRE/Compiled)
        Private Sub CalculatePremiums()
            Try
                Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                Dim oQuote As NexusProvider.Quote = Session(CNQuote)
                oWebService.UpdateRisk(oQuote, CInt(Session(CNCurrentRiskKey)), Nothing, Nothing, GetTransactionType(), False)
        
            Catch
        
            End Try
            'Update controls on the screen
            PREMIUM_SUMMARY__RATE.Text = GetValue("PREMIUM_SUMMARY", "RATE")
            PREMIUM_SUMMARY__ANNUAL_PREMIUM.Text = GetValue("PREMIUM_SUMMARY", "ANNUAL_PREMIUM")
            PREMIUM_SUMMARY__EXTENSIONS.Text = GetValue("PREMIUM_SUMMARY", "EXTENSIONS")
            PREMIUM_SUMMARY__ADDONS.Text = GetValue("PREMIUM_SUMMARY", "ADDONS")
            PREMIUM_SUMMARY__TOTAL_ANNUAL_PREMIUM.Text = GetValue("PREMIUM_SUMMARY", "TOTAL_ANNUAL_PREMIUM")
        End Sub
        
    
        
        Protected Shadows Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	If Not IsPostBack Then
        	Dim oUserDetails As NexusProvider.UserDetails = CType(Session(CNAgentDetails), NexusProvider.UserDetails)
        	Dim username = oUserDetails.ResolvedName
        
        	REM Insurance Reference START
        	REM PolicyRef Number is used in the description of the Authority Rules, the insurance reference is saved on the Motor Screen
        	Dim PolicyRef As NexusProvider.Quote = CType(Session.Item(CNQuote), NexusProvider.Quote)
        	MOTOR__REF_NUMBER.Text = PolicyRef.InsuranceFileRef.ToString()
        	REM Insurance Reference END
        	
        	'Get renewal frequency in months
        	Dim freqMonths As Integer
        	Select Case PolicyRef.RenewalFrequencyCode.Trim()
        		Case "ANNUAL"
        			freqMonths = 12
        		Case "BIANNUAL"
        			freqMonths = 6
        		Case "TRM"
        			freqMonths = 4
        		Case Else
        			freqMonths = 4
        	End Select
        	MOTOR__RENFREQ_MONTHS.Text = freqMonths
        	If GetTransactionType().Trim() = "NB" And Session(CNMode) = Mode.Add Then
        		MOTOR__ICDURATION.Text = freqMonths
        	End If
        	
        	REM Changes the List Code value based on the user logged in END
        	Dim idnumber = GetUserIDNumber()
        
        	If Not String.IsNullOrEmpty(idnumber) Then
        		MOTOR__USERIDNUM.Text = idnumber
        	End If
        
        
        	End If
        	
        	PopulateVehicleAndInsuranceType()
        	FilterICTaxClassLookup()
        		
        
        	'If renewal, reset ICECash
        	Dim transactionType = GetTransactionType()
        	If transactionType = "REN" Then
        		MOTOR__SESSIONTOKEN.Text = String.Empty
        		MOTOR__ICECASHSN.Text = String.Empty
        		MOTOR__ICISQUOTED.Text = 0
        		MOTOR__ICQUOTEID.Text = String.Empty
        	End If
        
        	If Session("ICECashToken") Is Nothing Then
        		MOTOR__SESSIONTOKEN.Text = String.Empty
        	Else
        		MOTOR__SESSIONTOKEN.Text = Session("ICECashToken").ToString()
        	End If
        
        	Dim parameter = Me.Request("__EVENTARGUMENT")
        	If Not parameter Is Nothing Then
        		Dim stringSeparators() As String = {","}
        		Dim result() As String
        		result = parameter.Split(stringSeparators, _
        					  StringSplitOptions.RemoveEmptyEntries)
        		If result.Length > 0 Then
        			Dim command As String = If(Not result(0) Is Nothing, result(0).ToString(), "")
        
        			If command.ToUpper() = "SETTOKEN" Then
        				If result.Length >= 3 Then
        					Dim icSessionToken As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					Dim nextStep As String = If(Not result(2) Is Nothing, result(2).ToString(), "")
        					Session("ICECashToken") = icSessionToken
        					Dim buildScript As String = ""
        					buildScript += "Field.getInstance('MOTOR', 'SESSIONTOKEN').setValue('" + icSessionToken + "');"
        					Select Case nextStep
        						Case "POST"
        							buildScript += "postAPIPolicy();"
        						Case "GET"
        							buildScript += "getAPIPolicy();"
        						Case "REJ"
        							buildScript += "rejectAPIPolicy();"
        						Case "VAL"
        							buildScript += "validateAPIPolicy();"
        						Case Else
        							buildScript += "displayResult("");"
        					End Select
        						
        						ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "AsyncPostback",
        															  buildScript,
        															  True)
        						asyncPanel.Update()
        				End If
        			End If
        		End If
        	End If
        End Sub
        
        Protected Sub PopulateVehicleAndInsuranceType()
        	Dim vehTypeCode = GetValue("MOTOR", "VEHICLE_TYPE_CODE")
        	Dim vehUseCode = GetPMLookupItemCodefromID("UDL_PM_VEHICLE_USE", GetValue("MOTOR", "VEHCUSE"))
        	Dim coverTypeCode = GetPMLookupItemCodefromID("UDL_PM_COVER_TYPE", GetValue("MOTOR", "COVER_TYPE"))
        
        	Dim icVehType As String = ""
        	Dim icInsureType As String = ""
        
        	'Set ICECash Vehicle Type
        	Select Case vehTypeCode
        		Case "PMVR"
        			If (vehUseCode = "TRAVELHOM") Then
        				icVehType = "1"
        			ElseIf (vehUseCode = "LIMBUSSNES" Or vehUseCode = "BUSINESS") Then
        				icVehType = "2"
        			End If
        		Case "MCR"
        			If (vehUseCode = "TRAVELHOM") Then
        				icVehType = "19"
        			ElseIf (vehUseCode = "LIMBUSSNES" Or vehUseCode = "BUSINESS") Then
        				icVehType = "20"
        			End If
        		Case "DTRR"
        			icVehType = "6"
        		Case "CRVR"
        			icVehType = "7"
        	End Select
        	MOTOR__ICVEHTYPECODE.Text = icVehType
        
        
        	'Set ICECash Insure Type
        	Select Case coverTypeCode
        		Case "RTA"
        			icInsureType = "1"
        		Case "FTP"
        			icInsureType = "2"
        		Case "FTPFT", "LAIDUP"
        			icInsureType = "3"
        		Case "COMP"
        			icInsureType = "4"
        	End Select
        	MOTOR__ICINSURETYPE.Text = icInsureType
        
        End Sub
        
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
        
         Protected Sub FilterICTaxClassLookup()
        	MOTOR__ICTAXCLASSLOOKUP.Items.Clear()
        	Dim vTypeCode = MOTOR__ICVEHTYPECODE.Text
        	
        	Dim oWebService As NexusProvider.ProviderBase = Nothing
        	Dim xeFilterListItems As System.Xml.XmlElement = Nothing
        	Dim oList As New NexusProvider.LookupListCollection
        	Dim oListCollection As New ArrayList
        	Dim sAuthLevelCode As String = String.Empty
        	Dim sRepudationAuthority As String = String.Empty
        
        	Try
        		oWebService = New NexusProvider.ProviderManager().Provider
        
        		oList = oWebService.GetList(NexusProvider.ListType.PMLookup, MOTOR__ICTAXCLASSLOOKUPALL.ListCode, True, True, , , , xeFilterListItems)
        		Dim filterColumns As String() = "ICECASH_VEHTYPE_ID".Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        		Dim values As String() = vTypeCode.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        
        		If values.Length <> filterColumns.Length Then
        			' Error.
        			Return
        		End If
        
        		Dim sEffectiveDate As Date
        		If MOTOR__ICTAXCLASSLOOKUPALL.EffectiveDate < New DateTime(1753, 1, 1) Then
        			sEffectiveDate = DateTime.Now
        		Else
        			sEffectiveDate = MOTOR__ICTAXCLASSLOOKUPALL.EffectiveDate
        		End If
        
        		If Not xeFilterListItems Is Nothing Then
        			Dim sXML As String = xeFilterListItems.OuterXml
        			Dim xmlDoc As New System.Xml.XmlDocument
        			Dim sIsCheckAuthLevel As Boolean = False
        			xmlDoc.PreserveWhitespace = False
        			xmlDoc.LoadXml(sXML)
        
        			Dim oNodeList As XmlNodeList
        			oNodeList = xmlDoc.SelectNodes("/AdditionalDetails/" + MOTOR__ICTAXCLASSLOOKUPALL.ListCode)
        			Dim doc As New System.Xml.XmlDocument
        			Dim rootNode As System.Xml.XmlElement = doc.AppendChild(doc.CreateElement("ListItems"))
        			For Each oNode As XmlNode In oNodeList
        				If oNode("is_deleted").InnerText <> "1" Then
        					Dim bIsMatched As Boolean = False
        					For i As Integer = 0 To filterColumns.Length - 1
        						Dim sFilterListValue As String = String.Empty
        						If oNode(filterColumns(i).ToLower().Trim()) IsNot Nothing AndAlso CDate(oNode("effective_date").InnerText) <= sEffectiveDate Then
        							sFilterListValue = oNode(filterColumns(i).ToLower().Trim()).InnerText.ToUpper()
        
        							If sFilterListValue = values(i) Then
        								bIsMatched = True
        							Else
        								bIsMatched = False
        
        							End If
        						End If
        						If bIsMatched Then
        							Dim sKey As String = String.Empty
        							Dim sDescription As String = String.Empty
        							Dim sCode As String = String.Empty
        							If oNode(MOTOR__ICTAXCLASSLOOKUPALL.ListCode + "_id") IsNot Nothing Then
        								sKey = oNode(MOTOR__ICTAXCLASSLOOKUPALL.ListCode + "_id").InnerText
        							End If
        
        							If oNode("description") IsNot Nothing Then
        								sDescription = oNode("description").InnerText
        							End If
        
        							If oNode("code") IsNot Nothing Then
        								sCode = oNode("code").InnerText
        							End If
        
        							Dim newItem As NexusProvider.LookupListItem = New NexusProvider.LookupListItem()
        							newItem.Key = sKey.Trim()
        							newItem.Code = sCode.Trim()
        							newItem.Description = sDescription.Trim()
        
        							MOTOR__ICTAXCLASSLOOKUP.Items.Add(newItem)
        
        						End If
        					Next
        
        
        				End If
        			Next
        		End If
        	Catch ex As Exception
        
        	Finally
        		oWebService = Nothing
        		xeFilterListItems = Nothing
        		oList = Nothing
        		oListCollection = Nothing
        	End Try
        End Sub
        
        Protected Function GetUserIDNumber() As String
        	Dim returnID As String = String.Empty
        	Dim oUserDetails As NexusProvider.UserDetails = CType(Session(CNAgentDetails), NexusProvider.UserDetails)
        	Dim fullname = oUserDetails.ResolvedName
        	' Get ID Number from Fullname
        	Dim pattern As String = "\(.*?\)"
        	Dim mc As System.Text.RegularExpressions.MatchCollection
        	Dim regx As New System.Text.RegularExpressions.Regex(pattern)
        
        	If Regex.IsMatch(fullname, pattern) Then
        		mc = regx.Matches(fullname)
        		For index As Integer = 0 To mc.Count - 1
        			Dim value As String = mc(index).Value
        			value = value.Replace("(", "").Replace(")", "").Trim()
        			If (value.Length > 0) Then
        				returnID = value
        			End If
        		Next
        
        	End If
        	Return returnID
        End Function
                
        
        
        

    End Class
End Namespace