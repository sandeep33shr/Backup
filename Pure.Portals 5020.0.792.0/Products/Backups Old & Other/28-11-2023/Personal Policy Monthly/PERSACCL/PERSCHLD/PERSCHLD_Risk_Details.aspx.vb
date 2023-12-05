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
    Partial Class PB2_PERSCHLD_Risk_Details : Inherits BaseRisk
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
		
		Protected Sub onValidate_PSINSURED__OCCUPATION()
        
End Sub
Protected Sub onValidate_PSINSURED__DEATH_SUM_INSURED()
        
End Sub
Protected Sub onValidate_PSINSURED__TEMP_DISAB_SUM_INSURED()
        
End Sub
Protected Sub onValidate_PSINSURED__MEDICAL_EXP_SUMINSURED()
        
End Sub
Protected Sub onValidate_PSINSURED__TOTAL_PRE()
        
        
End Sub
Protected Sub onValidate_Button_btnCalculatePrem()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_PSINSURED__OCCUPATION()
    onValidate_PSINSURED__DEATH_SUM_INSURED()
    onValidate_PSINSURED__TEMP_DISAB_SUM_INSURED()
    onValidate_PSINSURED__MEDICAL_EXP_SUMINSURED()
    onValidate_PSINSURED__TOTAL_PRE()
    onValidate_Button_btnCalculatePrem()
