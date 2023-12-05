<%@ Page Language="VB" AutoEventWireup="false" CodeFile="PersonalClientDetails.aspx.vb" Inherits="Nexus.secure_PersonalClientDetails" Title="Personal Client Details" MasterPageFile="~/Default.master" EnableViewState="true" %>

<%@ Register TagPrefix="Nexus" Namespace="Nexus" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<%@ Register Src="~/Controls/ProgressBar.ascx" TagName="ProgressBar" TagPrefix="uc3" %>
<%@ Register Src="~/Controls/NewQuote.ascx" TagName="NewQuote" TagPrefix="uc6" %>
<%@ Register Src="~/controls/CalendarLookup.ascx" TagName="CalendarLookup" TagPrefix="uc1" %>
<%@ Register Src="~/controls/AddressCntrl.ascx" TagName="AddressCntrl" TagPrefix="uc2" %>
<%@ Register Src="~/Controls/Addresses.ascx" TagName="Addresses" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/Convictions.ascx" TagName="Convictions" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/Associates.ascx" TagName="Associates" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/LifeStyles.ascx" TagName="LifeStyles" TagPrefix="uc7" %>
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



    <script runat="server">
        Protected Sub ddlBranchCode_Load(sender As Object, e As EventArgs)
            If Not IsPostBack Then
                ddlBranchCode.SelectedValue = "HeadOff"
            End If
        End Sub
    </script>



    <script type="text/javascript">
        function IsAlphaNumeric(e) {
            var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
            var ret = ((keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122) || (keyCode == 44 || keyCode == 39 || keyCode == 32));
            return ret;
        }

        $(document).ready(function () {
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
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="personal-client-details">
        <asp:HiddenField ID="hdnManualTransfer" runat="server"></asp:HiddenField>
        <uc3:ProgressBar ID="ucProgressBar" runat="server"></uc3:ProgressBar>
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Label ID="lblNewPCClient" runat="server" Text="<%$ Resources:lbl_AddPersonalClient_header %>" EnableViewState="false"></asp:Label>
                    <asp:Label ID="lblEditClient" runat="server" Visible="false" Text="<%$ Resources:lbl_EditClient_header %>" EnableViewState="false"></asp:Label>
                    <asp:Label ID="lblViewClient" runat="server" Visible="false" Text="<%$ Resources:lbl_ViewClient_header %>" EnableViewState="false"></asp:Label>
                </h1>
            </div>
            <asp:Panel ID="PnlRegisterPC" runat="server">
                <asp:Panel ID="pnlAddCC" runat="server" Visible="false" EnableViewState="false" CssClass="pnlClient">
                    <div class="card-divider">
                        <h5>
                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lbl_AddCClient_message %>"></asp:Label>
                            <asp:HyperLink ID="hypAddCorporateClient" runat="server" CssClass="font-bold text-dark-dk text-u-l" NavigateUrl="~/secure/agent/CorporateClientDetails.aspx?mode=add" Text="<%$ Resources:lbl_AddCClient_text %>"></asp:HyperLink>
                        </h5>
                    </div>
                </asp:Panel>
                <div id="personalclient-control" class="card-body clearfix">
                    <div class="md-whiteframe-z0 bg-white">
                        <ul class="nav nav-lines nav-tabs b-danger">
                            <li class="active"><a href="#tab-basicdetails" data-toggle="tab" aria-expanded="true">Basic Details</a></li>
                            <li><a href="#tab-editaddresses" data-toggle="tab" aria-expanded="true">Addresses</a></li>
                            <li><a href="#tab-editcontacts" data-toggle="tab" aria-expanded="true">Contacts</a></li>
                            <li><a href="#tab-editconvictions" data-toggle="tab" aria-expanded="true">Convictions</a></li>
                            <li><a href="#tab-editassociates" data-toggle="tab" aria-expanded="true">Associates</a></li>
                            <li><a href="#tab-editlifestyles" data-toggle="tab" aria-expanded="true">Lifestyles</a></li>
                            <li><a href="#tab-editloyalty" data-toggle="tab" aria-expanded="true">Loyalty</a></li>
                            <li><a href="#tab-editprospectpolicy" data-toggle="tab" aria-expanded="true">Prospect</a></li>
                            <li><a href="#tab-editbank" data-toggle="tab" aria-expanded="true">Bank Details</a></li>
                        </ul>
                        <div class="tab-content clearfix p b-t b-t-2x">
                            <div id="tab-basicdetails" class="tab-pane animated fadeIn active" role="tabpanel">
                                <div class="form-horizontal">
                                    <legend>
                                        <asp:Label ID="lblHeading" runat="server" Text="<%$ Resources:lbl_Heading %>"></asp:Label></legend>

                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblTitle" runat="server" AssociatedControlID="ddlTitle" Text="<%$ Resources:lbl_Title %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <NexusProvider:LookupList ID="ddlTitle" runat="server" DataItemValue="description" DataItemText="description" ListType="UserDefined" ListCode="131085" DefaultText="Please Select" CssClass="field-medium field-mandatory form-control"></NexusProvider:LookupList>
                                        </div>
                                        <asp:RequiredFieldValidator ID="vldTitleRequired" runat="server" Display="none" ControlToValidate="ddlTitle" ErrorMessage="<%$ Resources:lbl_Title %>" InitialValue="" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblGender" runat="server" AssociatedControlID="ddlGender" Text="<%$ Resources:lbl_Gender %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <NexusProvider:LookupList ID="ddlGender" runat="server" DataItemValue="description" DataItemText="description" ListType="UserDefined" ListCode="131091" DefaultText="(Please select)" CssClass="field-medium form-control"></NexusProvider:LookupList>
                                        </div>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblFirstName" runat="server" AssociatedControlID="txtFirstName" Text="<%$ Resources:lbl_FirstName%>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <asp:TextBox ID="txtFirstName" runat="server" onkeypress="return IsAlphaNumeric(event);" onpaste="return false;" CssClass="field-mandatory form-control"></asp:TextBox>
                                        </div>
                                        <asp:RequiredFieldValidator ID="vldFirstNameRequired" runat="server" Display="none" ControlToValidate="txtFirstName" ErrorMessage="<%$ Resources:lbl_FirstName %>" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="RegexForename" runat="server" Display="none" ControlToValidate="txtFirstName" ErrorMessage="<%$ Resources:lbl_RegexFirstName %>" ValidationExpression="[^{}:~#%&*:<>?^/\\|\u2022,\u2023,\u25E6,\u2043,\u2219]+" SetFocusOnError="True"></asp:RegularExpressionValidator>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblLastname" runat="server" AssociatedControlID="txtLastname" Text="<%$ Resources:lbl_Lastname %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <asp:TextBox ID="txtLastname" runat="server" onkeypress="return IsAlphaNumeric(event);" onpaste="return false;" CssClass="field-mandatory form-control"></asp:TextBox>
                                        </div>
                                        <asp:RequiredFieldValidator ID="vldLastnameRequired" runat="server" Display="none" ControlToValidate="txtLastname" ErrorMessage="<%$ Resources:lbl_Lastname %>" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="RegexLastName" runat="server" Display="none" ControlToValidate="txtLastname" ErrorMessage="<%$ Resources:lbl_RegexLastName %>" SetFocusOnError="True" ValidationExpression="[^{}:~#%&*:<>?^/\\|\u2022,\u2023,\u25E6,\u2043,\u2219]+"></asp:RegularExpressionValidator>
                                    </div>
                                    <div class="AlternateListItem form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblInitials" runat="server" AssociatedControlID="txtInitials" Text="<%$ Resources:lbl_Initials %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <asp:TextBox ID="txtInitials" runat="server" onkeypress="return IsAlphaNumeric(event);" onpaste="return false;" CssClass="field-mandatory form-control"></asp:TextBox>
                                        </div>
                                        <asp:RequiredFieldValidator ID="vldInitialsRequired" runat="server" Display="none" ControlToValidate="txtInitials" ErrorMessage="<%$ Resources:lbl_Initials %>" InitialValue="" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblDateOfBirth" runat="server" AssociatedControlID="txtDOB" Text="<%$ Resources:lbl_DOB %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <asp:Label ID="lblDateOfBirthRequired" runat="server" AssociatedControlID="txtDOB" Text="<%$ Resources:lbl_DOB %>" Visible="false" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <div class="input-group">
                                                <asp:TextBox ID="txtDOB" runat="server" CssClass="field-date form-control"></asp:TextBox><uc1:CalendarLookup ID="calDateOfBirth" runat="server" LinkedControl="txtDOB" HLevel="2"></uc1:CalendarLookup>
                                            </div>
                                        </div>

                                        <asp:CustomValidator ID="custrngvldDateOfBirth" runat="server" Display="None" ErrorMessage="<%$ Resources:lbl_InvalidDOB %>" OnServerValidate="custrngvldDateOfBirth_ServerValidate"></asp:CustomValidator>
                                        <asp:CustomValidator ID="cusvldAddress" runat="server" Display="None" OnServerValidate="cusvldAddress_ServerValidate"></asp:CustomValidator>
                                        <asp:CustomValidator ID="cusvlPreferredCorrespondence" runat="server" Display="None" OnServerValidate="cusvlPreferredCorrespondence_ServerValidate"></asp:CustomValidator>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblNationality" runat="server" AssociatedControlID="GISCorporate_Nationality" Text="<%$ Resources:lbl_Nationality%>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <NexusProvider:LookupList ID="GISCorporate_Nationality" runat="server" DataItemValue="Code" DataItemText="Description" Sort="ASC" ListType="PMLookup" ListCode="Nationality" DefaultText="(Please Select)" CssClass="field-medium form-control"></NexusProvider:LookupList>
                                        </div>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblServiceLevel" runat="server" AssociatedControlID="ddlServiceLevel" Text="<%$ Resources:lbl_ServiceLevel%>" class="col-md-4 col-sm-3 control-label" />
                                        <div class="col-md-8 col-sm-9">
                                            <NexusProvider:LookupList ID="ddlServiceLevel" runat="server" DataItemValue="Code" DataItemText="Description"
                                                Sort="ASC" ListType="PMLookup" ListCode="Service_Level" DefaultText=" " CssClass="field-mandatory form-control" />
                                        </div>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblTaxRegistrationNO" runat="server" AssociatedControlID="txtTaxRegistrationNO" Text="<%$ Resources:lbl_TaxRegistrationNO %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <asp:TextBox ID="txtTaxRegistrationNO" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div id="liFileCode" runat="server" visible="false" class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblFileCode" runat="server" AssociatedControlID="txtFileCode" Text="<%$ Resources:lbl_FileCode %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <asp:TextBox ID="txtFileCode" runat="server" CssClass="field-mandatory form-control"></asp:TextBox>
                                        </div>
                                        <asp:RequiredFieldValidator ID="vldFileCode" runat="server" Display="none" ControlToValidate="txtFileCode" ErrorMessage="Please enter Identification" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblMaritalStatus" runat="server" AssociatedControlID="ddlMaritalStatus" Text="<%$ Resources:lbl_MaritalStatus %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <NexusProvider:LookupList ID="ddlMaritalStatus" runat="server" DataItemValue="description" DataItemText="description" ListType="UserDefined" ListCode="131107" CssClass="field-medium form-control"></NexusProvider:LookupList>
                                        </div>
                                    </div>
                                    <div id="liBranchCode" runat="server" visible="false" class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="lblSelectBranch" runat="server" AssociatedControlID="ddlBranchCode" Text="<%$ Resources:lbl_Branch%>" class="col-md-4 col-sm-3 control-label">
                                        </asp:Label>
                                        <div class="col-md-8 col-sm-9">
                                            <asp:DropDownList ID="ddlBranchCode" DataTextField="Description" DataValueField="Code" runat="server" CssClass="field-medium form-control" OnLoad="ddlBranchCode_Load" OnSelectedIndexChanged="ddlBranchCode_SelectedIndexChanged"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                        <asp:Label ID="liCurrency" runat="server" AssociatedControlID="ddlCurrency" Text="<%$ Resources:lbl_Currency%>" class="col-md-4 col-sm-3 control-label">
                                        </asp:Label>
                                        <div class="col-md-8 col-sm-9">
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
                            <div id="tab-editconvictions" class="tab-pane animated fadeIn" role="tabpanel">
                                <uc7:Convictions ID="Conviction" runat="server"></uc7:Convictions>


                            </div>
                            <div id="tab-editassociates" class="tab-pane animated fadeIn" role="tabpanel">
                                <uc7:Associates ID="Associate" runat="server"></uc7:Associates>


                            </div>
                            <div id="tab-editlifestyles" class="tab-pane animated fadeIn" role="tabpanel">
                                <uc7:LifeStyles ID="LifeStyle" runat="server"></uc7:LifeStyles>


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
            <asp:Panel ID="pnlViewPC" CssClass="card-body clearfix" runat="server" Visible="true" EnableViewState="true">
                <div class="md-whiteframe-z0 bg-white">
                    <ul class="nav nav-lines nav-tabs b-danger">
                        <li class="active"><a href="#tab-overview" data-toggle="tab" aria-expanded="true">Overview</a></li>
                        <li><a href="#tab-addresses" data-toggle="tab" aria-expanded="true">Addresses</a></li>
                        <li><a href="#tab-contacts" data-toggle="tab" aria-expanded="true">Contacts</a></li>
                        <li><a href="#tab-convictions" data-toggle="tab" aria-expanded="true">Convictions</a></li>
                        <li><a href="#tab-associates" data-toggle="tab" aria-expanded="true">Associates</a></li>
                        <li><a href="#tab-lifestyles" data-toggle="tab" aria-expanded="true">Lifestyles</a></li>
                        <li><a href="#tab-loyalty" data-toggle="tab" aria-expanded="true">Loyalty</a></li>
                        <li><a href="#tab-prospectpolicy" data-toggle="tab" aria-expanded="true">Prospect</a></li>
                        <li><a href="#tab-policies" data-toggle="tab" aria-expanded="true">Quotes/Policies</a></li>
                        <li><a href="#tab-claims" data-toggle="tab" aria-expanded="true">Claims</a></li>
                        <li><a href="#tab-events" data-toggle="tab" aria-expanded="true">Events</a></li>
                        <% With CType(Session.Item("AGENT_DETAILS"), NexusProvider.UserDetails)
                                If String.IsNullOrEmpty(.PartyType) Then%>
                        <li><a href="#tab-accounts" data-toggle="tab" aria-expanded="true">Accounts</a></li>
                        <% End If
                            End With%>
                        <li><a href="#tab-bankdetails" data-toggle="tab" aria-expanded="true">Bank Details</a></li>
                    </ul>
                    <div class="tab-content clearfix p b-t b-t-2x">

                        <div id="tab-overview" class="tab-pane animated fadeIn active" role="tabpanel">
                            <div class="form-horizontal">
                                <legend>
                                    <asp:Label ID="lblClientDetails" runat="server" Text="<%$ Resources:lblClientDetails %>"></asp:Label></legend>

                                <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                    <asp:Label ID="lblCodeTitle" AssociatedControlID="lblCode_view" runat="server" Text="<%$ Resources:lbl_ClientCode %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    <div class="col-md-8 col-sm-9">
                                        <p class="form-control-static font-bold">
                                            <asp:Label ID="lblCode_view" runat="server"></asp:Label>
                                        </p>
                                    </div>
                                </div>
                                <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                    <asp:Label ID="lblGenderTitle" AssociatedControlID="lblGender_view" runat="server" Text="<%$ Resources:lbl_Gender %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    <div class="col-md-8 col-sm-9">
                                        <p class="form-control-static font-bold">
                                            <asp:Label ID="lblGender_view" runat="server"></asp:Label>
                                        </p>
                                    </div>
                                </div>
                                <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                    <asp:Label ID="lblNationalityTitle" AssociatedControlID="lblNationality_view" runat="server" Text="<%$ Resources:lbl_Nationality %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    <div class="col-md-8 col-sm-9">
                                        <p class="form-control-static font-bold">
                                            <asp:Label ID="lblNationality_view" runat="server"></asp:Label>
                                        </p>
                                    </div>
                                </div>
                                <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                    <asp:Label ID="lblServiceLevelTitle" AssociatedControlID="lblServiceLevel_view" runat="server" Text="<%$ Resources:lbl_ServiceLevel %>" class="col-md-4 col-sm-3 control-label" />
                                    <div class="col-md-8 col-sm-9">
                                        <p class="form-control-static font-bold">
                                            <asp:Label ID="lblServiceLevel_view" runat="server" />
                                        </p>
                                    </div>
                                </div>
                                <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                    <asp:Label ID="lblMaritalStatusTitle" AssociatedControlID="lblMaritalStatus_view" runat="server" Text="<%$ Resources:lbl_MaritalStatus %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    <div class="col-md-8 col-sm-9">
                                        <p class="form-control-static font-bold">
                                            <asp:Label ID="lblMaritalStatus_view" runat="server"></asp:Label>
                                        </p>
                                    </div>
                                </div>
                                <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                    <asp:Label ID="lblNameTitle" AssociatedControlID="lblName_view" runat="server" Text="<%$ Resources:lbl_ClientName %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    <div class="col-md-8 col-sm-9">
                                        <p class="form-control-static font-bold">
                                            <asp:Label ID="lblName_view" runat="server"></asp:Label>
                                        </p>
                                    </div>
                                </div>
                                <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                    <asp:Label ID="lblDOBTitle" AssociatedControlID="lblDOB_view" runat="server" Text="<%$ Resources:lbl_DOB %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    <div class="col-md-8 col-sm-9">
                                        <p class="form-control-static font-bold">
                                            <asp:Label ID="lblDOB_view" runat="server"></asp:Label>
                                        </p>
                                    </div>
                                </div>
                                <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                    <asp:Label ID="lblTaxRegistrationNoTitle" AssociatedControlID="lblTaxRegistrationNo_view" runat="server" Text="<%$ Resources:lbl_TaxRegistrationNO %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    <div class="col-md-8 col-sm-9">
                                        <p class="form-control-static font-bold">
                                            <asp:Label ID="lblTaxRegistrationNo_view" runat="server"></asp:Label>
                                        </p>
                                    </div>
                                </div>
                                <div id="liFileCodeView" runat="server" class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                    <asp:Label ID="lblFileCodeView" AssociatedControlID="lblFileCode_view" runat="server" Text="<%$ Resources:lbl_FileCode %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                    <div class="col-md-8 col-sm-9">
                                        <p class="form-control-static font-bold">
                                            <asp:Label ID="lblFileCode_view" runat="server"></asp:Label>
                                        </p>
                                    </div>
                                </div>
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
                        <div id="tab-lifestyles" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc7:LifeStyles ID="ViewLifeStyles" runat="server"></uc7:LifeStyles>


                        </div>
                        <div id="tab-loyalty" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc7:Loyalty ID="ViewLoyalty" runat="server"></uc7:Loyalty>


                        </div>
                        <div id="tab-prospectpolicy" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc7:ProspectPolicy ID="ViewProspectPolicy" runat="server"></uc7:ProspectPolicy>


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
            <asp:Panel ID="PANEL__PARTYBUILDER" runat="server">
                <%-- This panel has to exist so that the child controls appear when adding a new Corporate Client after entering the core details --%>
                <asp:Panel ID="PANEL__PARTYCHILDSCREEN" runat="server">

                    <!------------------------------------------->
                    <script type="text/javascript">
                        /**
                         * @fileoverview
                         * GeneralValidation.h
                         */
                        var GeneralValidationHandler = {};

                        GeneralValidationHandler.isDate = function (value, sepVal, dayIdx, monthIdx, yearIdx) {
                            try {
                                //Change the below values to determine which format of date you wish to check. It is set to dd/mm/yyyy by default.
                                var DayIndex = dayIdx !== undefined ? dayIdx : 0;
                                var MonthIndex = monthIdx !== undefined ? monthIdx : 1;
                                var YearIndex = yearIdx !== undefined ? yearIdx : 2;

                                value = value.replace(/-/g, "/").replace(/\./g, "/");
                                var SplitValue = value.split(sepVal || "/");
                                var OK = true;
                                if (!(SplitValue[DayIndex].length == 1 || SplitValue[DayIndex].length == 2)) {
                                    OK = false;
                                }
                                if (OK && !(SplitValue[MonthIndex].length == 1 || SplitValue[MonthIndex].length == 2)) {
                                    OK = false;
                                }
                                if (OK && SplitValue[YearIndex].length != 4) {
                                    OK = false;
                                }
                                if (OK) {
                                    var Day = parseInt(SplitValue[DayIndex], 10);
                                    var Month = parseInt(SplitValue[MonthIndex], 10);
                                    var Year = parseInt(SplitValue[YearIndex], 10);

                                    if (OK = ((Year > 1900) && (Year < (100 + new Date().getFullYear())))) {
                                        if (OK = (Month <= 12 && Month > 0)) {

                                            var LeapYear = (((Year % 4) == 0) && ((Year % 100) != 0) || ((Year % 400) == 0));

                                            if (OK = Day > 0) {
                                                if (Month == 2) {
                                                    OK = LeapYear ? Day <= 29 : Day <= 28;
                                                }
                                                else {
                                                    if ((Month == 4) || (Month == 6) || (Month == 9) || (Month == 11)) {
                                                        OK = Day <= 30;
                                                    }
                                                    else {
                                                        OK = Day <= 31;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                return OK;
                            }
                            catch (e) {
                                return false;
                            }
                        }

                        GeneralValidationHandler.Validate = function (isOnLoad, args, obj, prop, type) {
                            type = type.toLowerCase();
                            var node = document.getElementById("ctl00_cntMainBody_val" + obj.toUpperCase() + "__" + prop);
                            if (node == null) {
                                // Try slightly different format with only one underscore
                                node = document.getElementById("ctl00_cntMainBody_val" + obj.toUpperCase() + "_" + prop);
                            }

                            if (isOnLoad) {
                                //
                                //	Add a blur event to call validation function
                                if (node != null) {
                                    if (node.addEventListener) {
                                        node.addEventListener('blur', function () { window['onValidate_' + obj + '__' + prop](null, null, this); });
                                    } else {
                                        node.attachEvent('onblur', function () { window['onValidate_' + obj + '__' + prop](null, null, this); });
                                    }
                                }
                            } else {
                                // Ensure the field contents is the correct format on exit from the field
                                var field = Field.getInstance(obj, prop);
                                var errorMessage = null;
                                var isValid = true;

                                if (type == "integer") {
                                    var value = field.getValue();

                                    if (value != null && value != '') {
                                        var regExp = /^-?[0-9]+$/;

                                        if (regExp.test(value)) {
                                            if (value <= -1000000000 || value >= 1000000000) {
                                                errorMessage = "Is out of range";
                                                isValid = false;
                                            }
                                        } else {
                                            isValid = false;
                                            errorMessage = "Must be numeric";
                                        }
                                    }
                                }

                                if (type == "date") {
                                    var date = field.getValue();
                                    //if ((date instanceof Date) && window.isNaN(date.getTime())) {
                                    ///if (date.length > 0 && !GeneralValidationHandler.isDate(date, "/", 0, 1, 2)) {
                                    if (!date instanceof Date) {
                                        isValid = false;
                                        errorMessage = "Must be a valid date";
                                    }
                                }

                                if (type == "currency") {
                                    var value = field.getValue();
                                    if (value <= -1000000000000000 || value >= 1000000000000000) {
                                        errorMessage = "Is out of range";
                                        isValid = false;
                                    }
                                }

                                if (type == "percentage") {
                                    var value = field.getValue();
                                    if (value <= -1000 || value >= 1000) {
                                        errorMessage = "Is out of range";
                                        isValid = false;
                                    }
                                }

                                if (type == "text") {
                                    var value = field.getValue();
                                    if (value.length > 255) {
                                        errorMessage = "Too many characters";
                                        isValid = false;
                                    }

                                }

                                if (!isValid) {
                                    if (node != null) {
                                        var lbl = document.getElementById('ctl00_cntMainBody_lbl' + obj + '_' + prop);
                                        if (lbl != null) {
                                            node.errormessage = lbl.innerHTML + " -- " + errorMessage;
                                            if (args && args.IsValid == true) {
                                                args.IsValid = false;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        /**
                         * Set the control width
                         */
                        window.setControlWidth = function (field, width, obj, prop) {

                            // width sanitisation
                            if (typeof width == "string"
                                && ((width.slice(0, 1) == "'" && width.slice(-1) == "'") || (width.slice(0, 1) == "\"" || width.slice(-1) == "\""))) {

                                // As there is loads of rules in the spreadsheet in this format correcting this now will throw
                                // all the sizes of fields out of sync to what they were before. So to keep the same
                                // behaviour without erroring will exit out here instead.
                                return;
                                //width = width.slice(1, -1);
                            }
                            if (typeof width == "string") {
                                width = window.parseFloat(width);
                                if (width == NaN)
                                    return; // Don't continue
                            }


                            // If the control supports setWidth, use that else fall back on other method
                            // for older controls
                            // TO keep resizing consistent we will hard code a standard width
                            var standardWidth = 165;
                            //if (field.setWidth && field.getWidth){
                            if (field.setWidth) {
                                field.setWidth(standardWidth * width);
                            }
                            var sWidthClass = "";
                            var sWidthClass2 = "";
                            sWidthClass = "w-25";

                            // Fall back for older fields
                            var ele = document.getElementById('ctl00_cntMainBody_' + obj + '__' + prop);
                            if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
                                ele = document.getElementById('ctl00_cntMainBody_' + obj + '__' + prop + '_' + 'txtPartyName');
                            }
                            //var bounds = window.getBounds(ele);
                            var widthPx = Math.round(width * standardWidth);
                            if (width >= 1)
                                sWidthClass2 = "col-md-8 col-sm-9";

                            if (width >= 0.9 && width < 1.0)
                                sWidthClass2 = "col-md-7 col-sm-8";

                            if (width >= 0.8 && width < 0.9)
                                sWidthClass2 = "col-md-6 col-sm-7";

                            if (width >= 0.7 && width < 0.8)
                                sWidthClass2 = "col-md-5 col-sm-6";

                            if (width >= 0.5 && width < 0.7)
                                sWidthClass2 = "col-md-4 col-sm-5";
                            if (width >= 0.3 && width < 0.5)
                                sWidthClass2 = "col-md-3 col-sm-4";

                            if (width >= 0.2 && width < 0.3)
                                sWidthClass2 = "col-md-2 col-sm-3";
                            if (width = 0.1 && width < 0.2)
                                sWidthClass2 = "col-md-1 col-sm-2";


                            if (ele != null) {
                                //ele.style.width = ((widthPx > 790) ? 790 : widthPx) + "px !important";
                                var parentClassName = ele.parentElement.className;
                                //if (parentClassName !="col-md-8 col-sm-9")
                                //{
                                //ele.parentElement.parentElement.className = ele.parentElement.parentElement.className + " " + sWidthClass ;
                                //}
                                //else
                                //ele.parentElement.className = ele.parentElement.className + " " + sWidthClass ;

                                var sblEle = ele.parentElement.parentElement.previousElementSibling;
                                if (parentClassName != "col-md-8 col-sm-9") {
                                    ele.parentElement.parentElement.className = sWidthClass2;
                                    if (sblEle != undefined) {
                                        if (sblEle.nodeName == "LABEL")
                                            sblEle.className = sWidthClass2 + " " + "control-label";
                                    }
                                }
                                else {
                                    ele.parentElement.className = sWidthClass2;
                                    if (sblEle != undefined) {
                                        if (sblEle.nodeName == "LABEL")
                                            sblEle.className = sWidthClass2 + " " + "control-label";
                                    }
                                }




                            }

                            // Check for text area also
                            var textarea = document.getElementById('ctl00_cntMainBody_' + obj + '_' + prop + '_textarea');
                            //if (textarea != null){
                            //bounds = window.getBounds(textarea);
                            //	textarea.style.width = ((widthPx > 790) ? 790 : widthPx) + "px !important";
                            //}
                            if (textarea != null) {
                                if (parentClassName != "col-md-8 col-sm-9") {
                                    textarea.parentElement.className = sWidthClass2;
                                }
                                else
                                    textarea.parentElement.className = sWidthClass2;
                            }

                        };
                        function onValidate_PSCLIENT__VAT_NUMBER(source, args, sender, isOnLoad) {

                            /**
                             * @fileoverview
                             * GeneralValidation
                             */
                            (function () {
                                GeneralValidationHandler.Validate(isOnLoad, args, "PSCLIENT", "VAT_NUMBER", "Text");
                            })();
                            /**
                             * Set the control width
                             */
                            (function () {

                                if (isOnLoad) {
                                    (function () {
                                        var field = Field.getInstance("PSCLIENT.VAT_NUMBER");
                                        window.setControlWidth(field, "0.8", "PSCLIENT", "VAT_NUMBER");
                                    })();
                                }
                            })();
                            /**
                             * Set the label width
                             */
                            (function () {

                                if (isOnLoad) {
                                    window.setTimeout(function () {

                                        var width = window.parseFloat("1");
                                        var standardWidth = 165;
                                        if ("{name}" != "{na" + "me}") {
                                            var label = document.getElementById("{name}");
                                            // Walk up the dom, if a co-cell is found use that intead
                                            if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
                                                label = label.parentNode.parentNode.parentNode;
                                        } else {
                                            var label = document.getElementById("ctl00_cntMainBody_lblPSCLIENT_VAT_NUMBER");
                                            var ele = document.getElementById('ctl00_cntMainBody_PSCLIENT__VAT_NUMBER');
                                            if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
                                                label = document.getElementById("ctl00_cntMainBody_PSCLIENT__VAT_NUMBER_lblFindParty");
                                            }
                                        }
                                        var bounds = goog.style.getBounds(label);
                                        //if (bounds.width != 0)
                                        //standardWidth = bounds.width;

                                        //var bounds = window.getBounds(ele);
                                        //if (label != null)
                                        //label.style.width = Math.round(width * standardWidth) + "px";
                                        var sWidthClass2 = "col-md-4 col-sm-3 control-label";
                                        if (width >= 1)
                                            sWidthClass2 = "col-md-4 col-sm-3 control-label";

                                        if (width >= 0.9 && width < 1.0)
                                            sWidthClass2 = "col-md-4 col-sm-3 control-label";

                                        if (width >= 0.8 && width < 0.9)
                                            sWidthClass2 = "col-md-3 col-sm-2 control-label";

                                        if (width >= 0.7 && width < 0.8)
                                            sWidthClass2 = "col-md-3 col-sm-2 control-label";

                                        if (width >= 0.5 && width < 0.7)
                                            sWidthClass2 = "col-md-2 col-sm-1 control-label";
                                        if (width >= 0.3 && width < 0.5)
                                            sWidthClass2 = "col-md-2 col-sm-1 control-label";

                                        if (width >= 0.1 && width < 0.3)
                                            sWidthClass2 = "col-md-1 col-sm-1 control-label";

                                        label.className = sWidthClass2;
                                    }, 4);
                                }
                            })();
                            /**
                             * @fileoverview
                             * ValidWhen
                             */
                            (function () {

                                if (args && args.IsValid == true) {

                                    var setInvalid = function () {
                                        var message = (Expression.isValidParameter("'The vat number is invalid'")) ? "'The vat number is invalid'" : null;
                                        args.IsValid = false;
                                        if (message != null) {
                                            var node = document.getElementById("ctl00_cntMainBody_val" + "PSCLIENT".toUpperCase() + "__" + "VAT_NUMBER");
                                            if (node == null) {
                                                // Try slightly different format with only one underscore
                                                node = document.getElementById("ctl00_cntMainBody_val" + "PSCLIENT".toUpperCase() + "_" + "VAT_NUMBER");
                                            }
                                            if (node != null) {
                                                node.errormessage = message;
                                            }
                                        }
                                    };

                                    var exp;
                                    try {
                                        exp = new Expression("Matches('^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][5]$', PSCLIENT.VAT_NUMBER)||PSCLIENT.VAT_NUMBER=''||PSCLIENT.VAT_NUMBER=null");
                                    } catch (e) {
                                        setInvalid();
                                        return;
                                    }
                                    if (exp.getValue() != true)
                                        setInvalid();
                                }
                            })();
                        }
                        function onValidate_PSCLIENT__FIA(source, args, sender, isOnLoad) {

                            /**
                             * @fileoverview
                             * GeneralValidation
                             */
                            (function () {
                                GeneralValidationHandler.Validate(isOnLoad, args, "PSCLIENT", "FIA", "Checkbox");
                            })();
                            /**
                             * Set the control width
                             */
                            (function () {

                                if (isOnLoad) {
                                    (function () {
                                        var field = Field.getInstance("PSCLIENT.FIA");
                                        window.setControlWidth(field, "0.8", "PSCLIENT", "FIA");
                                    })();
                                }
                            })();
                            /**
                             * Set the label width
                             */
                            (function () {

                                if (isOnLoad) {
                                    window.setTimeout(function () {

                                        var width = window.parseFloat("1");
                                        var standardWidth = 165;
                                        if ("{name}" != "{na" + "me}") {
                                            var label = document.getElementById("{name}");
                                            // Walk up the dom, if a co-cell is found use that intead
                                            if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
                                                label = label.parentNode.parentNode.parentNode;
                                        } else {
                                            var label = document.getElementById("ctl00_cntMainBody_lblPSCLIENT_FIA");
                                            var ele = document.getElementById('ctl00_cntMainBody_PSCLIENT__FIA');
                                            if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
                                                label = document.getElementById("ctl00_cntMainBody_PSCLIENT__FIA_lblFindParty");
                                            }
                                        }
                                        var bounds = goog.style.getBounds(label);
                                        //if (bounds.width != 0)
                                        //standardWidth = bounds.width;

                                        //var bounds = window.getBounds(ele);
                                        //if (label != null)
                                        //label.style.width = Math.round(width * standardWidth) + "px";
                                        var sWidthClass2 = "col-md-4 col-sm-3 control-label";
                                        if (width >= 1)
                                            sWidthClass2 = "col-md-4 col-sm-3 control-label";

                                        if (width >= 0.9 && width < 1.0)
                                            sWidthClass2 = "col-md-4 col-sm-3 control-label";

                                        if (width >= 0.8 && width < 0.9)
                                            sWidthClass2 = "col-md-3 col-sm-2 control-label";

                                        if (width >= 0.7 && width < 0.8)
                                            sWidthClass2 = "col-md-3 col-sm-2 control-label";

                                        if (width >= 0.5 && width < 0.7)
                                            sWidthClass2 = "col-md-2 col-sm-1 control-label";
                                        if (width >= 0.3 && width < 0.5)
                                            sWidthClass2 = "col-md-2 col-sm-1 control-label";

                                        if (width >= 0.1 && width < 0.3)
                                            sWidthClass2 = "col-md-1 col-sm-1 control-label";

                                        label.className = sWidthClass2;
                                    }, 4);
                                }
                            })();
                        }
                        function DoLogic(isOnLoad) {
                            onValidate_PSCLIENT__VAT_NUMBER(null, null, null, isOnLoad);
                            onValidate_PSCLIENT__FIA(null, null, null, isOnLoad);
                        }
                    </script>


                    <script type="text/javascript">

	<%
                        Dim xmlset As String = Session(Nexus.Constants.CNParty).XMLDataset
                        If xmlset Is Nothing Then
                            xmlset = "<?xml version=""1.0"" encoding=""UTF-16"" standalone=""no""?><DATA_SET />"
                        Else
                            xmlset = xmlset.Replace("'", "\'").Replace(vbCr, "").Replace(vbLf, "")
                            xmlset = xmlset.Substring(0, xmlset.IndexOf("<!DOCTYPE DATA_SET")) & xmlset.Substring(xmlset.IndexOf("<DATA_SET"))
                        End If

                        ' Output the IO Number
                        Dim oOIText As String
                        Dim oOI As Collections.Stack
                        oOI = Session.Item(Nexus.Constants.CNOI)
                        If Not oOI Is Nothing Then
                            If oOI.Count > 0 Then
                                oOIText = oOI.Peek
                            End If
                        End If
	%>
                        window["XMLDataSet"] = '<%=xmlset %>';
                        window["ThisOI"] = '<%=oOIText %>';

                    </script>

                    <script src="<%=ResolveUrl("~/App_Themes/Standard/js/es5-shim.min.js")%>" type="text/javascript"></script>
                    <script src="<%=ResolveUrl("~/App_Themes/Standard/js/es6-shim.min.js")%>" type="text/javascript"></script>
                    <script src="<%=ResolveUrl("~/App_Themes/Standard/js/closure-v1.5.1.js")%>" type="text/javascript"></script>
                    <script src="<%=ResolveUrl("~/App_Themes/Standard/js/buildComponents-v1.5.1.js")%>" type="text/javascript"></script>


                    <link href="<%=ResolveUrl("~/App_Themes/Standard/css/closure-v1.5.1.css")%>" rel="stylesheet" type="text/css" />
                    <link href="<%=ResolveUrl("~/App_Themes/Standard/internal-differences.css")%>" rel="stylesheet" type="text/css" />
                    <link href="<%=ResolveUrl("~/App_Themes/Standard/internal-differences-addon-3-to-3.1.css")%>" rel="stylesheet" type="text/css" />

                    <script type="text/javascript">
	    <% If Session(Nexus.Constants.CNClientMode) = Nexus.Constants.Mode.Add Then%>
                        perseus.identifiers.isOnAdd = true;
	    <% Else %>
                        perseus.identifiers.isOnAdd = false;
	    <% End If %>
                        perseus.identifiers.loginName = '<%= Session(Nexus.Constants.CNLoginName).ToString()%>';


                    </script>

                    <div id="inner_content">

                        <!-- GeneralLayoutContainer -->
                        <div id="id9403e6118c864af998a05eee4e4ba7f5" class="general-layout-container">






                            <div class="clearfix p-xs">


                                <!-- ColumnLayoutContainer -->
                                <div id="frmInformationBox" class="column-layout-container,no-border  ">


                                    <legend>
                                        <asp:Label ID="lblHeading1" runat="server" Text=" " /></legend>


                                    <div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">

                                        <ul class="column-content">





                                            <li class="co-cell" style="width: 50%;">


                                                <!-- Text -->

                                                <div class="form-group form-group-sm">
                                                    <span class="field-container"
                                                        data-field-type="Text"
                                                        data-object-name="PSCLIENT"
                                                        data-property-name="VAT_NUMBER"
                                                        id="pb-container-text-PSCLIENT-VAT_NUMBER">


                                                        <asp:Label ID="lblPSCLIENT_VAT_NUMBER" runat="server" AssociatedControlID="PSCLIENT__VAT_NUMBER"
                                                            Text="VAT Number " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>






                                                        <div class="col-md-8 col-sm-9">
                                                            <asp:TextBox ID="PSCLIENT__VAT_NUMBER" runat="server" CssClass="form-control" data-type="Text" />
                                                            <asp:CustomValidator ID="valPSCLIENT_VAT_NUMBER"
                                                                runat="server"
                                                                Text="*"
                                                                ErrorMessage="A validation error occurred for VAT Number "
                                                                ClientValidationFunction="onValidate_PSCLIENT__VAT_NUMBER"
                                                                ValidationGroup=""
                                                                Display="None"
                                                                EnableClientScript="true" />
                                                        </div>




                                                    </span>
                                                </div>

                                                <!-- /Text -->

                                            </li>







                                            <li class="co-cell" style="width: 50%;">
                                                <!-- Checkbox -->
                                                <div class="form-group form-group-sm">
                                                    <label id="ctl00_cntMainBody_lblPSCLIENT_FIA" for="ctl00_cntMainBody_PSCLIENT__FIA" class="col-md-4 col-sm-3 control-label">
                                                        FIA</label>
                                                    <div class="col-md-8 col-sm-9">
                                                        <span class="field-container asp-check"
                                                            data-field-type="Checkbox"
                                                            data-object-name="PSCLIENT"
                                                            data-property-name="FIA"
                                                            id="pb-container-checkbox-PSCLIENT-FIA">

                                                            <asp:TextBox ID="PSCLIENT__FIA" runat="server" CssClass="form-control hidden" />
                                                            <asp:CustomValidator ID="valPSCLIENT_FIA"
                                                                runat="server"
                                                                Text="*"
                                                                ErrorMessage="A validation error occurred for FIA"
                                                                ClientValidationFunction="onValidate_PSCLIENT__FIA"
                                                                ValidationGroup=""
                                                                Display="None"
                                                                EnableClientScript="true" />

                                                        </span>
                                                    </div>
                                                </div>
                                                <!-- /Checkbox -->

                                            </li>



                                        </ul>

                                    </div>


                                </div>


                                <script type="text/javascript">
                                    var labelAlign = "";
                                    var textAlign = "";
                                    var labelWidth = "";

                                    $(document).ready(function () {
                                        var liElementHeight = 0;
                                        var liMaxHeight = 0;
                                        var liMinHeight = 46;
                                        var liRowElement = 0;
                                        var recordArray = new Array();
                                        var arrayCount = 0;
                                        if ($("#frmInformationBox div").attr("data-column-count") != "undefined") {
                                            columnCount = $("#frmInformationBox div").attr("data-column-count");
                                        }

                                        if (columnCount > 1) {
                                            $("#frmInformationBox div ul li").each(function () {
                                                liElementHeight = $(this).height();

                                                if (liElementHeight < liMinHeight) {
                                                    liElementHeight = liMinHeight;
                                                }

                                                if (liMaxHeight != 0 && liMaxHeight > liMinHeight) {
                                                    if (liElementHeight > liMaxHeight) {
                                                        liElementHeight = liMaxHeight;
                                                    }
                                                }

                                                if (liRowElement == (columnCount - 1)) {
                                                    liRowElement = 0;
                                                    recordArray[arrayCount] = liElementHeight;
                                                    arrayCount++;
                                                    liElementHeight = 0;

                                                }
                                                else {
                                                    liRowElement++;
                                                }

                                            });

                                            liRowElement = 0;
                                            arrayCount = 0;
                                            $("#frmInformationBox div ul li").each(function () {
                                                $(this).height(recordArray[arrayCount]);
                                                if (liRowElement == (columnCount - 1)) {
                                                    liRowElement = 0;
                                                    arrayCount++;
                                                }
                                                else {
                                                    liRowElement++;
                                                }
                                            });
                                        }
                                    });

                                    var styleString = "";
                                    if (labelWidth != "") {
                                        if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()) {
                                            labelWidth = labelWidth + "px";
                                        }
                                        styleString += "#frmInformationBox label{width: " + labelWidth + ";}";
                                    }
                                    if (labelAlign != "") {
                                        switch (labelAlign.toLowerCase()) {
                                            case "right": styleString += "#frmInformationBox label{text-align:right;}"; break;
                                            case "centre":
                                            case "center":
                                            case "middle": styleString += "#frmInformationBox label{text-align:center;}"; break;
                                            case "left":
                                            default: styleString += "#frmInformationBox label{text-align:left;}"; break;
                                        }
                                    }
                                    if (textAlign != "") {
                                        switch (textAlign.toLowerCase()) {
                                            case "right": styleString += "#frmInformationBox input{text-align:right;}"; break;
                                            case "centre":
                                            case "center":
                                            case "middle": styleString += "#frmInformationBox input{text-align:center;}"; break;
                                            case "left":
                                            default: styleString += "#frmInformationBox input{text-align:left;}"; break;
                                        }
                                    }

                                    if (styleString != "") {
                                        goog.style.installStyles(styleString);
                                    }
                                </script>
                                <!-- /ColumnLayoutContainer -->

                            </div>





                        </div>


                        <!-- /GeneralLayoutContainer -->

                    </div>

                    <script type="text/javascript">


                        BuildComponents();
                        DoLogic(true);
                    </script>


                    <!------------------------------------------->

                </asp:Panel>
            </asp:Panel>
            <div class="card-footer">
                <uc6:NewQuote ID="ctrlNewQuote" Visible="false" runat="server"></uc6:NewQuote>
                <uc14:NewQuoteImproved ID="ctrlNewQuoteImproved" runat="server"></uc14:NewQuoteImproved>
                <asp:Label runat="server" ID="lblReviewText" Text="<%$ Resources:lbl_Review %>" EnableViewState="false" CssClass="label-margin-right"></asp:Label>
                <asp:LinkButton runat="server" ID="btnCancel" Text="<%$ Resources:lbl_Cancel %>" Visible="false" OnClick="BtnCancelClientClick" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton runat="server" ID="btnSubmit" Text="<%$ Resources:lbl_Submit %>" EnableViewState="false" OnClick="BtnSubmitClientClick" SkinID="btnPrimary"></asp:LinkButton>
                <asp:LinkButton runat="server" ID="btnEditClient" Visible="false" Text="<%$ Resources:lbl_EditClient %>" EnableViewState="false" CausesValidation="False" OnClick="BtnEditClientClick" SkinID="btnPrimary"></asp:LinkButton>
                <uc16:LetterWriting ID="ctrlLetterWriting" runat="server" CustomSkinID="btnPrimary"></uc16:LetterWriting>
                <asp:LinkButton ID="cmdExtractClientData" runat="server" SkinID="btnPrimary" Text="<%$ Resources:lbl_ExtractClientData %>" EnableViewState="false" CausesValidation="false"
                    Style="width: auto !important; float: left; margin-left: 10px;" />
            </div>
        </div>
        <asp:ValidationSummary ID="ValidationSummary" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" runat="server" CssClass="validation-summary"></asp:ValidationSummary>
    </div>

 <script type="text/javascript">
     $("[id$='txtFileCode']").on("keypress", function (event) {
         let idType = $("[id$='ddlServiceLevel']").val();
          if (idType !== ''){
              if (idType == 'ID') {
                  //regular expression to print only letters, spaces, hyphens and apostrophes
                    let regularExpression = /^[0-9]*$/;
                    return allowCharactersToPrint(event, regularExpression);
              }
          }          
     });


     $("[id$='ddlServiceLevel']").on("change", function (event){
         var idType = $(this).find(':selected').text()
         var nationality = $("[id$='GISCorporate_Nationality']").find(':selected').text();
          if (idType !== '' && idType =='Passport' && nationality =='Namibian'){
			  //Clear Field
			  $("[id$='txtFileCode']").val("");
              // P as default value on Identification field
              $("[id$='txtFileCode']").val("P");  
          }
			if (idType !== '' && idType =='Identification Document' && nationality =='Namibian'){
			  //Clear Field
			  $("[id$='txtFileCode']").val("");
  
          } 	
	
    });


     //function to print specific character specified in regular expression as argument
        function allowCharactersToPrint(event, regularExpression) {
            var charCode = (event.which) ? event.which : window.event.keyCode;
            var keyChar = String.fromCharCode(charCode);
            if (regularExpression.test(keyChar))
                return true;
            else
                return false;
        }
  </script>
</asp:Content>
