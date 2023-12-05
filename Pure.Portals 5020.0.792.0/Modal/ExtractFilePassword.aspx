<%@ page title="" language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Modal_ExtractFilePassword, Pure.Portals" enableEventValidation="false" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="Modal_ExtractFilePassword">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="lblTitle" runat="server" Text="<%$ Resources:lbl_Title %>" /></h1>
            </div>
            <div class="card-body clearfix">
                <div class="form-horizontal">
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblPassword" runat="server" AssociatedControlID="txtPassword" Text="<%$ Resources:lbl_Password %>" class="col-md-4 col-sm-3" />
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" TabIndex="1" />
                            <br />
                            <asp:Label ID="lblNote" runat="server" Text="<%$ Resources:lbl_Note %>" Font-Size="Small"></asp:Label>
                        </div>
                    </div>
                </div>
                <br />
                <asp:RequiredFieldValidator ID="reqPassword" runat="server" ControlToValidate="txtPassword" SetFocusOnError="true"
                    ErrorMessage="<%$ Resources:err_RqdPassword %>" Display="Dynamic" />
                <asp:CustomValidator ID="custPasswordLength" runat="server" Display="Dynamic" Enabled="true" ControlToValidate="txtPassword"
                    OnServerValidate="custPasswordLength_ServerValidate" SetFocusOnError="true" />
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnCancel" runat="server" TabIndex="3" Text="<%$ Resources:btn_Cancel %>" SkinID="btnSecondary"
                    OnClientClick="self.parent.tb_remove(); return false;" />
                <asp:LinkButton ID="btnOK" runat="server" TabIndex="2" Text="<%$ Resources:btn_ok %>" SkinID="btnPrimary" />
            </div>
        </div>
    </div>
</asp:Content>
