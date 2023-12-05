<%@ page language="VB" autoeventwireup="false" inherits="Nexus.Modal_PlanCancel, Pure.Portals" masterpagefile="~/default.master" enableEventValidation="false" %>

<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">

    <script type="text/javascript" language="javascript">
        function RedirectToPolicyCancel(sMessage) {
            var IsConfirm;

            IsConfirm = window.confirm(sMessage);

            if (IsConfirm) {

                self.parent.CheckResponseAndRedirect(IsConfirm);
            }
            else {


                __doPostBack('RedirectFinancePlan', 'RedirectFinancePlan');

            }
        }
    </script>
    <asp:ScriptManager runat="server"></asp:ScriptManager>
    <div id="Modal_PlanCancel">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Label ID="lblPlanCancel" runat="server" Text="<%$ Resources:lbl_PlanCancel %>"></asp:Label>
                </h1>
            </div>
            <div class="card-body clearfix">
                <div class="form-horizontal">
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label runat="server" ID="lblPlanReason" Text="<%$ Resources:lbl_PlanReason %>" AssociatedControlID="ddlCancelReason" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <NexusProvider:LookupList ID="ddlCancelReason" runat="server" DataItemValue="Code" DataItemText="Description" Sort="ASC" ListType="PMLookup" ListCode="PFPREMIUMFINANCE_CANCEL_REASON" DefaultText="<%$ Resources:lbl_None %>" CssClass="field-medium form-control"></NexusProvider:LookupList>
                        </div>
                    </div>
                </div>
                <div>
                    <asp:Label runat="server" CssClass="list-group-item md-whiteframe-z0 error b-l-3x" ID="lblConfirmMessage" Text="<%$ Resources:lbl_ConfirmMessage %>"></asp:Label>
                </div>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnCancel" runat="server" Text="<%$ Resources:btnCancel %>" OnClientClick="javascript:self.parent.tb_remove();" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnOk" runat="server" Text="<%$ Resources:btnOk %>" SkinID="btnPrimary"></asp:LinkButton>
                
            </div>
        </div>
        <asp:ValidationSummary ID="ValidationSummary" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" runat="server" CssClass="validation-summary"></asp:ValidationSummary>
    </div>
</asp:Content>
