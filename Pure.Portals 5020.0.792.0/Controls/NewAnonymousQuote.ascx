<%@ control language="VB" autoeventwireup="false" inherits="Nexus.Controls_NewAnonymousQuote, Pure.Portals" %>
<div id="NewAnonymousQuote-control">
    <div id="pnlNewQuote" runat="server">
        <asp:Label ID="lblSelectProduct" runat="server" AssociatedControlID="litSelectProduct">
            <asp:Literal ID="litSelectProduct" runat="server" Text="<%$ Resources:lblSelectProduct %>"></asp:Literal></asp:Label>
        <asp:DropDownList ID="ddlProductlst" runat="server" CssClass="field-medium"></asp:DropDownList>
    </div>
    <asp:Button ID="btnNewQuote" runat="server" Text="<%$ Resources:btnNewQuote %>" CssClass="submit"></asp:Button>
</div>
