<%@ control language="VB" autoeventwireup="false" inherits="Nexus.Controls_NewQuote, Pure.Portals" %>
<script type="text/javascript">
    function CheckProductSelection() {
        var objDDL = document.getElementById('<%=ddlProductlst.ClientID%>');
        if (objDDL.options.length <= 0 || objDDL.options[objDDL.selectedIndex].value == '' || objDDL.options[objDDL.selectedIndex].value <= -1) {
            alert('No product is selected.');
            return false;
        }
        return true;
    }
</script>
<div id="Controls_NewQuote">
    <div class="form-inline pull-left">
        <div class="form-group form-group-sm">
            <asp:Label ID="lblSelectProduct" runat="server" AssociatedControlID="ddlProductlst">
                <asp:Literal ID="litSelectProduct" runat="server" Text="<%$ Resources:lblSelectProduct %>"></asp:Literal></asp:Label>
            <asp:DropDownList ID="ddlProductlst" runat="server" CssClass="form-control" AppendDataBoundItems="true">
            </asp:DropDownList>
            <asp:LinkButton ID="btnNewQuote" runat="server" Text="<%$ Resources:btnNewQuote %>" SkinID="btnPrimary" OnClientClick="return CheckProductSelection();"></asp:LinkButton>
        </div>
    </div>
</div>
