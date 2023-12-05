<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.secure_payment_CashListItems, Pure.Portals" enableEventValidation="false" %>

<%@ Register Src="~/Controls/CashListItems.ascx" TagName="CashListItems" TagPrefix="uc1" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">

    <script language="javascript" type="text/javascript">
        function CloseCashListItems() {
            tb_remove();
        }
    </script>
    <div id="secure_payment_CashListItems">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <uc1:CashListItems ID="CashListItems" runat="server"></uc1:CashListItems>
    </div>
</asp:Content>
