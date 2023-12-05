<%@ page language="VB" autoeventwireup="false" inherits="Modal_SendEmail, Pure.Portals" masterpagefile="~/default.master" enableEventValidation="false" %>


<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('.AttachmentContainer > span > label').after('<span class="RemoveAttachement" />');
            $('.RemoveAttachement').click(function () {
                $(this).hide();
                $(this).prev('label').hide().prev('input').removeAttr('checked');
            });
        });
    </script>
    <div id="Modal_SendEmail">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="ltPageHeader" runat="server" Text="<%$ Resources:lblEmailHeader %>"></asp:Literal></h1>
            </div>
            <asp:Panel ID="PnlComposeEmail" runat="server" DefaultButton="btnSendEmail" CssClass="card-body clearfix">
                <div class="form-horizontal">
                    <div class="form-group form-group-sm col-lg-12 col-md-12 col-sm-12">
                        <asp:Label ID="lblEmailTo" runat="server" AssociatedControlID="txtEmailTo" Text="<%$ Resources:lblEmailTo %>" class="col-lg-2 col-md-4 col-sm-3 control-label text-left"></asp:Label>
                        <div class="col-lg-8 col-md-8 col-sm-9">
                            <asp:TextBox ID="txtEmailTo" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator runat="server" ID="rqEmailTo" ControlToValidate="txtEmailTo" Display="None" ErrorMessage="<%$ Resources:rqEmailTo %>" SetFocusOnError="true"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator runat="server" ID="regEmailTo" ValidationExpression="((\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*([,])*)*" ControlToValidate="txtEmailTo" Display="None" ErrorMessage="<%$ Resources:regEmailTo %>" SetFocusOnError="true"></asp:RegularExpressionValidator>
                    </div>
                    <div class="form-group form-group-sm col-lg-12 col-md-12 col-sm-12">
                        <asp:Label ID="lblEmailCC" runat="server" AssociatedControlID="txtEmailCC" Text="<%$ Resources:lblEmailCC %>" class="col-lg-2 col-md-4 col-sm-3 control-label text-left"></asp:Label>
                        <div class="col-lg-8 col-md-8 col-sm-9">
                            <asp:TextBox ID="txtEmailCC" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <asp:RegularExpressionValidator runat="server" ID="regEmailCC" ValidationExpression="((\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*([,])*)*" ControlToValidate="txtEmailCC" Display="None" ErrorMessage="<%$ Resources:regEmailTo %>" SetFocusOnError="true"></asp:RegularExpressionValidator>
                    </div>
                    <div class="form-group form-group-sm col-lg-12 col-md-12 col-sm-12">
                        <asp:Label ID="lblEmailSubject" runat="server" AssociatedControlID="txtEmailSubject" Text="<%$ Resources:lblEmailSubject %>" class="col-lg-2 col-md-4 col-sm-3 control-label text-left"></asp:Label>
                        <div class="col-lg-8 col-md-8 col-sm-9">
                            <asp:TextBox ID="txtEmailSubject" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-12 col-md-12 col-sm-12">
                        <asp:Label ID="lblAttachments" AssociatedControlID="chklstAttachments" runat="server" Text="<%$ Resources:lblAttachments %>" class="col-lg-2 col-md-4 col-sm-3 control-label" Visible="false"></asp:Label>
                        <div class="col-lg-8 col-md-8 col-sm-9">
                            <asp:CheckBoxList runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal" ID="chklstAttachments" CssClass="asp-check"></asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-12 col-md-12 col-sm-12">
                        <asp:Label ID="lblMessageBody" runat="server" Text=" " class="col-lg-2 col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-lg-8 col-md-8 col-sm-9">
                            <asp:TextBox ID="txtMessageBody" TextMode="MultiLine" runat="server" CssClass="form-control" Rows="15"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <div class="card-footer">
                <asp:LinkButton ID="btnSendEmail" runat="server" Text="<%$ Resources:btnSendEmail %>" SkinID="btnPrimary"></asp:LinkButton>
            </div>
        </div>
        <asp:ValidationSummary runat="server" ID="vldSummary" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" CssClass="validation-summary"></asp:ValidationSummary>
    </div>
</asp:Content>
