<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.secure_payment_PayNow, Pure.Portals" title="Untitled Page" enableeventvalidation="false" %>

<%@ Register Src="~/Controls/CashList.ascx" TagName="CashList" TagPrefix="uc1" %>
<%@ Register Src="~/Controls/CashListItem.ascx" TagName="CashListItem" TagPrefix="uc1" %>

<asp:Content ID="cntProgressBar" ContentPlaceHolderID="cntProgressBar" runat="Server">
</asp:Content>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="secure_payment_PayNow">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <uc1:CashList ID="PayNow_CashList" runat="server"></uc1:CashList>
        <uc1:CashListItem ID="PayNow_CashListItem" runat="server"></uc1:CashListItem>
    </div>
</asp:Content>
