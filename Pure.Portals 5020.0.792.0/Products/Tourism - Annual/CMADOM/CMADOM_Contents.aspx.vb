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
    Partial Class PB2_CMADOM_Contents : Inherits BaseRisk
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
		
		Protected Sub onValidate_CONTENTS__ATTACHMENTDATE()
        
End Sub
Protected Sub onValidate_CONTENTS__EFFECTIVEDATE()
        
End Sub
Protected Sub onValidate_CONTENTS__PREMIUM()
        
        
End Sub
Protected Sub onValidate_Button_btnContentsCalculate()
        
End Sub
Protected Sub onValidate_CONTENTS__SUMINSURED()
        
End Sub
Protected Sub onValidate_CONTENTS__COVERTYPE()
        
End Sub
Protected Sub onValidate_CONTENTS__ALARMTYPECDE()
        
End Sub
Protected Sub onValidate_CONTENTS__REASON()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_CONTENTS__ATTACHMENTDATE()
    onValidate_CONTENTS__EFFECTIVEDATE()
    onValidate_CONTENTS__PREMIUM()
    onValidate_Button_btnContentsCalculate()
    onValidate_CONTENTS__SUMINSURED()
    onValidate_CONTENTS__COVERTYPE()
    onValidate_CONTENTS__ALARMTYPECDE()
    onValidate_CONTENTS__REASON()
