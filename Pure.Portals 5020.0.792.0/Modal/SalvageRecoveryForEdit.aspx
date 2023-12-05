<%@ page language="VB" autoeventwireup="false" inherits="Nexus.Modal_SalvageRecoveryForEdit, Pure.Portals" masterpagefile="~/default.master" enableEventValidation="false" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">

    <script type="text/javascript">
        var NumberAsFloat = function (price) {

            // StartNumber.replace(/\,/g,&#8216;&#8216;);
            var value = price.replace(/\,/g, '');
            return parseFloat(value, 10);
        }
        function CalculateRecovery() {

            var initialReserve = document.getElementById('<%=txtInitialReserve.ClientID %>');
            var thisRevision = document.getElementById('<%=txtThisRevision.ClientID %>');
            var revisedReserve = document.getElementById('<%=txtRevisedReserve.ClientID %>');
            var totalReserve = document.getElementById('<%=txtTotalReserve.ClientID %>');
            totalReserve.value = NumberAsFloat(initialReserve.value) + NumberAsFloat(thisRevision.value) + NumberAsFloat(revisedReserve.value);
            //Decimal Value for Total Reserve
            var ctrl = document.getElementById('<%=txtTotalReserve.ClientID %>').value;
            var myNum = new Number(ctrl);
            if (myNum.toFixed(2) != 'NaN') {
                document.getElementById('<%=txtTotalReserve.ClientID %>').value = FormatCurrency(myNum.toFixed(2));
            }
            //Decimal Value for This Revision
            ctrl = document.getElementById('<%=txtThisRevision.ClientID %>').value;
            myNum = new Number(ctrl);
            if (myNum.toFixed(2) != 'NaN') {
                document.getElementById('<%=txtThisRevision.ClientID %>').value = FormatCurrency(myNum.toFixed(2));
            }
        }

        function FormatCurrency(value) {
            var parts = value.toString().split(".");
            return parts[0].replace(/\B(?=(\d{3})+(?=$))/g, ",") + (parts[1] ? "." + parts[1] : "");
        }

        function isInteger(e) {
            var key = window.event ? e.keyCode : e.which;
            var keychar = String.fromCharCode(key);
            var ValidChars = "0123456789.-";
            var IsNumber = true;
            if (ValidChars.indexOf(keychar) == -1) {
                IsNumber = false;
            }
            return IsNumber;
        }

    </script>

    <div id="Modal_SalvageRecoveryForEdit">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="lblTitle" runat="server" Text=""></asp:Literal></h1>
            </div>
            <div class="card-body clearfix">
                <div class="form-horizontal">
                    <legend>
                        <asp:Label ID="lblSalvageRecoveryReserve" runat="server" Text=""></asp:Label></legend>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblRecoveryType" runat="server" AssociatedControlID="ddlRecoveryType" class="col-md-4 col-sm-3 control-label">
                            <asp:Literal ID="ltRecoveryType" runat="server" Text="<%$ Resources:lbl_RecoveryType%>"></asp:Literal>
                        </asp:Label><div class="col-md-8 col-sm-9">
                            <asp:DropDownList ID="ddlRecoveryType" runat="server" Enabled="false" CssClass="form-control">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblInitialReserve" runat="server" AssociatedControlID="txtInitialReserve" class="col-md-4 col-sm-3 control-label">
                            <asp:Literal ID="ltInitialReserve" runat="server" Text="<%$ Resources:lbl_InitialReserve%>"></asp:Literal>
                        </asp:Label><div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtInitialReserve" runat="server" CssClass="form-control form-control" MaxLength="15"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblRevisedReserve" runat="server" AssociatedControlID="txtRevisedReserve" class="col-md-4 col-sm-3 control-label">
                            <asp:Literal ID="ltRevisedReserve" runat="server" Text="<%$ Resources:lbl_RevisedReserve%>"></asp:Literal>
                        </asp:Label><div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtRevisedReserve" runat="server" CssClass="form-control form-control" MaxLength="15"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblThisRevision" runat="server" AssociatedControlID="txtThisRevision" Text="<%$ Resources:lbl_ThisRevision%>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtThisRevision" runat="server" CssClass="form-control field-mandatory form-control" MaxLength="15"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblTotalReserve" runat="server" AssociatedControlID="txtTotalReserve" class="col-md-4 col-sm-3 control-label">
                            <asp:Literal ID="ltTotalReserve" runat="server" Text="<%$ Resources:lbl_TotalReserve%>"></asp:Literal>
                        </asp:Label><div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtTotalReserve" runat="server" CssClass="form-control form-control" MaxLength="15"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnCancel" runat="server" Text="<%$ Resources:btnCancel %>" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnOk" runat="server" Text="<%$ Resources:btnOk %>" SkinID="btnPrimary"></asp:LinkButton>

            </div>
        </div>
        <asp:CustomValidator ID="CustValidType" runat="server" ControlToValidate="txtThisRevision" SetFocusOnError="true" Display="none"></asp:CustomValidator>
        <asp:ValidationSummary ID="ValidationSummary" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" runat="server" CssClass="validation-summary"></asp:ValidationSummary>
    </div>
</asp:Content>
