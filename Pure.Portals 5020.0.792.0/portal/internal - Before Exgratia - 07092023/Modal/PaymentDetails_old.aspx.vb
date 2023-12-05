Imports System.Web.Configuration.WebConfigurationManager
Imports Nexus
Imports Nexus.Constants
Imports Nexus.Constants.Session
Imports Nexus.Library
Imports CMS.Library.Portal

Namespace Nexus
    Partial Class Modal_PaymentDetails
        Inherits CMS.Library.Frontend.clsCMSPage

        Protected Sub btnOk_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOk.Click

            Dim oFormatString As String = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(GetPortalID()).FormatStrings.FormatString("Currency").DataFormatString
            'Before Submit ,Check BO ProductRiskMaintenance PaymentCannotExceedReserve & NegativeReserve option
            CheckIsTaxGroupMandatory()
            CheckProductRiskMaintenance()
            If Page.IsValid Then
                Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                Dim oOptionSettings As NexusProvider.OptionTypeSetting
                Dim bReceiptExcludeTax As Boolean = False
                oOptionSettings = oWebService.GetOptionSetting(NexusProvider.OptionType.SystemOption, 5067)

                If oOptionSettings.OptionValue = "1" Then
                    bReceiptExcludeTax = True
                End If

                Dim iPeril As Integer = CInt(Session(CNClaimPerilIndex))
                Dim iPaymentIndex As Integer = CInt(Request("PaymentIndex"))
                Dim oClaimOpen As NexusProvider.ClaimOpen = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen)

                Try
                    Decimal.Parse(txtPaymentAmount.Text)
                Catch ex As System.Exception
                    IsPaymentAmount.IsValid = False
                    IsPaymentAmount.ErrorMessage = GetLocalResourceObject("lbl_InvalidPayment")
                    Exit Sub
                End Try

                If Session(CNMode) = Mode.PayClaim Then
                    With oClaimOpen.ClaimPeril(iPeril)
                        If txtPaymentAmount.Text = "0.00" Or txtPaymentAmount.Text = "" Then
                            txtPaymentAmount_TextChanged(sender, e)
                        End If
                        .ClaimReserve(iPaymentIndex).TotalReserve = CDec(txtTotalReserve.Text)
                        .ClaimReserve(iPaymentIndex).ThisPaymentTax = CDec(HiddenLossTaxAmountDisabled.Value)
                        If hIsGrossClaimPaymentAmount.Value = "1" Then
                            .ClaimReserve(iPaymentIndex).CostToClaim = CDec(HiddenLossPaymentAmount.Value) - CDec(HiddenLossTaxAmountDisabled.Value)
                            .ClaimReserve(iPaymentIndex).ThisPaymentINCLTax = CDec(HiddenLossPaymentAmount.Value)
                        Else
                            .ClaimReserve(iPaymentIndex).ThisPaymentINCLTax = CDec(HiddenLossPaymentAmount.Value) + CDec(HiddenLossTaxAmountDisabled.Value)
                            .ClaimReserve(iPaymentIndex).CostToClaim = CDec(HiddenLossPaymentAmount.Value)
                        End If

                        .ClaimReserve(iPaymentIndex).CurrencyCode = ddlCurrency.SelectedValue
                        .ClaimReserve(iPaymentIndex).CurrencyRate = txtCurrencyRate.Text
                        'Store the LossPayment Amount to DIsplay  it again

                        If .ClaimReserve(iPaymentIndex).IsExcess Then
                            Dim dGrossAmount As Decimal
                            If String.IsNullOrEmpty(HiddenLossTaxAmountDisabled.Value) OrElse HiddenLossTaxAmountDisabled.Value = 0 Then
                                dGrossAmount = CDec(HiddenLossPaymentAmount.Value)
                            Else
                                dGrossAmount = CDec(HiddenLossTaxAmountDisabled.Value) - CDec(HiddenLossPaymentAmount.Value)
                            End If
                            Dim dCurrentReserve = .ClaimReserve(iPaymentIndex).OldReserve - dGrossAmount
                            .ClaimReserve(iPaymentIndex).CurrentReserve = dCurrentReserve
                            If chkReverseExcess.Checked = True Then
                                oClaimOpen.ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).ReverseExcess = True
                            Else
                                oClaimOpen.ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).ReverseExcess = False
                            End If
                        Else
                            oClaimOpen.ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).ReverseExcess = False
                            .ClaimReserve(iPaymentIndex).CurrentReserve = String.Format(oFormatString, .ClaimReserve(iPaymentIndex).OldReserve - CDec(txtNetPaymentDisabled.Text))
                        End If
                        oClaimOpen.ClaimPeril(iPeril).Payment.CurrencyCode = ddlCurrency.SelectedValue
                        oClaimOpen.ClaimPeril(iPeril).Payment.CurrencyRate = txtCurrencyRate.Text
                        oClaimOpen.ClaimPeril(iPeril).Payment.PaymentAmount = CDec(HiddenLossPaymentAmount.Value)
                        oClaimOpen.ClaimPeril(iPeril).Payment.RiskType = txtRiskType.Text
                        oClaimOpen.ClaimPeril(iPeril).Payment.ReserveType = txtReserveType.Text
                        oClaimOpen.ClaimPeril(iPeril).Payment.TaxAmount = HiddenLossTaxAmountDisabled.Value
                        oClaimOpen.ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).LossPaymentAmount = Math.Round(CDec(HiddenLossPaymentAmount.Value), 2)
                        oClaimOpen.ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).PaymentAmount = Math.Round(CDec(txtPaymentAmount.Text), 2)
                        oClaimOpen.ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).TaxGroupCode = ddlTaxGroup.SelectedValue
                        oClaimOpen.ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).TaxAmount = Math.Round(CDec(txtTaxAmount.Text), 2)
                        oClaimOpen.ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).CurrencyCode = ddlCurrency.SelectedValue
                        oClaimOpen.ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).CurrencyRate = txtCurrencyRate.Text
                        Dim oClaimPaymentTaxItems As New NexusProvider.ClaimPaymentTaxItem
                        'oClaimOpen.ClaimPeril(iPeril).Reserve(iPaymentIndex).RevisedReserve = 0
                        If .ClaimReserve(iPaymentIndex).CurrentReserve < 0 Then
                            oClaimOpen.ClaimPeril(iPeril).Reserve(iPaymentIndex).RevisedReserve = .ClaimReserve(iPaymentIndex).CurrentReserve * -1
                        End If

                        'Asigning of the PayQueue
                        Dim bFirstElement As Boolean = True
                        For iCount As Integer = 0 To .ClaimReserve.Count - 1
                            If .ClaimReserve(iCount).PayQueue > 0 Then
                                bFirstElement = False
                                Exit For
                            End If
                        Next
                        If bFirstElement Then
                            .ClaimReserve(iPaymentIndex).PayQueue = 1
                            oClaimOpen.ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).PayQueue = 1
                        End If
                        If String.IsNullOrEmpty(Trim(txtBalanceAmount.Text)) Then
                            txtBalanceAmount.Text = ("0.0")
                        End If
                        .ClaimReserve(iPaymentIndex).CurrentReserve = CDbl(txtBalanceAmount.Text)
                        If txtBalanceAmount.Enabled AndAlso (txtBalanceAmount.Text.Length > 0 AndAlso txtBalanceAmount.Text <> "") Then
                            If .ClaimReserve(iPaymentIndex).CurrentReserve <> String.Format(oFormatString, CDec(txtBalanceAmount.Text)) Then

                                UpdateReserve(oClaimOpen)
                            End If
                        End If
                    End With

                ElseIf Session(CNMode) = Mode.SalvageClaim Then
                    With oClaimOpen.ClaimPeril(iPeril)
                        .SalvageRecovery(iPaymentIndex).TotalRecovery = Math.Round(CDec(txtTotalReserve.Text), 2)
                        .SalvageRecovery(iPaymentIndex).CurrencyCode = ddlCurrency.SelectedValue
                        .SalvageRecovery(iPaymentIndex).ThisReceiptINCLTax = Math.Round(CDec(txtPaymentAmount.Text.Trim), 2)
                        .SalvageRecovery(iPaymentIndex).ThisReceiptTax = Math.Round(CDec(txtTaxAmount.Text.Trim), 2)
                        .SalvageRecovery(iPaymentIndex).LossThisReceiptINCLTax =Format (Math.Round(CDec(HiddenLossPaymentAmount.Value), 2),"#.00")
                        .SalvageRecovery(iPaymentIndex).LossThisReceiptTax = Math.Round(CDec(HiddenLossTaxAmountDisabled.Value), 2)
                        If  bReceiptExcludeTax Then
                            .SalvageRecovery(iPaymentIndex).LossThisNet = CDec(HiddenLossPaymentAmount.Value) + CDec(HiddenLossTaxAmountDisabled.Value)
                            .SalvageRecovery(iPaymentIndex).ThisNet = CDec(txtPaymentAmount.Text.Trim)
                        Else
                            .SalvageRecovery(iPaymentIndex).LossThisNet = CDec(HiddenLossPaymentAmount.Value) - CDec(HiddenLossTaxAmountDisabled.Value)
                            .SalvageRecovery(iPaymentIndex).ThisNet = CDec(txtPaymentAmount.Text.Trim)
                        End If
                        'Update The Receipt Object
                        'Asigning of the ReceiptQueue
                        Dim bFirstElement As Boolean = True
                        For iCount As Integer = 0 To .SalvageRecovery.Count - 1
                            If .SalvageRecovery(iCount).ReceiptQueue > 0 Then
                                bFirstElement = False
                                Exit For
                            End If
                        Next
                        If bFirstElement Then
                            .SalvageRecovery(iPaymentIndex).ReceiptQueue = 1
                        End If

                        With oClaimOpen.ClaimPeril(iPeril).Receipt
                            .BaseClaimKey = oClaimOpen.BaseClaimKey
                            .ClaimKey = oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).ClaimKey
                            .ClaimNumber = oClaimOpen.ClaimNumber
                            .BaseClaimKey = CLng(oClaimOpen.BaseClaimKey)
                            .BaseClaimPerilKey = oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).BaseClaimPerilKey
                            .ClaimVersionDescription = oClaimOpen.ClaimVersionDescription
                            .CurrencyCode = ddlCurrency.SelectedValue

                            .ReceiptItem(iPaymentIndex).BalanceAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).SalvageRecovery(iPaymentIndex).TotalRecovery - oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).SalvageRecovery(iPaymentIndex).LossThisReceiptINCLTax, 2)
                            .ReceiptItem(iPaymentIndex).RecoveryKey = oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).SalvageRecovery(iPaymentIndex).BaseRecoveryKey
                            .ReceiptItem(iPaymentIndex).TaxCode = ddlTaxGroup.SelectedValue
                            If bReceiptExcludeTax Then
                                .ReceiptItem(iPaymentIndex).ThisReceiptAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).SalvageRecovery(iPaymentIndex).ThisNet, 2)
                            Else
                                .ReceiptItem(iPaymentIndex).ThisReceiptAmount = Math.Round(CDec(txtPaymentAmount.Text.Trim),2) 
                            End If
                            .ReceiptItem(iPaymentIndex).ThisReceiptINCLTaxAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).SalvageRecovery(iPaymentIndex).LossThisReceiptINCLTax, 2)
                            .ReceiptItem(iPaymentIndex).ThisReceiptNetAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).SalvageRecovery(iPaymentIndex).LossThisNet, 2)
                            .ReceiptItem(iPaymentIndex).ThisReceiptTaxAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).SalvageRecovery(iPaymentIndex).LossThisReceiptTax, 2)
                            .ReceiptItem(iPaymentIndex).TotalReceiptAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).SalvageRecovery(iPaymentIndex).ReceiptedAmount + oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).SalvageRecovery(iPaymentIndex).LossThisReceiptINCLTax, 2)
                            .ReceiptItem(iPaymentIndex).TotalRecoveryAmount = Math.Round(.ReceiptItem(iPaymentIndex).TotalReceiptAmount, 2)
                            .ReceiptItem(iPaymentIndex).TypeCode = oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).SalvageRecovery(iPaymentIndex).TypeCode
                            If oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).SalvageRecovery(iPaymentIndex).IsSalvage = 1 Then
                                .IsSalvageRecovery = True
                            Else
                                .IsSalvageRecovery = False
                            End If

                            If bFirstElement Then
                                .ReceiptItem(iPaymentIndex).ReceiptQueue = 1
                            End If
                        End With
                    End With
                ElseIf Session(CNMode) = Mode.TPRecovery Then
                    With oClaimOpen.ClaimPeril(iPeril)
                        .TPRecovery(iPaymentIndex).TotalRecovery = CDec(txtTotalReserve.Text)
                        .TPRecovery(iPaymentIndex).CurrencyCode = ddlCurrency.SelectedValue
                        .TPRecovery(iPaymentIndex).ThisReceiptINCLTax = Math.Round(CDec(txtPaymentAmount.Text.Trim), 2)
                        .TPRecovery(iPaymentIndex).ThisReceiptTax = Math.Round(CDec(txtTaxAmount.Text.Trim), 2)

                        .TPRecovery(iPaymentIndex).LossThisReceiptINCLTax = Format(Math.Round(CDec(HiddenLossPaymentAmount.Value), 2),"#.00")
                        .TPRecovery(iPaymentIndex).LossThisReceiptTax = Math.Round(CDec(HiddenLossTaxAmountDisabled.Value), 2)
                        If bReceiptExcludeTax Then
                            .TPRecovery(iPaymentIndex).LossThisNet = CDec(HiddenLossPaymentAmount.Value) + CDec(HiddenLossTaxAmountDisabled.Value)
                            .TPRecovery(iPaymentIndex).ThisNet = CDec(txtPaymentAmount.Text.Trim)
                        Else
                            .TPRecovery(iPaymentIndex).LossThisNet = CDec(HiddenLossPaymentAmount.Value) - CDec(HiddenLossTaxAmountDisabled.Value)
                            .TPRecovery(iPaymentIndex).ThisNet = CDec(txtPaymentAmount.Text.Trim) - CDec(txtTaxAmount.Text.Trim)
                        End If
                        'Update The Receipt Object
                        'Asigning of the ReceiptQueue
                        Dim bFirstElement As Boolean = True
                        For iCount As Integer = 0 To .TPRecovery.Count - 1
                            If .TPRecovery(iCount).ReceiptQueue > 0 Then
                                bFirstElement = False
                                Exit For
                            End If
                        Next
                        If bFirstElement Then
                            .TPRecovery(iPaymentIndex).ReceiptQueue = 1
                        End If

                        With oClaimOpen.ClaimPeril(iPeril).Receipt
                            .BaseClaimKey = oClaimOpen.BaseClaimKey
                            .ClaimKey = oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).ClaimKey
                            .ClaimNumber = oClaimOpen.ClaimNumber
                            .BaseClaimKey = CLng(oClaimOpen.BaseClaimKey)
                            .BaseClaimPerilKey = oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).BaseClaimPerilKey
                            .ClaimVersionDescription = oClaimOpen.ClaimVersionDescription
                            .CurrencyCode = ddlCurrency.SelectedValue

                            .ReceiptItem(iPaymentIndex).BalanceAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).TotalRecovery - oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).LossThisReceiptINCLTax, 2)
                            .ReceiptItem(iPaymentIndex).RecoveryKey = oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).BaseRecoveryKey
                            .ReceiptItem(iPaymentIndex).TaxCode = ddlTaxGroup.SelectedValue
                            If bReceiptExcludeTax Then
                                .ReceiptItem(iPaymentIndex).ThisReceiptAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).ThisNet, 2)
                            Else
                                .ReceiptItem(iPaymentIndex).ThisReceiptAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).ThisReceiptINCLTax, 2)
                            End If
                            .ReceiptItem(iPaymentIndex).ThisReceiptINCLTaxAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).LossThisReceiptINCLTax, 2)
                            .ReceiptItem(iPaymentIndex).ThisReceiptNetAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).LossThisNet, 2)
                            .ReceiptItem(iPaymentIndex).ThisReceiptTaxAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).LossThisReceiptTax, 2)
                            .ReceiptItem(iPaymentIndex).TotalReceiptAmount = Math.Round(oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).ReceiptedAmount + oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).LossThisReceiptINCLTax, 2)
                            .ReceiptItem(iPaymentIndex).TotalRecoveryAmount = Math.Round(.ReceiptItem(iPaymentIndex).TotalReceiptAmount, 2)
                            .ReceiptItem(iPaymentIndex).TypeCode = oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).TypeCode
                            If oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).TPRecovery(iPaymentIndex).IsSalvage = 1 Then
                                .IsSalvageRecovery = True
                            Else
                                .IsSalvageRecovery = False
                            End If

                            If bFirstElement Then
                                .ReceiptItem(iPaymentIndex).ReceiptQueue = 1
                            End If

                        End With
                    End With
                End If
                Session(CNClaim) = oClaimOpen
                'set up javascript to postback the parent page
                'this will render as self.parent.__doPostBack('__Page', 'RiskTypeSelected');
                Page.ClientScript.RegisterStartupScript(GetType(String), "closeThickBox", "self.parent.tb_updated('" & Request.QueryString("PostbackTo") & "','PaymentUpdation');", True)
            End If
        End Sub
        Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
            'set up javascript to postback the parent page
            'this will render as self.parent.__doPostBack('__Page', 'RiskTypeSelected');
            Page.ClientScript.RegisterStartupScript(GetType(String), "closeThickBox", "self.parent.tb_updated('" & Request.QueryString("PostbackTo") & "','PaymentUpdation');", True)
        End Sub

        Protected Shadows Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

            Dim oClaimPayment As NexusProvider.PerilSummary = Nothing
            Dim oClaimOpen As NexusProvider.ClaimOpen = CType(Session(CNClaim), NexusProvider.ClaimOpen)
            Dim oWebservice As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            Dim oTaxGroupCollection As NexusProvider.TaxGroupCollection = Nothing
            Dim iPeril As Integer = CInt(Session(CNClaimPerilIndex))
            Dim iPaymentIndex As Integer = CInt(Request("PaymentIndex"))
            Dim oFormatString As String = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(GetPortalID()).FormatStrings.FormatString("Currency").DataFormatString

            If Not IsPostBack Then

                'Fill Currency By Branch
                PopulateCurrencyByBranch()

                'Set the Currency By Default First Time
                If (Session(CNMode) = Mode.PayClaim AndAlso oClaimOpen.ClaimPeril(iPeril).ClaimReserve(iPaymentIndex).ThisPaymentINCLTax = 0) _
                Or (Session(CNMode) = Mode.SalvageClaim AndAlso oClaimOpen.ClaimPeril(iPeril).SalvageRecovery(iPaymentIndex).ThisReceiptINCLTax = 0) _
                Or (Session(CNMode) = Mode.TPRecovery AndAlso oClaimOpen.ClaimPeril(iPeril).TPRecovery(iPaymentIndex).ThisReceiptINCLTax = 0) Then
                    If ddlCurrency.Items.Count > 0 Then
                        ddlCurrency.SelectedValue = Session(CNCurrenyCode)
                        UpdateDataOnCurrencyChange()
                    End If
                    If Session(CNMode) = Mode.PayClaim Then
                        lblPaymentDetails.Text = GetLocalResourceObject("lblPaymentDetails")
                    ElseIf Session(CNMode) = Mode.SalvageClaim OrElse Session(CNMode) = Mode.TPRecovery Then
                        lblPaymentDetails.Text = GetLocalResourceObject("lblReceiptDetails")
                    End If
                End If

                'To set the Focus
                Page.SetFocus(ddlCurrency)

                Try

                    Dim IswithholdingTax As Boolean = False
                    If String.IsNullOrEmpty(Request("DomiciledTax")) Then
                        IswithholdingTax = False
                    Else
                        IswithholdingTax = Request("DomiciledTax")
                    End If
                    Dim sOption As String
                    sOption = oWebservice.GetProductRiskOptionValue(NexusProvider.ProductConfigActionType.ProductRiskMaintenance, NexusProvider.ProductRiskOptions.IsGrossClaimPaymentAmount, NexusProvider.RiskTypeOptions.None, Session(CNProductCode), Nothing)
                    If String.IsNullOrEmpty(sOption) Then
                        hIsGrossClaimPaymentAmount.Value = "0"
                    Else
                        hIsGrossClaimPaymentAmount.Value = sOption
                    End If
                    Dim oSalvageAndTPRecoveryReservesExcludeTax As NexusProvider.OptionTypeSetting
                    oSalvageAndTPRecoveryReservesExcludeTax = oWebservice.GetOptionSetting(NexusProvider.OptionType.SystemOption, 5067)
                    hSalvageAndTPRecoveryReservesExcludeTax.Value = oSalvageAndTPRecoveryReservesExcludeTax.OptionValue

                    sOption = String.Empty
                    sOption = oWebservice.GetProductRiskOptionValue(NexusProvider.ProductConfigActionType.RiskTypeMaintenance, Nothing, NexusProvider.RiskTypeOptions.ClaimsIsPostTaxes, Nothing, oClaimOpen.RiskType)
                    If String.IsNullOrEmpty(sOption) Then
                        hClaimsIsPostTaxes.Value = "0"
                    Else
                        hClaimsIsPostTaxes.Value = sOption
                    End If

                    Dim sATSOption As String = String.Empty
                    sATSOption = oWebservice.GetProductRiskOptionValue(NexusProvider.ProductConfigActionType.ProductRiskMaintenance, NexusProvider.ProductRiskOptions.IsAdvancedTaxScriptEnabled, NexusProvider.RiskTypeOptions.None, Session(CNProductCode), Nothing)

                    If sATSOption = "1" AndAlso Session(CNMode) = Mode.SalvageClaim _
                    OrElse Session(CNMode) = Mode.TPRecovery _
                    OrElse Session(CNMode) = Mode.ViewClaim Then
                        lblScriptedTaxamount.Visible = True
                        txtScriptedTaxAmount.Visible = True
                    Else
                        lblScriptedTaxamount.Visible = False
                        txtScriptedTaxAmount.Visible = False
                    End If

                    Dim sTransType As String = String.Empty

                    If Session(CNMode) = Mode.SalvageClaim Then
                        sTransType = "C_SA"
                    ElseIf Session(CNMode) = Mode.TPRecovery Then
                        sTransType = "C_RV"
                    ElseIf Session(CNMode) = Mode.PayClaim Then
                        sTransType = "C_CP"
                    End If


                    oTaxGroupCollection = oWebservice.GetTaxGroupsForClaims(v_bIs_withholding_tax:=
                                                                            IswithholdingTax, v_sBranchCode:=
                                                                            String.Empty, v_sTransactionTypeCode:=
                                                                            sTransType)
                    ddlTaxGroup.DataSource = oTaxGroupCollection
                    ddlTaxGroup.DataTextField = "Description"
                    ddlTaxGroup.DataValueField = "Code"
                    ddlTaxGroup.DataBind()
                    ddlTaxGroup.Items.Insert(0, New ListItem("(Please Select)", ""))
                Finally

                    oTaxGroupCollection = Nothing
                    oWebservice = Nothing
                End Try

                If Session.Item(CNClaim) IsNot Nothing Then
                    Dim iCount As Integer = 0
                    Dim oQuote As NexusProvider.Quote = CType(Session(CNClaimQuote), NexusProvider.Quote)
                    For iCnt As Integer = 0 To oQuote.Risks.Count - 1
                        If oQuote.Risks(iCnt).Key = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).RiskKey Then
                            txtRiskType.Text = Convert.ToString(oQuote.Risks(iCnt).Description)
                            Exit For
                        End If
                    Next
                    If Session(CNMode) = Mode.PayClaim Then
                        'if it is not accepted first then it has to Reset all payment information
                        Dim bResetValues, bFirstElement As Boolean
                        If oClaimOpen.ClaimPeril(iPeril).ClaimReserve(iPaymentIndex).IsExcess = True AndAlso _
                        oClaimOpen.ClaimPeril(iPeril).ClaimReserve(iPaymentIndex).ThisPaymentINCLTax = 0 Then
                            For iCount = 0 To oClaimOpen.ClaimPeril(iPeril).ClaimReserve.Count - 1
                                If oClaimOpen.ClaimPeril(iPeril).ClaimReserve(iCount).IsExcess = False _
                                AndAlso oClaimOpen.ClaimPeril(iPeril).ClaimReserve(iCount).PayQueue > 0 Then
                                    bResetValues = True
                                    Exit For
                                End If
                            Next
                        Else
                            For iCount = 0 To oClaimOpen.ClaimPeril(iPeril).ClaimReserve.Count - 1
                                If oClaimOpen.ClaimPeril(iPeril).ClaimReserve(iCount).PayQueue > 0 Then
                                    bFirstElement = True
                                    Exit For
                                End If
                            Next
                        End If
                        If bResetValues = True Then
                            'Reset confirmation
                            oClaimOpen.ClaimPeril(iPeril).Payment.ClaimPaymentItem.Clear()
                            oClaimOpen.ClaimPeril(iPeril).ClaimReserve.Clear()
                            PopulateReserveItem()
                        End If

                        oClaimPayment = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril)

                        With oClaimPayment
                            txtTotalReserve.Text = String.Format(oFormatString, .ClaimReserve(iPaymentIndex).TotalReserve)
                            txtReserveType.Text = .ClaimReserve(iPaymentIndex).TypeCode
                            txtPaidToDate.Text = String.Format(oFormatString, .ClaimReserve(iPaymentIndex).PaidToDate)
                            If hClaimsIsPostTaxes.Value = "1" Then
                                txtBalance.Text = String.Format(oFormatString, .ClaimReserve(iPaymentIndex).TotalReserve - .ClaimReserve(iPaymentIndex).PaidToDate)
                            Else
                                txtBalance.Text = String.Format(oFormatString, (.ClaimReserve(iPaymentIndex).TotalReserve - (.ClaimReserve(iPaymentIndex).PaidToDate + .ClaimReserve(iPaymentIndex).PaidToDateTax)))
                            End If
                            txtCurrency.Text = GetCurrencyForCode(CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).Payment.LossCurrencyCode)
                            txtNetPayment.Text = String.Format(oFormatString, Math.Round(CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).Payment.NetPayment, 2))
                            txtNetPaymentDisabled.Text = Math.Round((.ClaimReserve(iPaymentIndex).ThisPaymentINCLTax - .ClaimReserve(iPaymentIndex).ThisPaymentTax), 2)

                            txtPaymentAmount.Text = String.Format(oFormatString, CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).PaymentAmount)
                            HiddenLossPaymentAmount.Value = String.Format(oFormatString, .ClaimReserve(iPaymentIndex).ThisPaymentINCLTax)
                            txtTaxAmount.Text = String.Format(oFormatString, Math.Round(CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).TaxAmount, 2))
                            txtTaxAmountDisabled.Text = String.Format(oFormatString, .ClaimReserve(iPaymentIndex).ThisPaymentTax)
                            HiddenLossTaxAmountDisabled.Value = String.Format(oFormatString, .ClaimReserve(iPaymentIndex).ThisPaymentTax)
                            txtPaymentAmountDisabled.Text = String.Format(oFormatString, Math.Round(.ClaimReserve(iPaymentIndex).ThisPaymentINCLTax, 2))
                            txtNetPaymentDisabled.Text = String.Format(oFormatString, CDbl(txtNetPaymentDisabled.Text))
                            txtScriptedTaxAmount.Text = txtTaxAmount.Text


                            If bFirstElement = True Then
                                'Disable the Currency Selection
                                If oClaimOpen.ClaimPeril(iPeril).ClaimReserve(iCount) IsNot Nothing Then
                                    ddlCurrency.Enabled = False
                                    ddlCurrency.SelectedValue = oClaimOpen.ClaimPeril(iPeril).ClaimReserve(iCount).CurrencyCode
                                    UpdateDataOnCurrencyChange()
                                End If
                            End If

                            If CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).TaxGroupCode IsNot Nothing Then
                                ddlTaxGroup.SelectedValue = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).Payment.ClaimPaymentItem(iPaymentIndex).TaxGroupCode
                            End If

                            If .ClaimReserve(iPaymentIndex).IsExcess Then
                                liBalanceAmount.Visible = False
                                liReverseExcess.Visible = True
                                pnlTaxesGroup.Visible = False
                                txtPaymentAmountDisabled.Enabled = True
                                HiddenIsExcess.Value = "1"
                            Else
                                pnlTaxesGroup.Visible = True
                                HiddenIsExcess.Value = "0"
                                UpdateTaxAmount()
                            End If

                            txtPaymentAmount.Attributes.Add("onkeypress", "javascript:return IsNegativeInteger(event);")
                            txtTaxAmount.Attributes.Add("onkeypress", "javascript:return isInteger(event);")
                            txtBalanceAmount.Attributes.Add("onkeypress", "javascript:return isInteger(event);")
                            txtScriptedTaxAmount.Attributes.Add("onkeypress", "javascript:return isInteger(event);")

                        End With


                    ElseIf Session(CNMode) = Mode.SalvageClaim Then
                        lblPayment.Text = GetLocalResourceObject("ltReceipt")
                        lblPaymentCurrency.Text = GetLocalResourceObject("lbl_ReceiptCurrency")
                        lblCurrency.Text = GetLocalResourceObject("lblReceiptCurrency")
                        ltReserveType.Text = GetLocalResourceObject("lt_RecoveryType")
                        ltTotalReserve.Text = GetLocalResourceObject("lt_TotalRecovery")
                        ltPaidToDate.Text = GetLocalResourceObject("ltReceivedToDate")
                        lblPaymentAmount.Text = GetLocalResourceObject("lbl_ReceivedAmount")
                        ltPaymentAmountDisabled.Text = GetLocalResourceObject("lbl_ReceivedAmount")
                        ltNetPayment.Text = GetLocalResourceObject("lbl_NetReceived")
                        ltNetPaymentDisabled.Text = GetLocalResourceObject("lbl_NetReceived")
                        lblPaymentDetails.Text = GetLocalResourceObject("lbl_PaymentDetails")

                        'If Currency has been selected tehn it should not be selected again
                        Dim bFirstElement As Boolean = True
                        For iCount = 0 To CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).SalvageRecovery.Count - 1
                            If CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).SalvageRecovery(iCount).ReceiptQueue > 0 Then
                                bFirstElement = False
                                Exit For
                            End If
                        Next

                        With CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril)

                            txtPaymentAmountDisabled.Text = String.Format(oFormatString, Math.Round(.Receipt.ReceiptItem(iPaymentIndex).ThisReceiptINCLTaxAmount, 2))
                            txtNetPaymentDisabled.Text = Math.Round(.Receipt.ReceiptItem(iPaymentIndex).ThisReceiptNetAmount, 2)
                            HiddenLossPaymentAmount.Value = String.Format(oFormatString, Math.Round(.Receipt.ReceiptItem(iPaymentIndex).ThisReceiptINCLTaxAmount, 2))
                            txtTaxAmountDisabled.Text = String.Format(oFormatString, Math.Round(.Receipt.ReceiptItem(iPaymentIndex).ThisReceiptTaxAmount, 2))
                            HiddenLossTaxAmountDisabled.Value = Math.Round(.Receipt.ReceiptItem(iPaymentIndex).ThisReceiptTaxAmount, 2)
                            txtNetPaymentDisabled.Text = String.Format(oFormatString, txtNetPaymentDisabled.Text)


                            txtCurrency.Text = GetCurrencyForCode(CType(Session.Item(CNClaimQuote), NexusProvider.Quote).CurrencyCode.Trim)
                            txtTotalReserve.Text = String.Format(oFormatString, .SalvageRecovery(iPaymentIndex).TotalRecovery)
                            txtReserveType.Text = .SalvageRecovery(iPaymentIndex).TypeCode
                            txtPaidToDate.Text = String.Format(oFormatString, .SalvageRecovery(iPaymentIndex).ReceiptedAmount)
                            txtBalance.Text = String.Format(oFormatString, .SalvageRecovery(iPaymentIndex).TotalRecovery - .SalvageRecovery(iPaymentIndex).ReceiptedAmount)
                            txtNetPayment.Text = String.Format(oFormatString, .SalvageRecovery(iPaymentIndex).ThisNet)
                            txtPaymentAmount.Text = String.Format(oFormatString, .SalvageRecovery(iPaymentIndex).ThisReceiptINCLTax)
                            txtTaxAmount.Text = String.Format(oFormatString, .SalvageRecovery(iPaymentIndex).ThisReceiptTax)
                            txtScriptedTaxAmount.Text = txtTaxAmount.Text

                            If bFirstElement = False Then
                                'Accepting the Currency code for the second time
                                ddlCurrency.Enabled = False
                                ddlCurrency.SelectedValue = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).SalvageRecovery(iCount).CurrencyCode.Trim
                                UpdateDataOnCurrencyChange()
                            End If

                            'To set the Tax Code on Edit
                            If oClaimOpen.ClaimPeril(iPeril).Receipt IsNot Nothing Then
                                If oClaimOpen.ClaimPeril(iPeril).Receipt.ReceiptItem.Count > 0 Then
                                    ddlTaxGroup.SelectedValue = oClaimOpen.ClaimPeril(iPeril).Receipt.ReceiptItem(iPaymentIndex).TaxCode
                                End If
                            End If

                            pnlTaxesGroup.Visible = True
                            ' txtPaymentAmountDisabled.Attributes.Add("onblur", "javascript:return CalculateAmount(false, true);")
                            txtPaymentAmount.Attributes.Add("onkeypress", "javascript:return IsNegativeInteger(event);")
                            txtTaxAmount.Attributes.Add("onkeypress", "javascript:return IsNegativeInteger(event);")
                        End With
                        UpdateTaxAmount()

                    ElseIf Session(CNMode) = Mode.TPRecovery Then
                        lblPayment.Text = GetLocalResourceObject("ltReceipt")
                        lblPaymentCurrency.Text = GetLocalResourceObject("lbl_ReceiptCurrency")
                        lblCurrency.Text = GetLocalResourceObject("lblReceiptCurrency")
                        ltReserveType.Text = GetLocalResourceObject("lt_RecoveryType")
                        ltTotalReserve.Text = GetLocalResourceObject("lt_TotalRecovery")
                        ltPaidToDate.Text = GetLocalResourceObject("ltReceivedToDate")
                        lblPaymentAmount.Text = GetLocalResourceObject("lbl_ReceivedAmount")
                        ltPaymentAmountDisabled.Text = GetLocalResourceObject("lbl_ReceivedAmount")
                        ltNetPayment.Text = GetLocalResourceObject("lbl_NetReceived")
                        ltNetPaymentDisabled.Text = GetLocalResourceObject("lbl_NetReceived")
                        lblPaymentDetails.Text = GetLocalResourceObject("lbl_ReceiptDetails")
                        'If Currency has been selected tehn it should not be selected again
                        Dim bFirstElement As Boolean = True
                        For iCount = 0 To CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).TPRecovery.Count - 1
                            If CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).TPRecovery(iCount).ReceiptQueue > 0 Then
                                bFirstElement = False
                                Exit For
                            End If
                        Next


                        With CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril)

                            txtPaymentAmountDisabled.Text = String.Format(oFormatString, Math.Round(.Receipt.ReceiptItem(iPaymentIndex).ThisReceiptINCLTaxAmount, 2))
                            txtNetPaymentDisabled.Text = Math.Round(.Receipt.ReceiptItem(iPaymentIndex).ThisReceiptNetAmount, 2)
                            HiddenLossPaymentAmount.Value = String.Format(oFormatString, Math.Round(.Receipt.ReceiptItem(iPaymentIndex).ThisReceiptINCLTaxAmount, 2))

                            txtTaxAmountDisabled.Text = String.Format(oFormatString, Math.Round(.Receipt.ReceiptItem(iPaymentIndex).ThisReceiptTaxAmount, 2))
                            HiddenLossTaxAmountDisabled.Value = Math.Round(.Receipt.ReceiptItem(iPaymentIndex).ThisReceiptTaxAmount, 2)
                            txtNetPaymentDisabled.Text = String.Format(oFormatString, txtNetPaymentDisabled.Text)

                            txtCurrency.Text = GetCurrencyForCode(CType(Session.Item(CNClaimQuote), NexusProvider.Quote).CurrencyCode.Trim)
                            txtTotalReserve.Text = String.Format(oFormatString, .TPRecovery(iPaymentIndex).TotalRecovery)

                            txtReserveType.Text = .TPRecovery(iPaymentIndex).TypeCode
                            txtPaidToDate.Text = String.Format(oFormatString, .TPRecovery(iPaymentIndex).ReceiptedAmount)
                            txtBalance.Text = String.Format(oFormatString, .TPRecovery(iPaymentIndex).TotalRecovery - .TPRecovery(iPaymentIndex).ReceiptedAmount)
                            txtNetPayment.Text = String.Format(oFormatString, .TPRecovery(iPaymentIndex).ThisNet)
                            txtPaymentAmount.Text = String.Format(oFormatString, .TPRecovery(iPaymentIndex).ThisReceiptINCLTax)
                            txtTaxAmount.Text = String.Format(oFormatString, .TPRecovery(iPaymentIndex).ThisReceiptTax)
                            txtScriptedTaxAmount.Text = txtTaxAmount.Text


                            If bFirstElement = False Then
                                'Accepting the Currency code for the second time
                                ddlCurrency.Enabled = False
                                ddlCurrency.SelectedValue = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).TPRecovery(iCount).CurrencyCode.Trim
                                UpdateDataOnCurrencyChange()
                            End If

                            'To set the Tax Code on Edit
                            If oClaimOpen.ClaimPeril(iPeril).Receipt IsNot Nothing Then
                                If oClaimOpen.ClaimPeril(iPeril).Receipt.ReceiptItem.Count > 0 Then
                                    ddlTaxGroup.SelectedValue = oClaimOpen.ClaimPeril(Session(CNClaimPerilIndex)).Receipt.ReceiptItem(iPaymentIndex).TaxCode
                                End If
                            End If
                            pnlTaxesGroup.Visible = True
                            'txtPaymentAmountDisabled.Attributes.Add("onblur", "javascript:return CalculateAmount(false, true);")
                            txtPaymentAmount.Attributes.Add("onkeypress", "javascript:return IsNegativeInteger(event);")
                            txtTaxAmount.Attributes.Add("onkeypress", "javascript:return IsNegativeInteger(event);")
                        End With
                        UpdateTaxAmount()


                    End If

                End If
            End If
            txtPaymentAmount.Focus()
        End Sub

        Protected Sub Page_PreInit1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreInit
            CMS.Library.Frontend.Functions.SetTheme(Page, AppSettings("ModalPageTemplate"))
        End Sub

        Protected Sub ddlTaxGroup_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTaxGroup.SelectedIndexChanged
            UpdateTaxAmount()
        End Sub
        Sub UpdateTaxAmount()
            Dim oFormatString As String = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(GetPortalID()).FormatStrings.FormatString("Currency").DataFormatString
            If ddlCurrency.SelectedValue IsNot Nothing Then
                If ddlTaxGroup.SelectedValue.Trim.Length <> 0 AndAlso txtPaymentAmount.Text.Trim.Length <> 0 _
               AndAlso CDbl(txtPaymentAmount.Text.Trim) <> 0 AndAlso ddlCurrency.SelectedValue.Trim.Length <> 0 Then
                    Dim oWebservice As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                    Dim oClaimPayment As NexusProvider.ClaimPayment = Nothing
                    Dim oClaimReceipt As NexusProvider.ClaimReceipt = Nothing
                    Dim iPeril As Integer = CInt(Session(CNClaimPerilIndex))
                    Dim iPaymentIndex As Integer = CInt(Request("PaymentIndex"))
                    Dim oQuote As NexusProvider.Quote = Session(CNClaimQuote)
                    Dim oClaimOpen As NexusProvider.ClaimOpen = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen)

                    oClaimPayment = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).Payment
                    oClaimReceipt = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).Receipt

                    Dim oTaxForClaim As New NexusProvider.TaxForClaims

                    Dim sATSOption As String
                    sATSOption = oWebservice.GetProductRiskOptionValue(NexusProvider.ProductConfigActionType.ProductRiskMaintenance, NexusProvider.ProductRiskOptions.IsAdvancedTaxScriptEnabled, NexusProvider.RiskTypeOptions.None, Session(CNProductCode), Nothing)

                    With oTaxForClaim
                        .Amount = Math.Round(CType(Trim(txtPaymentAmount.Text), Double), 2)
                        .CurrencyCode = ddlCurrency.SelectedValue
                        .LossCurrencyCode = oClaimOpen.CurrencyISOCode
                        .TaxGroupCode = ddlTaxGroup.SelectedValue
                        .ClaimPerilID = oClaimOpen.ClaimPeril(iPeril).ClaimPerilKey

                        If sATSOption = "1" Then
                            If Session(CNMode) = Mode.PayClaim Then
                                '.PaymentAdvancedTaxDetails = New NexusProvider.PaymentAdvancedTaxDetails
                                .ReserveType = txtReserveType.Text 'oClaimPayment.ReserveType
                                .ReserveKey = oClaimPayment.BaseReserveKey
                                .Mode = Mode.PayClaim.ToString
                                .PaymentAdvancedTaxDetails = oClaimPayment.PaymentAdvancedTaxDetails
                                .PaymentAdvancedTaxDetails.PaymentTo = oClaimPayment.PaymentAdvancedTaxDetails.PaymentTo


                            Else
                                If Session(CNMode) = Mode.TPRecovery OrElse Session(CNMode) = Mode.SalvageClaim Then
                                    .RecoveryType = txtReserveType.Text
                                End If

                                .IsSalvageRecovery = oClaimReceipt.IsSalvageRecovery
                                .ReceiptAdvancedTaxDetails = oClaimReceipt.AdvancedTaxDetails
                            End If
                        End If


                    End With
                     If Session(CNMode) = Mode.TPRecovery Then
                        oTaxForClaim.TransactionTypeCode = "C_RV"
                    ElseIf Session(CNMode) = Mode.SalvageClaim Then
                        oTaxForClaim.TransactionTypeCode = "C_SA"
                    End If

                    oWebservice.CalculateTaxForClaims(oTaxForClaim, oQuote.BranchCode)
                    Try

                        If Not String.IsNullOrEmpty(sATSOption) AndAlso sATSOption = "1" Then
                            If oTaxForClaim.TaxItems IsNot Nothing AndAlso oTaxForClaim.Mode = Mode.PayClaim.ToString Then
                                If oClaimPayment.ClaimPaymentTaxItems.Count = 0 Then
                                    oClaimPayment.ClaimPaymentTaxItems = oTaxForClaim.TaxItems
                                Else
                                    Dim bNew As Boolean = False
                                    Dim oClaimPaymentTaxItems As NexusProvider.ClaimPaymentTaxItemCollection = oClaimPayment.ClaimPaymentTaxItems
                                    For Each oClaimPayemttax As NexusProvider.ClaimPaymentTaxItem In oClaimPaymentTaxItems
                                        If oClaimPayemttax.ReserveTypeCode = txtReserveType.Text Then
                                            oClaimPayment.ClaimPaymentTaxItems.Remove(oClaimPayemttax)
                                            For Each oTaxForClaimTax As NexusProvider.ClaimPaymentTaxItem In oTaxForClaim.TaxItems
                                                With oClaimPayemttax
                                                    .Amount = oTaxForClaimTax.Amount
                                                    .ClassOfBusinessID = .ClassOfBusinessID
                                                    .IsManuallyChanges = .IsManuallyChanges
                                                    .Percentage = .Percentage
                                                    .ReserveType = oTaxForClaimTax.ReserveType
                                                    .Sequence = oTaxForClaimTax.Sequence
                                                    .TaxBandCode = oTaxForClaimTax.TaxBandCode
                                                    .TaxBandId = oTaxForClaimTax.TaxBandId
                                                    .TaxGroupCode = oTaxForClaimTax.TaxGroupCode
                                                    .TaxGroupId = oTaxForClaimTax.TaxGroupId
                                                End With
                                                oClaimPayment.ClaimPaymentTaxItems.Add(oClaimPayemttax)
                                            Next
                                            Exit For

                                        Else
                                            For Each oTaxForClaimTax As NexusProvider.ClaimPaymentTaxItem In oTaxForClaim.TaxItems
                                                Dim oClaimPayemttaxNew As New NexusProvider.ClaimPaymentTaxItem
                                                With oClaimPayemttaxNew
                                                    .Amount = oTaxForClaimTax.Amount
                                                    .ClassOfBusinessID = .ClassOfBusinessID
                                                    .IsManuallyChanges = .IsManuallyChanges
                                                    .Percentage = .Percentage
                                                    .ReserveType = oTaxForClaimTax.ReserveType
                                                    .Sequence = oTaxForClaimTax.Sequence
                                                    .TaxBandCode = oTaxForClaimTax.TaxBandCode
                                                    .TaxBandId = oTaxForClaimTax.TaxBandId
                                                    .TaxGroupCode = oTaxForClaimTax.TaxGroupCode
                                                    .TaxGroupId = oTaxForClaimTax.TaxGroupId
                                                End With
                                                oClaimPayment.ClaimPaymentTaxItems.Add(oClaimPayemttaxNew)
                                            Next
                                            bNew = True
                                            Exit For
                                        End If
                                    Next
                                End If

                                oClaimOpen.ClaimPeril(iPeril).Payment = oClaimPayment
                                Session(CNClaim) = oClaimOpen
                            ElseIf oTaxForClaim.ReceiptTaxItem IsNot Nothing Then

                                oClaimReceipt.TaxItem = oTaxForClaim.ReceiptTaxItem
                                oClaimOpen.ClaimPeril(iPeril).Receipt = oClaimReceipt
                                Session(CNClaim) = oClaimOpen

                            End If
                        End If
                        txtTaxAmount.Text = String.Format(oFormatString, oTaxForClaim.TaxCurrencyAmount)
                        txtTaxAmountDisabled.Text = String.Format(oFormatString, oTaxForClaim.TaxLossAmount)
                        txtScriptedTaxAmount.Text = txtTaxAmount.Text

                        If Not (Session(CNMode) = Mode.SalvageClaim Or Session(CNMode) = Mode.TPRecovery) Then
                            If hIsGrossClaimPaymentAmount.Value = "1" Then
                                txtNetPayment.Text = String.Format(oFormatString, CType(Trim(txtPaymentAmount.Text), Double) - oTaxForClaim.TaxCurrencyAmount)
                                txtNetPaymentDisabled.Text = String.Format(oFormatString, CDec(txtPaymentAmountDisabled.Text.Trim) - oTaxForClaim.TaxLossAmount)
                                txtBalanceAmount.Text = String.Format(oFormatString, CDbl(txtBalance.Text) - (CDec(txtNetPaymentDisabled.Text.Trim) + oTaxForClaim.TaxLossAmount))
                            Else
                                txtNetPayment.Text = String.Format(oFormatString, CType(Trim(txtPaymentAmount.Text), Double) + oTaxForClaim.TaxCurrencyAmount)
                                txtNetPaymentDisabled.Text = String.Format(oFormatString, CDec(txtPaymentAmountDisabled.Text.Trim) + oTaxForClaim.TaxLossAmount)
                                txtBalanceAmount.Text = String.Format(oFormatString, CDbl(txtBalance.Text) - (CDec(txtNetPaymentDisabled.Text.Trim) - oTaxForClaim.TaxLossAmount))
                            End If
                        End If

                        If (Session(CNMode) = Mode.SalvageClaim Or Session(CNMode) = Mode.TPRecovery) Then
                            If hSalvageAndTPRecoveryReservesExcludeTax.Value = "1" Then
                                txtNetPayment.Text = String.Format(oFormatString, CType(Trim(txtPaymentAmount.Text), Double) + oTaxForClaim.TaxCurrencyAmount)
                                txtNetPaymentDisabled.Text = String.Format(oFormatString, CDec(txtPaymentAmountDisabled.Text.Trim) + oTaxForClaim.TaxLossAmount)
                                txtBalanceAmount.Text = String.Format(oFormatString, CDbl(txtBalance.Text) - (CDec(txtNetPaymentDisabled.Text.Trim) - oTaxForClaim.TaxLossAmount))
                            Else
                                txtNetPayment.Text = String.Format(oFormatString, CType(Trim(txtPaymentAmount.Text), Double) - oTaxForClaim.TaxCurrencyAmount)
                                txtNetPaymentDisabled.Text = String.Format(oFormatString, CDec(txtPaymentAmountDisabled.Text.Trim) - oTaxForClaim.TaxLossAmount)
                                txtBalanceAmount.Text = String.Format(oFormatString, CDbl(txtBalance.Text) - (CDec(txtNetPaymentDisabled.Text.Trim) + oTaxForClaim.TaxLossAmount))
                            End If
                        End If

                        HiddenLossTaxAmountDisabled.Value = txtTaxAmountDisabled.Text.Trim
                    Finally
                        oWebservice = Nothing
                    End Try
                Else
                    txtTaxAmount.Text = "0.00"
                    txtTaxAmountDisabled.Text = "0.00"
                    txtNetPayment.Text = String.Format(oFormatString, txtPaymentAmount.Text.Trim)
                    txtNetPaymentDisabled.Text = String.Format(oFormatString, txtPaymentAmountDisabled.Text.Trim)
                    HiddenLossTaxAmountDisabled.Value = txtTaxAmountDisabled.Text.Trim
                    txtScriptedTaxAmount.Text = "0.00"
                    Dim dNetAmount, dBalance As Decimal
                    Decimal.TryParse(txtNetPaymentDisabled.Text, dNetAmount)
                    Decimal.TryParse(txtBalance.Text, dBalance)
                    If (Not String.IsNullOrEmpty(txtBalance.Text) AndAlso Not String.IsNullOrEmpty(HiddenLossPaymentAmount.Value)) Then
                        txtBalanceAmount.Text = String.Format(oFormatString, Math.Abs(CDbl(txtBalance.Text)) - Math.Abs(CDbl(HiddenLossPaymentAmount.Value)))
                    End If
                End If
            End If
        End Sub
        Protected Sub ddlCurrency_SelectedIndexChange(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCurrency.SelectedIndexChanged
            UpdateDataOnCurrencyChange()
        End Sub

        Protected Sub btnOk_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOk.Load
            If Session(CNMode) = Mode.PayClaim Then
                Dim oWebservice As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                Dim oQuote As NexusProvider.Quote = Session(CNClaimQuote)

                Dim oTaxGroupMandatorySetting As NexusProvider.OptionTypeSetting
                Dim oPaymentCannotExceedReserve As String

                oTaxGroupMandatorySetting = oWebservice.GetOptionSetting(NexusProvider.OptionType.SystemOption, 5063)


                'finding value of PaymentCannotExceedReserve
                oPaymentCannotExceedReserve = oWebservice.GetProductRiskOptionValue(NexusProvider.ProductConfigActionType.ProductRiskMaintenance, NexusProvider.ProductRiskOptions.PaymentCannotExceedReserve, NexusProvider.RiskTypeOptions.None, oQuote.ProductCode, Nothing)
                HidPaymentCannotExceedReserve.Value = oPaymentCannotExceedReserve
                IsTaxGroupMandatory.Value = oTaxGroupMandatorySetting.OptionValue
                Dim oIsNegativeReserve As String
                oIsNegativeReserve = oWebservice.GetProductRiskOptionValue(NexusProvider.ProductConfigActionType.ProductRiskMaintenance, NexusProvider.ProductRiskOptions.AllowNegativeReserve, NexusProvider.RiskTypeOptions.None, oQuote.ProductCode, Nothing)
                HidNegativeReserve.Value = oIsNegativeReserve
                If HidPaymentCannotExceedReserve.Value = "0" Then
                    btnOk.Attributes.Add("onclick", "javascript:return IsNegativeReserve('" + GetLocalResourceObject("lbl_PaymentConfirmMsg") + "')")
                End If
            End If
        End Sub

        Protected Sub txtPaymentAmount_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtPaymentAmount.TextChanged
            Dim oFormatString As String = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(GetPortalID()).FormatStrings.FormatString("Currency").DataFormatString
            If ddlCurrency.SelectedValue.Trim.Length <> 0 Then
                If txtPaymentAmount.Text.Trim.Length = 0 Then
                    txtPaymentAmount.Text = "0.00"
                End If
                Try
                    Decimal.Parse(txtPaymentAmount.Text)
                Catch ex As System.Exception
                    txtPaymentAmount.Text = "0.00"
                    IsPaymentAmount.IsValid = False
                    IsPaymentAmount.ErrorMessage = GetLocalResourceObject("lbl_InvalidPayment")
                    Exit Sub
                End Try
                If Session.Item(CNClaim) IsNot Nothing Then
                    Dim iPeril As Integer = CInt(Session(CNClaimPerilIndex))
                    Dim iPaymentIndex As Integer = CInt(Request("PaymentIndex"))
                    Dim oClaimPayment As NexusProvider.PerilSummary = Nothing
                    'added following line for issue 1596 
                    txtPaymentAmountDisabled.Text = String.Format(oFormatString, txtPaymentAmount.Text)
                    If String.IsNullOrEmpty(txtPaymentAmount.Text) Then
                        txtPaymentAmount.Text = "0"
                    End If
                    If Session(CNMode) = Mode.PayClaim Then
                        oClaimPayment = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril)
                        If oClaimPayment.ClaimReserve(iPaymentIndex).IsExcess Then
                            SetIsExecessValue(chkReverseExcess.Checked)
                        Else
                            txtNetPayment.Text = String.Format(oFormatString, Math.Round(CDbl(txtPaymentAmount.Text.Trim), 2) - Math.Round(CDbl(txtTaxAmount.Text.Trim), 2))
                            txtPaymentAmountDisabled.Text = String.Format(oFormatString, Math.Round(CDbl(txtCurrencyRate.Text.Trim) * CDbl(txtPaymentAmount.Text.Trim), 2))
                            HiddenLossPaymentAmount.Value = Math.Round(CDec(txtPaymentAmountDisabled.Text.Trim), 2)
                            ' txtBalanceAmount.Text = Math.Round(CDbl(txtBalance.Text) - CDbl(HiddenLossPaymentAmount.Value), 2)
                            txtPaymentAmount.Text = String.Format(oFormatString, CDbl(txtPaymentAmount.Text.Trim))
                            UpdateTaxAmount()
                        End If
                    ElseIf Session(CNMode) = Mode.SalvageClaim Or Session(CNMode) = Mode.TPRecovery Then
                        txtNetPayment.Text = String.Format(oFormatString, CDbl(txtPaymentAmount.Text.Trim) - CDbl(txtTaxAmount.Text.Trim))
                        txtPaymentAmountDisabled.Text = String.Format(oFormatString, CDbl(txtCurrencyRate.Text.Trim) * CDbl(txtPaymentAmount.Text.Trim))
                        HiddenLossPaymentAmount.Value = Math.Round(CDbl(txtPaymentAmountDisabled.Text.Trim), 2)
                        txtBalanceAmount.Text = String.Format(oFormatString, Math.Round(CDbl(txtBalance.Text) - CDbl(HiddenLossPaymentAmount.Value), 2))
                        txtPaymentAmount.Text = String.Format(oFormatString, CDbl(txtPaymentAmount.Text.Trim))
                        UpdateTaxAmount()
                    End If
                End If
            End If
        End Sub
        Sub SetIsExecessValue(Optional ByVal bCheck As Boolean = False)
            Dim oFormatString As String = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(GetPortalID()).FormatStrings.FormatString("Currency").DataFormatString
            If bCheck = False AndAlso CDbl(txtPaymentAmount.Text) > 0 Then
                txtNetPayment.Text = String.Format(oFormatString, CDbl(txtPaymentAmount.Text.Trim) - CDbl(txtTaxAmount.Text.Trim))
                txtPaymentAmountDisabled.Text = String.Format(oFormatString, CDbl(txtCurrencyRate.Text.Trim) * CDbl(txtPaymentAmount.Text.Trim))
                HiddenLossPaymentAmount.Value = txtPaymentAmountDisabled.Text.Trim
                txtNetPayment.Text = String.Format(oFormatString, -CDbl(txtNetPayment.Text))

                txtPaymentAmount.Text = String.Format(oFormatString, -CDbl(txtPaymentAmount.Text.Trim))
                HiddenLossPaymentAmount.Value = String.Format(oFormatString, -CDbl(HiddenLossPaymentAmount.Value))
                txtNetPaymentDisabled.Text = String.Format(oFormatString, -CDbl(txtPaymentAmountDisabled.Text))
                txtPaymentAmountDisabled.Text = String.Format(oFormatString, -CDbl(txtPaymentAmountDisabled.Text))
                txtBalanceAmount.Text = String.Format(oFormatString, Math.Abs(CDbl(txtBalance.Text)) - Math.Abs(CDbl(HiddenLossPaymentAmount.Value)))

            ElseIf bCheck = True Then
                txtNetPayment.Text = String.Format(oFormatString, Math.Abs(CDbl(txtPaymentAmount.Text.Trim)) - Math.Abs(CDbl(txtTaxAmount.Text.Trim)))
                txtPaymentAmountDisabled.Text = String.Format(oFormatString, Math.Abs(CDbl(txtCurrencyRate.Text.Trim)) * Math.Abs(CDbl(txtPaymentAmount.Text.Trim)))
                HiddenLossPaymentAmount.Value = Math.Abs(CDbl(txtPaymentAmountDisabled.Text.Trim))

                txtNetPayment.Text = String.Format(oFormatString, Math.Abs(CDbl(txtNetPayment.Text)))
                txtPaymentAmount.Text = String.Format(oFormatString, Math.Abs(CDbl(txtPaymentAmount.Text)))
                txtBalanceAmount.Text = String.Format(oFormatString, Math.Abs(CDbl(txtBalance.Text)) - Math.Abs(CDbl(txtNetPaymentDisabled.Text)))
                txtNetPaymentDisabled.Text = String.Format(oFormatString, Math.Abs(CDbl(txtPaymentAmountDisabled.Text)))
                txtPaymentAmountDisabled.Text = String.Format(oFormatString, Math.Abs(CDbl(txtPaymentAmountDisabled.Text)))
                HiddenLossPaymentAmount.Value = String.Format(oFormatString, Math.Abs(CDbl(HiddenLossPaymentAmount.Value)))
            Else
                txtPaymentAmount.Text = String.Format(oFormatString, CDbl(txtPaymentAmount.Text.Trim))
                txtPaymentAmountDisabled.Text = String.Format(oFormatString, CDbl(txtPaymentAmountDisabled.Text))
            End If
        End Sub
        ''' <summary>
        ''' This event is fired on OK Button click 
        ''' </summary>
        ''' <remarks></remarks>
        Sub CheckProductRiskMaintenance()
            If Session(CNMode) = Mode.PayClaim Then
                'Check ProductRiskMaintenance Paymentcannotexceedreserve  option
                If (HidPaymentCannotExceedReserve.Value = "1" And (HidNegativeReserve.Value = "1" Or HidNegativeReserve.Value = "0")) Then
                    'Check Netpayment amount is greater than balance amount
                    If ((((CDbl(txtNetPaymentDisabled.Text) > (CDbl(txtBalance.Text)))) AndAlso hIsGrossClaimPaymentAmount.Value = "1") _
                        OrElse (((CDbl(txtNetPaymentDisabled.Text) - CDbl(HiddenLossTaxAmountDisabled.Value) > (CDbl(txtBalance.Text)))) AndAlso hIsGrossClaimPaymentAmount.Value = "0")) Then
                        'CustomValidator is fired
                        CustVldProductRiskMaintenance.IsValid = False
                        'Display Paymentcannotexceedreserve error message
                        CustVldProductRiskMaintenance.ErrorMessage = GetLocalResourceObject("lbl_PaymentCannotExceedReserveConfirmMsg")
                        txtPaymentAmount.Text = "0.00"
                        txtBalanceAmount.Text = "0.00"
                        txtTaxAmount.Text = "0.00"
                        txtNetPayment.Text = "0.00"
                        txtPaymentAmountDisabled.Text = "0.00"
                        txtNetPaymentDisabled.Text = "0.00"
                        txtTaxAmountDisabled.Text = "0.00"
                        HiddenLossPaymentAmount.Value = 0
                        HiddenLossTaxAmountDisabled.Value = "0"
                        HiddenIsExcess.Value = "0"
                    End If
                End If
                If (HidNegativeReserve.Value = "0" And (CDbl(txtNetPaymentDisabled.Text) > (CDbl(txtBalance.Text)))) Then
                    txtBalanceAmount.Text = "0.00"
                    txtTaxAmount.Text = "0.00"
                    txtNetPayment.Text = "0.00"
                    txtNetPaymentDisabled.Text = "0.00"
                    txtTaxAmountDisabled.Text = "0.00"
                End If
                If String.IsNullOrEmpty(txtBalanceAmount.Text.Trim) Then
                    txtBalanceAmount.Text = "0.00"
                End If

                'Check Session variable (set in perils.ascx) payment amount is greater than payment amount enter on screen
                If Session(CNMaxClaimPaymentValue) IsNot Nothing Then
                    If txtPaymentAmount.Text.Trim <> "" AndAlso Session(CNMaxClaimPaymentValue) < CDbl(txtPaymentAmount.Text) Then
                        cvAllowMultipleClaimPayment.IsValid = False
                        Exit Sub
                    End If
                ElseIf Session(CNMaxClaimPaymentValue) Is Nothing Then
                    cvAllowMultipleClaimPayment.IsValid = True
                End If


            End If
        End Sub
        ''' <summary>
        ''' This event is fired on OK Button click 
        ''' </summary>
        ''' <remarks></remarks>
        Sub CheckIsTaxGroupMandatory()
            If Session(CNMode) = Mode.PayClaim Then
                'Check System Options for IsTaxGroupMandatory
                If (IsTaxGroupMandatory.Value = "1") AndAlso (HiddenIsExcess.Value <> "1") Then
                    'Check if Tax Group has been selected
                    If (ddlTaxGroup.SelectedValue = "") Then
                        'CustomValidator is fired
                        CustVldIsTaxGroupMandatory.IsValid = False
                        'Display IsTaxGroupMandatory error message
                        CustVldIsTaxGroupMandatory.ErrorMessage = GetLocalResourceObject("lbl_TaxGroupMandatory")

                    End If
                End If
            End If
        End Sub

        Sub PopulateReserveItem()
            Dim iPeril As Integer = CInt(Session(CNClaimPerilIndex))
            Dim oClaimOpen As NexusProvider.ClaimOpen = Nothing
            Dim oClaimPayment As New NexusProvider.ClaimPayment
            'Retreiving the claim quote information from session
            Dim oQuote As NexusProvider.Quote = CType(Session(CNClaimQuote), NexusProvider.Quote)
            'Retreiving the claim  information from session
            oClaimOpen = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen)

            For Each oCPeril As NexusProvider.PerilSummary In oClaimOpen.ClaimPeril
                For Each oReserveItem As NexusProvider.Reserve In oCPeril.Reserve
                    Dim oClaimPaymentItem As New NexusProvider.ClaimPaymentItemType
                    Dim oClaimReserve As New NexusProvider.ClaimPerilReservePaymentType
                    oClaimPayment.BaseReserveKey = oReserveItem.BaseReserveKey
                    oClaimPaymentItem.BaseReserveKey = oReserveItem.BaseReserveKey

                    With oClaimReserve
                        .TypeCode = oReserveItem.TypeCode
                        .BaseReserveKey = oReserveItem.BaseReserveKey
                        .PaidToDate = oReserveItem.PaidAmount

                        'Total Tax Paid
                        If oClaimOpen.ClaimPeril(iPeril).Payment IsNot Nothing Then
                            If oClaimOpen.ClaimPeril(iPeril).Payment.PaymentItems IsNot Nothing Then
                                If oClaimOpen.ClaimPeril(iPeril).Payment.PaymentItems.Count > 0 Then
                                    .PaidToDateTax = oClaimOpen.ClaimPeril(iPeril).Payment.PaymentItems(0).TotalTaxAmount
                                End If
                            End If
                        End If
                        'Calculation of Current Reserve and other values
                        If oReserveItem.IsExcess Then
                            .CurrentReserve = oReserveItem.InitialReserve + oReserveItem.RevisedReserve + (-oReserveItem.PaidAmount)
                        Else
                            .CurrentReserve = oReserveItem.InitialReserve + oReserveItem.RevisedReserve - oReserveItem.PaidAmount
                        End If
                        If .OldReserve <= 0.0 Then
                            .OldReserve = .CurrentReserve
                        End If
                        .TotalReserve = oReserveItem.InitialReserve + oReserveItem.RevisedReserve
                        .IsExcess = oReserveItem.IsExcess
                        .IsIndemnity = oReserveItem.IsIndemnity
                        .IsExpense = oReserveItem.IsExpense

                        If Session.Item(CNReserveDescriptions) IsNot Nothing Then
                            Dim oReserveDescriptions As Hashtable = Session.Item(CNReserveDescriptions)
                            Dim HData As DictionaryEntry
                            For Each HData In oReserveDescriptions
                                If HData.Key.ToString.Trim.ToUpper = oReserveItem.TypeCode.Trim.ToUpper Then
                                    .Description = HData.Value
                                End If
                            Next
                        End If
                    End With
                    'All claim reserve will be added
                    If oCPeril.ClaimReserve IsNot Nothing Then
                        oCPeril.ClaimReserve.Add(oClaimReserve)
                    End If
                    'Only selected peril will have payment item
                    If oClaimOpen.ClaimPeril(iPeril).ClaimPerilKey = oCPeril.ClaimPerilKey AndAlso oClaimPaymentItem.BaseReserveKey <> 0 Then
                        oClaimPayment.ClaimPaymentItem.Add(oClaimPaymentItem)
                    End If
                Next
            Next

            'Updating values into oClaimPayment object
            oClaimPayment.CurrencyCode = oClaimOpen.CurrencyISOCode
            oClaimPayment.LossCurrencyCode = oClaimOpen.CurrencyISOCode
            oClaimPayment.RiskType = oQuote.Risks(0).Description
            oClaimPayment.BaseClaimKey = oClaimOpen.BaseClaimKey
            oClaimPayment.BaseClaimPerilKey = oClaimOpen.ClaimPeril(iPeril).BaseClaimPerilKey
            oClaimPayment.ClientKey = oClaimOpen.Client.PartyKey
            oClaimOpen.ClaimPeril(iPeril).Payment = oClaimPayment
            Session(CNClaim) = oClaimOpen
        End Sub

        Protected Sub chkReverseExcess_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkReverseExcess.CheckedChanged
            SetIsExecessValue(CType(sender, CheckBox).Checked)
        End Sub

        Sub PopulateCurrencyByBranch()
            'Fill Currency
            Dim oCurrencyCollection As NexusProvider.CurrencyCollection
            Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            Dim oQuote As NexusProvider.Quote = Session(CNClaimQuote)

            oCurrencyCollection = oWebService.GetCurrenciesByBranch(oQuote.BranchCode)
            ddlCurrency.Items.Clear()
            For i As Integer = 0 To oCurrencyCollection.Count - 1
                Dim lstCurrency As New ListItem
                lstCurrency.Text = oCurrencyCollection.Item(i).Description.ToString
                lstCurrency.Value = Trim(oCurrencyCollection.Item(i).CurrencyCode.ToString)
                ddlCurrency.Items.Add(lstCurrency)
            Next
            ddlCurrency.DataBind()
        End Sub

        Sub UpdateDataOnCurrencyChange()
            If ddlCurrency.SelectedValue.Trim.Length <> 0 Then
                Dim oWebservice As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                Dim oCurrency As New NexusProvider.Currency
                Dim iPeril As Integer = CInt(Session(CNClaimPerilIndex))
                Dim oClaimReserve As NexusProvider.ClaimPerilReservePaymentTypeCollection = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).ClaimReserve
                Dim iPaymentIndex As Integer = CInt(Request("PaymentIndex"))
                Dim amount As Decimal
                Dim iClaimKey As Integer = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).BaseClaimKey
                Dim oQuote As NexusProvider.Quote = Session(CNClaimQuote)
                Dim oFormatString As String = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(GetPortalID()).FormatStrings.FormatString("Currency").DataFormatString
                Try
                    oCurrency.AccountCode = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClientShortName
                    oCurrency.TransactionCurrencyCode = ddlCurrency.SelectedValue
                    oCurrency.Mode = "ALL"
                    'Added Claim key in following function.
                    oCurrency = oWebservice.GetCurrencyExchangeRates(oCurrency, Session(CNBranchCode), iClaimKey)
                    txtCurrencyRate.Text = oCurrency.TransactionCurrencyRate
                    If Trim(txtPaymentAmount.Text) <> String.Empty Then
                        If Session(CNMode) = Mode.PayClaim Then
                            If oClaimReserve(iPaymentIndex).IsExcess Then
                                amount = Math.Round(CDec(txtPaymentAmount.Text) * CDec(txtCurrencyRate.Text), 2)
                                txtPaymentAmountDisabled.Text = String.Format(oFormatString, Math.Round(amount, 2))
                                HiddenLossPaymentAmount.Value = Math.Round(amount, 2)
                                txtBalanceAmount.Text = String.Format(oFormatString, Math.Abs(Math.Round(CDbl(txtBalance.Text)) - Math.Abs(CDbl(HiddenLossPaymentAmount.Value))))
                                txtNetPaymentDisabled.Text = Math.Round(amount, 2)
                                txtBalanceAmount.Text = String.Format(oFormatString, Math.Round(CDbl(txtBalance.Text) - CDbl(txtNetPaymentDisabled.Text)))
                                txtNetPayment.Text = String.Format(oFormatString, Math.Round(CDec(txtPaymentAmount.Text), 2))
                                txtNetPaymentDisabled.Text = String.Format(oFormatString, CDbl(txtNetPaymentDisabled.Text))
                            Else
                                amount = CDec(txtPaymentAmount.Text) * CDec(txtCurrencyRate.Text)
                                txtPaymentAmountDisabled.Text = String.Format(oFormatString, Math.Round(amount, 2))
                                HiddenLossPaymentAmount.Value = Math.Round(amount, 2)
                                txtBalanceAmount.Text = String.Format(oFormatString, Math.Round(CDbl(txtBalance.Text) - CDbl(HiddenLossPaymentAmount.Value)))
                                txtNetPayment.Text = String.Format(oFormatString, Math.Round((CDec(txtPaymentAmount.Text) - CDec(txtTaxAmount.Text)), 2))
                                txtNetPaymentDisabled.Text = Math.Round((CDec(txtPaymentAmountDisabled.Text) - CDec(txtTaxAmountDisabled.Text)), 2)
                                txtBalanceAmount.Text = String.Format(oFormatString, Math.Round(CDbl(txtBalance.Text) - CDbl(txtNetPaymentDisabled.Text)))
                                txtNetPaymentDisabled.Text = String.Format(oFormatString, CDbl(txtNetPaymentDisabled.Text))
                            End If
                        Else
                            amount = CDec(txtPaymentAmount.Text) * CDec(txtCurrencyRate.Text)
                            txtPaymentAmountDisabled.Text = String.Format(oFormatString, Math.Round(amount, 2))
                            HiddenLossPaymentAmount.Value = Math.Round(amount, 2)
                            txtBalanceAmount.Text = String.Format(oFormatString, Math.Round(CDbl(txtBalance.Text) - CDbl(HiddenLossPaymentAmount.Value)))
                            txtNetPayment.Text = String.Format(oFormatString, Math.Round((CDec(txtPaymentAmount.Text) - CDec(txtTaxAmount.Text)), 2))
                            txtNetPaymentDisabled.Text = String.Format(oFormatString, Math.Round((CDec(txtPaymentAmountDisabled.Text) - CDec(txtTaxAmountDisabled.Text)), 2))
                        End If
                    End If
                Finally
                    UpdateTaxAmount()
                    oWebservice = Nothing
                End Try
            Else
                txtPaymentAmount.Text = "0.00"
                txtPaymentAmountDisabled.Text = "0.00"
                txtCurrencyRate.Text = String.Empty
                UpdateTaxAmount()
            End If
        End Sub

        Sub UpdateReserve(ByRef oClaim As NexusProvider.ClaimOpen)
            Session(CNLockPaymentGrid) = True
            Dim iPeril As Integer = CInt(Session(CNClaimPerilIndex)) ' CInt(Request.QueryString("PerilIndex"))
            Dim iPaymentIndex As Integer = CInt(Request("PaymentIndex"))
            Dim oModeClaim As Mode = CType(Session.Item(CNMode), Mode)
            'Flag to check which peril has been updated it need to be updated in DB
            oClaim.ClaimPeril(iPeril).PerilEdited = True
            Dim sAmount As String = txtBalanceAmount.Text
            Dim dTaxAmount As Decimal = 0D
            Decimal.TryParse(txtTaxAmountDisabled.Text, dTaxAmount)

            If oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).BaseReserveKey <> 0 Then
                If String.IsNullOrEmpty(sAmount) = False Then
                    Dim dAmountToBePaid As Decimal
                    If oClaim.ClaimPeril(iPeril).ClaimReserve IsNot Nothing AndAlso oClaim.ClaimPeril(iPeril).ClaimReserve.Count > 0 Then
                        If hIsGrossClaimPaymentAmount.Value = "1" Then
                            Decimal.TryParse(oClaim.ClaimPeril(iPeril).ClaimReserve(iPaymentIndex).ThisPaymentINCLTax, dAmountToBePaid)
                        Else
                            Decimal.TryParse(oClaim.ClaimPeril(iPeril).ClaimReserve(iPaymentIndex).ThisPaymentINCLTax - oClaim.ClaimPeril(iPeril).ClaimReserve(iPaymentIndex).ThisPaymentTax, dAmountToBePaid)
                        End If
                    End If
                    oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).CurrentReserve += CDbl(sAmount) - (oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).InitialReserve + oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).RevisedReserve - oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).PaidAmount - dAmountToBePaid)
                    If hIsGrossClaimPaymentAmount.Value = "1" Then
                        oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).RevisedReserve += CDbl(sAmount) - (oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).InitialReserve + oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).RevisedReserve - oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).PaidAmount - dAmountToBePaid)
                    Else
                        oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).RevisedReserve += CDbl(sAmount) - (oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).InitialReserve + oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).RevisedReserve - oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).PaidAmount - (dAmountToBePaid - dTaxAmount))
                    End If


                    If CDbl(sAmount) < 0 Then
                        oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).RevisedReserve = sAmount * -1
                    End If
                    'Flag to check which reserve has been updated it need to be updated in DB

                    oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).ReserveEdited = True
                Else
                    'Flag to check which reserve has been updated it need to be updated in DB
                    oClaim.ClaimPeril(iPeril).Reserve(iPaymentIndex).ReserveEdited = False
                End If

            End If

            Session.Item(CNClaim) = oClaim


        End Sub
    End Class
End Namespace
