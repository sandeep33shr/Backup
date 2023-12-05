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
    Partial Class PB2_CDOMCLM_Claim_Information : Inherits BaseClaim
        Protected iMode As Integer
        Private coverNoteBookKey As Integer = 0
        Dim oWebService As NexusProvider.ProviderBase = Nothing

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
            Me.Page.ClientScript.RegisterStartupScript(Me.GetType, "DoLogicStartup", "onload = function () {BuildComponents(); DoLogic(true);};", True)
			eLifecycleEvent = LifecycleEvent.Page_Load
			CallRuleScripts()
        End Sub
		
		Protected Shadows Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
            ' Output the XMLDataSet
            XMLDataSet.Text = Session(CNDataSet).Replace("'", "\'").Replace(vbCr, "").Replace(vbLf, "")

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

        Protected Sub btnNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
			eLifecycleEvent = LifecycleEvent.btnNext_Click
			CallRuleScripts()
        End Sub
		
        Protected Overrides Sub Render(ByVal writer As HtmlTextWriter)
            MyBase.Render(writer)
			eLifecycleEvent = LifecycleEvent.Render
			CallRuleScripts()
        End Sub

		Protected Sub onValidate_GENERAL__TRANSACTION_TYPE()
             
End Sub
Protected Sub onValidate_CMDOMCLM__CDOMTRAIL()
        
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_GENERAL__TRANSACTION_TYPE()
    onValidate_CMDOMCLM__CDOMTRAIL()
