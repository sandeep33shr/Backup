Imports Nexus.Constants
Imports Nexus.Constants.Session
Imports Nexus.Library
Imports CMS.Library
Imports System.Data
Imports System.Web.Configuration
Imports System.Web.Configuration.WebConfigurationManager
Imports System.Collections
Imports System.Xml
Imports System.Reflection
Imports Nexus.Utils
Imports Nexus

Namespace Nexus
    Partial Class Controls_EditTax
        Inherits System.Web.UI.UserControl
        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider


        Protected Sub bindRiskTaxGrid()

            Dim oQuote As NexusProvider.Quote
            Dim iInsuranceFilekey As Integer
            Dim oPolicyAllTaxes As NexusProvider.AllTaxes
            Dim oTempPolicyAllTaxesColl As NexusProvider.AllTaxesCollection
            Dim TaxBand As String = String.Empty
            Dim TaxAmount As Decimal = 0.00
            Dim oTempPolicyAllTaxes As New NexusProvider.AllTaxesCollection

            Try
                oQuote = Session(CNQuote)
                If oQuote IsNot Nothing Then
                    iInsuranceFilekey = oQuote.InsuranceFileKey
                End If

                If (Not IsPostBack Or Session(CNPolicyAllTaxesColl) Is Nothing) AndAlso iInsuranceFilekey <> 0 Then
                    oPolicyAllTaxes = oWebService.GetTaxes(iInsuranceFilekey)
                    Session(CNPolicyAllTaxesColl) = oPolicyAllTaxes.AllTaxes



                    If Session(CNPolicyAllTaxesColl) IsNot Nothing Then

                        oTempPolicyAllTaxesColl = CType(Session(CNPolicyAllTaxesColl), NexusProvider.AllTaxesCollection)

                        If (oTempPolicyAllTaxesColl.Count = 0) Then
                            btnUpdateRiskTax.Visible = False

                        Else
                            'This section is added to group all Tax Band together. -Badimu Kazadi
                            Dim isFound As Boolean = False

                            For itemTax As Integer = 0 To oTempPolicyAllTaxesColl.Count - 1
                                TaxBand = oTempPolicyAllTaxesColl(itemTax).TaxBandCode

                                'Checks if the Tax Band has been found in the collection or not
                                For index = 0 To oTempPolicyAllTaxes.Count - 1
                                    If oTempPolicyAllTaxes(index).TaxBandCode = TaxBand Then
                                        isFound = True
                                        Exit For
                                    End If
                                Next

                                'Adds all Tax Amount together based on the Tax Band
                                If isFound = False Then
                                    For Each item As NexusProvider.AllTaxes In oTempPolicyAllTaxesColl
                                        If item IsNot Nothing Then
                                            If item.TaxBandCode = TaxBand Then
                                                TaxAmount += item.TaxValue
                                            End If
                                        End If

                                    Next

                                    Dim oTemPolicyAllTax As New NexusProvider.AllTaxes
                                    oTemPolicyAllTax = oTempPolicyAllTaxesColl(itemTax)
                                    oTemPolicyAllTax.TaxValue = TaxAmount
                                    oTempPolicyAllTaxes.Add(oTemPolicyAllTax)
                                End If
                                TaxAmount = 0
                                isFound = False
                            Next

                        End If

                        grdvRiskTax.DataSource = oTempPolicyAllTaxes 'Session(CNPolicyAllTaxesColl)
                        grdvRiskTax.DataBind()

                    Else
                        grdvRiskTax.DataSource = Nothing
                        grdvRiskTax.DataBind()
                    End If
                End If

                For iCounter As Integer = 0 To grdvRiskTax.Rows.Count - 1
                    If Not CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text.Contains("%") Then
                        CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text = CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text + "%"
                    End If
                Next
                'Catch ex As Exception
            Finally
                oQuote = Nothing
                iInsuranceFilekey = Nothing
            End Try

        End Sub


        Protected Sub grdvRiskTax_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdvRiskTax.RowCommand

            Dim grvDataRow As GridViewRow = CType((CType(e.CommandSource, LinkButton).NamingContainer), GridViewRow)
            Dim grvRowIndex As Integer = grvDataRow.RowIndex

            Dim oTempPolicyAllTaxesColl As NexusProvider.AllTaxesCollection

            If (e.CommandName = "EDIT_TAX") Then
                Dim grdvItem_CheckBox As CheckBox = CType(grdvRiskTax.Rows(grvRowIndex).FindControl("IsValueType"), CheckBox)
                grdvItem_CheckBox.Enabled = True

                oTempPolicyAllTaxesColl = CType(Session(CNPolicyAllTaxesColl), NexusProvider.AllTaxesCollection)
                oTempPolicyAllTaxesColl.Item(grvRowIndex).IsEdit = True
                For iCounter As Integer = 0 To grdvRiskTax.Rows.Count - 1

                    If CType(CType(grdvRiskTax.Rows(iCounter).FindControl("IsValueType"), CheckBox).Checked, Boolean) Then
                        oTempPolicyAllTaxesColl.Item(iCounter).TaxValue = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempTaxAmount"), TextBox).Text, Decimal)
                        If CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text.Trim <> "" Then
                            oTempPolicyAllTaxesColl.Item(iCounter).TaxPercentage = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text.Trim("%"), Decimal)
                        Else
                            oTempPolicyAllTaxesColl.Item(iCounter).TaxPercentage = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempTaxAmount"), TextBox).Text, Decimal)
                        End If

                        oTempPolicyAllTaxesColl.Item(iCounter).IsValue = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("IsValueType"), CheckBox).Checked, Boolean)
                    Else
                        oTempPolicyAllTaxesColl.Item(iCounter).TaxPercentage = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text.Trim("%"), Decimal)
                        oTempPolicyAllTaxesColl.Item(iCounter).IsValue = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("IsValueType"), CheckBox).Checked, Boolean)
                    End If
                Next

                Session(CNPolicyAllTaxesColl) = oTempPolicyAllTaxesColl
            End If


        End Sub

        ''' <summary>
        ''' btnUpdateRiskTax_Click : Recalculates the Tax amount as per the rate/value entered.
        ''' </summary>
        ''' <param name="sender"></param>
        ''' <param name="e"></param>
        ''' <remarks></remarks>
        Protected Sub btnUpdateRiskTax_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdateRiskTax.Click


            Dim oTempPolicyAllTaxesColl As NexusProvider.AllTaxesCollection
            oTempPolicyAllTaxesColl = CType(Session(CNPolicyAllTaxesColl), NexusProvider.AllTaxesCollection)

            For iCounter As Integer = 0 To grdvRiskTax.Rows.Count - 1

                If Not CType(CType(grdvRiskTax.Rows(iCounter).FindControl("IsValueType"), CheckBox).Checked, Boolean) Then

                    oTempPolicyAllTaxesColl.Item(iCounter).TaxValue = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempTaxAmount"), TextBox).Text, Decimal)
                    If CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text = "" Then
                        oTempPolicyAllTaxesColl.Item(iCounter).TaxPercentage = 0.0
                    Else
                        oTempPolicyAllTaxesColl.Item(iCounter).TaxPercentage = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text.Trim("%"), Decimal)
                    End If

                Else
                    If (CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text.Trim <> "") Then
                        oTempPolicyAllTaxesColl.Item(iCounter).TaxValue = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text.Trim("%"), Decimal)
                    Else
                        If (CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempTaxAmount"), TextBox).Text) <> String.Empty Then
                            oTempPolicyAllTaxesColl.Item(iCounter).TaxValue = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempTaxAmount"), TextBox).Text, Decimal)
                        End If
                    End If
                    If CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text.Trim = "" Then
                        oTempPolicyAllTaxesColl.Item(iCounter).TaxPercentage = 0.0
                    Else
                        oTempPolicyAllTaxesColl.Item(iCounter).TaxPercentage = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("txtItemTempRate"), TextBox).Text.Trim("%"), Decimal)
                    End If

                End If

                oTempPolicyAllTaxesColl.Item(iCounter).IsValue = CType(CType(grdvRiskTax.Rows(iCounter).FindControl("IsValueType"), CheckBox).Checked, Boolean)

            Next

            oWebService.UpdateTaxes(oTempPolicyAllTaxesColl)
            Session(CNPolicyAllTaxesColl) = Nothing
            Response.Redirect(Request.RawUrl, False)

        End Sub

        Protected Sub grdvRiskTax_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdvRiskTax.RowDataBound
            If e.Row.RowType = DataControlRowType.DataRow Then
                If CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review Or UserCanDoTask("EditTax") <> True Then
                    CType(e.Row.FindControl("IsValueType"), CheckBox).Visible = False
                End If
                If CType(CType(e.Row.FindControl("IsValueType"), CheckBox).Checked, Boolean) Then
                    CType(e.Row.FindControl("txtItemTempRate"), TextBox).CssClass = "form-control e-num3"
                End If

            End If
        End Sub

        Protected Sub Page_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
            'Hide the tax recalculate button on View and Review
            If CType(Session.Item(CNMode), Mode) = Mode.View Or CType(Session.Item(CNMode), Mode) = Mode.Review Or UserCanDoTask("EditTax") <> True Then
                btnUpdateRiskTax.Visible = False
            End If

            bindRiskTaxGrid()
        End Sub
        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

            If Not IsPostBack Then

                If hdnIsSuppressDecimals.Value Is Nothing OrElse Trim(hdnIsSuppressDecimals.Value) = "" Then
                    Dim oWebService As NexusProvider.ProviderBase = Nothing
                    Dim oSuppressDecimalOptionType As New NexusProvider.OptionTypeSetting
                    oWebService = New NexusProvider.ProviderManager().Provider
                    oSuppressDecimalOptionType = oWebService.GetOptionSetting(NexusProvider.OptionType.ProductOption, NexusProvider.ProductOptions.SuppressDecimalValues)
                    If oSuppressDecimalOptionType IsNot Nothing Then
                        hdnIsSuppressDecimals.Value = oSuppressDecimalOptionType.OptionValue
                    End If
                End If

            End If

        End Sub
    End Class
End Namespace

