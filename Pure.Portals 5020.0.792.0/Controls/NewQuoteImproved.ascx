<%@ control language="VB" autoeventwireup="false" inherits="Nexus.Controls_NewQuoteImproved, Pure.Portals" %>
     
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
<div id="Controls_NewQuoteImproved">
    <div class="form-inline pull-left">
        <div class="form-group form-group-sm">
            <asp:Label ID="lblSelectProduct" runat="server" AssociatedControlID="ddlProductlst">
                <asp:Literal ID="litSelectProduct" runat="server" Text="<%$ Resources:lblSelectProduct %>" /></asp:Label>
            <asp:DropDownList ID="ddlProductlst" runat="server" CssClass="form-control" AppendDataBoundItems="true">
                <asp:ListItem Enabled="True" Text="(Please Select)" Value=""></asp:ListItem>    
            </asp:DropDownList>
        </div>
        <asp:LinkButton ID="btnNewQuote" runat="server" SkinID="btnPrimary" Text="<%$ Resources:btnNewQuote %>"  ValidationGroup = "ProductList" OnClientClick="return CheckProductSelection();"/>
    </div>
</div>