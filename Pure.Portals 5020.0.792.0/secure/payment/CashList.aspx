<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.secure_payment_CashList, Pure.Portals" enableEventValidation="false" %>

<%@ Register Src="~/Controls/CashList.ascx" TagName="CashList" TagPrefix="uc1" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="secure_payment_CashList">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <uc1:CashList ID="PayNow_CashList" runat="server"></uc1:CashList>
    </div>
</asp:Content>
