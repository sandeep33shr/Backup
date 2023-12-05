<%@ page language="VB" autoeventwireup="false" inherits="Nexus.SelectBranch, Pure.Portals" masterpagefile="~/Default.master" enableviewstate="true" enableEventValidation="false" %>

<%@ Register Src="~/Controls/MultiBranch.ascx" TagName="MultiBranch" TagPrefix="uc1" %>
<asp:Content ID="cntMainBody" runat="server" ContentPlaceHolderID="cntMainBody">
    <div id="SelectBranch">
        <uc1:MultiBranch ID="ucMultiBranch" runat="server"></uc1:MultiBranch>
    </div>
</asp:Content>
