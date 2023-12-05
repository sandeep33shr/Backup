<%@ page language="VB" autoeventwireup="false" inherits="Nexus.Modal_PlanTransactions, Pure.Portals" masterpagefile="~/default.master" enableEventValidation="false" %>

<%@ Register Src="~/Controls/PlanTransactions.ascx" TagName="PlanTransactions" TagPrefix="uc1" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <uc1:PlanTransactions ID="ucPlanTransactions" runat="server" />
</asp:Content>
