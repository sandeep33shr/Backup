<%@ page language="VB" autoeventwireup="false" inherits="Nexus._Error, Pure.Portals" masterpagefile="~/default.master" enableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <ajaxToolkit:ToolkitScriptManager runat="server" ID="ajaxScriptManager" EnablePartialRendering="true" CombineScripts="false"></ajaxToolkit:ToolkitScriptManager>
    <div id="Error">
        <div class="grey-200 bg-big">
            <div class="">
                <asp:Panel ID="pnlError" runat="server" DefaultButton="btnBack" CssClass="text-center">
                    <h1 class="text-shadow no-margin text-white text-3x p-v-lg">
                        <span class="text-2x font-bold block text-danger">
                            <i class="fa fa-warning" aria-hidden="true"></i>
                            <asp:Literal ID="lblErrorHeader" runat="server" Text="error" EnableViewState="false" />
                        </span>
                    </h1>
                   <p class="h4 m-v-lg text-black">
                        <asp:Literal ID="ltError" runat="server" Text="" />
                    </p>
                </asp:Panel>
                <ajaxToolkit:CollapsiblePanelExtender ID="cpeErrorDetail" runat="Server" TargetControlID="pnlErrorDetail"
                    CollapsedSize="0" Collapsed="True" AutoCollapse="False" AutoExpand="False"
                    ScrollContents="True" TextLabelID="lblErrorDetail" ExpandedText="<%$ Resources:lbl_HideError%>" CollapsedText="<%$ Resources:lbl_ShowError%>"
                     ImageControlID="imgExpandCollapse" ExpandedImage="~/images/ribbon-hide.png" CollapsedImage="~/images/ribbon-show.png"
                     ExpandControlID="pnlErrorDetailTitle" CollapseControlID="pnlErrorDetailTitle"
                    ExpandDirection="Vertical" ExpandedSize="430" />
                <div class="panel panel-card m-b-md">
                    <asp:Panel ID="pnlErrorDetailTitle" runat="server" CssClass="panel-heading grey-50 p-sm b-b b-light">
                        <h5 class="no-margin font-bold text-danger">
                            <asp:Image ID="imgExpandCollapse" runat="server" />
                            <asp:Label ID="lblErrorDetail" runat="server"></asp:Label>
                        </h5>
                    </asp:Panel>
                    <asp:Panel ID="pnlErrorDetail" runat="server" CssClass="panel-body p">
                        <asp:Literal ID="ltErrorDetail" runat="server" Text="" />
                    </asp:Panel>
                </div>
                <div id="divSubmitArea" runat="server" class="text-center p-v-lg">
                    <asp:LinkButton ID="btnBack" CssClass="md-btn red md-raised p-h-lg" TabIndex="2" runat="server" Text="<%$ Resources:lbl_btnBack%>" />
                    <asp:LinkButton ID="btnEmailError" CssClass="md-btn red md-raised p-h-lg" TabIndex="3" Visible="false" runat="server" Text="<%$ Resources:lbl_btnSendEmail%>" />
                </div>
            </div>
        </div>

</asp:Content>
