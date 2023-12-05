<%@ page language="VB" autoeventwireup="false" inherits="Nexus.Modal_ClientDetailsForClaims, Pure.Portals" enablesessionstate="True" masterpagefile="~/default.master" enableEventValidation="false" %>

<%@ Register Src="~/Controls/AddressCntrl.ascx" TagName="AddressControl" TagPrefix="uc1" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">

    <script language="javascript" type="text/javascript">
        function ReceiveAddressData(sAddressData, sPostBackTo) {
            document.getElementById('<%=txtAddressData.ClientID %>').value = sAddressData;
            __doPostBack(sPostBackTo, 'UpdateAddress');
        }

        function pageLoad() {
            //this is needed if the trigger is external to the update panel   
            var manager = Sys.WebForms.PageRequestManager.getInstance();
            manager.add_beginRequest(OnBeginRequest);
        }

        function OnBeginRequest(sender, args) {
            var postBackElement = args.get_postBackElement();
            if (postBackElement.id == 'lnkClientAddress') {
                $get(uprogQuotes).style.display = "block";
            }
        }

    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="Modal_ClientDetailsForClaims">
        <div class="card">
            <div class="card-body clearfix">
                <div class="form-horizontal">
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblClientName" runat="server" Text="<%$ Resources:clientdetails_ClientName %>" AssociatedControlID="txtClientName" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtClientName" runat="server" Columns="10" Enabled="false" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblTelephoneNumberHome" runat="server" Text="<%$ Resources:clientdetails_TelephoneNumberHome %>" AssociatedControlID="txtTelephoneNumberHome" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtTelephoneNumberHome" runat="server" Columns="10" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblTelephoneNumberOffice" runat="server" Text="<%$ Resources:clientdetails_TelephoneNumberOffice %>" AssociatedControlID="txtTelephoneNumberoffice" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtTelephoneNumberoffice" runat="server" Columns="10" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblFaxNumber" runat="server" Text="<%$ Resources:clientdetails_FaxNumber %>" AssociatedControlID="txtFaxNumber" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtFaxNumber" runat="server" Columns="10" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblMobileNumber" runat="server" Text="<%$ Resources:clientdetails_MobileNumber %>" AssociatedControlID="txtMobileNumber" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtMobileNumber" runat="server" Columns="10" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblVATRegistrationNumber" runat="server" Text="<%$ Resources:clientdetails_VATRegistrationNumber %>" AssociatedControlID="txtVATRegistrationNumber" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtVATRegistrationNumber" runat="server" Columns="10" CssClass="form-control" Enabled="false"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblEmailNumber" runat="server" Text="<%$ Resources:clientdetails_EmailNumber %>" AssociatedControlID="txtEmailNumber" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtEmailNumber" runat="server" Columns="10" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblClientClaimNumber" runat="server" Text="<%$ Resources:clientdetails_ClientClaimNumber %>" AssociatedControlID="txtClientClaimNumber" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtClientClaimNumber" runat="server" Columns="10" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblVATRegistered" runat="server" AssociatedControlID="chkVATRegistered" class="col-md-4 col-sm-3 control-label">
                            <asp:Literal ID="litVATRegistered" runat="server" Text="<%$ Resources:lbl_VATregistered %>"></asp:Literal></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:CheckBox ID="chkVATRegistered" runat="server" AutoPostBack="true" Text=" " CssClass="asp-check"></asp:CheckBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblExcessListA" runat="server" Text="<%$ Resources:clientdetails_ExcessListA %>" AssociatedControlID="ddlExcessListA" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:DropDownList ID="ddlExcessListA" runat="server" CssClass="field-medium form-control">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblExcessListB" runat="server" Text="<%$ Resources:clientdetails_ExcessListB %>" AssociatedControlID="ddlExcessListB" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:DropDownList ID="ddlExcessListB" runat="server" CssClass="field-medium form-control"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblExcessListC" runat="server" Text="<%$ Resources:clientdetails_ExcessListC %>" AssociatedControlID="ddlExcessListC" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:DropDownList ID="ddlExcessListC" runat="server" CssClass="field-medium form-control"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblNCBPercentage" runat="server" Text="<%$ Resources:clientdetails_NCBPercentage %>" AssociatedControlID="ddlNCBPercentage" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:DropDownList ID="ddlNCBPercentage" runat="server" CssClass="field-medium form-control"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblCoverType" runat="server" Text="<%$ Resources:clientdetails_CoverType %>" AssociatedControlID="ddlCoverType" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:DropDownList ID="ddlCoverType" runat="server" CssClass="field-medium form-control"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:UpdatePanel ID="updateAddress" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                            <ContentTemplate>
                                <asp:Label ID="lblClientAddress" runat="server" Text="<%$ Resources:lbl_Address %>" AssociatedControlID="txtClientAddress" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <div class="input-group">
                                        <asp:TextBox ID="txtClientAddress" runat="server" Columns="5" Enabled="false" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                                        <span class="input-group-btn">
                                            <asp:LinkButton ID="lnkClientAddress" SkinID="btnModal" runat="server">
                                                <i class="glyphicon glyphicon-search"></i>
                                                 <span class="btn-fnd-txt">Address</span>
                                            </asp:LinkButton>
                                        </span>
                                    </div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <Nexus:ProgressIndicator ID="upAddress" OverlayCssClass="updating" AssociatedUpdatePanelID="updateAddress" runat="server">
                            <progresstemplate>
                                    </progresstemplate>
                        </Nexus:ProgressIndicator>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                 <asp:LinkButton ID="btnCancel" runat="server" Text="<%$ Resources:clientdetails_btnCancel %>" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnOk" runat="server" Text="<%$ Resources:clientdetails_btnOk %>" SkinID="btnPrimary"></asp:LinkButton>
               
            </div>
        </div>
        <asp:HiddenField ID="txtAddressData" runat="server"></asp:HiddenField>
    </div>
</asp:Content>
