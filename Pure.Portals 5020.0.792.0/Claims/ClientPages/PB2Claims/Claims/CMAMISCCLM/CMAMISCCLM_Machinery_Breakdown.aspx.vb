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
    Partial Class PB2_CMAMISCCLM_Machinery_Breakdown : Inherits BaseClaim
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

		Protected Sub onValidate_MBREAK__MBITMCL()
        
End Sub
Protected Sub onValidate_MBREAK__MBOTXTCL()
        
End Sub
Protected Sub onValidate_MBREAK__MBFAPCL()
        
End Sub
Protected Sub onValidate_MBREAK__MBEPCLM()
        
End Sub
Protected Sub onValidate_MBREAK__MBNTSCL()
        
End Sub
Protected Sub onValidate_MBREAK__MBSNTSCL()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_MBREAK__MBITMCL()
    onValidate_MBREAK__MBOTXTCL()
    onValidate_MBREAK__MBFAPCL()
    onValidate_MBREAK__MBEPCLM()
    onValidate_MBREAK__MBNTSCL()
    onValidate_MBREAK__MBSNTSCL()
End Sub

		     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' MBREAK = The parent object name of child screen
        ' MB_ITEM = The child screen object name
        
        Protected Sub MBREAK__MB_ITEM_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles MBREAK__MB_ITEM.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' MBREAK = The parent object name of child screen
        ' MB_OEXTENSIONS = The child screen object name
        
        Protected Sub MBREAK__MB_OEXTENSIONS_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles MBREAK__MB_OEXTENSIONS.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' MBREAK = The parent object name of child screen
        ' MB_FAP = The child screen object name
        
        Protected Sub MBREAK__MB_FAP_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles MBREAK__MB_FAP.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' MBREAK = The parent object name of child screen
        ' MB_CLAUSEPREM = The child screen object name
        
        Protected Sub MBREAK__MB_CLAUSEPREM_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles MBREAK__MB_CLAUSEPREM.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' MBREAK = The parent object name of child screen
        ' MB_NOTES = The child screen object name
        
        Protected Sub MBREAK__MB_NOTES_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles MBREAK__MB_NOTES.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' MBREAK = The parent object name of child screen
        ' MB_SNOTES = The child screen object name
        
        Protected Sub MBREAK__MB_SNOTES_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles MBREAK__MB_SNOTES.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        

    End Class
End Namespace