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
    Partial Class PB2_CMAMISCCLM_Electronic_Equipment : Inherits BaseClaim
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

		Protected Sub onValidate_ELECTEQUIP__EECCHILD()
        
End Sub
Protected Sub onValidate_ELECTEQUIP__EECMP()
        
End Sub
Protected Sub onValidate_ELECTEQUIP__EECNDPREM()
        
End Sub
Protected Sub onValidate_ELECTEQUIP__ECNOTES()
        
End Sub
Protected Sub onValidate_ELECTEQUIP__ECSNOTES()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_ELECTEQUIP__EECCHILD()
    onValidate_ELECTEQUIP__EECMP()
    onValidate_ELECTEQUIP__EECNDPREM()
    onValidate_ELECTEQUIP__ECNOTES()
    onValidate_ELECTEQUIP__ECSNOTES()
End Sub

		     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' ELECTEQUIP = The parent object name of child screen
        ' ELECTEQ = The child screen object name
        
        Protected Sub ELECTEQUIP__ELECTEQ_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles ELECTEQUIP__ELECTEQ.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' ELECTEQUIP = The parent object name of child screen
        ' EE_MULTIPLE_PREMISES = The child screen object name
        
        Protected Sub ELECTEQUIP__EE_MULTIPLE_PREMISES_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles ELECTEQUIP__EE_MULTIPLE_PREMISES.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' ELECTEQUIP = The parent object name of child screen
        ' EE_CLAUSE = The child screen object name
        
        Protected Sub ELECTEQUIP__EE_CLAUSE_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles ELECTEQUIP__EE_CLAUSE.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' ELECTEQUIP = The parent object name of child screen
        ' EENOTE_DETAILS = The child screen object name
        
        Protected Sub ELECTEQUIP__EENOTE_DETAILS_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles ELECTEQUIP__EENOTE_DETAILS.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' ELECTEQUIP = The parent object name of child screen
        ' EESNOTE_DETAILS = The child screen object name
        
        Protected Sub ELECTEQUIP__EESNOTE_DETAILS_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles ELECTEQUIP__EESNOTE_DETAILS.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        

    End Class
End Namespace