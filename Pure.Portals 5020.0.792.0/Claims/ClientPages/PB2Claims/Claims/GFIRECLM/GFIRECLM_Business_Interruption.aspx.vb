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
    Partial Class PB2_GFIRECLM_Business_Interruption : Inherits BaseClaim
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

		Protected Sub onValidate_BI__CSPECSUP()
        
End Sub
Protected Sub onValidate_BI__CSPECUS()
        
End Sub
Protected Sub onValidate_BI__CIENDPREM()
        
End Sub
Protected Sub onValidate_BI__CBINOTES()
        
End Sub
Protected Sub onValidate_BI__CBISNOTES()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_BI__CSPECSUP()
    onValidate_BI__CSPECUS()
    onValidate_BI__CIENDPREM()
    onValidate_BI__CBINOTES()
    onValidate_BI__CBISNOTES()
End Sub

		     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' BI = The parent object name of child screen
        ' SPECSU_CHILD = The child screen object name
        
        Protected Sub BI__SPECSU_CHILD_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles BI__SPECSU_CHILD.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' BI = The parent object name of child screen
        ' SPECU_CHILD = The child screen object name
        
        Protected Sub BI__SPECU_CHILD_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles BI__SPECU_CHILD.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' BI = The parent object name of child screen
        ' BI_CLAUSE = The child screen object name
        
        Protected Sub BI__BI_CLAUSE_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles BI__BI_CLAUSE.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' BI = The parent object name of child screen
        ' BI_CNOTE_DETAILS = The child screen object name
        
        Protected Sub BI__BI_CNOTE_DETAILS_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles BI__BI_CNOTE_DETAILS.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' BI = The parent object name of child screen
        ' BI_SCNOTE_DETAILS = The child screen object name
        
        Protected Sub BI__BI_SCNOTE_DETAILS_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles BI__BI_SCNOTE_DETAILS.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        

    End Class
End Namespace