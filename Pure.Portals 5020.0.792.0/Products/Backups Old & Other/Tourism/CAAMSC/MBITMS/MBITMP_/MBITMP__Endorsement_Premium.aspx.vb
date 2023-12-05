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
    Partial Class PB2_MBITMP__Endorsement_Premium : Inherits BaseRisk
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
		
		Protected Sub onValidate_MBITMS_CLAUSEPREM__COUNTER_ID()
        
End Sub
Protected Sub onValidate_MBITMS_CLAUSEPREM__ENDORSE_ID()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_MBITMS_CLAUSEPREM__COUNTER_ID()
    onValidate_MBITMS_CLAUSEPREM__ENDORSE_ID()
End Sub

		    
        'MB_ITEM - Parent object
        'MBITMS_CLAUSEPREM - Child object
        	Protected Shadows Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        		 Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        
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
        
                    If (transactionValue <> "VIEW") Then
                        Dim sXMLDataset As String = String.Empty
                        For index = 0 To oQuote.Risks.Count - 1
                            sXMLDataset = oQuote.Risks(index).XMLDataset
                            Dim sChildId As String = GetAutoNumber("//" & "MB_ITEM" & "/" & "MBITMS_CLAUSEPREM", sXMLDataset)
                            If sChildId <> "0" Then
                                MBITMS_CLAUSEPREM__COUNTER_ID.Text = "I" & sChildId
                            End If
                        Next
        
                    End If
                End Sub
        
        	Public Function GetDatafromXML(ByVal Xpath As String, ByVal field As String, ByVal strXMLDataSet As String) As String
                    Dim dStrValue As String = ""
                    If Not String.IsNullOrEmpty(strXMLDataSet) Then
                        Dim srDataset As New System.IO.StringReader(strXMLDataSet)
                        Dim xmlTR As New XmlTextReader(srDataset)
                        Dim Doc As New XmlDocument
                        Doc.Load(xmlTR)
                        xmlTR.Close()
        
                        Dim oNode As XmlNode = Doc.SelectSingleNode(Xpath)
                        If oNode IsNot Nothing Then
                            If oNode.Attributes(field) IsNot Nothing Then
                                dStrValue = oNode.Attributes(field).Value
                            End If
                        End If
                    End If
                    Return dStrValue
        	End Function
        	Public Function GetAutoNumber(ByVal Xpath As String, ByVal strXMLDataSet As String) As String
                    Dim dStrValue As String = "0"
                    If Not String.IsNullOrEmpty(strXMLDataSet) Then
                        Dim srDataset As New System.IO.StringReader(strXMLDataSet)
                        Dim xmlTR As New XmlTextReader(srDataset)
                        Dim Doc As New XmlDocument
                        Doc.Load(xmlTR)
                        xmlTR.Close()
        
                        Dim oNodes As XmlNodeList = Doc.SelectNodes(Xpath)
                        If oNodes IsNot Nothing Then
                            If oNodes.Count = 1 Then
                                dStrValue = oNodes.Count
                            Else
                                Dim oLastNode As XmlNode = oNodes(oNodes.Count - 1)
                                If oLastNode IsNot Nothing Then
                                    If oLastNode.Attributes("COUNTER_ID") Is Nothing Then
                                        Dim oNode As XmlNode = oNodes(oNodes.Count - 2)
                                        If oNode IsNot Nothing Then
                                            If oNode.Attributes("COUNTER_ID") IsNot Nothing Then
                                                Dim IdValue = CInt(oNode.Attributes("COUNTER_ID").Value.Replace("I", "")) + 1
                                                dStrValue = IdValue
                                            End If
                                        End If
                                    End If
                                End If
                            End If
                        End If
                    End If
                    Return dStrValue
                End Function
    
        'Script to add premium per selected Endorsement
        'Parameters:
        'MB_ITEM - Standard Wording Parent Object
        'MB_ITEM_CLAUSES - Standard Wording Parent Property
        'MBITMS_CLAUSEPREM - Child Screen Object
        'ENDORSE_DESC - Child Screen List Property
        'ENDORSE_CAP - Child Screen List Caption Property
        
        Protected Shadows Sub Page_Load_SelectedEndorsements(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim oNexusFrameWork As Config.NexusFrameWork = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
        	Dim oMaster As ContentPlaceHolder = GetMasterPlaceHolder(Page, oNexusFrameWork.MainContainerName)
        	Dim srDataset As New System.IO.StringReader(oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset)
        	Dim xmlTR As New XmlTextReader(srDataset)
        	Dim Doc As New XmlDocument
        	Doc.Load(xmlTR)
        	Dim xmlLocations As XmlNodeList = Doc.SelectNodes("//" & Session.Item(CNDataModelCode) & "_POLICY_BINDER/MBREAK/MB_ITEM/SW.MB_ITEM_CLAUSES")
        	Dim EndorsementScheme As Object = oMaster.FindControl("MBITMS_CLAUSEPREM__ENDORSE_DESC")
        	Dim EndorsementList As NexusProvider.LookupListV2 = CType(EndorsementScheme, NexusProvider.LookupListV2)
        	EndorsementList.Items.Clear()
        	Dim cnt As Integer = 0
        
        	For Each xmlnThisNode As XmlNode In xmlLocations
        		cnt += 1
        		Dim item As NexusProvider.LookupListItem = New NexusProvider.LookupListItem()
        		item.Key = cnt
        		item.Code = xmlnThisNode.Attributes("ID").Value
        		item.Description = xmlnThisNode.Attributes("DESCRIPTION").Value
        		EndorsementList.Items.Add(item)
        	Next
        End Sub
        
        Protected Shadows Sub btnNextFinish_SelectedEndorsements(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click, btnFinish.Click, btnNextTop.Click, btnFinishTop.Click
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim srDataset As New System.IO.StringReader(oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset)
        	Dim xmlTR As New XmlTextReader(srDataset)
        	Dim Doc As New XmlDocument
        	Doc.Load(xmlTR)
        	Dim xmlLocations As XmlNodeList = Doc.SelectNodes("//" & Session.Item(CNDataModelCode) & "_POLICY_BINDER/MBREAK/MB_ITEM/MBITMS_CLAUSEPREM")
        
        	'Dim CurrentSelected As String = CLAUSEPREM__ENDORSE_CAP.Text
        	
        	Dim CurrentSelected As String = MBITMS_CLAUSEPREM__ENDORSE_CAP.Text 'Changed so it can just use property passed as Parameters to make it more dynamic @Badimu
        	Dim Flag As Boolean = False
        	Dim Check = ThisOI
        
        	For index = 0 To xmlLocations.Count - 1
        		If xmlLocations.Item(index).Attributes.Count > 3 Then
        			If xmlLocations.Item(index).Attributes("ENDORSE_CAP").Value = CurrentSelected Then
        				If ThisOI.Text <> xmlLocations.Item(index).Attributes("OI").Value Then
        					Flag = True
        					Exit For
        				End If
        			End If
        		End If
        	Next
        
        	Dim oCustomValidator As New CustomValidator()
        	oCustomValidator.ID = "ValidateAddedEndorsementPremiums"
        	oCustomValidator.ErrorMessage = "A Premium has already been added for the selected Endorsement"
        	oCustomValidator.IsValid = True
        
        	If Flag Then
        		oCustomValidator.IsValid = False
        	End If
        
        	Page.Validators.Add(oCustomValidator)
        End Sub

    End Class
End Namespace