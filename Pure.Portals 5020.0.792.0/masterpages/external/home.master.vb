Imports CMS.Library.Frontend
Imports System.IO
Imports NexusProvider
Imports System.Web.Configuration.WebConfigurationManager

Namespace Nexus
    Partial Class MasterPages_demo_home : Inherits CMSMasterPage

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            'If My.User.IsAuthenticated Then
            '    Response.Redirect("~/main.aspx")
            'End If
            Page.Header.DataBind()
        End Sub

        Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
            'DH - debug purposes only
            'Controls.Add(New LiteralControl(ErrorFormatter.GetSessionAsHtml()))
        End Sub
    End Class
End Namespace

