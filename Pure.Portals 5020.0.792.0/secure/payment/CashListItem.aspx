<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.secure_payment_CashListItem, Pure.Portals" validaterequest="false" enableEventValidation="false" %>

<%@ Register Src="~/Controls/CashListItem.ascx" TagName="CashListItem" TagPrefix="uc1" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="secure_payment_CashListItem">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <uc1:CashListItem ID="PayNow_CashListItem" runat="server"></uc1:CashListItem>
    </div>
</asp:Content>
