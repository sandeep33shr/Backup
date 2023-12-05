Imports System.Web.Script.Serialization
Imports System.Web.Configuration.WebConfigurationManager
Imports Nexus
Imports Nexus.Constants.Constant
Imports Nexus.Constants.Session
Imports Nexus.Library


Namespace Nexus

    Partial Class Modal_TransUnionGM
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
			Dim oVehicleList As System.Collections.Generic.List(Of TransUnionProject.TransUnionWCFService.GreyManVehicles) = Nothing
			oVehicleList = Session("WEBSERVICEGMDATA")
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
                Dim sMake As String = grdvTransUnion.Rows.Item(nRowindex).Cells(1).Text
                Dim sModel As String = grdvTransUnion.Rows.Item(nRowindex).Cells(2).Text
                Dim sMakeModel As String = sMake + " " + sModel
                Dim sYearMan As String = grdvTransUnion.Rows.Item(nRowindex).Cells(3).Text
                Dim sBodyType As String = grdvTransUnion.Rows.Item(nRowindex).Cells(4).Text
                Dim sCubicCap As String = grdvTransUnion.Rows.Item(nRowindex).Cells(5).Text
                Dim sFuelType As String = grdvTransUnion.Rows.Item(nRowindex).Cells(6).Text
                Dim sKiloWatts As String = grdvTransUnion.Rows.Item(nRowindex).Cells(7).Text
                Dim sMass As String = grdvTransUnion.Rows.Item(nRowindex).Cells(8).Text
                Dim sGVM As String = grdvTransUnion.Rows.Item(nRowindex).Cells(9).Text
                Dim sVehicleValue As String = grdvTransUnion.Rows.Item(nRowindex).Cells(10).Text
				
				If Session("GMType") = "G" Then
					sYearMan = "-1"
				End If

                Dim dataselected As String = sMMCode + ";" + sMake + ";" + sModel + ";" + sMakeModel + ";" + sYearMan + ";" + sBodyType + ";" + sCubicCap + ";" + sFuelType + ";" + sKiloWatts + ";" + sMass + ";" + sGVM + ";" + sVehicleValue
				dataselected = dataselected.Replace("&nbsp;", "-1")
                Page.ClientScript.RegisterStartupScript(GetType(String), "closeThickBox", "self.parent.tb_remove();", True)
                Page.ClientScript.RegisterStartupScript(GetType(String), "ParentGMPostBack", "self.parent.SetVehicleDetails('" + dataselected + "');", True)
            End If
        End Sub
    End Class
End Namespace

