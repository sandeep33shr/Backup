<%@ control language="VB" autoeventwireup="false" inherits="Nexus.Controls_PremiumConfirmation, Pure.Portals" enableviewstate="false" %>
    <script type="text/javascript" language="javascript">
        function ConfirmAction(path,msg) {
            if (confirm(msg) == '1') {
                tb_show(null, path , null);
                return false;
            }
            else
                return false;
        }
    </script>
<div id="Controls_PremiumConfirmation">
<asp:Button ID="btnPremiumConfirmation" runat="server" CausesValidation="false" Text="<%$ Resources:lbl_PremiumConfirmation %>"></asp:Button>
</div> 
