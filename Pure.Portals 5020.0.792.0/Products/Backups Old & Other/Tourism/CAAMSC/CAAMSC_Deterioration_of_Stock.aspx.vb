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
    Partial Class PB2_CAAMSC_Deterioration_of_Stock : Inherits BaseRisk
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
		
		Protected Sub onValidate_DSTOCK__ATTACHMENTDATE()
        
        
End Sub
Protected Sub onValidate_DSTOCK__EFFECTIVEDATE()
        
End Sub
Protected Sub onValidate_SEQCNT_DS__COUNT()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_DSTOCK__ATTACHMENTDATE()
    onValidate_DSTOCK__EFFECTIVEDATE()
    onValidate_SEQCNT_DS__COUNT()
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
        	
        	If DSTOCK__ATTACHMENTDATE.Text = "" or DSTOCK__ATTACHMENTDATE.Text Is Nothing Then
        		If transactionValue = "NB" Then
        			DSTOCK__ATTACHMENTDATE.Text = RTrim(LTrim(oQuote.InceptionDate))
        		Else
        			DSTOCK__ATTACHMENTDATE.Text = RTrim(LTrim(oQuote.CoverStartDate))
        		End If
        	End If
        	
        	If oQuote.Risks(Session(CNCurrentRiskKey)).RiskInceptionDate <> oQuote.InceptionDate And (DSTOCK__ATTACHMENTDATE.Text <> "" Or DSTOCK__ATTACHMENTDATE.Text IsNot Nothing) Then
        		If transactionValue <> "NB" Then
        			If transactionValue <> "REN" Then
        				DSTOCK__ATTACHMENTDATE.Text = RTrim(LTrim(oQuote.CoverStartDate))
        			End If
        		Else
        			DSTOCK__ATTACHMENTDATE.Text = RTrim(LTrim(oQuote.InceptionDate))
        		End If
        	End If
        	
        End Sub
    
        Protected Shadows Sub Page_Load_RemoveFinish(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	btnFinish.Visible = False
        	btnFinishTop.Visible = False
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
        		DSTOCK__EFFECTIVEDATE.Text = RTrim(LTrim(oQuote.InceptionDate))
        	End If
        	
        	If transactionValue = "MTA" Then
        		DSTOCK__EFFECTIVEDATE.Text = RTrim(LTrim(oQuote.CoverStartDate))
        	End If
        	
        	If transactionValue = "REN" Then
        		DSTOCK__EFFECTIVEDATE.Text = RTrim(LTrim(oQuote.InceptionTPI))
        	End If
        	
        End Sub
    
        
        
        Protected Shadows Sub Page_Load3(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        			NumberLocacationItems()
        
        End Sub
        		'Item numbering
        		Private Sub NumberLocacationItems()
                    Dim oQuote As NexusProvider.Quote = CType(Session(CNQuote), NexusProvider.Quote)
                    Dim sDataSet As String = oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset
                    Dim objDataSet As New SiriusFS.SAM.Client.DataSetControl.Application
                    objDataSet.LoadFromXML(Nexus.DataSetFunctions.GetDataSetDefinition(Current.Session(CNDataModelCode)), sDataSet)
                    Dim sTransactionType As String = GetTransactionType()
                    Dim iNextItemNo As Integer = 0
                    Dim iCountAfterNB As Integer = 0
        
        
                    Try
                        'Number all DSTOCKs  sequentially for New Business transaction type 
                        If sTransactionType = "NB"  Then
                            If objDataSet.Risk.Item("DSTOCK").Count("DS_ITEM") > 0 Then
                                For icount As Integer = 1 To objDataSet.Risk.Item("DSTOCK").Count("DS_ITEM")
                                    objDataSet.Risk.Item("DSTOCK").Item("DS_ITEM", icount).Item("INCR").Value = icount
                                    objDataSet.Risk.Item("DSTOCK").Item("DS_ITEM", icount).Item("LASTITEMNUM").Value = objDataSet.Risk.Item("DSTOCK").Count("DS_ITEM")
        							objDataSet.Risk.Item("DSTOCK").Item("DS_ITEM", icount).Item("ISLASTLASTITEMSET").Value = 1
                                Next
                                objDataSet.ReturnAsXML(sDataSet)
                                oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset = sDataSet
                            End If
                        ElseIf sTransactionType = "MTA" Or sTransactionType = "REN" Or sTransactionType = "MTR" Then
        
                            'Set a session variable to keep the last DSTOCK number
                            If objDataSet.Risk.Item("DSTOCK").Count("DS_ITEM") = 0 Then
                                Session("LastItemNo") = 0
                            ElseIf objDataSet.Risk.Item("DSTOCK").Count("DS_ITEM") > 0 Then
                                Session("LastItemNo") = objDataSet.Risk.Item("DSTOCK").Item("DS_ITEM", 1).Item("LASTITEMNUM").Value
                            End If
        
                            Integer.TryParse(Session("LastItemNo"), iNextItemNo)
        
                            'Number only DSTOCKs being added in this session
                            If objDataSet.Risk.Item("DSTOCK").Count("DS_ITEM") > 0 Then
                                For icount As Integer = 1 To objDataSet.Risk.Item("DSTOCK").Count("DS_ITEM")
                                    If objDataSet.Risk.Item("DSTOCK").Item("DS_ITEM", icount).Item("ISLASTLASTITEMSET").Value <> 1 Then
                                        iCountAfterNB = iCountAfterNB + 1
                                        objDataSet.Risk.Item("DSTOCK").Item("DS_ITEM", icount).Item("INCR").Value = iNextItemNo + iCountAfterNB
                                    End If
                                Next
                                objDataSet.ReturnAsXML(sDataSet)
                                oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset = sDataSet
                            End If
        
                        End If
                    Catch
        
                    End Try
        			
        			If Session("Refresh") = "1" Then
        				Dim sUrl As String = "/Products/Tourism%20-%20Annual/CAAMSC/CAAMSC_Deterioration_of_Stock.aspx"
        				If HttpContext.Current.Session.IsCookieless Then
        					sUrl = Request.ApplicationPath + "/(S(" & Session.SessionID.ToString() + "))" + sUrl
        				Else
        					sUrl = Request.ApplicationPath + sUrl
        				End If
        
        				Response.Redirect(sUrl, False)
        				Context.ApplicationInstance.CompleteRequest()
        				Session("Refresh") = "0"
        			End if
                End Sub

    End Class
End Namespace