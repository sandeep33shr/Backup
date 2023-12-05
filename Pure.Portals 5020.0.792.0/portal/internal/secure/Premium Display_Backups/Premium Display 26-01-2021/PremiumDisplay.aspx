<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" CodeFile="PremiumDisplay.aspx.vb" inherits="Nexus.secure_PremiumDisplay" enablesessionstate="True" title="Untitled Page" enableEventValidation="false" %>

<%@ Register Src="~/Controls/ProgressBar.ascx" TagName="ProgressBar" TagPrefix="uc3" %>
<%@ Register Src="~/Controls/RiskData.ascx" TagName="SummaryCoverCntrl" TagPrefix="uc1" %>
<%@ Register Src="~/Controls/Navigator.ascx" TagName="Navigator" TagPrefix="uc4" %>
<%@ Register Src="../Controls/MultiRisk.ascx" TagName="MultiRisk" TagPrefix="uc5" %>
<%@ Register Src="~/Controls/AddTaskButton.ascx" TagName="AddTask" TagPrefix="uc6" %>
<%@ Register Src="~/Controls/PolicyDetails.ascx" TagName="PolicyDetails" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/Document.ascx" TagName="Document" TagPrefix="uc4" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Controls/FinancePlan.ascx" TagName="Installment" TagPrefix="uc8" %>
<%@ Register Src="~/Controls/PolicyHeader.ascx" TagName="PolicyHeader" TagPrefix="uc5" %>
<%@ Register Src="~/Controls/Instalments.ascx" TagName="Instalments" TagPrefix="uc9" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMainBody" runat="Server">

    <script type="text/javascript">
        function GetAccountType(rbClient, rbAgent) {
            if (rbClient == true) {
                document.getElementById('<%=hSelectedAccount.ClientID%>').value = "Client"
            } else {
                document.getElementById('<%=hSelectedAccount.ClientID%>').value = "Agent"
            }
            __doPostBack('', 'GetAccount')
        }
        function closethickbox() {
            tb_remove();
        }

        $(document).ready(function () {
            var session = '<%= HttpContext.Current.Session("COMMISSION_WARNING")%>';
            if (session == null || session == '') {

                document.getElementById('<%= lblCommAmendWarning.ClientID%>').style.display = "none";
                document.getElementById('<%= lblTaxAmendWarning.ClientID%>').style.display = "none";
            }
            else {
                if (session.indexOf("CommissionAmend") > -1) {

                    document.getElementById('<%= lblCommAmendWarning.ClientID%>').style.display = "block";
                }
                else {
                    document.getElementById('<%= lblCommAmendWarning.ClientID%>').style.display = "none";
                }

                if ((session.indexOf("TaxAmend") > -1) || (session.indexOf("TaxGroupAmend") > -1)) {

                    document.getElementById('<%= lblTaxAmendWarning.ClientID%>').style.display = "block";
                }
                else {
                    document.getElementById('<%= lblTaxAmendWarning.ClientID%>').style.display = "none";
                }
            }
			
			
			//---------------------------------------------------------------
			//Updated Display for Premium Totals (Derick de Klerk 2019/06/11)
			//---------------------------------------------------------------
			$('#hiddenPaymentOptions').find('ul').each(function(){
				var ulVal = $(this).find('li:first').text().toLowerCase();
				if ($.trim(ulVal) == 'invoice'){
					$(this).find('li:not(:first-child)').each(function(){
						var line = $.trim($(this).text());
						var items = line.split(':');
						if (items.length > 1)
						{
							var caption = items[0];
							var amount = items[1];
							if (caption.toLowerCase().indexOf('net') != -1)
							{
								$('#txtNetPrem').html(caption);
								$('#valNetPrem').html(amount);
							}
							if (caption.toLowerCase().indexOf('ipt') != -1)
							{
								$('#txtIPTPrem').html(caption);
								$('#valIPTPrem').html(amount);
							}
							if (caption.toLowerCase().indexOf('gross') != -1)
							{
								$('#txtGrossPrem').html(caption);
								$('#valGrossPrem').html(amount);
							}
						}
					});
				}
			});
			
			//---------------------------

        });

        //This function will call Unmarked alert only when there is quote marked for selection   
        function UnMarkedConfirmation() {
            IsUnconfirm = confirm("Warning, this quote is marked for collection. If you continue, the quote will be removed from the collection process.");
            return IsUnconfirm;
        }

        function CheckStatus(oSrc, args) {
            var IsCancelationMTA = document.getElementById('<%=hdnIsCancelationMTA.ClientID%>');
            var grid = document.getElementById('ctl00_cntMainBody_MultiRisk_grdvRisk');  //Retrieve the grid

            if (grid != null) {
                var inputs = grid.getElementsByTagName("input"); //Retrieve all the input elements from the grid
                var isValid = false;
                if (IsCancelationMTA.value != 1) {

                    for (var i = 0; i < inputs.length; i += 1) {
                        if (inputs[i].type === "checkbox") { //If the current element's type is checkbox
                            if (inputs[i].checked === true) { //If the current checkbox is true, then atleast one checkbox is ticked, so break the loop
                                isValid = true;
                                args.IsValid = true;
                                return true;
                                break;
                            }
                        }
                    }
                    if (!isValid) {
                        args.IsValid = false;
                        return false;
                    }
                }
                else {
                    args.IsValid = true;
                }
            }
        }

        //take the confirmation if user has amended(using Edit\Requote) the policy in renewal
        function ConfirmRenewalTermsAcceptence() {
            var IsConfirm = confirm("Confirm renewal terms have been Accepted \n as clicking OK will make policy live.");
            return IsConfirm;
        }
        function setPolicyNumber(sPolicyNo) {
            document.getElementById('<%=hPolicyNo.ClientID%>').value = sPolicyNo;
            __doPostBack('', 'WritePolicy')
        }


        function DisplayMessage(sender, args) {
            var answer = "The &#8216;Who Contacted You&#8217; user has been deleted, to issue this quote please edit the quote and select a valid user.";
            alert(answer)
            return false;
        }

        function ShowHideInstalmentTab(bStatus) {           
            if (bStatus == true) {
                $('#tbInstallments').show();               
                if (document.getElementById('<%=hdnTransactionType.ClientID%>').value != "MTA" &&
                    document.getElementById('<%=hdnTransactionType.ClientID%>').value != "REN") {
                    $('#tbInstallments').click();
                }
                document.getElementById('<%=hdnRememberTab.ClientID%>').value = "1";
            }
            else {               
                $('#tbInstallments').hide();
                $('#tbDetails').click();
                document.getElementById('<%=hdnRememberTab.ClientID%>').value = "0";
            }
        }

        function ValidateInstalmentPlan(sender, args) {
            var rdoPaymentOptions = document.getElementById('ctl00_cntMainBody_rblPaymentMethods').getElementsByTagName("tr");
            var isPaymentTypeInstalment = false;
            for (var vCount = 0; vCount < rdoPaymentOptions[0].cells.length; vCount++) {
                var paymentMethod = rdoPaymentOptions[0].cells[vCount].getElementsByTagName("input")[0];
                if (paymentMethod.value.indexOf('instalment') > -1 || paymentMethod.value.indexOf('Direct Debit') > -1) {
                    isPaymentTypeInstalment = rdoPaymentOptions[0].cells[vCount].getElementsByTagName("input")[0].checked;
                    break;
                }
            }
            var firstInstallment = document.getElementById("ctl00_cntMainBody_Instalments_txtFirstInstalment");
            if (firstInstallment == null && isPaymentTypeInstalment) {
                sender.errormessage = "No Instalment quote is available.";
                args.IsValid = false;

            }
            else if (firstInstallment != null) {
                firstInstallment = parseInt(document.getElementById("ctl00_cntMainBody_Instalments_txtFirstInstalment").value);
                if (firstInstallment < 0) {
                    sender.errormessage = "Since this is a negative premium transaction so cannot proceed with instalment.";
                    args.IsValid = false;
                } else {
                    args.IsValid = true;
                }
            } else {
                args.IsValid = true;
            }
        }

        $(document).ready(function () {
            $("input[id='ctl00_cntMainBody_rblPaymentMethods_3']").click(function () {
                $.blockUI({ message: null });
            });
        });

        function MTACancellationConfirmation(sender, args) {
            var answer = confirm("Cancel This MTA?")
            if (answer) {
                return true;
            }
            else {
                return false;
            }
        }

        //        }

        function RenewalWarning() {
            var sConfirmPolicyUnderRenewal = '<%= sConfirmPolicyUnderRenewal %>';
            alert(sConfirmPolicyUnderRenewal);
        }
        function ConfirmPaymentChangeOnRenewalQuote() {
            var sPaymentOption = '<%= SelectedPaymentOptionType%>';
            if (sPaymentOption != '' && sPaymentOption.toUpperCase().indexOf('PREMIUMFINANCE') < 0) {
                var IsConfirm = confirm("You have changed the payment plan from instalments, the old instalment plan will be deleted at renewal acceptance.\n\rDo you wish to continue?");
                return IsConfirm;
            }
            return true;
        }


        //This function will show warning message if user wants to cancel live instalment Policy.  
        function CancelLiveInstalmentPolicy() {
            var IsConfirmCancel = confirm("There is live plan attached with the policy which will not be cancelled during policy cancellation. Do you wish to proceed?");
           return IsConfirmCancel;
        }


        $(document).ready(function () {
            var taxGrid = $("#ctl00_cntMainBody_SummaryCoverCntrl_ctl00_EditTaxCntrl_grdvRiskTax");
            if (taxGrid != null) {
                var gridRows = document.getElementById("ctl00_cntMainBody_SummaryCoverCntrl_ctl00_EditTaxCntrl_grdvRiskTax").getElementsByTagName("tr");
                var totalTaxValue = 0;
                if (gridRows.length > 0) {
                    for (rowCount = 1; rowCount < gridRows.length; rowCount++) {
                        var cellValue = $(gridRows[rowCount]).find("td:eq(4) input[type='text']").val().replace(',', '').replace('&nbsp;', '');
                        if (cellValue != '&nbsp;' && cellValue != '' && cellValue.length > 0) {

                            totalTaxValue = parseFloat(totalTaxValue) + parseFloat(cellValue);
                        }
                    }
                }

                if ($("#<%=hdnPolicyFee.ClientID%>").val()!= '' && $("#<%=hdnPolicyFee.ClientID%>").val() > 0)
                {
                    totalTaxValue = totalTaxValue + parseFloat($("#<%=hdnPolicyFee.ClientID%>").val());
                }

                totalTaxValue = parseFloat(totalTaxValue, 10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").toString();
                if ($("#ctl00_cntMainBody_rblPaymentMethods_0").next('label').children('ul').find('li:eq(2)') != 'undefined') {
                    $("#ctl00_cntMainBody_rblPaymentMethods_0").next('label').children('ul').find('li:eq(2)').html('Premium IPT : $' + totalTaxValue);
                }
            }
        });

        function RememberTabClick(tab) {
            document.getElementById('<%=hdnRememberTab.ClientID%>').value = tab;
        }
       
    </script>

    <cc1:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="secure_PremiumDisplay">
        <asp:HiddenField ID="hdnfRenewalStatus" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="hdnDefaultPaymentMethod" runat="server"></asp:HiddenField>
        <asp:HiddenField ID="hdnTransactionType" runat="server" />
        <asp:HiddenField ID="hdnPolicyFee" runat="server" />
        <uc3:ProgressBar ID="ucProgressBar" runat="server"></uc3:ProgressBar>
        <uc5:PolicyHeader ID="ucPolicyHeader" runat="server"></uc5:PolicyHeader>
        <div class="tab-content p b-a no-b-t bg-white m-b-md">
            <div class="card">
                <div class="card-heading">
                    <h1>
                        <asp:Literal ID="lblSummaryheadertitle" runat="server" Text="<%$ Resources:lbl_Summary_headertitle%>"></asp:Literal></h1>
                </div>
                <div class="card-body clearfix">
                    <div class="md-whiteframe-z0 bg-white">
                        <ul class="nav nav-lines nav-tabs b-danger">
                            <li id="litbDetails" runat="server" class="active"><a href="#tabdetails" id="tbDetails" data-toggle="tab" aria-expanded="true" onclick="RememberTabClick('0');">
                                <asp:Literal ID="liDetails" runat="server" Text="<%$ Resources:lt_liDetails %>"></asp:Literal></a></li>
                            <li id="liInstalments" runat="server"><a href="#tabInstalments" id="tbInstallments" data-toggle="tab" aria-expanded="true" onclick="RememberTabClick('1');">
                                <asp:Literal ID="ltInstalments" runat="server" Text="<%$ Resources:lt_Instalments %>"></asp:Literal></a></li>
                        </ul>
                        <div class="tab-content clearfix p b-t b-t-2x">
                            <div id="tabdetails" class="tab-pane animated fadeIn active" role="tabpanel" runat="server" clientidmode="Static">
                                <asp:Label ID="lblPageheader" Font-Bold="true" CssClass="text-dark dk" runat="server" Text="<%$ Resources:lbl_quote_page_header%>"></asp:Label>
                                <asp:Label CssClass="error" ID="lblNoChangePremium" Visible="false" runat="server" Text="<%$ Resources:lblNoChangePremium%>"></asp:Label>
                                <uc7:PolicyDetails ID="ucPolicyDetails" runat="server"></uc7:PolicyDetails>
                                <asp:Literal ID="lblRenewalMessage" Visible="false" Text="<%$ Resources:lbl_Renewal_Message%>" runat="server"></asp:Literal>
                                <asp:Literal ID="lblTotalPremium" runat="server"></asp:Literal>
                                <asp:Literal ID="lblPremium" runat="server"></asp:Literal>
                                <asp:UpdatePanel ID="updPremiumDisplay" runat="server" ChildrenAsTriggers="true">
                                    <ContentTemplate>
                                        <asp:Label ID="lblPremiumDisplay" runat="server" Font-Bold="true" AssociatedControlID="lblPremiumValue">
                                            <asp:Literal ID="litPremiumDisplay" runat="server" Text="<%$ Resources:lbl_PremiumDisplay %>"></asp:Literal></asp:Label>
                                        <asp:Label ID="lblPremiumValue" runat="server"></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <uc5:MultiRisk ID="MultiRisk" runat="server"></uc5:MultiRisk>
                                <uc1:SummaryCoverCntrl ID="SummaryCoverCntrl" runat="server"></uc1:SummaryCoverCntrl>
                                <uc8:Installment ID="InstallementPlan1" Visible="false" runat="server"></uc8:Installment>
                                <asp:Panel ID="pnlPaymentMethods" runat="server">
                                    <div class="card card-secondary no-margin">
                                        <div class="card-heading">
                                            <h4>
                                                <asp:Literal ID="lblPaymentPlan" runat="server" Text="Select Payment Option"></asp:Literal>
                                            </h4>
                                        </div>
                                        <div class="card-body no-padding">
                                            
                                        </div>
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvPaymentMethods" runat="server" ControlToValidate="rblPaymentMethods" Display="none" ErrorMessage="<%$ Resources:lbl_ErrorMsg_PaymentMethods %>"></asp:RequiredFieldValidator>
                                </asp:Panel>
                            </div>
                            <div id="tabInstalments" class="tab-pane animated fadeIn" role="tabpanel" runat="server" clientidmode="Static">
                                <asp:Panel ID="pnlInstalmentsTab" runat="server" Visible="true">
                                    <asp:UpdatePanel ID="updInstalment" runat="server" ChildrenAsTriggers="true">
                                        <ContentTemplate>
                                            <uc9:Instalments ID="Instalments" runat="server"></uc9:Instalments>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    <Nexus:ProgressIndicator ID="piInstalment" OverlayCssClass="updating" AssociatedUpdatePanelID="updInstalment" runat="server">
                                        <progresstemplate>
                                    </progresstemplate>
                                    </Nexus:ProgressIndicator>
                                </asp:Panel>
                            </div>
							<div id="hiddenPaymentOptions" style="display:none;">
								<asp:RadioButtonList ID="rblPaymentMethods" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" AutoPostBack="true" OnSelectedIndexChanged="rblPaymentMethods_SelectedIndexChanged" CssClass="asp-radio">
								</asp:RadioButtonList>
							</div>
							<div id="tabPremBreakdown" style="margin-top:20px;">
								<div class="form-horizontal clear">
									<div class="row">
										<div class="col-sm-6 col-md-4">
											<div class="md-list md-whiteframe-z0 m-b">
												<div class="md-list-item">
													<div class="md-list-item-left circle lt">
														<i class="mdi-action-grade i-24"></i>
													</div>
													<div class="md-list-item-content">
														<h3 id="txtNetPrem" class="text-md">
															</h3>
														<small id="valNetPrem" class="font-thin">
															</small>
													</div>
												</div>
											</div>
										</div>
										<div class="col-sm-6 col-md-4">
											<div class="md-list md-whiteframe-z0 m-b">
												<div class="md-list-item">
													<div class="md-list-item-left circle lt">
														<i class="mdi-action-grade i-24"></i>
													</div>
													<div class="md-list-item-content">
														<h3 id="txtIPTPrem" class="text-md">
															</h3>
														<small id="valIPTPrem" class="font-thin">
															</small>
													</div>
												</div>
											</div>
										</div>
										<div class="col-sm-6 col-md-4">
											<div class="md-list md-whiteframe-z0 m-b">
												<div class="md-list-item">
													<div class="md-list-item-left circle lt">
														<i class="mdi-action-grade i-24"></i>
													</div>
													<div class="md-list-item-content">
														<h3 id="txtGrossPrem" class="text-md">
															</h3>
														<small id="valGrossPrem" class="font-thin">
															</small>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
                        </div>
                    </div>
                </div>
            </div>

            <asp:Panel ID="PanelButton" runat="server">
                <asp:ValidationSummary ID="ValidationSummary1" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" runat="server" CssClass="validation-summary"></asp:ValidationSummary>
                <div class="card-footer">
                    <span class="pull-left">
                        <uc6:AddTask ID="btnAddTask" runat="server"></uc6:AddTask>
                        <asp:Literal ID="lblMessage" runat="server" Visible="false"></asp:Literal>
                    </span>
                    <asp:LinkButton ID="btnCancelMTAQuote" runat="server" Text="<%$ Resources:btnCancelMTAQuote%>" CausesValidation="False" SkinID="btnSecondary"></asp:LinkButton>
                    <asp:LinkButton ID="btnCancel" runat="server" Text="<%$ Resources:btn_Cancel%>" CausesValidation="False" Visible="false" SkinID="btnSecondary"></asp:LinkButton>
                    <asp:LinkButton ID="btnChangePolicy" runat="server" Text="<%$ Resources:btn_ChangePolicy%>" Visible="false" CausesValidation="False" SkinID="btnPrimary"></asp:LinkButton>
                    <asp:LinkButton ID="btnRequote" runat="server" Text="<%$ Resources:btn_Requote%>" CausesValidation="False" SkinID="btnPrimary"></asp:LinkButton>
                    <asp:LinkButton ID="btnBuy" runat="server" Text="<%$ Resources:btn_Buy%>" SkinID="btnPrimary"></asp:LinkButton>
                    <asp:LinkButton ID="btnSaveQuote" runat="server" Text="<%$ Resources:btn_SaveQuote%>" SkinID="btnPrimary"></asp:LinkButton>
                    <asp:LinkButton ID="btnLapse" runat="server" Text="<%$ Resources:btn_LapsePolicy%>" Visible="false" CausesValidation="False" SkinID="btnPrimary"></asp:LinkButton>
                    <asp:LinkButton ID="btnMarkQuoteForCollection" Visible="false" runat="server" Text="<%$ Resources:btn_MarkQuote%>" CausesValidation="False" OnClientClick="return MarkedConfirmation()" SkinID="btnPrimary"></asp:LinkButton>
                    <asp:LinkButton ID="btnPrint" runat="server" Text="<%$ Resources:btn_Print %>" Visible="false" CausesValidation="False" SkinID="btnPrimary"></asp:LinkButton>
                    <uc4:Document ID="Print_Renewaldocument" runat="server" DocumentName="RenewalInvite" PreGenerate="false" Visible="false" Text="<%$ Resources:Print_Renewaldocument %>"></uc4:Document>
                    <asp:LinkButton ID="btnWrite" runat="server" CausesValidation="False" Text="<%$ Resources:btnWrite %>" Visible="false" SkinID="btnPrimary"></asp:LinkButton>
                   
                </div>
            </asp:Panel>
        </div>
        <asp:CustomValidator ID="vldChkStatus" runat="server" Display="None" ClientValidationFunction="CheckStatus" ErrorMessage="<%$ Resources:lbl_Please_Check %>"></asp:CustomValidator><asp:CustomValidator ID="vldChkRenwalDoc" runat="server" Display="None" ErrorMessage="<%$ Resources:btn_vldChkRenwalDoc %>" Enabled="false"></asp:CustomValidator><asp:CustomValidator ID="vldCommissionGreaterThanPremium" runat="server" Display="None" Enabled="false" ErrorMessage="<%$ Resources:lbl_CommissionGreaterThanPremium %>"></asp:CustomValidator><%--WPR VB 64 - Media Type Status--%><asp:CustomValidator ID="vldMediaTypeStatus" runat="server" CssClass="error" ErrorMessage="<%$ Resources:lbl_MediaTypeStatus_Error %>" Display="none"></asp:CustomValidator><asp:HiddenField ID="hdnIsCancelationMTA" runat="server"></asp:HiddenField>
        <asp:CustomValidator ID="vldInstalmentSchemes" runat="server" CssClass="error" ErrorMessage="<%$ Resources:lbl_InstalmentSchemes_Error %>" Display="none"></asp:CustomValidator><asp:CustomValidator ID="vldPaymentMethod" runat="server" CssClass="error" ErrorMessage="<%$ Resources:lbl_ErrorMsg_PaymentMethods %>" Display="none"></asp:CustomValidator><asp:HiddenField ID="hPolicyNo" runat="server"></asp:HiddenField>
        <asp:TextBox ID="hdWriteChoice" runat="server" Style="visibility: hidden"></asp:TextBox>
        <asp:HiddenField ID="hSelectedAccount" runat="server"></asp:HiddenField>
        <asp:CustomValidator ID="vldAgencyCancellation" runat="server" Display="None" CssClass="error" ErrorMessage="<%$ Resources:vldAgencyCancelled %>"></asp:CustomValidator>
         <asp:HiddenField ID="hdnRememberTab" runat="server" Value="-1"></asp:HiddenField>
            <table>
                <tr>
                    <td>
                        <asp:Label ID="lblTaxAmendWarning" runat="server" Text="<%$ Resources:lbl_Warning%>" ForeColor="red"></asp:Label></td>
                    <td>
                        <asp:Label ID="lblCommAmendWarning" runat="server" Text="<%$ Resources:lbl_CommWarning%>" Style="text-align: right" ForeColor="red"></asp:Label></td>
                </tr>
            </table>
        <asp:Table ID="tblDocs" runat="server">
        </asp:Table>
    </div>
</asp:Content>
