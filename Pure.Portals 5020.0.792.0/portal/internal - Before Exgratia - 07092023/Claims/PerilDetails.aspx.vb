Imports System.Linq
Imports NexusProvider
Imports Nexus.Constants
Imports Nexus.Constants.Session

Namespace Nexus
    Partial Class Claims_PerilDetails
        Inherits BasePeril
        Private sJScriptDisableCalculate As String

        Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                'if page is loaded first time then setting of the status of progres bar
                ucProgressBar.OverviewStyle = "complete"
                ucProgressBar.PerilsStyle = "in-progress"
                ucProgressBar.SummaryStyle = "incomplete"
                ucProgressBar.ReinsuranceStyle = "incomplete"
                ucProgressBar.CompleteStyle = "incomplete"

         
                If CType(Session.Item(CNMode), Mode) = Mode.NewClaim Or CType(Session.Item(CNMode), Mode) = Mode.EditClaim Or CType(Session.Item(CNMode), Mode) = Mode.ViewClaim Then
                    Me.ClientScript.RegisterStartupScript(GetType(String), "StartupScripts", "$('.nav-tabs li:eq(0) a').tab('show');", True)
               

			   End If

                If Session(CNMode) = Mode.SalvageClaim OrElse Session(CNMode) = Mode.TPRecovery Then
                    liTabPaymentDetails.Text = GetLocalResourceObject("lbl_TabReceiptDetails")
                End If
            End If

            Dim rblPayee As RadioButtonList = CType(PayClaim_ctrl.FindControl("rblPayee"), RadioButtonList)
            Dim txtParty As TextBox = CType(PayClaim_ctrl.FindControl("txtParty"), TextBox)
            If Session(CNMode) = Mode.SalvageClaim Or Session(CNMode) = Mode.TPRecovery Or Session(CNMode) = Mode.PayClaim Then
                If rblPayee.SelectedValue = "1" And txtParty.Text IsNot Nothing And txtParty.Text <> "" Then
                    hfRememberTabs.Value = "2"
                End If
            End If
        End Sub

        ''' <summary>
        ''' To Validate all preconditions for WPR85 - Automatic cashlist generation for Salavage and TP Recovery
        ''' </summary>
        ''' <param name="source"></param>
        ''' <param name="args"></param>
        ''' <remarks></remarks>
        Protected Sub cvMediaTypeAndDefaultBankAccountForReciept_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles cvMediaTypeAndDefaultBankAccountForReciept.ServerValidate

            If Session(CNMode) = Mode.SalvageClaim Or Session(CNMode) = Mode.TPRecovery Then
                Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                Dim sReturnCode As NexusProvider.OptionTypeSetting
                Dim oQuote As NexusProvider.Quote = CType(Session(CNClaimQuote), NexusProvider.Quote)
                Dim oClaimOpen As NexusProvider.ClaimOpen = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen)

                ''Pass system option for "Automate receipt generation for Salvage/Third Party receipt"
                sReturnCode = oWebService.GetOptionSetting(NexusProvider.OptionType.SystemOption, 5117)

                If sReturnCode IsNot Nothing AndAlso sReturnCode.OptionValue IsNot Nothing Then
                    If sReturnCode.OptionValue = "1" Then
                        Dim sMediaTypeValue As String = CType(CType(CType(PayClaim_ctrl, Controls_PayClaim).FindControl("GISLookup_MediaType"), NexusProvider.LookupList), NexusProvider.LookupList).Value
                        If String.IsNullOrEmpty(sMediaTypeValue) Then
                            args.IsValid = False
                            cvMediaTypeAndDefaultBankAccountForReciept.ErrorMessage = GetLocalResourceObject("vld_MediaTypeRequired").ToString()
                            Exit Sub
                        End If

                        'Get MediaTypeKey from Code
                        Dim sMediaTypeKey As String = GetCodeForKey(NexusProvider.ListType.PMLookup, sMediaTypeValue, "MediaType", False)
                        'Find Bank Account Defaults for Reciepts
                        Dim oBankAccountDefaults As New NexusProvider.BankAccountDefaults
                        oBankAccountDefaults = oWebService.GetDefaultBankAccountWithCurrency(oQuote.ProductCode, Convert.ToInt32(sMediaTypeKey), 2, oQuote.BranchCode)
                        If oBankAccountDefaults.Count = 0 Then
                            args.IsValid = False
                            cvMediaTypeAndDefaultBankAccountForReciept.ErrorMessage = GetLocalResourceObject("vld_NoDefaultBankAccount").ToString()
                            Exit Sub
                        End If


                        Dim iCurrencyMatches As Integer = 0
                        For iCt As Integer = 0 To oBankAccountDefaults.Count - 1
                            If oBankAccountDefaults(iCt).CurrencyCode.Trim.ToUpper = oClaimOpen.CurrencyISOCode.Trim.ToUpper Then
                                iCurrencyMatches += 1
                            End If
                        Next

                        If iCurrencyMatches > 1 Then
                            args.IsValid = False
                            cvMediaTypeAndDefaultBankAccountForReciept.ErrorMessage = GetLocalResourceObject("vld_MoreThanOneDefaultBankAccountForCurrency").ToString()
                            Exit Sub
                        End If

                        If iCurrencyMatches = 0 Then
                            args.IsValid = False
                            cvMediaTypeAndDefaultBankAccountForReciept.ErrorMessage = GetLocalResourceObject("vld_NoDefaultBankAccountForCurrency").ToString()
                            Exit Sub
                        End If

                        Dim oCashListItemReceiptTypes As NexusProvider.LookupListCollection
                        Dim iCashListItemRecieptTypeForClaim As Integer
                        Dim v_sOptionList As System.Xml.XmlElement = Nothing
                        oCashListItemReceiptTypes = oWebService.GetList(NexusProvider.ListType.PMLookup, "CashListItem_Receipt_Type", True, False, , , , v_sOptionList)

                        If oCashListItemReceiptTypes IsNot Nothing Then
                            If oCashListItemReceiptTypes.Cast(Of LookupListItem)().Any(Function(oCashListItemRecieptType) oCashListItemRecieptType.Code.Trim.ToUpper() = "CLAIMRPT") Then
                                iCashListItemRecieptTypeForClaim = iCashListItemRecieptTypeForClaim + 1
                            End If
                        End If
                        If iCashListItemRecieptTypeForClaim = 0 Then
                            args.IsValid = False
                            cvMediaTypeAndDefaultBankAccountForReciept.ErrorMessage = GetLocalResourceObject("vld_NoClaimRecieptType").ToString()
                            Exit Sub
                        End If
                    End If
                End If
            End If
        End Sub
		'' Badimu changes to get the transaction type
		Protected Function GetTransactionType() As String
			Dim sTransactionType As String
			If CType(Session.Item(CNMode), Mode) = Mode.NewClaim Then
						sTransactionType = "NEWCLAIM"
					ElseIf CType(Session.Item(CNMode), Mode) = Mode.EditClaim Then
						sTransactionType = "EDITCLAIM"
					ElseIf CType(Session.Item(CNMode), Mode) = Mode.PayClaim Then
						sTransactionType = "PAYCLAIM"
					ElseIf CType(Session.Item(CNMode), Mode) = Mode.SalvageClaim Then
						sTransactionType = "SALVAGECLAIM"
					ElseIf CType(Session.Item(CNMode), Mode) = Mode.TPRecovery Then
						sTransactionType = "TPRECOVERY"
					Else
						sTransactionType = "VIEW"
			End If
				Return sTransactionType
		End Function
    End Class
End Namespace
