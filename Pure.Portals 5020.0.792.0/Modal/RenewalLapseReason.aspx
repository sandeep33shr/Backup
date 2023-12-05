<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.Modal_RenewalLapseReason, Pure.Portals" title="Renewal Lapse Reason" enableEventValidation="false" %>

<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="Modal_RenewalLapseReason">
        <div class="card">
            <div class="card-body clearfix">
                <div class="form-horizontal">
                    <legend>
                        <asp:Label ID="lblReason" runat="server" Text="<%$ Resources:lbl_ReasonHeading %>"></asp:Label></legend>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblLapseReason" runat="server" AssociatedControlID="RenewalReasonDescription" Text="<%$ Resources:lbl_LapseReason %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <NexusProvider:LookupList ID="RenewalReasonDescription" runat="server" DataItemValue="Code" DataItemText="Description" Sort="ASC" ListType="PMLookup" ListCode="Lapsed_Reason" DefaultText="(Please Select)" CssClass="field-medium form-control"></NexusProvider:LookupList>
                        </div>
                        <asp:RequiredFieldValidator ID="RqdLapseReason" runat="server" InitialValue="" ControlToValidate="RenewalReasonDescription" ErrorMessage="<%$ Resources:lbl_ErrMsg_LapseReason %>" Display="none" SetFocusOnError="true" ValidationGroup="RenewalReasonGroup" Enabled="true"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnLapse" runat="server" Text="<%$ Resources:btn_Lapse %>" ValidationGroup="RenewalReasonGroup" SkinID="btnPrimary"></asp:LinkButton>
            </div>

        </div>
        <asp:ValidationSummary ID="ValidationSummary" ShowSummary="true" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" runat="server" ValidationGroup="RenewalReasonGroup" CssClass="validation-summary"></asp:ValidationSummary>
    </div>
</asp:Content>