End Sub

		    
        
        Protected Shadows Sub Page_Load_For_Defaults_PSINSURED_OCCUPATION(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Page.IsPostBack Then
            'Retreiving Argument from _doPostBack();
            Dim parameter = Me.Request("__EVENTARGUMENT")
            If Not parameter Is Nothing Then
                Dim stringSeparators() As String = {","}
                Dim result() As String
                result = parameter.Split(stringSeparators, _
                            StringSplitOptions.RemoveEmptyEntries)
                If result.Length > 0 Then
                    Dim command As String = If(Not result(0) Is Nothing, result(0).ToString(), "")
                    If command.ToUpper() = "POPULATEDEFAULTS_PSINSURED_OCCUPATION".ToUpper() Then
                        If result.Length >= 1 Then
                            Dim onChangeType As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					Dim vCode As String = If(Not result(2) Is Nothing, result(2).ToString(), "")
                            If onChangeType <> "" Then
                                Retrieve_Extensions_Defaults_For_PSINSURED_OCCUPATION(onChangeType, vCode)
                            End If
                        End If
                    End If
                End If
            End If
        End If
        End Sub
        
        Protected Sub Retrieve_Extensions_Defaults_For_PSINSURED_OCCUPATION(ByVal onChangeType As String, ByVal sCode As String)
        
        Dim buildScript As new System.Text.StringBuilder()
        
        Dim ListCode = "UDL_OCCUPCDE"
        
        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim oList As NexusProvider.LookupListCollection
        Dim XmlList As System.Xml.XmlElement = Nothing
        Try
            oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        
        
        If XmlList IsNot Nothing Then
                Dim sXML As String = XmlList.OuterXml
                Dim xmlDoc As New System.Xml.XmlDocument
                Dim NodeList As XmlNodeList
                xmlDoc.LoadXml(sXML)
        
                NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
                If NodeList IsNot Nothing And NodeList.Count > 0 Then
                    For Each oNode As XmlNode In NodeList
                                    If onChangeType = "OCCUPATION" Then
                                        If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sCode Then
                                            Dim ObjectsPropertiesArray As String() = {"PSINSURED.OCCUPATION_DESCRIPTION,description", "{2}", "{3}", "{4}", "{5}", "{6}", "{7}", "{8}", "{9}", "{10}", "{11}", "{12}", "{13}", "{14}", "{15}", "{16}"}
                                            Dim x As Integer
        
                                            For x = 0 To 15
                                                Try
                                                    Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
                                                    Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                                                    Dim sobject = ObjectPropertySplit(0).ToString().Trim()
                                                    Dim sproperty = ColumnNameSplit(0).ToString().Trim()
                                                    Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        											
        											If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        												buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        											Else
        												buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        											End If
                                                Catch
                                                    Exit For
                                                End Try
                                            Next x
                                        End If
                                    End If
                                Next
                    CompleteASyncPostback_For_PSINSURED_OCCUPATION(buildScript.ToString())
                End If
            End If
        
        Catch
            Exit Sub
        End Try
        
        End Sub
        
        
        Protected Sub CompleteASyncPostback_For_PSINSURED_OCCUPATION(ByVal buildScript As String)
        ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "AsyncPostback",
        													  buildScript,
        													  True)
        	asyncPanel.Update()
        End Sub
    
        
        Protected Shadows Sub Page_Load_For_Defaults_PSINSURED_DEATH_SUM_INSURED(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Page.IsPostBack Then
            'Retreiving Argument from _doPostBack();
            Dim parameter = Me.Request("__EVENTARGUMENT")
            If Not parameter Is Nothing Then
                Dim stringSeparators() As String = {","}
                Dim result() As String
                result = parameter.Split(stringSeparators, _
                            StringSplitOptions.RemoveEmptyEntries)
                If result.Length > 0 Then
                    Dim command As String = If(Not result(0) Is Nothing, result(0).ToString(), "")
                    If command.ToUpper() = "POPULATEDEFAULTS_PSINSURED_DEATH_SUM_INSURED".ToUpper() Then
                        If result.Length >= 1 Then
                            Dim onChangeType As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					Dim vCode As String = If(Not result(2) Is Nothing, result(2).ToString(), "")
                            If onChangeType <> "" Then
                                Retrieve_Extensions_Defaults_For_PSINSURED_DEATH_SUM_INSURED(onChangeType, vCode)
                            End If
                        End If
                    End If
                End If
            End If
        End If
        End Sub
        
        Protected Sub Retrieve_Extensions_Defaults_For_PSINSURED_DEATH_SUM_INSURED(ByVal onChangeType As String, ByVal sCode As String)
        
        Dim buildScript As new System.Text.StringBuilder()
        
        Dim ListCode = "UDL_KDEATHSI"
        
        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim oList As NexusProvider.LookupListCollection
        Dim XmlList As System.Xml.XmlElement = Nothing
        Try
            oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        
        
        If XmlList IsNot Nothing Then
                Dim sXML As String = XmlList.OuterXml
                Dim xmlDoc As New System.Xml.XmlDocument
                Dim NodeList As XmlNodeList
                xmlDoc.LoadXml(sXML)
        
                NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
                If NodeList IsNot Nothing And NodeList.Count > 0 Then
                    For Each oNode As XmlNode In NodeList
                                    If onChangeType = "DEATH_SUM_INSURED" Then
                                        If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sCode Then
                                            Dim ObjectsPropertiesArray As String() = {"PSINSURED.TEMPCODE,Maximum_TTD_Sum_Insured", "PSINSURED.MAXTEMP,Maximum_Medical_Expenses_Sum_Insured", "PSINSURED.DEATHSUMIN,description", "{4}", "{5}", "{6}", "{7}", "{8}", "{9}", "{10}", "{11}", "{12}", "{13}", "{14}", "{15}", "{16}"}
                                            Dim x As Integer
        
                                            For x = 0 To 15
                                                Try
                                                    Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
                                                    Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                                                    Dim sobject = ObjectPropertySplit(0).ToString().Trim()
                                                    Dim sproperty = ColumnNameSplit(0).ToString().Trim()
                                                    Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        											
        											If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        												buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        											Else
        												buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        											End If
                                                Catch
                                                    Exit For
                                                End Try
                                            Next x
                                        End If
                                    End If
                                Next
                    CompleteASyncPostback_For_PSINSURED_DEATH_SUM_INSURED(buildScript.ToString())
                End If
            End If
        
        Catch
            Exit Sub
        End Try
        
        End Sub
        
        
        Protected Sub CompleteASyncPostback_For_PSINSURED_DEATH_SUM_INSURED(ByVal buildScript As String)
        ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "AsyncPostback",
        													  buildScript,
        													  True)
        	asyncPanel.Update()
        End Sub
    
        
        Protected Shadows Sub Page_Load_For_Defaults_PSINSURED_TEMP_DISAB_SUM_INSURED(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Page.IsPostBack Then
            'Retreiving Argument from _doPostBack();
            Dim parameter = Me.Request("__EVENTARGUMENT")
            If Not parameter Is Nothing Then
                Dim stringSeparators() As String = {","}
                Dim result() As String
                result = parameter.Split(stringSeparators, _
                            StringSplitOptions.RemoveEmptyEntries)
                If result.Length > 0 Then
                    Dim command As String = If(Not result(0) Is Nothing, result(0).ToString(), "")
                    If command.ToUpper() = "POPULATEDEFAULTS_PSINSURED_TEMP_DISAB_SUM_INSURED".ToUpper() Then
                        If result.Length >= 1 Then
                            Dim onChangeType As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					Dim vCode As String = If(Not result(2) Is Nothing, result(2).ToString(), "")
                            If onChangeType <> "" Then
                                Retrieve_Extensions_Defaults_For_PSINSURED_TEMP_DISAB_SUM_INSURED(onChangeType, vCode)
                            End If
                        End If
                    End If
                End If
            End If
        End If
        End Sub
        
        Protected Sub Retrieve_Extensions_Defaults_For_PSINSURED_TEMP_DISAB_SUM_INSURED(ByVal onChangeType As String, ByVal sCode As String)
        
        Dim buildScript As new System.Text.StringBuilder()
        
        Dim ListCode = "UDL_KTTDSI"
        
        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim oList As NexusProvider.LookupListCollection
        Dim XmlList As System.Xml.XmlElement = Nothing
        Try
            oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        
        
        If XmlList IsNot Nothing Then
                Dim sXML As String = XmlList.OuterXml
                Dim xmlDoc As New System.Xml.XmlDocument
                Dim NodeList As XmlNodeList
                xmlDoc.LoadXml(sXML)
        
                NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
                If NodeList IsNot Nothing And NodeList.Count > 0 Then
                    For Each oNode As XmlNode In NodeList
                                    If onChangeType = "TEMP_DISAB_SUM_INSURED" Then
                                        If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sCode Then
                                            Dim ObjectsPropertiesArray As String() = {"PSINSURED.TEMPORARY_DIS_PER,No_of_Weeks", "PSINSURED.TEMPSI,description", "{3}", "{4}", "{5}", "{6}", "{7}", "{8}", "{9}", "{10}", "{11}", "{12}", "{13}", "{14}", "{15}", "{16}"}
                                            Dim x As Integer
        
                                            For x = 0 To 15
                                                Try
                                                    Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
                                                    Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                                                    Dim sobject = ObjectPropertySplit(0).ToString().Trim()
                                                    Dim sproperty = ColumnNameSplit(0).ToString().Trim()
                                                    Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        											
        											If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        												buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        											Else
        												buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        											End If
                                                Catch
                                                    Exit For
                                                End Try
                                            Next x
                                        End If
                                    End If
                                Next
                    CompleteASyncPostback_For_PSINSURED_TEMP_DISAB_SUM_INSURED(buildScript.ToString())
                End If
            End If
        
        Catch
            Exit Sub
        End Try
        
        End Sub
        
        
        Protected Sub CompleteASyncPostback_For_PSINSURED_TEMP_DISAB_SUM_INSURED(ByVal buildScript As String)
        ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "AsyncPostback",
        													  buildScript,
        													  True)
        	asyncPanel.Update()
        End Sub
    
        
        Protected Shadows Sub Page_Load_For_Defaults_PSINSURED_MEDICAL_EXP_SUMINSURED(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Page.IsPostBack Then
            'Retreiving Argument from _doPostBack();
            Dim parameter = Me.Request("__EVENTARGUMENT")
            If Not parameter Is Nothing Then
                Dim stringSeparators() As String = {","}
                Dim result() As String
                result = parameter.Split(stringSeparators, _
                            StringSplitOptions.RemoveEmptyEntries)
                If result.Length > 0 Then
                    Dim command As String = If(Not result(0) Is Nothing, result(0).ToString(), "")
                    If command.ToUpper() = "POPULATEDEFAULTS_PSINSURED_MEDICAL_EXP_SUMINSURED".ToUpper() Then
                        If result.Length >= 1 Then
                            Dim onChangeType As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					Dim vCode As String = If(Not result(2) Is Nothing, result(2).ToString(), "")
                            If onChangeType <> "" Then
                                Retrieve_Extensions_Defaults_For_PSINSURED_MEDICAL_EXP_SUMINSURED(onChangeType, vCode)
                            End If
                        End If
                    End If
                End If
            End If
        End If
        End Sub
        
        Protected Sub Retrieve_Extensions_Defaults_For_PSINSURED_MEDICAL_EXP_SUMINSURED(ByVal onChangeType As String, ByVal sCode As String)
        
        Dim buildScript As new System.Text.StringBuilder()
        
        Dim ListCode = "UDL_KMEDEXP"
        
        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim oList As NexusProvider.LookupListCollection
        Dim XmlList As System.Xml.XmlElement = Nothing
        Try
            oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        
        
        If XmlList IsNot Nothing Then
                Dim sXML As String = XmlList.OuterXml
                Dim xmlDoc As New System.Xml.XmlDocument
                Dim NodeList As XmlNodeList
                xmlDoc.LoadXml(sXML)
        
                NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
                If NodeList IsNot Nothing And NodeList.Count > 0 Then
                    For Each oNode As XmlNode In NodeList
                                    If onChangeType = "MEDICAL_EXP_SUMINSURED" Then
                                        If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sCode Then
                                            Dim ObjectsPropertiesArray As String() = {"PSINSURED.MED_EXP_VAL,description", "{2}", "{3}", "{4}", "{5}", "{6}", "{7}", "{8}", "{9}", "{10}", "{11}", "{12}", "{13}", "{14}", "{15}", "{16}"}
                                            Dim x As Integer
        
                                            For x = 0 To 15
                                                Try
                                                    Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
                                                    Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                                                    Dim sobject = ObjectPropertySplit(0).ToString().Trim()
                                                    Dim sproperty = ColumnNameSplit(0).ToString().Trim()
                                                    Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        											
        											If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        												buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        											Else
        												buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        											End If
                                                Catch
                                                    Exit For
                                                End Try
                                            Next x
                                        End If
                                    End If
                                Next
                    CompleteASyncPostback_For_PSINSURED_MEDICAL_EXP_SUMINSURED(buildScript.ToString())
                End If
            End If
        
        Catch
            Exit Sub
        End Try
        
        End Sub
        
        
        Protected Sub CompleteASyncPostback_For_PSINSURED_MEDICAL_EXP_SUMINSURED(ByVal buildScript As String)
        ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "AsyncPostback",
        													  buildScript,
        													  True)
        	asyncPanel.Update()
        End Sub
    
        Protected Sub btnNextCalculate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
            PremiumValidator()
        End Sub
        
        Protected Sub btnNextTopCalculate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNextTop.Click
        	PremiumValidator()
        End Sub
        
         Protected Sub btnFinishCalculate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinish.Click
        	PremiumValidator()
        End Sub
        
        Protected Sub btnFinishTopCalculate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinishTop.Click
        	PremiumValidator()
        End Sub
        
        Private Sub PremiumValidator()
        	Dim oCustomValidator As New CustomValidator()
        
        	oCustomValidator.IsValid = True
        	If (PSINSURED__TOTAL_PRE.Text = "") And (PSINSURED__TOTAL_PRE.Text = Nothing) Then
        		oCustomValidator.ID = "ValidateCalculateButton"
        		oCustomValidator.ErrorMessage = "Calculate Premium button must be clicked in order to proceed"
        		oCustomValidator.IsValid = False
        	End If
        
        	Page.Validators.Add(oCustomValidator)
        
        End Sub
    
        
        
          Protected Sub btnCalculatePrem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCalculatePrem.Click
                    If Page.IsValid Then
                        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
                        CalculatePremiums()
                    End If
                End Sub
        
        
                'Calls the any rating rule configured (VBScript/PRE/Compiled)
                Protected Sub CalculatePremiums()
                    Dim sURLNew As String = HttpContext.Current.Request.Url.ToString()
        
                    'Same save the data entered by the user to dataset
                    For index As Integer = 1 To 2
                        WriteRisk()
                        Try
                            Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                            Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        
                            'Preferred method
                            oWebService.UpdateRisk(oQuote, CInt(Session(CNCurrentRiskKey)), Nothing, Nothing, Nothing)
        
                            'To be used if automatic calling of PRE can't be avoided
                            'oWebService.ExecutePRERuleset(oQuote, CInt(Session(CNCurrentRiskKey)), Nothing, Nothing, sTransactionType, False, "", False, False)
                        Catch
        
                        End Try
                    Next
        
                    'Update all controls with data from the new dataset
                    If HttpContext.Current.Session.IsCookieless Then
                        Dim iIndex As Integer = sURLNew.IndexOf(AppSettings("WebRoot"))
                        iIndex = iIndex + Convert.ToInt16(Convert.ToString(AppSettings("WebRoot")).Length)
                        sURLNew = sURLNew.Insert(iIndex, "(S(" & Session.SessionID.ToString() + "))/")
                        Response.Redirect(sURLNew)
                    Else
                        Response.Redirect(sURLNew)
                    End If
        
                End Sub

    End Class
End Namespace