End Sub

		    
        Protected Shadows Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	Dim sTransactionType As String = ""
        	If CType(Session.Item(CNMode), Mode) = Mode.NewClaim Then
        		sTransactionType = "NEWCLAIM"
        	ElseIf CType(Session.Item(CNMode), Mode) = Mode.EditClaim Then
        		sTransactionType = "EDITCLAIM"
        	ElseIf CType(Session.Item(CNMode), Mode) = Mode.PayClaim Then
        		sTransactionType = "PAYCLAIM"
        	End If
        	
        	GENERAL__TRANSACTION_TYPE.Text = sTransactionType.ToString()
        End Sub
    
        
        Protected Shadows Sub btnNextTop_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNextTop.Click
        	UpdateAuditTrail()
        End Sub
        
        Protected Shadows Sub btnNext_Click2(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
        	UpdateAuditTrail()
        End Sub
        
        Protected Sub UpdateAuditTrail()
        	Dim captionSalvage As String = "Salvage Status"
        	Dim captionLegal As String = "Legal Status"
        	Dim captionDecision As String = "Claim Decision"
        
        	Dim salvage As String = CMDOMCLM__SALVAGESTAT.Text
        	Dim legal As String = CMDOMCLM__LEGALSTAT.Text
        	Dim decision As String = CMDOMCLM__CLMDECISION.Text
        
        	Dim prevSalvage As String = String.Empty
        	Dim prevLegal As String = String.Empty
        	Dim prevDecision As String = String.Empty
        
        	Dim salvage_updatereq As Boolean = AuditEntryRequired(captionSalvage, salvage, prevSalvage)
        	Dim legal_updatereq As Boolean = AuditEntryRequired(captionLegal, legal, prevLegal)
        	Dim decision_updatereq As Boolean = AuditEntryRequired(captionDecision, decision, prevDecision)
        
        	If (salvage_updatereq) Then
        		LogAuditEntry(captionSalvage, salvage, prevSalvage)
        	End If
        
        	If (legal_updatereq) Then
        		LogAuditEntry(captionLegal, legal, prevLegal)
        	End If
        
        	If (decision_updatereq) Then
        		LogAuditEntry(captionDecision, decision, prevDecision)
        	End If
        
        
        	If (salvage_updatereq Or legal_updatereq Or decision_updatereq) Then
        		Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        		Session(CNDataSet) = oWebService.RunDefaultRulesEdit(CMDOMCLM__CMDOMAUDIT.ScreenCode, Session(CNDataSet))
        	End If
        
        End Sub
        
        
        Protected Function AuditEntryRequired(ByVal propertyName As String, ByVal propertyValue As String, ByRef previousValue As String) As Boolean
        	Dim prevPropValue As String = String.Empty
        	Dim prevPropDate As Date = Date.Parse("1900/01/01")
        
        	Dim datamodelXML As Linq.XElement = Linq.XElement.Parse(XMLDataSet.Text)
        	For Each el As Linq.XElement In datamodelXML.DescendantNodes()
        		If (el.Name.ToString().ToUpper() = "CMDOMAUDIT") Then
        			If (el.Attribute("CHANGED_PROP").Value.ToUpper().Trim() = propertyName.ToUpper().Trim()) Then
        				Dim prevDate As Date
        				If (Date.TryParse(el.Attribute("CHANGED_DATE"), prevDate)) Then
        
        					If (prevDate > prevPropDate) Then
        						prevPropValue = el.Attribute("CHANGED_TO").Value
        					End If
        
        				End If
        			End If
        		End If
        	Next
        
        	If (propertyValue.ToUpper().Trim() <> prevPropValue.ToUpper().Trim()) Then
        		previousValue = prevPropValue
        		Return True
        	Else
        		Return False
        	End If
        
        End Function
        
        Protected Sub LogAuditEntry(ByVal propertyName As String, ByVal propertyValue As String, ByVal previousValue As String)
        	Dim sDataSetDefinition As String = ClaimGetDataSetDefinition()
        
        	Dim strDS As String = Session(CNDataSet)
        	Dim srDataset As New System.IO.StringReader(Session(CNDataSet))
        
        	Dim xmlTR As New XmlTextReader(srDataset)
        
        	Dim Doc As New XmlDocument
        
        	Doc.LoadXml(strDS)
        	Dim xmlParent As XmlNode = Doc.SelectSingleNode("//" & Session.Item(CNDataModelCode) & "_POLICY_BINDER/CMDOMCLM/CMDOMAUDIT")
        	Dim v_sOI As String = Nothing
        	If xmlParent IsNot Nothing Then
        		v_sOI = xmlParent.Attributes("OI").Value
        	End If
        	Dim v_sScreenCode As String = CMDOMCLM__CMDOMAUDIT.ScreenCode
        	Dim sParentElement, sChildElement As String
        	Dim sTmp() As String = Regex.Split(CMDOMCLM__CMDOMAUDIT.ID, "__")
        	If sTmp.Length > 1 Then
        		sParentElement = sTmp(0) 'Parent Element Name
        		sChildElement = sTmp(1) 'Child Element Name
        	End If
        	Dim oDoc As XmlDocument
        	oDoc = New XmlDocument
        	Dim oDataSet As New SiriusFS.SAM.Client.DataSetControl.Application
        
        	'create new element in XML
        	Dim newOI As String = DataSetFunctions.CreateElementFromXML(v_sScreenCode, v_sOI, sParentElement, sChildElement) 'This creates a blank child-screen entry in the database
        	'loading of the latest xmldataset in the session
        	strDS = Current.Session(CNDataSet)
        	xmlTR = New XmlTextReader(srDataset)
        
        	oDoc.LoadXml(strDS)
        	xmlTR.Close()
        
        	Dim oNode As XmlNode = oDoc.SelectSingleNode("//*[@OI='" & newOI.Trim & "']")
        
        	If oNode IsNot Nothing Then
        		'Update the xmldataset -Start
        		Dim swContent As New System.IO.StringWriter
        		Dim xmlwContent As New XmlTextWriter(swContent)
        
        		oDoc.WriteTo(xmlwContent)
        
        		xmlwContent.Close()
        		swContent.Close()
        
        		'loading of the latest xmldataset in the session
        		oDataSet.LoadFromXML(sDataSetDefinition, Session(CNDataSet))
        		'Update the values on Screen
        		UpdateXML(oNode, oDataSet, propertyName, propertyValue, previousValue)
        	End If
        
        	oDataSet.ReturnAsXML(Session(CNDataSet))
        	oDataSet.Terminate()
        	oDataSet = Nothing
        	'Update the xmldataset-End
        
        	Dim oXMLSource As New XmlDataSource
        	Dim sXPath As String = String.Empty
        
        	sXPath = ".//" & sParentElement & "[@OI='" & newOI & "']/" & sChildElement
        	oXMLSource.EnableCaching = False
        	oXMLSource.Data = Session(CNDataSet)
        	oXMLSource.XPath = sXPath
        
        	CMDOMCLM__CMDOMAUDIT.DataSource = oXMLSource
        	CMDOMCLM__CMDOMAUDIT.DataBind()
        
        End Sub
        
        Sub UpdateXML(ByRef oNode As XmlNode,
        						ByRef r_oDataset As SiriusFS.SAM.Client.DataSetControl.Application,
        						  ByVal propertyName As String, ByVal propertyValue As String, ByVal previousValue As String)
        	Dim sValue As String
        	If oNode IsNot Nothing Then
        
        		'US
        		sValue = "2" 'Setting to US:2 will instruct the Stored procs to update the already existing blank entry
        		r_oDataset.SetPropertyValue("DESCRIPTION", "US", oNode.Attributes("OI").Value, sValue, True)
        
        		'Property Name
        		sValue = propertyName
        		r_oDataset.SetPropertyValue("DESCRIPTION", "CHANGED_PROP", oNode.Attributes("OI").Value, sValue, True)
        
        		'Previous Value
        		sValue = previousValue
        		r_oDataset.SetPropertyValue("DESCRIPTION", "CHANGED_FROM", oNode.Attributes("OI").Value, sValue, True)
        
        		'Current Value
        		sValue = propertyValue
        		r_oDataset.SetPropertyValue("DESCRIPTION", "CHANGED_TO", oNode.Attributes("OI").Value, sValue, True)
        
        		'Changed Date
        		sValue = Date.Now().ToString("yyyy/MM/dd HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture)
        		r_oDataset.SetPropertyValue("DESCRIPTION", "CHANGED_DATE", oNode.Attributes("OI").Value, sValue, True)
        
        		'Changed By
        		Dim user As String = Session(CNLoginName)
        		sValue = user
        		r_oDataset.SetPropertyValue("DESCRIPTION", "CHANGED_BY", oNode.Attributes("OI").Value, sValue, True)
        
        
        	End If
        End Sub
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' CMDOMCLM = The parent object name of child screen
        ' CMDOMAUDIT = The child screen object name
        
        Protected Sub CMDOMCLM__CMDOMAUDIT_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles CMDOMCLM__CMDOMAUDIT.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        

    End Class
End Namespace