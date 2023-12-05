<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.TransactionConfirmation, Pure.Portals" enableEventValidation="false" %>

<%@ Register Src="~/Controls/RiskData.ascx" TagName="RiskData" TagPrefix="uc1" %>
<%@ Register Src="~/Controls/ProgressBar.ascx" TagName="ProgressBar" TagPrefix="uc3" %>
<%@ Register Src="~/Controls/Document.ascx" TagName="Document" TagPrefix="uc4" %>
<%@ Register Src="~/Controls/DocumentManager.ascx" TagName="documentmanager" TagPrefix="uc5" %>
<asp:Content ID="cntMainBody" runat="server" ContentPlaceHolderID="cntMainBody">
    <div id="secure_TransactionConfirmation">
        <uc3:ProgressBar ID="ucProgressBar" runat="server"></uc3:ProgressBar>
        <div class="grey-200">
            <div class="text-center">
                <h1 class="text-shadow no-margin text-4x p-v-lg">
                    <span class="text-xl font-bold text-success m-t-lg block">
                        <asp:Label ID="lblTransactionHeading" runat="server" Text="<%$ Resources:lbl_Transaction_heading %>" />
                    </span>
                </h1>
                <h4 class="h4 m-v-lg">
                    <asp:Literal ID="lblTransactionText" runat="server" />
                    <asp:Literal ID="LblOrderID" runat="server" />
                    <asp:Literal ID="lblMTAPremiumReturn" runat="server" />
                </h4>
                <p class="h4 m-v-lg text-u-c font-bold">
                    <uc1:RiskData ID="ucRiskData" runat="server" />
                </p>
                <%--<div class="p-v-lg">
                    <asp:Label ID="lblTransactionSubHeading" CssClass="font-bold" runat="server" Text="<%$ Resources:lbl_Transaction_Sub_heading %>" />
                </div>--%>
            </div>
        </div>
    </div>
</asp:Content>
