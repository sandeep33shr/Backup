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
    Partial Class PB2_MMFLEET_Fleet_Details : Inherits BaseRisk
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
		
		Protected Sub onValidate_FLEET__FLEET_OPTION()
        
End Sub
Protected Sub onValidate_Custom_btnImportItem()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_FLEET__FLEET_OPTION()
    onValidate_Custom_btnImportItem()
End Sub

		    
        Protected Shadows Sub Page_Load_RemoveFinish(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	btnFinish.Visible = False
        	btnFinishTop.Visible = False
        End Sub
    
        Private Sub btnUploadFile_click(sender As Object, e As EventArgs) Handles btnUploadFile.Click
        	Dim iTotalRecordsProcessed As Integer = 0
        	Dim iTotalRecordsImported As Integer = 0
        	Dim iTotalRecordsChanged As Integer = 0
        	Dim blnValidFormat As Boolean = False
        	Dim strInvalidItems As String = ""
        	If FileUploadExcel.HasFile Then
        		Try
        			'Make a unique temp copy of the uploaded file
        			Dim sExtension As String = System.IO.Path.GetExtension(FileUploadExcel.PostedFile.FileName)
        			Dim sFileName As String = Guid.NewGuid.ToString & sExtension
        			FileUploadExcel.SaveAs(Server.MapPath(sFileName))
        
        			'Create a new Adapter
        			Dim objDataAdapter As New System.Data.OleDb.OleDbDataAdapter()
        
        			'Retrieve the Select command for the Spreadsheet
        			'objDataAdapter.SelectCommand = ExcelConnection(sFileName, sExtension)
        			objDataAdapter.SelectCommand = ExcelConnection(sFileName)
        
        			'Create a DataSet
        			Dim objDataSet As New System.Data.DataSet()
        
        			'Populate the DataSet with the spreadsheet worksheet data
        			objDataAdapter.Fill(objDataSet)
        
        			If Not IsValidTemplateFormat(objDataSet) Then
        				LabelUpload.Text = "Error: Invalid file format. Please contact Application Support Team for valid Items Template."
        
        				Dim strScript1 As String = "<script type=text/javascript>window.onload = function(){PageReload()}</script>"
        				Page.ClientScript.RegisterStartupScript(Page.GetType(), "ScriptKey", strScript1)
        				Exit Sub
        			End If
        
        
        			Dim oQuote As NexusProvider.Quote = System.Web.HttpContext.Current.Session(CNQuote)
        			Dim srDataset As New System.IO.StringReader(oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset)
        			Dim xmlTR As New XmlTextReader(srDataset)
        			Dim Doc As New XmlDocument
        			Doc.Load(xmlTR)
        			xmlTR.Close()
        
        			'create a data table to hold the data that we'll import
        			Dim dtImportData As New System.Data.DataTable
        			dtImportData.Columns.Add(New System.Data.DataColumn("VehicleNumber", GetType(String))) '0
        			dtImportData.Columns.Add(New System.Data.DataColumn("MakeModel", GetType(String))) '1
        			dtImportData.Columns.Add(New System.Data.DataColumn("Year", GetType(String))) '2
        			dtImportData.Columns.Add(New System.Data.DataColumn("RegistrationNumber", GetType(String))) '4
        			dtImportData.Columns.Add(New System.Data.DataColumn("SumInsured", GetType(String))) '4
        			dtImportData.Columns.Add(New System.Data.DataColumn("IsValid", GetType(Boolean))) '5
        			dtImportData.Columns.Add(New System.Data.DataColumn("IsExist", GetType(Boolean))) '6
        
        			'create another datatable to hold validation messages
        			Dim dtValidationErrors As New System.Data.DataTable
        			dtValidationErrors.Columns.Add(New System.Data.DataColumn("VehicleNumber", GetType(String)))
        			dtValidationErrors.Columns.Add(New System.Data.DataColumn("ErrorMessage", GetType(String)))
        
        			'Loop through dataset 
        			'If a row passes validation then add this to the Import Data datatable
        			'If a row fails then add messages to the validation errors datatable for each failure
        			Dim rowNo As Integer = 0
        			For Each drSourceRow As System.Data.DataRow In objDataSet.Tables(0).Rows
        				'Maintain a flag to check if row is valid. If anything fails then we'll set this to false
        				Dim bRowValid As Boolean = True
        				rowNo = rowNo + 1
        				'Set up variables to hold our data and read data into them
        				'VehicleNumber
        				Dim sVehicleNumber As String = ""
        				If Not IsDBNull(drSourceRow.Item(0)) Then
        					sVehicleNumber = drSourceRow.Item(0)
        				Else
        					bRowValid = False
        
        					If Not IsDBNull(drSourceRow.Item(1)) Then
        						strInvalidItems = strInvalidItems & "," & rowNo
        					End If
        					Exit For
        				End If
        
        				'Make/Model
        				Dim sMakeModel As String = ""
        				If IsDBNull(drSourceRow.Item(1)) = False Then
        					sMakeModel = drSourceRow.Item(1)
        				Else
        					'Item Description is Mandatory
        					bRowValid = False
        				End If
        
        				'Year
        				Dim lYear As Integer = 2000
        				If IsDBNull(drSourceRow.Item(2)) = False Then
        					Integer.TryParse(drSourceRow.Item(2), lYear)
        				Else
        					'Year is Mandatory
        					bRowValid = False
        				End If
        				
        				'RegistrationNumber
        				Dim sRegistrationNumber As String = ""
        				If IsDBNull(drSourceRow.Item(3)) = False Then
        					sRegistrationNumber = drSourceRow.Item(3)
        				Else
        					'Registration Number is Mandatory
        					bRowValid = False
        				End If
        
        				'Sum Insured 
        				Dim dSumInsured As Decimal = 0
        				If IsDBNull(drSourceRow.Item(4)) = False Then
        					Decimal.TryParse(drSourceRow.Item(4), dSumInsured)
        				Else
        					'Sum Insured is Mandatory
        					bRowValid = False
        				End If
        
        				If bRowValid Then
        					'validation has passed, add a new row to the data to be imported
        					Dim drNewRow As System.Data.DataRow
        					drNewRow = dtImportData.NewRow()
        					drNewRow("VehicleNumber") = sVehicleNumber
        					drNewRow("MakeModel") = sMakeModel
        					drNewRow("Year") = lYear
        					drNewRow("RegistrationNumber") = sRegistrationNumber
        					drNewRow("SumInsured") = dSumInsured
        					drNewRow("IsValid") = True
        					drNewRow("IsExist") = False
        
        					' Add the row
        					dtImportData.Rows.Add(drNewRow)
        
        					' Count the total number of records processed for feedback
        					iTotalRecordsProcessed = iTotalRecordsProcessed + 1
        				Else
        					strInvalidItems = strInvalidItems & "," & sVehicleNumber
        				End If
        			Next
        
        			'We need a reference to SAMClient, holding the current dataset, in order to manipulate the valaues in the dataset
        			Dim oDataSet As New SiriusFS.SAM.Client.DataSetControl.Application
        
        			'Get the dataset definition
        			Dim sDataSetDefinition As String = Nexus.DataSetFunctions.GetDataSetDefinition(Current.Session(CNDataModelCode))
        
        			'load dataset into SAM client
        			oDataSet.LoadFromXML(sDataSetDefinition, oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset)
        
        
        			'Loop through xml, check if each location is in the ImportData datatable. 
        			Dim xmlLocations As XmlNodeList = Doc.SelectNodes("//" & Session.Item(CNDataModelCode) & "_POLICY_BINDER/FLEET/VEHICLE_DETAILS")
        			If xmlLocations IsNot Nothing Then
        				For Each xmlnThisNode As XmlNode In xmlLocations
        					'for each location currently in the xml check if the SITUATION_NUMBER is in the import datatable
        					'write the property value
        					Dim xAttr As XmlAttribute
        					xAttr = xmlnThisNode.Attributes("VEH_NO")
        					If xAttr IsNot Nothing Then
        						Dim sITEM_NUMBER As String = xmlnThisNode.Attributes("VEH_NO").Value
        						Dim bFound As Boolean = False
        						Dim sOI As String = xmlnThisNode.Attributes("OI").Value
        
        						If Not String.IsNullOrEmpty(sITEM_NUMBER) And sITEM_NUMBER.Trim <> "" Then
        							For iCount As Integer = 0 To dtImportData.Rows.Count - 1
        								If dtImportData.Rows(iCount).Item("VehicleNumber").ToString.Trim = sITEM_NUMBER.Trim Then
        
        									'True means this records exist in dtImportData
        									dtImportData.Rows(iCount).Item("IsExist") = True
        
        									'Update The Record if exists
        									UpdateImportXML(xmlnThisNode, oDataSet, dtImportData.Rows(iCount))
        
        									oDataSet.ReturnAsXML(oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset)
        									'oDataSet.Terminate()
        									'oDataSet = Nothing
        
        									'Update The Record if it exists
        									bFound = True
        									Exit For
        								End If
        							Next
        							If bFound = False Then
        
        								'Update The XML with changed values
        								Dim swContent As New System.IO.StringWriter
        								Dim xmlwContent As New XmlTextWriter(swContent)
        								iTotalRecordsImported = iTotalRecordsImported + 1
        
        								Doc.WriteTo(xmlwContent)
        								oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset = swContent.ToString()
        
        								xmlwContent.Close()
        								swContent.Close()
        
        							End If
        						End If
        					End If
        				Next
        				oDataSet.Terminate()
        				oDataSet = Nothing
        			End If
        
        			'Add/Update the record in XML -Start
        			Dim xmlParent As XmlNode = Doc.SelectSingleNode("//" & Session.Item(CNDataModelCode) & "_POLICY_BINDER/FLEET")
        			Dim v_sOI As String = Nothing
        			If xmlParent IsNot Nothing Then
        				v_sOI = xmlParent.Attributes("OI").Value
        			End If
        			AddRecord(dtImportData, v_sOI, dtValidationErrors)
        
        
        			'Bind The error into grid
        			If dtValidationErrors IsNot Nothing AndAlso dtValidationErrors.Rows.Count > 0 Then
        
        				'Make visible the error panel to show the error
        				PnlValidationError.Visible = True
        
        				' Give feedback
        				LabelUpload.Text = "Errors were encountered in the import file <b><i>" & FileUploadExcel.PostedFile.FileName & "</i></b>. Please review the errors listed below and try to re-import the file:"
        				'Store the error in Session
        				Session("ValidationFailures") = dtValidationErrors
        
        				grdValidationErrors.DataSource = dtValidationErrors
        				grdValidationErrors.DataBind()
        
        			Else
        				LabelUpload.Text = "Total number of records processed: " & iTotalRecordsProcessed
        				WriteRisk()
        			End If
        
        			'Delete the temp file
        			objDataAdapter.SelectCommand.Connection.Close()
        			System.IO.File.Delete(Server.MapPath(sFileName))
        
        			If strInvalidItems.StartsWith(",") Then strInvalidItems = strInvalidItems.Substring(1)
        			If strInvalidItems.Length > 0 Then
        				LabelUpload.Text = "Records not imported: Item " & strInvalidItems
        			End If
        
        		Catch ex As System.Exception
        			'output the error to the information label
        			If blnValidFormat Then
        				LabelUpload.Text = "Error: " & ex.Message.ToString
        			Else
        				LabelUpload.Text = "Error: Invalid File Format " & ex.Message.ToString
        			End If
        
        		End Try
        	Else
        		LabelUpload.Text = "Please select a file to upload."
        	End If
        
        
        	' Dim strScript As String = "<script type=text/javascript>window.onload = function(){PageReload()}</script>"
        	'Page.ClientScript.RegisterStartupScript(Page.GetType(), "ScriptKey", strScript)
        
        	Dim strScript As String = "<script type=text/javascript>(function refresh() {" +
        		"if (!window.location.hash) {window.location = window.location + '#loaded';" +
        		   " window.location.reload();	} })();</script>"
        	Page.ClientScript.RegisterStartupScript(Page.GetType(), "ScriptKey", strScript)
        
        End Sub
        
        Private Function IsValidTemplateFormat(ByVal objDataSet As System.Data.DataSet) As Boolean
        	With objDataSet.Tables(0)
        		If Not (.Columns(0).ColumnName.ToLower.Trim = "vehicle no" Or .Columns(0).ColumnName.ToLower.Trim = "vehicle no#") Then Return False
        		If .Columns(1).ColumnName.ToLower.Trim <> "make/model" Then Return False
        		If .Columns(2).ColumnName.ToLower.Trim <> "year" Then Return False
        		If .Columns(3).ColumnName.ToLower.Trim <> "registration number" Then Return False
        		If .Columns(4).ColumnName.ToLower.Trim <> "sum insured" Then Return False
        
        	End With
        	Return True
        End Function
        
        Protected Sub AddRecord(ByRef dtImportData As System.Data.DataTable, ByVal v_OI As String, ByRef dtValidationErrors As System.Data.DataTable)
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim sDataSetDefinition As String = GetDataSetDefinition(Current.Session(CNDataModelCode))
        	Dim v_sScreenCode As String = FLEET__VEHICLE_DETAILS.ScreenCode
        	Dim oDoc As XmlDocument
        	Dim srDataset As System.IO.StringReader
        	Dim xmlTR As XmlTextReader
        
        	Dim sParentElement, sChildElement As String
        	Dim sTmp() As String = Regex.Split(FLEET__VEHICLE_DETAILS.ID, "__")
        	If sTmp.Length > 1 Then
        		sParentElement = sTmp(0) 'Parent Element Name
        		sChildElement = sTmp(1) 'Child Element Name
        	End If
        
        	For Each drSourceRow As System.Data.DataRow In dtImportData.Rows
        		oDoc = New XmlDocument
        		Dim oDataSet As New SiriusFS.SAM.Client.DataSetControl.Application
        		'loop through import data. If a situation is already in the xml then update it, if not then add it
        		'use xpath query to find if it is in the existing xml by looking up the ITEM_NUMBER
        		'Check the Validation
        
        		If ValidateRecord(drSourceRow, dtValidationErrors) = False Then
        			drSourceRow("IsValid") = True
        			' drSourceRow("IsExist") = False
        			If drSourceRow("IsValid") = True AndAlso drSourceRow("IsExist") = False Then
        				'Delete the object of  US="3" 
        				Dim DelObj As XmlNodeList = oDoc.SelectNodes("//*[@US='3']")
        				If DelObj IsNot Nothing Then
        					For Each oDelNode As XmlNode In DelObj
        						Dim DelOI As String = oDelNode.Attributes("OI").Value
        						Dim oSAMClient As New SiriusFS.SAM.Client.DataSetControl.Application
        						oSAMClient.LoadFromXML(GetDataSetDefinition(Session(CNDataModelCode)), oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset)
        						oSAMClient.DelObjectInstance(oDelNode.Name, DelOI)
        						oSAMClient.ReturnAsXML(oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset)
        						oSAMClient.Terminate()
        						Session(CNQuote) = oQuote
        					Next
        				End If
        
        				'create new element in XML
        				Dim v_sOI As String = DataSetFunctions.CreateElementFromXML(v_sScreenCode, v_OI, sParentElement, sChildElement)
        
        				'loading of the latest xmldataset in the session
        				srDataset = New System.IO.StringReader(oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset)
        				xmlTR = New XmlTextReader(srDataset)
        
        				oDoc.Load(xmlTR)
        				xmlTR.Close()
        
        				Dim oNode As XmlNode = oDoc.SelectSingleNode("//*[@OI='" & v_sOI.Trim & "']")
        
        				If oNode IsNot Nothing Then
        					'Add the object of  US="1" 
        					oNode.Attributes("US").Value = "1"
        
        					'Update the xmldataset 
        					Dim swContent As New System.IO.StringWriter
        					Dim xmlwContent As New XmlTextWriter(swContent)
        
        					oDoc.WriteTo(xmlwContent)
        					oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset = swContent.ToString()
        
        					xmlwContent.Close()
        					swContent.Close()
        
        					'loading of the latest xmldataset in the session
        					oDataSet.LoadFromXML(sDataSetDefinition, oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset)
        					'Update the values on Screen
        					UpdateImportXML(oNode, oDataSet, drSourceRow)
        				End If
        
        				oDataSet.ReturnAsXML(oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset)
        				oDataSet.Terminate()
        				oDataSet = Nothing
        			End If
        		End If
        	Next
        
        	'Call the RunDefaultRuleEdit after adding/update of the record
        	If Current.Session(CNMTAType) IsNot Nothing And Current.Session(CNRenewal) Is Nothing Then
        		If Current.Session(CNMTAType) = MTAType.PERMANENT Or Current.Session(CNMTAType) = MTAType.TEMPORARY Then
        			oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset = oWebService.RunDefaultRulesEdit(v_sScreenCode, oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset, Nothing, Nothing, "MTA")
        		ElseIf Current.Session(CNMTAType) = MTAType.CANCELLATION Then
        			oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset = oWebService.RunDefaultRulesEdit(v_sScreenCode, oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset, Nothing, Nothing, "MTC")
        		ElseIf (Current.Session(CNMTAType) = MTAType.REINSTATEMENT) Then
        			oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset = oWebService.RunDefaultRulesEdit(v_sScreenCode, oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset, Nothing, Nothing, "MTR")
        		End If
        	ElseIf Current.Session(CNMTAType) Is Nothing And Current.Session(CNRenewal) IsNot Nothing Then
        		oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset = oWebService.RunDefaultRulesEdit(v_sScreenCode, oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset, Nothing, Nothing, "REN")
        	Else
        		oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset = oWebService.RunDefaultRulesEdit(v_sScreenCode, oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset)
        	End If
        
        	'Bind the Values in Grid 
        	Dim oXMLSource As New XmlDataSource
        	srDataset = New System.IO.StringReader(oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset)
        	xmlTR = New XmlTextReader(srDataset)
        	oDoc = New XmlDocument
        	Dim sXPath As String = String.Empty
        
        	oDoc.Load(xmlTR)
        	xmlTR.Close()
        
        
        	sXPath = ".//" & sParentElement & "[@OI='" & v_OI & "']/" & sChildElement
        	oXMLSource.EnableCaching = False
        	oXMLSource.Data = oQuote.Risks(Current.Session(CNCurrentRiskKey)).XMLDataset
        	oXMLSource.XPath = sXPath
        
        	FLEET__VEHICLE_DETAILS.DataSource = oXMLSource
        	FLEET__VEHICLE_DETAILS.DataBind()
        
        End Sub
        
        Sub UpdateImportXML(ByRef oNode As XmlNode,ByRef r_oDataset As SiriusFS.SAM.Client.DataSetControl.Application,ByRef drSourceRow As System.Data.DataRow)
        	Dim sValue As String
        
        	If oNode IsNot Nothing Then
        		'VEHICLE_DETAILS__VEH_NO
        		sValue = drSourceRow("VehicleNumber")
        		r_oDataset.SetPropertyValue("VEHICLE_DETAILS", "VEH_NO", oNode.Attributes("OI").Value, sValue, True)
        
        		'VEHICLE_DETAILS__MAKEMODEL
        		sValue = drSourceRow("MakeModel")
        		r_oDataset.SetPropertyValue("VEHICLE_DETAILS", "MAKEMODEL", oNode.Attributes("OI").Value, sValue, True)
        
        		'VEHICLE_DETAILS__CYEAR
        		sValue = drSourceRow("Year")
        		r_oDataset.SetPropertyValue("VEHICLE_DETAILS", "CYEAR", oNode.Attributes("OI").Value, sValue, True)
        		
        		'VEHICLE_DETAILS__REGNO
        		sValue = drSourceRow("RegistrationNumber")
        		r_oDataset.SetPropertyValue("VEHICLE_DETAILS", "REGNO", oNode.Attributes("OI").Value, sValue, True)
        
        		'VEHICLE_DETAILS__SUMINSURED
        		sValue = drSourceRow("SumInsured")
        		r_oDataset.SetPropertyValue("VEHICLE_DETAILS", "SUMINSURED", oNode.Attributes("OI").Value, sValue, True)
        	End If
        End Sub
        
        Protected Function ValidateRecord(ByRef dr As System.Data.DataRow, ByRef dtValidationErrors As System.Data.DataTable) As Boolean
        	'need to write the validation code
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim drValErr As System.Data.DataRow
        	Dim bFoundErr As Boolean = False
        
        	'Validation for Item Number
        	If IsDBNull(dr("VehicleNumber")) = True Or String.IsNullOrEmpty(dr("VehicleNumber")) = True Then
        		drValErr = dtValidationErrors.NewRow
        		drValErr(0) = dr("VehicleNumber")
        		drValErr(1) = "Vehicle number not available"
        		dtValidationErrors.Rows.Add(drValErr)
        		bFoundErr = True
        	End If
        
        	'Validation for Item Description
        	If IsDBNull(dr("MakeModel")) = True Or String.IsNullOrEmpty(dr("MakeModel")) = True Then
        		drValErr = dtValidationErrors.NewRow
        		drValErr(0) = dr("MakeModel")
        		drValErr(1) = "Make/Model not Present"
        		dtValidationErrors.Rows.Add(drValErr)
        		bFoundErr = True
        	End If
        	
        	'Validation for Machinery Code
        	If IsDBNull(dr("Year")) = True Or String.IsNullOrEmpty(dr("Year")) = True Then
        		drValErr = dtValidationErrors.NewRow
        		drValErr(0) = dr("Year")
        		drValErr(1) = "Year not Present"
        		dtValidationErrors.Rows.Add(drValErr)
        		bFoundErr = True
        	End If
        	
        	'Validation for Registration Number
        	If IsDBNull(dr("RegistrationNumber")) = True Or String.IsNullOrEmpty(dr("RegistrationNumber")) = True Then
        		drValErr = dtValidationErrors.NewRow
        		drValErr(0) = dr("RegistrationNumber")
        		drValErr(1) = "Registration Number not Present"
        		dtValidationErrors.Rows.Add(drValErr)
        		bFoundErr = True
        	End If
        
        	'Validation for Sum Insured
        	If IsDBNull(dr("SumInsured")) = True Or String.IsNullOrEmpty(dr("SumInsured")) = True Then
        		drValErr = dtValidationErrors.NewRow
        		drValErr(0) = dr("SumInsured")
        		drValErr(1) = "Sum Insured not Present"
        		dtValidationErrors.Rows.Add(drValErr)
        		bFoundErr = True
        	End If
        
        	If bFoundErr = False Then
        		dr("IsValid") = True
        	Else
        		dr("IsValid") = False
        	End If
        	Return bFoundErr
        End Function
        
        Protected Function ExcelConnection(ByVal sFileName As String) As System.Data.OleDb.OleDbCommand
        	Dim xConnStr As String = "Provider=Microsoft.ACE.OLEDB.12.0;" &
        							  "Data Source=" & Server.MapPath(sFileName) & ";" &
        							  "Extended Properties='Excel 8.0;IMEX=1;HDR=YES;MAXSCANROWS=0;'"
        
        	'Create the excel connection object using the connection string
        	Dim objXConn As New System.Data.OleDb.OleDbConnection(xConnStr)
        	objXConn.Open()
        	' use a SQL Select command to retrieve the data from the Excel Spreadsheet
        	' the "table name" is the name of the worksheet within the spreadsheet
        
        	Dim objCommand As New System.Data.OleDb.OleDbCommand("SELECT * FROM [Vehicles$A1:E200]", objXConn)
        	Return objCommand
        
        End Function
        
        Protected Function GetListIDFromCode(ByVal sListCode As String, ByVal slistType As String, ByVal sItemCode As String) As String
        	Dim sItemID As String = String.Empty
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        	Dim oList As New NexusProvider.LookupListCollection
        	If sItemCode <> "" Then
        		' Web service call to retreive the list of items from UDL
        		Try
        			If slistType = "PMLookup" Then
        				oList = oWebService.GetList(NexusProvider.ListType.PMLookup, sListCode, False, False)
        			Else
        				oList = oWebService.GetList(NexusProvider.ListType.UserDefined, sListCode, False, False)
        			End If
        		Catch ex As Exception
        
        		End Try
        
        		' Get code for ID
        		For iListCount As Integer = 0 To oList.Count - 1
        			If oList(iListCount).Description = sItemCode Then
        				sItemID = oList(iListCount).Key
        				Exit For
        			End If
        		Next
        	End If
        	Return sItemID
        End Function
        
        
        Protected Function GetListIDFromDescription(ByVal sListCode As String, ByVal slistType As String, ByVal sItemDescription As String) As String
        	Dim sItemID As String = String.Empty
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        	Dim oList As New NexusProvider.LookupListCollection
        	If sItemDescription <> "" Then
        		' Web service call to retreive the list of items from UDL
        		Try
        			If slistType = "PMLookup" Then
        				oList = oWebService.GetList(NexusProvider.ListType.PMLookup, sListCode, False, False)
        			Else
        				oList = oWebService.GetList(NexusProvider.ListType.UserDefined, sListCode, False, False)
        			End If
        		Catch ex As Exception
        
        		End Try
        
        		' Get code for ID
        		For iListCount As Integer = 0 To oList.Count - 1
        			If oList(iListCount).Description = sItemDescription Then
        				sItemID = oList(iListCount).Key
        				Exit For
        			End If
        		Next
        	End If
        	Return sItemID
        End Function
        
        Protected Function GetUDLItemDescription(ByVal sListCode As String, ByVal iItemCode As String) As String
        	Dim sItemDescription As String = ""
        
        	'Dim oNexusFrameWork As Config.NexusFrameWork = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork)
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        
        	Dim oList As New NexusProvider.LookupListCollection
        
        	' sam call to retreive the list of items from user defined list
        	oList = oWebService.GetList(NexusProvider.ListType.PMLookup, sListCode, False, False, "Description")
        
        	' Get description for code
        	For iListCount As Integer = 0 To oList.Count - 1
        		If oList(iListCount).Code = iItemCode Then
        			sItemDescription = oList(iListCount).Description
        			Exit For
        		End If
        	Next
        	Return sItemDescription
        	oList = Nothing
        End Function

    End Class
End Namespace