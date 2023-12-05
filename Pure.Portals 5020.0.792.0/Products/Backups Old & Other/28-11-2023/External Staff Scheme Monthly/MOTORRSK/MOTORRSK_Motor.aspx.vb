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
    Partial Class PB2_MOTORRSK_Motor : Inherits BaseRisk
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
		
		Protected Sub onValidate_Custom_btnTUButton()
        
        
End Sub
Protected Sub onValidate_MOTOR__QUOTE_DATE()
        
End Sub
Protected Sub onValidate_MOTOR__TOT_SI()
        
End Sub
Protected Sub onValidate_MOTOR__REASON()
        
End Sub
Protected Sub onValidate_MOTOR__PREMIUM()
        
        
End Sub
Protected Sub onValidate_Button_btnPremiumCalculate()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_Custom_btnTUButton()
    onValidate_MOTOR__QUOTE_DATE()
    onValidate_MOTOR__TOT_SI()
    onValidate_MOTOR__REASON()
    onValidate_MOTOR__PREMIUM()
    onValidate_Button_btnPremiumCalculate()
End Sub

		    
        Protected Sub btnTUSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        	If IsPostBack Then
        		Dim oWebservice As New TransUnionProject.Transunion
        		Dim oVehicleList As System.Collections.Generic.List(Of TransUnionProject.TransUnionWCFService.TUVehicles) = Nothing
        		Dim oCTList As System.Collections.Generic.List(Of TransUnionProject.TransUnionWCFService.CTVehicles) = Nothing
        		Dim oGreyManList As System.Collections.Generic.List(Of TransUnionProject.TransUnionWCFService.GreyManVehicles) = Nothing
        		Try
        			Dim sMakeModel As String = MOTOR__MAKEMODEL.Text
        			Dim sMMCode As String = MOTOR__MMCODE.Text
        			Dim sMYear As String = MOTOR__MAN_YEAR.Text
        			Dim dQuoteDate As Date = MOTOR__QUOTE_DATE.Text
        			Dim sVehicleType As String = MOTOR__TUVEHTYPE.Text
        			Dim sListOption = MOTOR__TUTYPECODE.Text
        			
        			If sVehicleType = "Caravan" Or sVehicleType = "Trailer" Then
        				Dim sOption As String = "Caravan"
        				If sVehicleType = "Trailer" Then
        					sOption = "Trailer"
        				End If
        				oCTList = oWebservice.GetCTVehicles(sOption, dQuoteDate, sMakeModel, sMMCode)
        				Dim sURL As String = "/portal/internal/Modal/TransUnionCT.aspx?modal=true&KeepThis=true&TB_iframe=true&height=200&width=750"
        				If HttpContext.Current.Session.IsCookieless Then
        					sURL = Request.ApplicationPath + "/(S(" & Session.SessionID.ToString() + "))" + sURL
        				Else
        					sURL = Request.ApplicationPath + sUrl
        				End If
        				
        				Page.ClientScript.RegisterClientScriptBlock(Me.GetType(), "tb_show", _
        				"<script language=""JavaScript"" type=""text/javascript"">$(document).ready(function(){tb_show( null,'" & sURL & "' , null);});</script>")
        				Session("WEBSERVICECTDATA") = oCTList
        			ElseIf (sVehicleType = "Private Motor" AND sListOption = "3") OR sVehicleType = "Motor Cycle" OR (sVehicleType = "Motor Xtender" AND sListOption = "3") Then
        				Dim sOption As String = "Vehicle"
        				Session("VehicleType") = "stdMotor"
        				If sVehicleType = "Motor Cycle" Then
        					sOption = "MotorCycle"
        					Session("VehicleType") = "Motorcycle"
        				End If
        				oVehicleList = oWebservice.GetTUVehicles(sOption, dQuoteDate, sMakeModel, sMMCode, sMYear)
        				Dim sURL As String = "/portal/internal/Modal/TransUnion.aspx?modal=true&KeepThis=true&TB_iframe=true&height=200&width=750"
        				If HttpContext.Current.Session.IsCookieless Then
        					sURL = Request.ApplicationPath + "/(S(" & Session.SessionID.ToString() + "))" + sURL
        				Else
        					sURL = Request.ApplicationPath + sUrl
        				End If
        				
        				Page.ClientScript.RegisterClientScriptBlock(Me.GetType(), "tb_show", _
        				"<script language=""JavaScript"" type=""text/javascript"">$(document).ready(function(){tb_show( null,'" & sURL & "' , null);});</script>")
        				Session("WEBSERVICETUDATA") = oVehicleList
        			Else
        				Dim sOption As String = "Grey"
        				Session("GMType") = "G"
        				If sListOption = "2" Then
        					sOption = "Manual"
        					Session("GMType") = "M"
        				End If
        				oGreyManList = oWebservice.GetGreyManVehicles(sOption, dQuoteDate, sMakeModel, sMMCode, sMYear)
        				Dim sURL As String = "/portal/internal/Modal/TransUnionGM.aspx?modal=true&KeepThis=true&TB_iframe=true&height=200&width=750"
        				If HttpContext.Current.Session.IsCookieless Then
        					sURL = Request.ApplicationPath + "/(S(" & Session.SessionID.ToString() + "))" + sURL
        				Else
        					sURL = Request.ApplicationPath + sUrl
        				End If
        				
        				Page.ClientScript.RegisterClientScriptBlock(Me.GetType(), "tb_show", _
        				"<script language=""JavaScript"" type=""text/javascript"">$(document).ready(function(){tb_show( null,'" & sURL & "' , null);});</script>")
        				Session("WEBSERVICEGMDATA") = oGreyManList
        			End If
        		
        		Catch ex As System.Web.Services.Protocols.SoapException
        			Page.ClientScript.RegisterStartupScript(GetType(String), "ClearOldResponse", "ClearOldResponse();", True)
        		Finally
        			oWebservice = Nothing
        			oVehicleList = Nothing
        			oCTList = Nothing
        		End Try
        	End If
        	End If
        End Sub
    
        Protected Sub btnTUClear_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		If IsPostBack Then
        			MOTOR__MMCODE.Text = ""
        			MOTOR__MAKEMODEL.Text = ""
        			MOTOR__MAKE.Text = ""
        			MOTOR__MODEL.Text = ""
        			MOTOR__BODTYPECODE.Text = ""
        			MOTOR__BODY_TYPE.Value = ""
        			MOTOR__CUBICCAP.Text = ""
        			MOTOR__KWATTS.Text = ""
        			MOTOR__VEHMASS.Text = ""
        			MOTOR__GWM.Text = ""
        			MOTOR__MAN_YEAR.Text = ""
        			MOTOR__FUEL.Value = ""
        			MOTOR__FUELCODE.Text = ""
        			MOTOR__RETAILVAL.Text = ""
        			MOTOR__COVGRP.Text = ""
        			'MOTOR__IS_REBUILD.Text = "0"
        			MOTOR__TMPRETAIL.Text = ""
        			'MOTOR__TYPE_BIKE.Value = ""
        			'MOTOR__CURRKM.Text = ""
        			'MOTOR__MXVEH_CAT.Value = ""
        			'MOTOR__VEH_CAT.Value = ""
        			'MOTOR__VIN_NO.Text = ""
        			'MOTOR__ENGINE_NO.Text = ""
        			'MOTOR__CHASSIS.Text = ""
        			'MOTOR__REG_NO.Text = ""
        			'MOTOR__EXTRA.Text = "0"
        			'MOTOR__RADIO.Text = "0"
        		End If
        	End If
        End Sub
    
        Protected Shadows Sub Page_Load_ClientInfo(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
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
        		If isTrueMonthly Then
        			MOTOR__QUOTE_DATE.Text = RTrim(LTrim(oQuote.InceptionDate))
        		Else
        			MOTOR__QUOTE_DATE.Text = RTrim(LTrim(oQuote.InceptionTPI))
        		End If
        	End If
        	
        End Sub
    
        
        Protected Shadows Sub Page_Load_SICheck(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Dim VehicleTypeCode
        	Session("ValidSI") = 0
        	If Session("SIData") is Nothing Then
        		VehicleTypeCode = GetValue("MOTOR","VEHTYPECODE")
        		If VehicleTypeCode = "5" Then
        			If (MOTOR__VEH_VALUE.Text = "") Or (MOTOR__VEH_VALUE.Text = Nothing) Or (MOTOR__PREMIUM.Text = "") Or (MOTOR__PREMIUM.Text = Nothing) Then
        				Session("SIData") = -1
        			Else
        				Session("SIData") = MOTOR__VEH_VALUE.Text
        			End If
        		Else
        			If (MOTOR__TOT_SI.Text = "") Or (MOTOR__TOT_SI.Text = Nothing) Or (MOTOR__PREMIUM.Text = "") Or (MOTOR__PREMIUM.Text = Nothing) Then
        				Session("SIData") = -1
        			Else
        				Session("SIData") = MOTOR__TOT_SI.Text
        			End If
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
        	Dim IsSanctionAllowed
        	Dim SanctionSI, VehicleTypeCode
        	Dim OriginalSI, CurrentSI
        	
        	oCustomValidatorSI.ID = "ValidateSICombined"
        	oCustomValidatorSI.ErrorMessage = "Vehicle Value exceeds Maximum allowed - Please contact HOLLARD"
        	
        	Session("SIChange") = 0
        	
        	'Get the Sanction Status
        	SanctionSI = CDbl(GetValue("MOTOR","MAXSI"))
        	
        	VehicleTypeCode = GetValue("MOTOR","VEHTYPECODE")
        	
        	'Get the original SI
        	OriginalSI = Session("SIData")
        	
        	'Get the current SI
        	If VehicleTypeCode = "5" Then
        		CurrentSI = CDbl(GetValue("MOTOR","VEH_VALUE"))
        	Else
        		CurrentSI = CDbl(GetValue("MOTOR","TOT_SI"))
        	End If
        	
        	If (OriginalSI = CurrentSI) Then 'OR (VehicleTypeCode = "5") Then
        		Session("SIChange") = 1
        		oCustomValidatorSI.IsValid = True
        		Session("ValidSI") = 0
        	Else
        		If CurrentSI > SanctionSI Then
        			oCustomValidatorSI.IsValid = False
        			Session("ValidSI") = 1
        		Else
        			Session("SIChange") = 1
        			oCustomValidatorSI.IsValid = True
        			Session("ValidSI") = 0
        		End If
        		
        	End If
        
        	Page.Validators.Add(oCustomValidatorSI)
        
        End Sub
    
        
        Protected Shadows Sub Page_Load_DiscountSave(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Session("ValidDiscount") = 0
        	If Session("DiscountData") is Nothing Then
        		If (MOTOR__INDICATOR_PERC.Text = "") Or (MOTOR__INDICATOR_PERC.Text = Nothing) Or (MOTOR__PREMIUM.Text = "") Or (MOTOR__PREMIUM.Text = Nothing) Then
        			Session("DiscountData") = -1
        		Else
        			Session("DiscountData") = MOTOR__INDICATOR_PERC.Text
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
        	DiscountStatus = MOTOR__IND_CODE.Text
        	'Get the sanction amount
        	SanctionPercentage = CDbl(GetValue("MOTOR","DISCSANC"))
        	'Get the current amount
        	CurrentPercentage = MOTOR__INDICATOR_PERC.Text
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
        	If (MOTOR__PREMIUM.Text = "") And (MOTOR__PREMIUM.Text = Nothing) Then
        		oCustomValidator.ID = "ValidateCalculateButton"
        		oCustomValidator.ErrorMessage = "Calculate Premium button must be clicked in order to proceed"
        		oCustomValidator.IsValid = False
        	End If
        
        	Page.Validators.Add(oCustomValidator)
        
        End Sub
    
        Private Sub btnPremiumCalculate_Click(sender As Object, e As EventArgs) Handles btnPremiumCalculate.Click
        	If Not (CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review) Then
        		MOTOR__PREMIUM.Text = ""
        		MOTOR__MXPREMIUM.Text = ""
        		MOTOR__SXCARHIREPREM.Text = ""
        		MOTOR__SXPREM.Text = ""
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
        

    End Class
End Namespace