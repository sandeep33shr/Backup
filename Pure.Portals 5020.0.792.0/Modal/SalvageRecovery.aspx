<%@ page language="VB" autoeventwireup="false" inherits="Nexus.Modal_SalvageRecovery, Pure.Portals" masterpagefile="~/default.master" enableEventValidation="false" %>

<asp:Content ID="Content4" ContentPlaceHolderID="cntMainBody" runat="Server">

    <script type="text/javascript">
        //    function isInteger(e){
        //	    var key = window.event ? e.keyCode : e.which;
        //	    var keychar = String.fromCharCode(key);
        //	    reg = /\d/;
        //	    return reg.test(keychar);
        //    }
        function ConvertFindToDecimal() {
            var ctrl = document.getElementById('<%=txtInitialReserve.ClientID %>').value;
            var myNum = new Number(ctrl);
            if (myNum.toFixed(2) != 'NaN') {
                document.getElementById('<%=txtInitialReserve.ClientID %>').value = myNum.toFixed(2);
            }
        }
        function isInteger(e) {
            var key = window.event ? e.keyCode : e.which;
            var keychar = String.fromCharCode(key);
            var ValidChars = "0123456789.";
            var IsNumber = true;
            if (ValidChars.indexOf(keychar) == -1) {
                IsNumber = false;
            }
            return IsNumber;
        }
    </script>

    <div id="Modal_SalvageRecovery">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="lblTitle" runat="server" Text="<%$ Resources:lbl_SalvageRecovery_Title %>"></asp:Literal></h1>
            </div>
            <div class="card-body clearfix">
                <div class="form-horizontal">
                    <legend>
                        <asp:Label ID="lblSalvageRecoveryReserve" runat="server" Text="<%$ Resources:lbl_SalvageRecoveryReserve %>"></asp:Label></legend>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblRecoveryType" runat="server" AssociatedControlID="ddlRecoveryType" class="col-md-4 col-sm-3 control-label">
                            <asp:Literal ID="ltRecoveryType" runat="server" Text="<%$ Resources:lbl_RecoveryType%>"></asp:Literal></asp:Label><div class="col-md-8 col-sm-9">
                                <asp:DropDownList ID="ddlRecoveryType" runat="server" Enabled="True" CssClass="form-control">
                                </asp:DropDownList>
                            </div>
                    </div>
                    <div class="AlternateListItem form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblInitailReserve" runat="server" AssociatedControlID="txtInitialReserve" class="col-md-4 col-sm-3 control-label">
                            <asp:Literal ID="ltInitailReserve" runat="server" Text="<%$ Resources:lbl_InitialReserve%>"></asp:Literal></asp:Label><div class="col-md-8 col-sm-9">
                                <asp:TextBox ID="txtInitialReserve" runat="server" CssClass="form-control e-num2 form-control" MaxLength="15" onkeypress="javascript:return isInteger(event);" onblur="ConvertFindToDecimal()"></asp:TextBox>
                            </div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnCancel" runat="server" Text="<%$ Resources:btnCancel %>" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnOk" runat="server" Text="<%$ Resources:btnOk %>" SkinID="btnPrimary"></asp:LinkButton>

            </div>
        </div>
        <asp:CustomValidator ID="CustValidType" runat="server" ControlToValidate="txtInitialReserve" SetFocusOnError="true" Display="none"></asp:CustomValidator>
        <asp:ValidationSummary ID="ValidationSummary" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" runat="server" CssClass="validation-summary"></asp:ValidationSummary>
    </div>
</asp:Content>
