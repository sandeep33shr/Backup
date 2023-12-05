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
    Partial Class PB2_VAPRISK_Value_Added_Products : Inherits BaseRisk
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
		
		Protected Sub onValidate_Custom_btnTUButton()
        
        
End Sub
Protected Sub onValidate_VAP__QUOTEDATE()
        
End Sub
Protected Sub onValidate_VAP__RET_INVOICE()
        
End Sub
Protected Sub onValidate_Button_btnCSCalculatePrem()
        
End Sub
Protected Sub onValidate_Button_btnDPCalculatePrem()
        
End Sub
Protected Sub onValidate_Button_btnRICalculatePrem()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_Custom_btnTUButton()
    onValidate_VAP__QUOTEDATE()
    onValidate_VAP__RET_INVOICE()
    onValidate_Button_btnCSCalculatePrem()
    onValidate_Button_btnDPCalculatePrem()
    onValidate_Button_btnRICalculatePrem()
End Sub

		    
        Protected Sub btnTUSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        
        
        	 Dim sVehicleType As String = VAP__TUVEHTYPE.Text
             Dim sListOption = VAP__TUTYPECODE.Text
        	 
        	If ((sVehicleType="Private Motor" or sVehicleType="Motor Cycle") and not(sListOption="" and sListOption = Nothing))  or (sVehicleType = "Caravan & Trailer") Then    
        			If IsPostBack Then
                        Dim oWebservice As New TransUnionProject.Transunion
                        Dim oVehicleList As System.Collections.Generic.List(Of TransUnionProject.TransUnionWCFService.TUVehicles) = Nothing
                        Dim oCTList As System.Collections.Generic.List(Of TransUnionProject.TransUnionWCFService.CTVehicles) = Nothing
                       
        			   Dim oGreyManList As System.Collections.Generic.List(Of TransUnionProject.TransUnionWCFService.GreyManVehicles) = Nothing
                        Try
                            Dim sMakeModel As String = VAP__MAKE_MODEL_DESCRIPTION.Text
        
                            Dim sMMCode As String = VAP__MAKE.Text
        
                            Dim sMYear As String = "" 'VAP__MAN_YEAR.Text
        
                            Dim dQuoteDate As Date = VAP__QUOTEDATE.Text
                        
        
        
                            If sVehicleType = "Caravan & Trailer" Then
                                
                                oCTList = oWebservice.GetCTVehiclesCombined(dQuoteDate, sMakeModel, sMMCode)
        						
                                Dim sURL As String = "/portal/internal/Modal/TransUnionCT.aspx?modal=true&KeepThis=true&TB_iframe=true&height=200&width=750"
                                If HttpContext.Current.Session.IsCookieless Then
                                    sURL = Request.ApplicationPath + "/(S(" & Session.SessionID.ToString() + "))" + sURL
                                Else
                                    sURL = Request.ApplicationPath + sURL
                                End If
        
                                Page.ClientScript.RegisterClientScriptBlock(Me.GetType(), "tb_show",
                                "<script language=""JavaScript"" type=""text/javascript"">$(document).ready(function(){tb_show( null,'" & sURL & "' , null);});</script>")
                                Session("WEBSERVICECTDATA") = oCTList
                            ElseIf (sVehicleType = "Private Motor" And sListOption = "3") Or (sVehicleType = "Motor Cycle" And sListOption = "3") Then
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
                                    sURL = Request.ApplicationPath + sURL
                                End If
        
                                Page.ClientScript.RegisterClientScriptBlock(Me.GetType(), "tb_show",
                                "<script language=""JavaScript"" type=""text/javascript"">$(document).ready(function(){tb_show( null,'" & sURL & "' , null);});</script>")
                                Session("WEBSERVICETUDATA") = oVehicleList
                            Else
                                Dim sOption As String
                                If sVehicleType = "Private Motor" Then
                                    sOption = "Grey"
                                    If sListOption = "2" Then
                                        sOption = "Manual"
        
                                    End If
                                ElseIf sVehicleType = "Motor Cycle" Then
                                    sOption = "GreyMC"
                                    If sListOption = "2" Then
                                        sOption = "ManualMC"
                                    End If
        
                                End If
        
                                oGreyManList = oWebservice.GetGreyManVehicles(sOption, dQuoteDate, sMakeModel, sMMCode, sMYear)
                                Dim sURL As String = "/portal/internal/Modal/TransUnionGM.aspx?modal=true&KeepThis=true&TB_iframe=true&height=200&width=750"
                                If HttpContext.Current.Session.IsCookieless Then
                                    sURL = Request.ApplicationPath + "/(S(" & Session.SessionID.ToString() + "))" + sURL
                                Else
                                    sURL = Request.ApplicationPath + sURL
                                End If
        
                                Page.ClientScript.RegisterClientScriptBlock(Me.GetType(), "tb_show",
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
        		Else 
        		SearchValidator()
        		End If
        End Sub
        
        Private Sub SearchValidator()
            Dim oCustomValidator As New CustomValidator()
            oCustomValidator.IsValid = True
            If (VAP__TUTYPECODE.Text = "") or (VAP__TUTYPECODE.Text = Nothing) Then
                oCustomValidator.ID = "ValidateSearchButton"
                oCustomValidator.ErrorMessage = "Group must be selected in order to search"
                oCustomValidator.IsValid = False
            End If
            Page.Validators.Add(oCustomValidator)
        End Sub
    
        Protected Sub btnTUClear_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        	If IsPostBack Then
        		VAP__CC.Text = ""
        		VAP__MAKE.Text = ""
        		VAP__MAKE_MODEL_DESCRIPTION.Text = ""
        
        	End If
        End Sub
    
        Protected Shadows Sub LoadCoverStart(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim isTrueMonthly = Session(CNIsTrueMonthlyPolicy)
        
        	If isTrueMonthly Then
        		VAP__QUOTEDATE.Text = RTrim(LTrim(oQuote.InceptionDate))
        	Else
        		VAP__QUOTEDATE.Text = RTrim(LTrim(oQuote.InceptionTPI))
        	End If
         
        End Sub
    
        Protected Sub btnNextCalculate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
            PremiumValidator()
        	PremiumDepositValidator()
        	PremiumReturnToInvoiceValidator()
        End Sub
        
        Protected Sub btnNextTopCalculate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNextTop.Click
        	PremiumValidator()
        	PremiumDepositValidator()
        	PremiumReturnToInvoiceValidator()
        End Sub
        
         Protected Sub btnFinishCalculate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinish.Click
        	PremiumValidator()
        	PremiumDepositValidator()
        	PremiumReturnToInvoiceValidator()
        End Sub
        
        Protected Sub btnFinishTopCalculate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinishTop.Click
        	PremiumValidator()
        	PremiumDepositValidator()
        	PremiumReturnToInvoiceValidator()
        End Sub
        
        
        
        
        Private Sub PremiumValidator()
            Dim oCustomValidator As New CustomValidator()
            oCustomValidator.IsValid = True
        	
        	If VAP__CRED_SHORTFALL.Text = "1" Then
            If Not((VAPCRED__STAT_SETTLE.Text = "") And (VAPCRED__STAT_SETTLE.Text = Nothing)) Then
                If (VAPCRED__CREDIT_SHORTFALL_PREMIUM.Text = "") And (VAPCRED__CREDIT_SHORTFALL_PREMIUM.Text = Nothing) Then
                    oCustomValidator.ID = "ValidateCalculateButton"
                    oCustomValidator.ErrorMessage = "Calculate Premium button must be clicked in order to proceed"
                    oCustomValidator.IsValid = False
                End If
               End If
        	End If
            Page.Validators.Add(oCustomValidator)
        End Sub
        
        
        Private Sub PremiumDepositValidator()
            Dim oCustomValidator As New CustomValidator()
            oCustomValidator.IsValid = True
        	If VAP__DEP_PROTECTOR.Text = "1" Then
           
              If Not((VAPDEP__DEP_AMT.Text = "") And (VAPDEP__DEP_AMT.Text = Nothing) ) Then
                If (VAPDEP__DEPOSIT_PROTECTOR_PREMIUM.Text = "") And (VAPDEP__DEPOSIT_PROTECTOR_PREMIUM.Text = Nothing) Then
                    oCustomValidator.ID = "ValidateCalculateButton"
                    oCustomValidator.ErrorMessage = "Calculate Premium button must be clicked in order to proceed"
                    oCustomValidator.IsValid = False
                End If
             End If
        	 
        	End If
            Page.Validators.Add(oCustomValidator)
        End Sub
         
        
        Private Sub PremiumReturnToInvoiceValidator()
            Dim oCustomValidator As New CustomValidator()
            oCustomValidator.IsValid = True
        	If VAP__RET_INVOICE.Text = "1" Then
           
              If Not((VAPRET__PURCHA_AMT.Text = "") And (VAPRET__PURCHA_AMT.Text = Nothing) ) Then
        	  
                If (VAPRET__RETURN_TO_INVOICE_PREMIUM.Text = "") And (VAPRET__RETURN_TO_INVOICE_PREMIUM.Text = Nothing) Then
                    oCustomValidator.ID = "ValidateCalculateButton"
                    oCustomValidator.ErrorMessage = "Calculate Premium button must be clicked in order to proceed"
                    oCustomValidator.IsValid = False
                End If
        		
              End If
        	 
        	End If
            Page.Validators.Add(oCustomValidator)
        	
        End Sub
        
    
        
          Protected Sub btnCSCalculatePrem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCSCalculatePrem.Click
                    If Page.IsValid Then
                        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
                        CSCalculatePrem()
                    End If
                End Sub
        
        
                'Calls the any rating rule configured (VBScript/PRE/Compiled)
                Protected Sub CSCalculatePrem()
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
    
        
          Protected Sub btnDPCalculatePrem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDPCalculatePrem.Click
                    If Page.IsValid Then
                        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
                        DPCalculatePrem()
                    End If
                End Sub
        
        
                'Calls the any rating rule configured (VBScript/PRE/Compiled)
                Protected Sub DPCalculatePrem()
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
    
        
          Protected Sub btnRICalculatePrem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRICalculatePrem.Click
                    If Page.IsValid Then
                        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
                        RICalculatePrem()
                    End If
                End Sub
        
        
                'Calls the any rating rule configured (VBScript/PRE/Compiled)
                Protected Sub RICalculatePrem()
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