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
    Partial Class PB2_MEDRCVRSC_Recovery : Inherits BaseClaim
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

		Protected Sub onValidate_RECOVERIES__ITEM_NUMBER()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_RECOVERIES__ITEM_NUMBER()
End Sub

		             
        
          Protected Shadows Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
                               Dim oClaim As NexusProvider.Claim = CType(Session(CNClaim), NexusProvider.Claim)
        
                    Dim sXMLDataset As String = DirectCast(Session(CNDataSet), System.Object)
        
                    Dim sTransactionType As String = String.Empty
                    If CType(Session.Item(CNMode), Mode) = Mode.NewClaim Then
                        sTransactionType = "NEWCLAIM"
                    ElseIf CType(Session.Item(CNMode), Mode) = Mode.EditClaim Then
                        sTransactionType = "EDITCLAIM"
                    ElseIf CType(Session.Item(CNMode), Mode) = Mode.PayClaim Then
                        sTransactionType = "PAYCLAIM"
                    End If
        
                    RECOVERIES__TransactionType.Text = sTransactionType
        
                    If (sTransactionType <> "PAYCLAIM") Then
        
        
                        Dim sReserveId As String = GetAutoNumber("//MEDMALCLAIM/RECOVERIES", sXMLDataset)
                        If sReserveId <> "0" Then
                            RECOVERIES__ITEM_NUMBER.Text = "R" & sReserveId
                        End If
        				
        				
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
                                    If oLastNode.Attributes("ITEM_NUMBER") Is Nothing Then
                                        Dim oNode As XmlNode = oNodes(oNodes.Count - 2)
                                        If oNode IsNot Nothing Then
                                            If oNode.Attributes("ITEM_NUMBER") IsNot Nothing Then
                                                Dim nLossIdValue = CInt(oNode.Attributes("ITEM_NUMBER").Value.Replace("R", "")) + 1
                                                dStrValue = nLossIdValue
                                            End If
                                        End If
                                    End If
                                End If
                            End If
                        End If
                    End If
                    Return dStrValue
                End Function
        		
        		 ' Protected Sub LSRSV__Cover_SelectedIndexChange(sender As Object, e As EventArgs) Handles LSRSV__Cover.SelectedIndexChange
                    ' LSRSV__Sum_Insured.Text = "1000"
                ' End Sub

    End Class
End Namespace