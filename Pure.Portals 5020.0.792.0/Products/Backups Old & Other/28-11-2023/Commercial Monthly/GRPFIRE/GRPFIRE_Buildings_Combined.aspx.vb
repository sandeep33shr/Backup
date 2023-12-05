﻿Imports CMS.Library
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
    Partial Class PB2_GRPFIRE_Buildings_Combined : Inherits BaseRisk
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
		
		Protected Sub onValidate_BUILDCOM__RISK_ATTACH_DATE()
        
End Sub
Protected Sub onValidate_BUILDCOM__EFFECTIVEDATE()
        
End Sub
Protected Sub onValidate_REINSEXP_BC__TOTAL_RI_EXP()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_BUILDCOM__RISK_ATTACH_DATE()
    onValidate_BUILDCOM__EFFECTIVEDATE()
    onValidate_REINSEXP_BC__TOTAL_RI_EXP()
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
        	
        	If BUILDCOM__RISK_ATTACH_DATE.Text = "" or BUILDCOM__RISK_ATTACH_DATE.Text Is Nothing Then
        		If transactionValue = "NB" Then
        			BUILDCOM__RISK_ATTACH_DATE.Text = RTrim(LTrim(oQuote.InceptionDate))
        		Else
        			BUILDCOM__RISK_ATTACH_DATE.Text = RTrim(LTrim(oQuote.CoverStartDate))
        		End If
        	ElseIf oQuote.Risks(Session(CNCurrentRiskKey)).RiskInceptionDate <> oQuote.InceptionDate Then
        		If transactionValue <> "NB" Then
        			If transactionValue <> "REN" Then
        				BUILDCOM__RISK_ATTACH_DATE.Text = RTrim(LTrim(oQuote.CoverStartDate))
        			End If
        		Else
        			BUILDCOM__RISK_ATTACH_DATE.Text = RTrim(LTrim(oQuote.InceptionDate))
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
        		BUILDCOM__EFFECTIVEDATE.Text = RTrim(LTrim(oQuote.InceptionDate))
        	End If
        	
        	If transactionValue = "MTA" Then
        		BUILDCOM__EFFECTIVEDATE.Text = RTrim(LTrim(oQuote.CoverStartDate))
        	End If
        	
        	If transactionValue = "REN" Then
        		BUILDCOM__EFFECTIVEDATE.Text = RTrim(LTrim(oQuote.InceptionTPI))
        	End If
        	
        End Sub
    
        Protected Shadows Sub FirePage_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	
        	If oQuote IsNot Nothing Then
        		Dim RiskPremium As Double = 0.0
        		Dim EndorsePremium As Double = 0.0
        		Dim LiabilityPremium As Double = 0.0
        		Dim ExtensionPremium As Double = 0.0
        		Dim TotalPremium As Double = 0.0
        		Dim EscalationPremium As Double = 0.0
        		Dim TotExtensionPremium As Double = 0.0
                		
        		If Not String.IsNullOrEmpty(BUILDCOM__TOTAL_ENDORSE_PREM.Text) Then
        		EndorsePremium = CDbl (BUILDCOM__TOTAL_ENDORSE_PREM.Text)
        		End If
        		
        		If Not String.IsNullOrEmpty(BUILDCOM__LIAB_PREMIUM.Text) Then
        			LiabilityPremium = CDbl (BUILDCOM__LIAB_PREMIUM.Text)
        		End If
        		
        		If Not String.IsNullOrEmpty(BCOM_EXTENSIONS__TOTAL_PREMIUM.Text) Then
        			ExtensionPremium = CDbl (BCOM_EXTENSIONS__TOTAL_PREMIUM.Text)
        		End If
        		
        		If Not String.IsNullOrEmpty(BUILDCOM__TOTAL_PREMIUM.Text) Then
        			TotalPremium = CDbl (BUILDCOM__TOTAL_PREMIUM.Text)
        		End If
        		
        		If Not String.IsNullOrEmpty(BUILDCOM__BC_ESC_TOTPREM.Text) Then
        			EscalationPremium = CDbl (BUILDCOM__BC_ESC_TOTPREM.Text)
        		End If
        		
        		
        		RiskPremium = CDbl (TotalPremium - (EndorsePremium + ExtensionPremium + EscalationPremium + LiabilityPremium))
        		TotExtensionPremium = ExtensionPremium + EscalationPremium
                'Section to update Premium on the Overview Page
        		UpdateXML("BC_RISK_PREMIUM", RiskPremium, "PREMIUM_SUMMARY")
        		UpdateXML("BC_EXT_PREM", TotExtensionPremium, "PREMIUM_SUMMARY")
                UpdateXML("BC_ENDORSE_PREMIUM", EndorsePremium, "PREMIUM_SUMMARY")
        		UpdateXML("BC_LIAB_PREMIUM", LiabilityPremium, "PREMIUM_SUMMARY")
                UpdateXML("BC_TOTAL_PREMIUM", TotalPremium, "PREMIUM_SUMMARY")
        
                'Section to update Sum Insured on the Overview Page
                UpdateXML("BC_TOTAL_SI", REINSEXP_BC__TOTAL_SI.Text, "EXPOSURE_SUMMARY")
                UpdateXML("BC_TARGET_SI", REINSEXP_BC__TOTAL_TARGET_SI.Text, "EXPOSURE_SUMMARY")
                UpdateXML("BC_RI_EXP", REINSEXP_BC__TOTAL_RI_EXP.Text, "EXPOSURE_SUMMARY")
        		
        		If Not String.IsNullOrEmpty(REINSEXP_BC__TOTAL_RI_EXP.Text) Then
        			Dim BC_RI As Double = CDbl(REINSEXP_BC__TOTAL_RI_EXP.Text)
        			Dim BC_RI_VAT As Double = CDbl(BC_RI / ((15 + 100) / 100))
        			UpdateXML("BC_RI_EXPVAT", BC_RI_VAT, "EXPOSURE_SUMMARY")
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
        

    End Class
End Namespace