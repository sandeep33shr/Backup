<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.FinancePlanDetails, Pure.Portals" enableeventvalidation="false" %>

<%@ Register assembly="Pure.Portals"  TagPrefix="Nexus" Namespace="Nexus" %>
<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<%@ Register Src="~/Controls/PFPlanDetails.ascx" TagName="PlanDetails" TagPrefix="FinancePlan" %>
<%--<%@ Register Src="~/controls/PFClientInfo.ascx" TagName="ClientInformation" TagPrefix="FinancePlan" %>--%>
<%@ Register Src="~/controls/BankAccountDetails.ascx" TagName="BankDetails" TagPrefix="FinancePlan" %>
<%@ Register Src="~/Controls/CreditCardDetails.ascx" TagName="CreditCardDetails" TagPrefix="FinancePlan" %>
<%@ Register Src="~/Controls/InstallmentDetails.ascx" TagName="Instalments" TagPrefix="FinancePlan" %>
<%@ Register Src="~/Controls/AddTaskButton.ascx" TagName="AddTaskButton" TagPrefix="FinancePlan" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">

    <script type="text/javascript" language="javascript">

        function CheckResponseAndRedirect(response) {

            document.getElementById('<%=hvConfirmationResponse.ClientId %>').value = response;
            __doPostBack('Policy', 'load');
        }

        function isInteger(e) {
            var key = window.event ? e.keyCode : e.which;
            var keychar = String.fromCharCode(key);
            reg = /\d/;
            return reg.test(keychar);
        }

        function ConfirmBeforePlanHold(sMessage) {
            var bShowMsg = false;
            $("form input:checkbox").each(function () {
                var $this = $(this);
                if ($this.is(":checked")) {
                    var chkId = $this.attr("id");
                    if(chkId != undefined){
                        if (chkId.indexOf("chkDDCancelled") > 0) { //if chkDDCancelled is checked show msg
                            bShowMsg = true;
                        }
                        else if (chkId.indexOf("chkCCCancelled") > 0) { //if chkCCCancelled is checked show msg
                            bShowMsg = true;
                        }
                    }
                }
            });

            if (bShowMsg) {
                var IsConfirm;
                IsConfirm = window.confirm(sMessage);
                if (IsConfirm) {
                    return true;
                }
                else {
                    return false;
                }
            }
            else {
                return true;
            }
        }

        function DeleteConfirmation(sMessage) {
            var IsConfirm;

            IsConfirm = window.confirm(sMessage);
            if (IsConfirm)
                return true;
            else
                return false;
        }

        function ReleaseConfirmation(sMessage) {
            var IsConfirm;
            IsConfirm = window.confirm(sMessage);
            if (IsConfirm)
                return true;
            else
                return false;
        }


        function tb_updated(postbackargument, postbacktarget) {

            tb_remove();
            __doPostBack(postbackargument, postbacktarget);

        }

        function tb_updatedEditMode(postbackargument, postbacktarget) {
            tb_remove();
            __doPostBack(postbackargument, postbacktarget);

        }


        function tb_updatedWithAlert(postbackargument, postbacktarget, message) {
            if (message != null)
                alert(message);
            tb_remove();
            __doPostBack(postbackargument, postbacktarget);

        }

        function RedirecttoFindTransactions() {
            tb_remove();
            __doPostBack("FindTransactions", "FindTransactions");
        }

        function RedirectToCashList() {
            tb_remove();
            __doPostBack("CashList", "CashList");

        }

        function ShowBankAccountTab() {

            $('#tabBankDetails').show();
            $('#tabBankDetails').click();


        }

        function ShowCreditCardTab() {

            $('#tabCreditCardDetails').show();
            $('#tabCreditCardDetails').click();


        }

    </script>
    <asp:ScriptManager ID="smFinancePlanDetails" runat="server"></asp:ScriptManager>
    <asp:HiddenField ID="hvConfirmationResponse" runat="server"></asp:HiddenField>
    <div id="secure_FinancePlanDetails">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="lblPageHeader" runat="server" Text="<%$ Resources:lblHeader%>"></asp:Literal>
                </h1>
            </div>
            <div class="card-body clearfix">
                <div class="md-whiteframe-z0 bg-white">
                    <ul class="nav nav-lines nav-tabs b-danger">
                        <li class="active"><a href="#tab-PlanDetails" data-toggle="tab" aria-expanded="true">Plan Details</a></li>
                        <li id="liBankDetails"><a href="#tab-BankDetails" id="tabBankDetails" data-toggle="tab" aria-expanded="true">Bank Details</a></li>
                        <li id="liCCDetails"><a href="#tab-CCDetails" id="tabCreditCardDetails" data-toggle="tab" aria-expanded="true">Credit Card Details</a></li>
                        <li><a href="#tab-Instalments" data-toggle="tab" aria-expanded="true">Instalments</a></li>
                    </ul>
                    <div class="tab-content clearfix p b-t b-t-2x">
                        <div id="tab-PlanDetails" class="tab-pane animated fadeIn active" role="tabpanel">
                            <FinancePlan:PlanDetails ID="fpPlanDetails" runat="server"></FinancePlan:PlanDetails>
                        </div>
                        <div id="tab-BankDetails" class="tab-pane animated fadeIn" role="tabpanel">
                            <FinancePlan:BankDetails ID="fpBankDetails" runat="server"></FinancePlan:BankDetails>
                        </div>
                        <div id="tab-CCDetails" class="tab-pane animated fadeIn" role="tabpanel">
                            <FinancePlan:CreditCardDetails ID="fpCreditCardDetails" runat="server"></FinancePlan:CreditCardDetails>
                        </div>
                        <div id="tab-Instalments" class="tab-pane animated fadeIn" role="tabpanel">
                            <FinancePlan:Instalments ID="fpInstalments" runat="server"></FinancePlan:Instalments>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnBack" runat="server" Visible="false" PostBackUrl="PremiumFinancePlan.aspx?Type=EditPlan" Text="<%$ Resources:btn_Back %>" CausesValidation="False" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnDelete" runat="server" Text="<%$ Resources:btn_Delete %>" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnCancelPlan" runat="server" Text="<%$ Resources:btn_CancelPlan %>" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnReprint" runat="server" Text="<%$ Resources:btn_Reprint %>" SkinID="btnPrimary"></asp:LinkButton>
                <asp:LinkButton ID="btnSettle" runat="server" Text="<%$ Resources:btn_Settle %>" SkinID="btnPrimary"></asp:LinkButton>
                <asp:LinkButton ID="btnMTA" runat="server" Text="<%$ Resources:btn_MTA %>" SkinID="btnPrimary"></asp:LinkButton>
                <asp:LinkButton ID="btnRelease" runat="server" Text="<%$ Resources:btn_Release %>" CausesValidation="True" SkinID="btnPrimary"></asp:LinkButton>
                <asp:LinkButton ID="btnSave" runat="server" Text="<%$ Resources:btn_Save %>" SkinID="btnPrimary"></asp:LinkButton>
                <FinancePlan:AddTaskButton ID="ucAddTask" runat="server"></FinancePlan:AddTaskButton>
            </div>
        </div>
        <asp:ValidationSummary ID="ValidationSummary" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" runat="server" CssClass="validation-summary"></asp:ValidationSummary>
    </div>
</asp:Content>
