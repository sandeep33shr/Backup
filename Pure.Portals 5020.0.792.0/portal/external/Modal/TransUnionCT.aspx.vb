Imports System.Web.Script.Serialization
Imports System.Web.Configuration.WebConfigurationManager
Imports Nexus
Imports Nexus.Constants.Constant
Imports Nexus.Constants.Session
Imports Nexus.Library
Imports CMS.Library.Portal


Namespace Nexus

    Partial Class Modal_TransUnionCT
        Inherits System.Web.UI.Page

        Protected Sub Page_PreInit1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreInit
            CMS.Library.Frontend.Functions.SetTheme(Page, AppSettings("ModalPageTemplate"))
        End Sub

        Protected Shadows Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                Me.BindDetailsView()
            End If
        End Sub
		
		Private Sub BindDetailsView()
			Dim oVehicleList As System.Collections.Generic.List(Of TransUnionProject.TransUnionWCFService.CTVehicles) = Nothing
			oVehicleList = Session("WEBSERVICECTDATA")
			grdvTransUnion.DataSource = oVehicleList
			grdvTransUnion.DataBind()
		End Sub
		
		Protected sub grdvTransUnion_PageIndexChange(sender As Object, e As GridViewPageEventArgs)
			grdvTransUnion.PageIndex = e.NewPageIndex
			Me.BindDetailsView()
		End Sub

        Protected Sub grdvTransUnion_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles grdvTransUnion.RowCommand
            If e.CommandName = "SelectLink" Then
                Dim nRowindex As Integer = e.CommandArgument Mod grdvTransUnion.PageSize
                Dim sMMCode As String = grdvTransUnion.Rows.Item(nRowindex).Cells(0).Text
                Dim sMakeModel As String = grdvTransUnion.Rows.Item(nRowindex).Cells(1).Text

                Dim dataselected As String = sMMCode + ";" + sMakeModel
                Page.ClientScript.RegisterStartupScript(GetType(String), "closeThickBox", "self.parent.tb_remove();", True)
                Page.ClientScript.RegisterStartupScript(GetType(String), "ParentPostBack", "self.parent.SetCTDetails('" + dataselected + "');", True)
            End If
        End Sub
    End Class
End Namespace

