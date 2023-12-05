<%@ page language="VB" autoeventwireup="false" inherits="Nexus.Modal_Payment, Pure.Portals" masterpagefile="~/default.master" enableviewstate="false" enableEventValidation="false" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">

    <script language="javascript" type="text/javascript">
        function CloseFindAccount() {
            tb_remove();
        }
    </script>
    <div id="Modal_Payment">
        <div class="card">
            <div id="Div1" class="card-body clearfix" runat="server">
                <div class="form-horizontal">
                    <legend>
                        <asp:Label runat="server" ID="lblFindClient" Text="<%$ Resources:lbl_Heading_Payment %>"></asp:Label>
                    </legend>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblEnterPaymentAmount" runat="server" AssociatedControlID="txtEnterPaymentAmount" Text="<%$ Resources:lblEnterPaymentAmount %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtEnterPaymentAmount" TabIndex="1" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnCancel" SkinID="btnSecondary" runat="server" TabIndex="5" Text="<%$ Resources:btnCancel %>"></asp:LinkButton>
                <asp:LinkButton ID="btnOk" SkinID="btnPrimary" runat="server" TabIndex="5" Text="<%$ Resources:btnOk %>"></asp:LinkButton>

            </div>
        </div>
    </div>
</asp:Content>
