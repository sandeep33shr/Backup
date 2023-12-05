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
    Partial Class PB2_NPADOM_Mechanical_and_Electrical_Breakdown : Inherits BaseRisk
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
		
		Protected Sub onValidate_MECHELECTRIC__COMBINED_SI()
        
End Sub
Protected Sub onValidate_MECHELECTRIC__PREMIUM()
        
        
End Sub
Protected Sub onValidate_Button_btnMechCalculate()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_MECHELECTRIC__COMBINED_SI()
    onValidate_MECHELECTRIC__PREMIUM()
    onValidate_Button_btnMechCalculate()
End Sub

		    
        
        Protected Shadows Sub Page_Load_SICheck(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Session("ValidSI") = 0
        	If Session("SIData") is Nothing Then
        		If (MECHELECTRIC__SUMINSURED.Text = "") Or (MECHELECTRIC__SUMINSURED.Text = Nothing) Then
        			Session("SIData") = -1
        		Else
        			Session("SIData") = MECHELECTRIC__SUMINSURED.Text
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
        Protected Sub btnBackTopSICheck_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBackTop.Click
            If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
                Session("SIData") = Nothing
            End If
        End Sub

        Protected Sub btnBackSICheck_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBack.Click
            If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
                Session("SIData") = Nothing
            End If
        End Sub

        Protected Sub tabClickSICheck_TabClicked(ByVal v_sPath As String) Handles ctrlTabIndex.TabClicked
            If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
                Session("SIData") = Nothing
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
        	CurrentCover = "MECHELECTRIC"
        	
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
        			RoofSI = CDbl(GetValue("GENERAL","ROOF_BUILD_MAX_SI"))
        			WallSI = CDbl(GetValue("GENERAL","WALL_BUILD_MAX_SI"))
        			
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
        	If (MECHELECTRIC__PREMIUM.Text = "") And (MECHELECTRIC__PREMIUM.Text = Nothing) Then
        		oCustomValidator.ID = "ValidateCalculateButton"
        		oCustomValidator.ErrorMessage = "Calculate Premium button must be clicked in order to proceed"
        		oCustomValidator.IsValid = False
        	End If
        
        	Page.Validators.Add(oCustomValidator)
        
        End Sub
    
        Private Sub btnCalculatePremium_Click(sender As Object, e As EventArgs) Handles btnMechCalculate.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		MECHELECTRIC__PREMIUM.Text = ""
         		CalculatePremiums()
            End If
        End Sub
        
        Protected Sub CalculatePremiums()
            Dim sURLNew As String = HttpContext.Current.Request.Url.ToString()
        	
        	'Same save the data entered by the user to dataset
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