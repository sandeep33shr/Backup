<%@ page language="VB" autoeventwireup="false" masterpagefile="~/default.master" inherits="Nexus.Modal_FindDocumentTemplates, Pure.Portals" enableEventValidation="false" %>

<%@ Register Src="~/Controls/FindDocumentTemplates.ascx" TagName="FindDocumentTemplates" TagPrefix="uc1" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="Modal_FindDocumentTemplates">
                <uc1:FindDocumentTemplates ID="ucFindDocumentTemplates" runat="server"></uc1:FindDocumentTemplates>
    </div>
</asp:Content>
