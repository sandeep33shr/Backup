<%@ page language="VB" autoeventwireup="false" inherits="Nexus.secure_CorporateClientDetails, Pure.Portals" title="Untitled Page" masterpagefile="~/default.master" enableviewstate="true" enableEventValidation="false" %>

<%@ Register assembly="Pure.Portals"  TagPrefix="Nexus" Namespace="Nexus" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<%@ Register Src="~/Controls/CorporateClient.ascx" TagName="CorporateClient" TagPrefix="uc1" %>
<%@ Register Src="~/Controls/ProgressBar.ascx" TagName="ProgressBar" TagPrefix="uc3" %>
<%@ Register Src="~/Controls/NewQuote.ascx" TagName="NewQuote" TagPrefix="uc6" %>
<%@ Register Src="~/Controls/Addresses.ascx" TagName="Addresses" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/Convictions.ascx" TagName="Convictions" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/Associates.ascx" TagName="Associates" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/Loyalty.ascx" TagName="Loyalty" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/ProspectPolicy.ascx" TagName="ProspectPolicy" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/ClientClaims.ascx" TagName="ClientClaims" TagPrefix="uc8" %>
<%@ Register Src="~/Controls/EventList.ascx" TagName="ClientEvents" TagPrefix="uc9" %>
<%@ Register Src="~/Controls/ClientAccounts.ascx" TagName="ClientAccounts" TagPrefix="uc10" %>
<%@ Register Src="~/Controls/Contacts.ascx" TagName="Contacts" TagPrefix="uc11" %>
<%@ Register Src="~/Controls/ClientSummary.ascx" TagName="ClientSummary" TagPrefix="uc12" %>
<%@ Register Src="~/Controls/BankDetails.ascx" TagName="BankDetail" TagPrefix="uc13" %>
<%@ Register Src="~/Controls/NewQuoteImproved.ascx" TagName="NewQuoteImproved" TagPrefix="uc14" %>
<%@ Register Src="~/Controls/PolicyManager.ascx" TagName="PolicyManager" TagPrefix="uc15" %>
<%@ Register Src="~/Controls/CtrlLetterWriting.ascx" TagName="LetterWriting" TagPrefix="uc16" %>
<asp:Content ID="cntMainBody" runat="server" ContentPlaceHolderID="cntMainBody">

    <script language="javascript" type="text/javascript">
        $(document).ready(function () {
            //Sort employee band dropdown box based on code in ascending order
            $("#ctl00_cntMainBody_GISCorporate_Employees").html($('#ctl00_cntMainBody_GISCorporate_Employees option').sort(function (x, y) {
                return $(x).val() < $(y).val() ? -1 : 1;
            }));

            if ($("#<%=hdnManualTransfer.CLientID%>").val() == "NB") {
                $('a[href=#tab-policies]').attr("disabled", "disabled");
                $('a[href=#tab-claims]').attr("disabled", "disabled");
                $('a[href=#tab-policies]').off('click');
                $('a[href=#tab-claims]').off('click');
            }
            else {
                $('a[href=#tab-policies]').removeAttr("disabled");
                $('a[href=#tab-claims]').removeAttr("disabled");
            }
        });
        function pageLoad() {
            var manager = Sys.WebForms.PageRequestManager.getInstance();
            manager.add_beginRequest(OnBeginRequest);
            manager.add_endRequest(OnEndRequest);
        }

        function OnBeginRequest(sender, args) {
            //disable the button (or whatever else we need to do) here
            var btnSubmit = document.getElementById('<%= btnSubmit.ClientId%>');
            var btnCancel = document.getElementById('<%= btnCancel.ClientId%>');

            if (btnSubmit != null) {
                btnSubmit.disabled = true;
            }

            if (btnCancel != null) {
                btnCancel.disabled = true;
            }

        }

        function OnEndRequest(sender, args) {
            //enable the button (or whatever else we need to do) here
            var btnSubmit = document.getElementById('<%= btnSubmit.ClientId%>');
            var btnCancel = document.getElementById('<%= btnCancel.ClientId%>');

            if (btnSubmit != null) {
                btnSubmit.disabled = false;
            }

            if (btnCancel != null) {
                btnCancel.disabled = false;
            }
        }
    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="secure_agent_CorporateClientDetails">
        <asp:HiddenField ID="hdnManualTransfer" runat="server"></asp:HiddenField>
        <uc3:ProgressBar ID="uctProgressBar" runat="server"></uc3:ProgressBar>
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Label ID="lblNewCClient" runat="server" Text="<%$ Resources:lbl_AddPersonalClient_header %>" EnableViewState="false"></asp:Label>
                    <asp:Label ID="lblEditClient" runat="server" Visible="false" Text="<%$ Resources:lbl_EditClient_header %>" EnableViewState="false"></asp:Label>
                    <asp:Label ID="lblViewClient" runat="server" Visible="false" Text="<%$ Resources:lbl_ViewClient_header %>" EnableViewState="false"></asp:Label>
                </h1>
            </div>
            <asp:Panel ID="PnlRegisterCC" runat="server">
                <asp:Panel ID="pnlAddPC" runat="server" Visible="false">
                    <div class="card-divider">
                        <h5>
                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lbl_AddPerClient_message %>"></asp:Label>
                            <asp:HyperLink ID="hypAddPersonalClient" runat="server" CssClass="font-bold text-dark-dk text-u-l" NavigateUrl="~/secure/agent/PersonalClientDetails.aspx?mode=add" Text="<%$ Resources:lbl_AddPerClient_text %>"></asp:HyperLink>
                        </h5>
                    </div>
                </asp:Panel>
                <div id="corporateclient-control" class="card-body clearfix">
                    <div class="md-whiteframe-z0 bg-white">
                        <ul class="nav nav-lines nav-tabs b-danger">
                            <li class="active"><a href="#tab-basicdetails" data-toggle="tab" aria-expanded="true">Basic Details</a></li>
                            <li><a href="#tab-editaddresses" data-toggle="tab" aria-expanded="true">Addresses</a></li>
                            <li><a href="#tab-editcontacts" data-toggle="tab" aria-expanded="true">Contacts</a></li>
                            <li><a href="#tab-editassociates" data-toggle="tab" aria-expanded="true">Associates</a></li>
                            <li><a href="#tab-editconvictions" data-toggle="tab" aria-expanded="true">Convictions</a></li>
                            <li><a href="#tab-editloyalty" data-toggle="tab" aria-expanded="true">Loyalty</a></li>
                            <li><a href="#tab-editprospectpolicy" data-toggle="tab" aria-expanded="true">Prospect</a></li>
                            <li><a href="#tab-editbank" data-toggle="tab" aria-expanded="true">Bank Details</a></li>
                        </ul>
                        <div class="tab-content clearfix p b-t b-t-2x">
                            <div id="tab-basicdetails" class="tab-pane animated fadeIn active" role="tabpanel">
                                <div class="form-horizontal">
                                    <legend>
                                        <asp:Label ID="lblHeading" runat="server" Text="<%$ Resources:lbl_CompDetails_header %>"></asp:Label></legend>


                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblCompanyName" runat="server" AssociatedControlID="txtCompanyName" Text="<%$ Resources:lbl_CompanyName %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <asp:TextBox ID="txtCompanyName" runat="server" CssClass="field-mandatory form-control" MaxLength="255"></asp:TextBox>
                                        </div>
                                        <asp:RequiredFieldValidator ID="vldCompName" runat="server" Display="none" ControlToValidate="txtCompanyName" ErrorMessage="<%$ Resources:lbl_ErrMsg_companyname %>" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="vldCompanyNameRegex" runat="server" Display="None" ErrorMessage="<%$ Resources:lbl_RegExpr_CompanyName %>" ControlToValidate="txtCompanyName" ValidationExpression="[^{}:~#%*:<>?^/\\|\u2022,\u2023,\u25E6,\u2043,\u2219]+" SetFocusOnError="True"></asp:RegularExpressionValidator>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblRegisteredName" runat="server" AssociatedControlID="txtRegisteredName" Text="<%$ Resources:lbl_RegisteredName %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <asp:TextBox ID="txtRegisteredName" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblNumberOfEmployees" runat="server" AssociatedControlID="GISCorporate_Employees" Text="<%$ Resources:lbl_NumberOfEmployees %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <NexusProvider:LookupList ID="GISCorporate_Employees" runat="server" DataItemValue="Code" DataItemText="Description" ListType="PMLookup" ListCode="employeeband" DefaultText="(Please Select)" CssClass="field-medium form-control"></NexusProvider:LookupList>
                                        </div>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblMainContact" runat="server" AssociatedControlID="txtMainContact" Text="<%$ Resources:lbl_MainContact %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <asp:TextBox ID="txtMainContact" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                        <asp:RequiredFieldValidator ID="vldMainContact" runat="server" Display="none" ControlToValidate="txtMainContact" EnableClientScript="false" ErrorMessage="<%$ Resources:lbl_ErrMsg_maincontact %>" SetFocusOnError="True" Enabled="false"></asp:RequiredFieldValidator>
                                        <asp:CustomValidator ID="cusvldAddress" runat="server" Display="None" OnServerValidate="cusvldAddress_ServerValidate"></asp:CustomValidator>
                                        <asp:CustomValidator ID="cusvlPreferredCorrespondence" runat="server" Display="None" OnServerValidate="cusvlPreferredCorrespondence_ServerValidate"></asp:CustomValidator>
                                    </div>
                                    <div id="liFileCode" runat="server" visible="false" class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblFileCode" runat="server" AssociatedControlID="txtFileCode" class="col-md-4 col-sm-3 control-label">
                                            <asp:Literal ID="ltFileCode" runat="server" Text="<%$ Resources:lbl_FileCode %>"></asp:Literal>
                                        </asp:Label><div class="col-md-8 col-sm-9">
                                            <asp:TextBox ID="txtFileCode" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div id="liBranchCode" runat="server" visible="false" class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblSelectBranch" runat="server" AssociatedControlID="ddlBranchCode" Text="<%$ Resources:lbl_Branch%>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <asp:DropDownList ID="ddlBranchCode" DataTextField="Description" DataValueField="Code" runat="server" CssClass="field-medium form-control" OnSelectedIndexChanged="ddlBranchCode_SelectedIndexChanged"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="liCurrency" runat="server" AssociatedControlID="ddlCurrency" Text="<%$ Resources:lbl_Currency%>" class="col-md-4 col-sm-3 control-label">
                                        </asp:Label><div class="col-md-8 col-sm-9">
                                            <asp:DropDownList ID="ddlCurrency" DataTextField="Description" DataValueField="Code" runat="server" CssClass="field-medium form-control"></asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="tab-editaddresses" class="tab-pane animated fadeIn" role="tabpanel">

                                <uc7:Addresses ID="Addresses" runat="server"></uc7:Addresses>

                            </div>
                            <div id="tab-editcontacts" class="tab-pane animated fadeIn" role="tabpanel">

                                <uc11:Contacts ID="Contact" runat="server"></uc11:Contacts>

                            </div>
                            <div id="tab-editassociates" class="tab-pane animated fadeIn" role="tabpanel">

                                <uc7:Associates ID="Associate" runat="server"></uc7:Associates>

                            </div>
                            <div id="tab-editconvictions" class="tab-pane animated fadeIn" role="tabpanel">

                                <uc7:Convictions ID="Conviction" runat="server"></uc7:Convictions>

                            </div>
                            <div id="tab-editloyalty" class="tab-pane animated fadeIn" role="tabpanel">

                                <uc7:Loyalty ID="Loyalty" runat="server"></uc7:Loyalty>

                            </div>
                            <div id="tab-editprospectpolicy" class="tab-pane animated fadeIn" role="tabpanel">

                                <uc7:ProspectPolicy ID="ProspectPolicy" runat="server"></uc7:ProspectPolicy>

                            </div>
                            <div id="tab-editbank" class="tab-pane animated fadeIn" role="tabpanel">
                                <uc13:BankDetail ID="BankDetail" runat="server"></uc13:BankDetail>
                            </div>

                        </div>
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="pnlViewCC" runat="server" CssClass="card-body clearfix" Visible="false" EnableViewState="true">
                <div class="md-whiteframe-z0 bg-white">
                    <ul class="nav nav-lines nav-tabs b-danger">
                        <li class="active"><a href="#tab-overview" data-toggle="tab" aria-expanded="true">Overview</a></li>
                        <li><a href="#tab-addresses" data-toggle="tab" aria-expanded="true">Addresses</a></li>
                        <li><a href="#tab-contacts" data-toggle="tab" aria-expanded="true">Contacts</a></li>
                        <li><a href="#tab-associates" data-toggle="tab" aria-expanded="true">Associates</a></li>
                        <li><a href="#tab-convictions" data-toggle="tab" aria-expanded="true">Convictions</a></li>
                        <li><a href="#tab-loyalty" data-toggle="tab" aria-expanded="true">Loyalty</a></li>
                        <li><a href="#tab-prospectpolicy" data-toggle="tab" aria-expanded="true">Prospect</a></li>
                        <li><a href="#tab-policies" data-toggle="tab" aria-expanded="true">Quotes/Policies</a></li>
                        <li><a href="#tab-claims" data-toggle="tab" aria-expanded="true">Claims</a></li>
                        <li><a href="#tab-events" data-toggle="tab" aria-expanded="true">Events</a></li>
                        <% With CType(Session.Item(Nexus.Constants.Session.CNAgentDetails), NexusProvider.UserDetails)
                                If String.IsNullOrEmpty(.PartyType) Then%>
                            <li><a href="#tab-accounts" data-toggle="tab" aria-expanded="true">Accounts</a></li>
                        <% End If 
                        End With%>
                        <li><a href="#tab-bankdetails" data-toggle="tab" aria-expanded="true">Bank Details</a></li>
                        <li><a href="#tab-customdata" data-toggle="tab" aria-expanded="true">
                            <asp:Literal ID="Literal2" runat="server" Text="Party Builder"></asp:Literal></a>
                        </li>
                    </ul>
                    <div class="tab-content clearfix p b-t b-t-2x">

                        <div id="tab-overview" class="tab-pane animated fadeIn active" role="tabpanel">
                            <div class="form-horizontal">
                                <legend>
                                    <asp:Label ID="lblClientDetails" runat="server" Text="<%$ Resources:lblClientDetails %>"></asp:Label></legend>
                                <ol class="details">
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblCodeTitle" AssociatedControlID="lblCode_view" runat="server" Text="<%$ Resources:lbl_ClientCode %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <asp:Label ID="lblCode_view" runat="server" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblMainContactTitle" AssociatedControlID="lblMainContact_view" runat="server" Text="<%$ Resources:lbl_MainContactTitle %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <asp:Label ID="lblMainContact_view" runat="server" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblRegisteredNameTitle" AssociatedControlID="lblRegisteredName_view" runat="server" Text="<%$ Resources:lbl_RegisteredName %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <asp:Label ID="lblRegisteredName_view" runat="server" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblNumberOfEmployeesTitle" AssociatedControlID="lblNumberOfEmployees_view" runat="server" Text="<%$ Resources:lbl_NumberOfEmployees %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <asp:Label ID="lblNumberOfEmployees_view" runat="server" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    </div>
                                </ol>
                                <ol class="details">
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblCompanyNameTitle" AssociatedControlID="lblCompanyName_view" runat="server" Text="<%$ Resources:lbl_CompanyName_view %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <asp:Label ID="lblCompanyName_view" runat="server" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    </div>
                                </ol>
                            </div>
                            <uc12:ClientSummary ID="ClientSummaryCntrl" runat="server"></uc12:ClientSummary>

                        </div>
                        <div id="tab-addresses" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc7:Addresses ID="ViewAddressesCntrl" runat="server"></uc7:Addresses>

                        </div>
                        <div id="tab-contacts" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc11:Contacts ID="ViewContactsCntrl" runat="server"></uc11:Contacts>

                        </div>
                        <div id="tab-associates" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc7:Associates ID="ViewAssociatesCntrl" runat="server"></uc7:Associates>

                        </div>
                        <div id="tab-convictions" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc7:Convictions ID="ViewConvictionsCntrl" runat="server"></uc7:Convictions>

                        </div>
                        <div id="tab-loyalty" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc7:Loyalty ID="ViewLoyaltyCntrl" runat="server"></uc7:Loyalty>

                        </div>
                        <div id="tab-prospectpolicy" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc7:ProspectPolicy ID="ProspectPolicyCntrl" runat="server"></uc7:ProspectPolicy>

                        </div>
                        <div id="tab-policies" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc15:PolicyManager ID="ClientQuotesPolicies" runat="server"></uc15:PolicyManager>

                        </div>
                        <div id="tab-claims" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc8:ClientClaims ID="ctrlClientClaims" runat="server"></uc8:ClientClaims>

                        </div>
                        <div id="tab-events" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc9:ClientEvents ID="ctrlClientEvents" runat="server"></uc9:ClientEvents>

                        </div>
                        <div id="tab-accounts" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc10:ClientAccounts ID="ctrlClientAccounts" runat="server"></uc10:ClientAccounts>

                        </div>
                        <div id="tab-bankdetails" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc13:BankDetail ID="ctrlBankDetail" runat="server"></uc13:BankDetail>

                        </div>
                    </div>
                </div>
            </asp:Panel>
            <div class="card-footer">
                <uc6:NewQuote ID="ctrlNewQuote" runat="server"></uc6:NewQuote>
                <uc14:NewQuoteImproved ID="ctrlNewQuoteImproved" runat="server"></uc14:NewQuoteImproved>
                <asp:Label runat="server" ID="lblReviewText" Text="<%$ Resources:lbl_Review %>" EnableViewState="false"></asp:Label>
                <asp:LinkButton runat="server" ID="btnCancel" Text="<%$ Resources:lbl_Cancel %>" Visible="false" OnClick="BtnCancelClientClick" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton runat="server" ID="btnSubmit" Text="<%$ Resources:lbl_submit %>" EnableViewState="false" OnClick="BtnSubmitClientClick" SkinID="btnPrimary"></asp:LinkButton>
                <asp:LinkButton runat="server" ID="btnEditClient" Visible="false" Text="<%$ Resources:lbl_EditClient %>" EnableViewState="false" CausesValidation="false" OnClick="BtnEditClientClick" SkinID="btnPrimary"></asp:LinkButton>
                <uc16:LetterWriting ID="ctrlLetterWriting" runat="server" CustomSkinID="btnPrimary"></uc16:LetterWriting>
            </div>
        </div>
        <asp:ValidationSummary ID="ValidationSummary" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" runat="server" CssClass="validation-summary"></asp:ValidationSummary>
    </div>
</asp:Content>
