<%@ page title="" language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.Modal_PFPlanSettle, Pure.Portals" enableEventValidation="false" %>

<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<%@ Register Src="~/controls/CalendarLookup.ascx" TagName="CalendarLookup" TagPrefix="uc1" %>
<asp:Content ID="Content4" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="Modal_PlanSettlement">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="lblTitle" runat="server" Text="<%$ Resources:lbl_Title %>"></asp:Literal></h1>
            </div>
            <div class="card-body clearfix">
                <div class="list-group-item md-whiteframe-z0 b-l-info b-l-3x text-info-dk">
                    <i class="fa fa-info-circle i-16 m-r-sm"></i>  <asp:Label ID="lblMessage" runat="server" Text="<%$ Resources:lbl_Message %>"></asp:Label>
                </div>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnCancel" runat="server" Text="<%$ Resources:btn_Cancel %>" CausesValidation="true" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnOk" runat="server" Text="<%$ Resources:btn_Ok %>" CausesValidation="true" SkinID="btnPrimary"></asp:LinkButton>
            </div>
        </div>
        <asp:ValidationSummary ID="ValidationSummary" runat="server" DisplayMode="BulletList" ShowSummary="true" HeaderText="<%$Resources:lbl_EditInstalment_ValidationSummary %>" CssClass="validation-summary"></asp:ValidationSummary>

    </div>
</asp:Content>
