Imports CMS.Library.Frontend
Imports System.Web.Configuration.WebConfigurationManager
Imports CMS.Library
Imports System.Web.Configuration
Imports Nexus.Library
Imports Nexus.Utils
Imports Nexus.Constants
Imports Nexus.Constants.Session

Namespace Nexus
    Partial Class MasterPages_Internal_Modal : Inherits CMS.Library.Frontend.CMSMasterPage

        Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
            Response.Cache.SetCacheability(HttpCacheability.NoCache)
        End Sub

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            'To open a thickbox inside thickbox
            Page.Header.DataBind()

            If (Not Page.ClientScript.IsOnSubmitStatementRegistered(Me.GetType(), "OnSubmitScript")) Then
                Page.ClientScript.RegisterOnSubmitStatement(Me.GetType(), "OnSubmitScript", "beforeSubmit();")
            End If

            'This will register a function for showing updatepanel errors as alert
            If ScriptManager.GetCurrent(Me.Page) IsNot Nothing Then
                If Not (Page.ClientScript.IsStartupScriptRegistered("AddEndRequestHandler")) Then
                    Page.ClientScript.RegisterStartupScript(Me.GetType(), "AddEndRequestHandler", "Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandlerForUpdatePanel);", True)
                End If
            End If
        End Sub

        Protected Overrides Sub Render(ByVal writer As HtmlTextWriter)
            Dim validatorOverrideScripts As String = ("<script src='" & (ResolveClientUrl("~/App_Themes/Internal/js/validators.js") & "' type='text/javascript'></script>"))
            Me.Page.ClientScript.RegisterStartupScript(Me.GetType, "ValidatorOverrideScripts", validatorOverrideScripts, False)
            MyBase.Render(writer)
        End Sub
    End Class

End Namespace