End Sub

		    
        Protected Shadows Sub Page_Load_AttachmentDate(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim isTrueMonthly = Session(CNIsTrueMonthlyPolicy)
        	
        	Dim transactionValue = String.Empty
        	
        	If Session(CNMTAType) = MTAType.PERMANENT Or Session(CNMTAType) = MTAType.TEMPORARY Then
        		transactionValue = "MTA"
        	ElseIf Session(CNRenewal) IsNot Nothing Or Session.Item("CNRenewal") IsNot Nothing Then
        		transactionValue = "REN"
        	ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
        		transactionValue = "MTC"
        	ElseIf Session(CNMode) = Mode.View Then
        		transactionValue = "VIEW"
        	Else
        		transactionValue = "NB"
        	End If
        	
        	If CONTENTS__ATTACHMENTDATE.Text = "" or CONTENTS__ATTACHMENTDATE.Text Is Nothing Then
        		If transactionValue = "NB" Then
        			CONTENTS__ATTACHMENTDATE.Text = RTrim(LTrim(oQuote.InceptionDate))
        		Else
        			CONTENTS__ATTACHMENTDATE.Text = RTrim(LTrim(oQuote.CoverStartDate))
        		End If
        	End If
        	
        	If oQuote.Risks(Session(CNCurrentRiskKey)).RiskInceptionDate <> oQuote.InceptionDate And (CONTENTS__ATTACHMENTDATE.Text <> "" Or CONTENTS__ATTACHMENTDATE.Text IsNot Nothing) Then
        		If transactionValue <> "NB" Then
        			If transactionValue <> "REN" Then
        				CONTENTS__ATTACHMENTDATE.Text = RTrim(LTrim(oQuote.CoverStartDate))
        			End If
        		Else
        			CONTENTS__ATTACHMENTDATE.Text = RTrim(LTrim(oQuote.InceptionDate))
        		End If
        	End If
        	
        End Sub
    
        Protected Shadows Sub Page_Load_EffectiveDate(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim isTrueMonthly = Session(CNIsTrueMonthlyPolicy)
        	
        	Dim transactionValue = String.Empty
        	
        	If Session(CNMTAType) = MTAType.PERMANENT Or Session(CNMTAType) = MTAType.TEMPORARY Then
        		transactionValue = "MTA"
        	ElseIf Session(CNRenewal) IsNot Nothing Or Session.Item("CNRenewal") IsNot Nothing Then
        		transactionValue = "REN"
        	ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
        		transactionValue = "MTC"
        	ElseIf Session(CNMode) = Mode.View Then
        		transactionValue = "VIEW"
        	Else
        		transactionValue = "NB"
        	End If
        	
        	If transactionValue = "NB" Then
        		CONTENTS__EFFECTIVEDATE.Text = RTrim(LTrim(oQuote.InceptionDate))
        	End If
        	
        	If transactionValue = "MTA" Then
        		CONTENTS__EFFECTIVEDATE.Text = RTrim(LTrim(oQuote.CoverStartDate))
        	End If
        	
        	If transactionValue = "REN" Then
        		CONTENTS__EFFECTIVEDATE.Text = RTrim(LTrim(oQuote.InceptionTPI))
        	End If
        	
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
        	If (CONTENTS__PREMIUM.Text = "") And (CONTENTS__PREMIUM.Text = Nothing) Then
        		oCustomValidator.ID = "ValidateCalculateButton"
        		oCustomValidator.ErrorMessage = "Calculate Premium button must be clicked in order to proceed"
        		oCustomValidator.IsValid = False
        	End If
        
        	Page.Validators.Add(oCustomValidator)
        
        End Sub
    
        Private Sub btnCalculatePremium_Click(sender As Object, e As EventArgs) Handles btnContentsCalculate.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		CONTENTS__PREMIUM.Text = ""
        		'BUILDINGS__PREMIUM.Text = ""
        		DiscountValidator()
         		CalculatePremiums()
            End If
        End Sub
        
        Protected Sub CalculatePremiums()
            Dim sURLNew As String = HttpContext.Current.Request.Url.ToString()
        	
        	'Same save the data entered by the user to dataset
            WriteRisk()
        	If Session("ValidDiscount") = 0 then
        		Try
        			Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        			Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        			
        			'Preferred method
        			oWebService.UpdateRisk(oQuote, CInt(Session(CNCurrentRiskKey)), Nothing, Nothing, Nothing)
        			
        			'To be used if automatic calling of PRE can't be avoided
        			'oWebService.ExecutePRERuleset(oQuote, CInt(Session(CNCurrentRiskKey)), Nothing, Nothing, sTransactionType, False, "", False, False)
        		Catch
        
        		End Try
        	End If
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
        
    
        
        Protected Shadows Sub Page_Load_SICheck(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Session("ValidSI") = 0
        	If Session("SIData") is Nothing Then
        		If (CONTENTS__SUMINSURED.Text = "") Or (CONTENTS__SUMINSURED.Text = Nothing) Then
        			Session("SIData") = -1
        		Else
        			Session("SIData") = CONTENTS__SUMINSURED.Text
        		End If
        	End If
        	SIValidator()
        End Sub
        
        Protected Sub btnNextSICheck_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		SIValidator()
        		If Session("SIChange") = 1 Then
        			Session("SIData") = Nothing
        		End If
        	End If
        End Sub
        
        Protected Sub btnNextTopSICheck_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNextTop.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		SIValidator()
        		If Session("SIChange") = 1 Then
        			Session("SIData") = Nothing
        		End If
        	End If
        End Sub
        
         Protected Sub btnFinishSICheck_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinish.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		SIValidator()
        		If Session("SIChange") = 1 Then
        			Session("SIData") = Nothing
        		End If
        	End If
        End Sub
        
        Protected Sub btnFinishTopSICheck_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinishTop.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		SIValidator()
        		If Session("SIChange") = 1 Then
        			Session("SIData") = Nothing
        		End If
        	End If
        End Sub
        
        Private Sub SIValidator()
        	Dim oCustomValidatorSI As New CustomValidator()
        	Dim oCustomValidatorRoofSI As New CustomValidator()
        	Dim oCustomValidatorWallSI As New CustomValidator()
        	Dim IsSanctionAllowed
        	Dim SanctionStatus
        	Dim RoofCombinedSI
        	Dim RoofSI, WallSI
        	Dim CurrentCover
        	Dim BuildSI, ContentSI, AllRiskSI, MachBrkSI
        	Dim OriginalSI, CurrentSI, SumSI
        	
        	Session("SIChange") = 0
        	IsSanctionAllowed = 0
        	
        	'Get the Sanction Status
        	SanctionStatus = CDbl(GetValue("GENERAL","SISANC"))
        	
        	'Get the original SI
        	OriginalSI = Session("SIData")
        	
        	'Get the SI amounts
        	BuildSI = GetValue("BUILDINGS","SUMINSURED")
        	ContentSI = GetValue("CONTENTS","SUMINSURED")
        	AllRiskSI = GetValue("ALLRISK","TOTSUMINSURED")
        	MachBrkSI = GetValue("MECHELECTRIC","SUMINSURED")
        
        	'Ensure that the SI entered is not null - Set to 0 if Null
        	'Check if there is a percentage entered on screen
        	If BuildSI = "" or BuildSI = Nothing Then
        		BuildSI = CDbl(0)
        	Else
        		BuildSI = CDbl(BuildSI)
        	End If
        	
        	'Check if there is a percentage entered on screen
        	If ContentSI = "" or ContentSI = Nothing Then
        		ContentSI = CDbl(0)
        	Else
        		ContentSI = CDbl(ContentSI)
        	End If
        	
        	'Check if there is a percentage entered on screen
        	If AllRiskSI = "" or AllRiskSI = Nothing Then
        		AllRiskSI = CDbl(0)
        	Else
        		AllRiskSI = CDbl(AllRiskSI)
        	End If
        	
        	'Check if there is a percentage entered on screen
        	If MachBrkSI = "" or MachBrkSI = Nothing Then
        		MachBrkSI = CDbl(0)
        	Else
        		MachBrkSI = CDbl(MachBrkSI)
        	End If
        	
        	SumSI = BuildSI + ContentSI + AllRiskSI + MachBrkSI
        	
        	'Get the Current Cover
        	CurrentCover = "CONTENTS"
        	
        	If CurrentCover = "BUILDINGS" Then
        		CurrentSI = BuildSI
        	End If
        	
        	If CurrentCover = "CONTENTS" Then
        		CurrentSI = ContentSI
        	End If
        	
        	If CurrentCover = "ALLRISK" Then
        		CurrentSI = AllRiskSI
        	End If
        	
        	If CurrentCover = "MECHELECTRIC" Then
        		CurrentSI = MachBrkSI
        	End If
        	
        	
        	If SanctionStatus = 1 Then
        		IsSanctionAllowed = 1
        	Else
        		RoofCombinedSI = CDbl(GetValue("GENERAL","ROOF_COMBINED_SI"))
        		
        		If CurrentCover = "BUILDINGS" OR CurrentCover = "CONTENTS" Then
        			RoofSI = CDbl(GetValue("GENERAL","ROOF_CONTENT_MAX_SI"))
        			WallSI = CDbl(GetValue("GENERAL","WALL_CONTENT_MAX_SI"))
        			
        			If CurrentSI = OriginalSI Then
        				IsSanctionAllowed = 1
        			Else
        				If CurrentSI > RoofSI Then
        					Session("ValidSI") = 1
        					oCustomValidatorRoofSI.ID = "ValidateRoofSI"
        					oCustomValidatorRoofSI.ErrorMessage = "Sum Insured exceeds maximum Roof construction value"
        					oCustomValidatorRoofSI.IsValid = False
        					Page.Validators.Add(oCustomValidatorRoofSI)
        				End If
        				
        				If CurrentSI > WallSI Then
        					Session("ValidSI") = 1
        					oCustomValidatorWallSI.ID = "ValidateWallSI"
        					oCustomValidatorWallSI.ErrorMessage = "Sum Insured exceeds maximum Wall construction value"
        					oCustomValidatorWallSI.IsValid = False
        					Page.Validators.Add(oCustomValidatorWallSI)
        				End If				
        				
        				If SumSI > RoofCombinedSI Then
        					IsSanctionAllowed = 0
        				Else
        					IsSanctionAllowed = 1
        				End If
        			End If
        		Else
        			If CurrentSI = OriginalSI Then
        				IsSanctionAllowed = 1
        			Else
        				If SumSI > RoofCombinedSI Then
        					IsSanctionAllowed = 0
        				Else
        					IsSanctionAllowed = 1
        				End If
        			End If
        		End If
        	End If
        	
        	oCustomValidatorSI.ID = "ValidateSICombined"
        	oCustomValidatorSI.ErrorMessage = "Combined Sum Insured exceeds maximum"
        	
        	If IsSanctionAllowed = 1 Then
        		Session("SIChange") = 1
        		oCustomValidatorSI.IsValid = True
        		Session("ValidSI") = 0
        	Else
        		oCustomValidatorSI.IsValid = False
        		Session("ValidSI") = 1
        	End If
        
        	Page.Validators.Add(oCustomValidatorSI)
        
        End Sub
    
        
        Protected Shadows Sub Page_Load_For_Defaults_CONTENTS_COVERTYPE(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
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
                    If command.ToUpper() = "POPULATEDEFAULTS_CONTENTS_COVERTYPE".ToUpper() Then
                        If result.Length >= 1 Then
                            Dim onChangeType As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					Dim vCode As String = If(Not result(2) Is Nothing, result(2).ToString(), "")
                            If onChangeType <> "" Then
                                Retrieve_List_Defaults_For_CONTENTS_COVERTYPE(onChangeType, vCode)
                            End If
                        End If
                    End If
        			
        			If command.ToUpper() = "POPULATECHECKBOXDEFAULTS_CONTENTS_COVERTYPE".ToUpper() Then
                        If result.Length >= 1 Then
                            Dim onChangeType As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
                            If onChangeType <> "" Then
                                Retrieve_Checkbox_Defaults_For_CONTENTS_COVERTYPE(onChangeType)
                            End If
                        End If
                    End If
                End If
            End If
        End If
        
        End Sub
        
        Protected Sub Retrieve_List_Defaults_For_CONTENTS_COVERTYPE(ByVal onChangeType As String, ByVal sCode As String)
        
        Dim buildScript As new System.Text.StringBuilder()
        
        Dim ListCode = "UDL_CKCOVTYPE"
        
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
                                    If onChangeType = "COVERTYPE" Then
                                        If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sCode Then
                                            Dim ObjectsPropertiesArray As String() = {"CONTENTS.CONTENT_MIN_SI,Min_SI", "CONTENTS.CONTENT_HH,Min_HHome_SI", "{3}", "{4}", "{5}", "{6}", "{7}", "{8}", "{9}", "{10}", "{11}", "{12}", "{13}", "{14}", "{15}", "{16}"}
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
                    CompleteASyncPostback_For_CONTENTS_COVERTYPE(buildScript.ToString())
                End If
            End If
        
        Catch
            Exit Sub
        End Try
        
        End Sub
        
        Protected Sub Retrieve_Checkbox_Defaults_For_CONTENTS_COVERTYPE(ByVal onChangeType As String)
        
        Dim buildScript As new System.Text.StringBuilder()
        
        Dim ListCode = "UDL_CKCOVTYPE"
        Dim sCode = "CONTENTS.CONTENT_MIN_SI,Min_SI"
        
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
                                    If onChangeType = "COVERTYPE" Then
                                        If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sCode.Trim() Then
                                            Dim ObjectsPropertiesArray As String() = {"CONTENTS.CONTENT_HH,Min_HHome_SI", "{3}", "{4}", "{5}", "{6}", "{7}", "{8}", "{9}", "{10}", "{11}", "{12}", "{13}", "{14}", "{15}", "{16}"}
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
                    CompleteASyncPostback_For_CONTENTS_COVERTYPE(buildScript.ToString())
                End If
            End If
        
        Catch
            Exit Sub
        End Try
        
        End Sub
        
        
        Protected Sub CompleteASyncPostback_For_CONTENTS_COVERTYPE(ByVal buildScript As String)
        ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "AsyncPostback",
        													  buildScript,
        													  True)
        	asyncPanel.Update()
        End Sub
    
        Protected Shadows Sub Page_Load_Alarm(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Session("Valid") = 0
        	If Session("AlarmData") is Nothing Then
        		If (CONTENTS__ALARMTYPECDE.text = "") Or (CONTENTS__ALARMTYPECDE.text = Nothing) Then
        			Session("AlarmData") = "-1"
        		Else
        			Session("AlarmData") = CONTENTS__ALARMTYPECDE.text
        		End If
        	End If
        	AlarmValidation()
        End Sub
        
        Protected Sub btnNextAlarm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
            If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		AlarmValidation()
        		If Session("AlarmChange") = 1 Then
        			Session("AlarmData") = Nothing
        		End If
        	End If
        End Sub
        
        Protected Sub btnNextTopAlarm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNextTop.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		AlarmValidation()
        		If Session("AlarmChange") = 1 Then
        			Session("AlarmData") = Nothing
        		End If
        	End If
        End Sub
        
         Protected Sub btnFinishAlarm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinish.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		AlarmValidation()
        		If Session("AlarmChange") = 1 Then
        			Session("AlarmData") = Nothing
        		End If
        	End If
        End Sub
        
        Protected Sub btnFinishTopAlarm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinishTop.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		AlarmValidation()
        		If Session("AlarmChange") = 1 Then
        			Session("AlarmData") = Nothing
        		End If
        	End If
        End Sub
        
        Private Sub AlarmValidation()
        	Dim AreaCode As String = ""
        	Dim CoverType As String = ""
        	Dim AlarmSanction As String = ""
        	Dim AlarmType As String = ""
        	Dim Town As String = ""
        	Dim OriginalAlarmType
        	Dim IsSanctionAllowed
        	
        	Dim oCustomValidator As New CustomValidator()
        	oCustomValidator.ID = "ValidateAlarmMandate"
        	oCustomValidator.ErrorMessage = "Alarm required - Please Contact HOLLARD"
        	
        	AlarmSanction = GetValue("GENERAL", "CONTENTSANC")
        	
        	If AlarmSanction = "1" Then
        		Session("AlarmChange") = 1
        		oCustomValidator.IsValid = True
        	Else
        		'Get OriginalAlarmType	from session
        		OriginalAlarmType = Session("AlarmData")
        		
        		AlarmType = CONTENTS__ALARMTYPECDE.text
        		
        		If OriginalAlarmType = AlarmType Then
        			Session("AlarmChange") = 1
        			oCustomValidator.IsValid = True
        		Else
        			Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        			CoverType = CONTENTS__COVERTYPE.Code
        			Town = GetValue("ADDRESS", "TOWN")
        			AreaCode = GetAreaCode("UDL_TOWN_DESC", town, "area_code")
        			
        			Session("AlarmChange") = 1
        			oCustomValidator.IsValid = True
        			
        			If (AreaCode = "26" OR AreaCode = "31" OR AreaCode = "32" OR AreaCode = "62") And (AlarmSanction = "0") AND (CoverType = "1") AND (Not(AlarmType = "2")) Then
        				Session("AlarmChange") = 0
        				oCustomValidator.IsValid = False
        			End If
        		End If
        	End If
        
        	Page.Validators.Add(oCustomValidator)
        
        End Sub
        
        
        Protected Function GetAreaCode(ByVal sListCode As String, ByVal itemDesc As String, ByVal sValue As String) As String
        	Dim value As String = String.Empty
        	Dim LstXmlElement As XmlElement = Nothing
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        	Dim oList As New NexusProvider.LookupListCollection
        	oList = oWebService.GetList(NexusProvider.ListType.PMLookup, sListCode, False, False,,,, LstXmlElement)
        	Dim sXML As String = LstXmlElement.OuterXml
        	Dim xmlDoc As New System.Xml.XmlDocument
        	Dim NodeList As XmlNodeList
        	xmlDoc.LoadXml(sXML)
        
        	NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & sListCode)
        	If NodeList.Count > 0 Then
        		value = (From Node As XmlNode In NodeList Where Node.SelectSingleNode("description").InnerText.Trim() = itemDesc Select Node.SelectSingleNode(sValue).InnerText.Trim()).FirstOrDefault()
        	End If
        	Return value
         End Function
    
        
        Protected Shadows Sub Page_Load_DiscountSave(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Session("ValidDiscount") = 0
        	If Session("DiscountData") is Nothing Then
        		If (CONTENTS__INDICATOR_PERC.Text = "") Or (CONTENTS__INDICATOR_PERC.Text = Nothing) Or (CONTENTS__PREMIUM.Text = "") Or (CONTENTS__PREMIUM.Text = Nothing) Then
        			Session("DiscountData") = -1
        		Else
        			Session("DiscountData") = CONTENTS__INDICATOR_PERC.Text
        		End If
        	End If
        	DiscountValidator()
        End Sub
        
        Protected Sub btnNextDiscount_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		DiscountValidator()
        		If Session("DiscountChange") = 1 Then
        			Session("DiscountData") = Nothing
        		End If
        	End If
        End Sub
        
        Protected Sub btnNextTopDiscount_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNextTop.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		DiscountValidator()
        		If Session("DiscountChange") = 1 Then
        			Session("DiscountData") = Nothing
        		End If
        	End If
        End Sub
        
         Protected Sub btnFinishDiscount_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinish.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		DiscountValidator()
        		If Session("DiscountChange") = 1 Then
        			Session("DiscountData") = Nothing
        		End If
        	End If
        End Sub
        
        Protected Sub btnFinishTopDiscount_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinishTop.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		DiscountValidator()
        		If Session("DiscountChange") = 1 Then
        			Session("DiscountData") = Nothing
        		End If
        	End If
        End Sub
        
        Private Sub DiscountValidator()
        	Dim oCustomValidatorDisc As New CustomValidator()
        	Dim SanctionPercentage
        	Dim CurrentPercentage
        	Dim PreviousPercentage
        	Dim DiscountStatus
        	Dim IsSanctionAllowed
        	
        	IsSanctionAllowed = 0
        	Session("DiscountChange") = 0
        	
        	'Get whether it is loading or discount
        	DiscountStatus = CONTENTS__INDICATORCDE.Text
        	'Get the sanction amount
        	SanctionPercentage = CDbl(GetValue("GENERAL","DISCSANC"))
        	'Get the current amount
        	CurrentPercentage = CONTENTS__INDICATOR_PERC.Text
        	'Get the previously entered amount from the session
        	PreviousPercentage = CDbl(Session("DiscountData"))
        	
        	'Check if there is a percentage entered on screen
        	If CurrentPercentage = "" or CurrentPercentage = Nothing Then
        		CurrentPercentage = CDbl(0)
        	Else
        		CurrentPercentage = CDbl(CurrentPercentage)
        	End If
        	
        	
        	If SanctionPercentage = PreviousPercentage Then
        		IsSanctionAllowed = 1
        	Else
        		If CurrentPercentage > SanctionPercentage Then
        			If CurrentPercentage = PreviousPercentage Then
        				IsSanctionAllowed = 1
        			Else
        				IsSanctionAllowed = 0
        			End If
        		Else
        			IsSanctionAllowed = 1
        		End If
        	End If
        	
        	If IsSanctionAllowed = 1 Then
        		Session("DiscountChange") = 1
        	End If
        	
        	
        	'Check if it has been changed
        	oCustomValidatorDisc.ID = "ValidateDiscountPercentage"
        	oCustomValidatorDisc.ErrorMessage = "Discount % is more than allowed"
        	oCustomValidatorDisc.IsValid = False
        	Session("ValidDiscount") = 1
        	If ((DiscountStatus = "L") OR (DiscountStatus = "") OR ((DiscountStatus = "D") AND (IsSanctionAllowed = 1))) Then
        		oCustomValidatorDisc.IsValid = True
        		Session("ValidDiscount") = 0
        	End If
        
        	Page.Validators.Add(oCustomValidatorDisc)
        
        End Sub

    End Class
End Namespace