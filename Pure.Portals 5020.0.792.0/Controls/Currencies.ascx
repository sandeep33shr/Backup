<%@ control language="VB" autoeventwireup="false" inherits="Nexus.Controls_Currencies, Pure.Portals" %>
<div id="Controls_Currencies">
    <asp:UpdatePanel ID="CurrencyUpdate" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:DropDownList ID="ddlCurrencylst" AutoPostBack="true" runat="server"></asp:DropDownList>
        </ContentTemplate>
    </asp:UpdatePanel>
    <nexus:ProgressIndicator ID="upCurrencies" OverlayCssClass="updating" AssociatedUpdatePanelID="CurrencyUpdate" runat="server">
        <ProgressTemplate>
        </ProgressTemplate>
    </nexus:ProgressIndicator>
</div>
