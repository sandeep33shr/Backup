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
    <script type="text/javascript">
        function IsAlphaNumeric(e) {
            var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
            var ret = ((keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122) || (keyCode == 44 || keyCode == 39 || keyCode==32));
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
                                                <asp:TextBox ID="txtDOB" runat="server" CssClass="field-date form-control" ></asp:TextBox><uc1:CalendarLookup ID="calDateOfBirth" runat="server" LinkedControl="txtDOB" HLevel="2"></uc1:CalendarLookup>
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
                                        <asp:Label ID="lblServiceLevel" runat="server" AssociatedControlID="ddlServiceLevel" Text="<%$ Resources:lbl_ServiceLevel%>" class="col-md-4 col-sm-3 control-label"/>
                                        <div class="col-md-8 col-sm-9">
                                            <NexusProvider:LookupList ID="ddlServiceLevel" runat="server" DataItemValue="Code" DataItemText="Description"
                                                Sort="ASC" ListType="PMLookup" ListCode="Service_Level" DefaultText=" " CssClass="field-medium form-control" />
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
                                            <asp:TextBox ID="txtFileCode" runat="server" CssClass="form-control"></asp:TextBox>
                                        </div>
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
                                            <asp:DropDownList ID="ddlBranchCode" DataTextField="Description" DataValueField="Code" runat="server" CssClass="field-medium form-control" OnSelectedIndexChanged="ddlBranchCode_SelectedIndexChanged"></asp:DropDownList>
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
                            If  String.IsNullOrEmpty(.PartyType) Then%>
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
                                    <asp:Label ID="lblServiceLevelTitle" AssociatedControlID="lblServiceLevel_view" runat="server" Text="<%$ Resources:lbl_ServiceLevel %>" class="col-md-4 col-sm-3 control-label"/>
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
        
        	GeneralValidationHandler.isDate = function(value, sepVal, dayIdx, monthIdx, yearIdx) {
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
        						
        						if(OK = Day > 0)
        						{
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
        	
        	GeneralValidationHandler.Validate = function(isOnLoad, args, obj, prop, type){
        		type = type.toLowerCase();
        		var node = document.getElementById("ctl00_cntMainBody_val" + obj.toUpperCase() + "__" + prop);
        		if (node == null){
        			// Try slightly different format with only one underscore
        			node = document.getElementById("ctl00_cntMainBody_val" + obj.toUpperCase() + "_" + prop);
        		}
        
        		if (isOnLoad) {
        			//
        			//	Add a blur event to call validation function
        			if (node != null) {
        				if (node.addEventListener) {
        					node.addEventListener('blur', function() { window['onValidate_' + obj + '__' + prop](null, null, this); } );
        				} else {
        					node.attachEvent('onblur', function() { window['onValidate_' + obj + '__' + prop](null, null, this); } );
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
        
        					if (regExp.test(value)){
        						if (value <= -1000000000 || value >= 1000000000){
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
        				if (! date instanceof Date){
        					isValid = false;
        					errorMessage = "Must be a valid date";
        				}
        			}
        
        			if (type == "currency") {
        				var value = field.getValue();
        				if (value <= -1000000000000000 || value >= 1000000000000000){
        					errorMessage = "Is out of range";
        					isValid = false;
        				}
        			}
        
        			if (type == "percentage") {
        				var value = field.getValue();
        				if (value <= -1000 || value >= 1000){
        					errorMessage = "Is out of range";
        					isValid = false;
        				}
        			}
        			
        			if (type == "text") {
        				var value = field.getValue();
        				if (value.length > 255){
        					errorMessage = "Too many characters";
        					isValid = false;
        				}
        			
        			}
        			
        			if (!isValid) {
        				if (node != null){
        					var lbl = document.getElementById('ctl00_cntMainBody_lbl' + obj + '_' + prop);
        					if (lbl != null) {
        						node.errormessage = lbl.innerHTML + " -- " + errorMessage;
        						if (args && args.IsValid == true){
        							args.IsValid = false;
        						}
        					}
        				}
        			}
        		}
        	}
        
        
        String.prototype.killWhiteSpace = function() {
            return this.replace(/\s/g, '');
        };
        
        String.prototype.reduceWhiteSpace = function() {
            return this.replace(/\s+/g, ' ');
        };
        
        var SetControlProperties = function( field, setControl, strFeaturesOn, strFeaturesOff, paramValidationMessage ){
        
        	var strFeaturesToUse
        
        	if (setControl == true){
        		strFeaturesToUse = strFeaturesOn;
        		
        		// Don't do anything if no features are provided, i.e. empty parameter
        		if (strFeaturesOn == "")
        			return;
        	} else {               
        		strFeaturesToUse = strFeaturesOff;
        	}
        
        
        	// L = Leave the attributes only
        	if (strFeaturesToUse.toLowerCase().indexOf("l") == -1
        		&& strFeaturesToUse.toLowerCase().indexOf("n") == -1) {
        	
        		if (strFeaturesToUse.toLowerCase().indexOf("e") != -1){
        			field.setReadOnly(false);
        		} else {
        			field.setReadOnly(true);
        		};
        		   
        		if (strFeaturesToUse.toLowerCase().indexOf("v") != -1){
        			field.setVisible(true);
        		} else {
        			field.setVisible(false);
        		}   
        		   
        		if (strFeaturesToUse.toLowerCase().indexOf("m") != -1){
        			field.setMandatory(true, paramValidationMessage);
        			if (strFeaturesToUse.indexOf("m") != -1){
        				// If a lower case m, 0 is not valid
        				var exp = new Expression(field.getObjectName() + "." + field.getPropertyName() + " == 0")
        				
        				goog.events.listen(exp, "change", function(){
        					if (exp.getValue() == true){
        						field.setValid(false);
        					} else {
        						field.setValid(true);
        					}
        				}, false, this);
        			}
        		} else {
        			field.setMandatory(false);
        		}   
        		
        		if (strFeaturesToUse.toLowerCase().indexOf("r") != -1){
        			field.setHidden(true);
        		} else {
        			field.setHidden(false);
        		}   
        
        		if (strFeaturesToUse.toLowerCase().indexOf("h") != -1){
        			field.setMandatory(false);
        			field.setVisible(false);
        			field.setReadOnly(true);
        		} 
        
                
        
        
        	}
        };
        
        
        
        var NormaliseCurrencyString = function(theString) {
        	
        	// Force to string
        	theString = "" + theString;
        
            var strValidChars, strNormalised, i, strChar;
        
        	strValidChars  = "0123456789.";
        	strNormalised = "";
        
        	for (var i = 0; i < theString.length; i++){
        		strChar = theString.slice(i, 1);
        		if (strValidChars.indexOf(strChar) != -1){
        			strNormalised += strChar;
        		}
        	}
        
        	if (theString.length == 0)
                strNormalised = "0";
             
        
            return strNormalised; 
        };
        
        /**
         * Get the column total.
         * @param screenObjectStr The screen object name
         * @param strObject The object string of the column to total
         * @param strProperty The property string of the column to total
         */
        var getColumnTotal = function(screenObjectStr, strObject, strProperty, condition){
        
        	var root = new XMLDataSetReader(window.XMLDataSet);
        
        	var childScreenObject = root.getObjects(screenObjectStr)[0];
        	if (childScreenObject == null)
        		return 0;
        	var childObjects = childScreenObject.getObjects(strObject);
        	
        	var total = 0;
        	for (var i = 0; i < childObjects.length; i++){
        		if (condition != null){
        			var conditionExpression = new Expression(condition);
        		} else {
        			total += window.parseFloat(childObjects[i].getPropertyValue(strProperty)) || 0;
        		}
        	};
        	return total;
        };
        /**
         * @fileoverview
         * Set property
         */
        window.setProperty = function(field, value, condition, elseValue, validationMessage){
        		
        		
        	var paramValue = value,
        		paramCondition = condition,
        		paramElseValue = elseValue,
        		paramValidationMessage = validationMessage;
        		
        	paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
        	
        	
        	
        	if (paramValue != ""){
        		var paramValueExpression = new Expression(paramValue);
        	}
        	if (Expression.isValidParameter(paramCondition)){
        		// Check for condition
        		
        		var condition = new Expression(paramCondition);
        		var update = function(){
        			paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
        			var value = condition.getValue();
        			if (value == true){
        				SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
        			} else if (Expression.isValidParameter(paramElseValue)){
        				if (paramElseValue != "U") {
        					SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
        				}
        			} else {
        				// No else value provided
        				// Set field to not visible/ non editable/ non mandatory
        				field.setVisible(false);
        				field.setMandatory(false);
        				field.setReadOnly(true);
        			}
        		};
        		events.listen(condition, "change", update);
        		update();
        	} else {
        		// Set to the value
        		paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
        		SetControlProperties(field, true, paramValue, undefined, paramValidationMessage);
        	}
        };
        /**
         * Set the control width
         */
        window.setControlWidth = function(field, width, obj, prop){
        	
        	// width sanitisation
        	if (typeof width == "string" 
        		&& ((width.slice(0,1) == "'" && width.slice(-1) == "'") || (width.slice(0,1) == "\"" || width.slice(-1) == "\""))){
        		
        		// As there is loads of rules in the spreadsheet in this format correcting this now will throw
        		// all the sizes of fields out of sync to what they were before. So to keep the same
        		// behaviour without erroring will exit out here instead.
        		return;
        		//width = width.slice(1, -1);
        	}
        	if (typeof width == "string"){
        		width = window.parseFloat(width);
        		if (width == NaN)
        			return; // Don't continue
        	}
        	
        	
        	// If the control supports setWidth, use that else fall back on other method
        	// for older controls
        	// TO keep resizing consistent we will hard code a standard width
        	var standardWidth = 165;
        	//if (field.setWidth && field.getWidth){
        	if (field.setWidth){
        		field.setWidth(standardWidth * width);
        	}
        	var sWidthClass ="";
        	var sWidthClass2 ="";
            sWidthClass = "w-25";
        	
        	// Fall back for older fields
            var ele = document.getElementById('ctl00_cntMainBody_' + obj + '__' + prop);
            if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
                ele = document.getElementById('ctl00_cntMainBody_' + obj + '__' + prop + '_' + 'txtPartyName');
            }
        	//var bounds = window.getBounds(ele);
        	var widthPx = Math.round(width * standardWidth);
        	if (width>=1)
        		sWidthClass2 = "col-md-8 col-sm-9";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-7 col-sm-8";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-6 col-sm-7";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-5 col-sm-6";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-4 col-sm-5";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-3 col-sm-4";
        	
        	if (width>=0.2 && width <0.3 )
        		sWidthClass2 ="col-md-2 col-sm-3";
        	if (width=0.1 && width <0.2 )
        		sWidthClass2 ="col-md-1 col-sm-2";
        	
        	
        	if (ele != null)
        	{
        		//ele.style.width = ((widthPx > 790) ? 790 : widthPx) + "px !important";
        		var parentClassName = ele.parentElement.className;
        		//if (parentClassName !="col-md-8 col-sm-9")
        		//{
        			//ele.parentElement.parentElement.className = ele.parentElement.parentElement.className + " " + sWidthClass ;
        		//}
        		//else
        			//ele.parentElement.className = ele.parentElement.className + " " + sWidthClass ;
        		
        		var sblEle = ele.parentElement.parentElement.previousElementSibling;
        		if (parentClassName !="col-md-8 col-sm-9")
        		{
        			ele.parentElement.parentElement.className = sWidthClass2;			
        			if (sblEle != undefined)
        			{				
        				if(sblEle.nodeName == "LABEL")
        			      sblEle.className = sWidthClass2 + " " + "control-label";
        			}
        		}
        		else
        		{
        			ele.parentElement.className = sWidthClass2;
        			if (sblEle != undefined)
        			{				
        				if(sblEle.nodeName == "LABEL")
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
        	if (textarea != null)
        	{
        		if (parentClassName !="col-md-8 col-sm-9")
        		{
        			textarea.parentElement.className = sWidthClass2 ;
        		}
        		else
        			textarea.parentElement.className = sWidthClass2;
        	}
        	
        };
function onScreenLogic(source, args, sender, isOnLoad) {
                $(document).ready(function () {
                    var NationalONloadValue = $("#ctl00_cntMainBody_GISCorporate_Nationality").val();
                    $("#ctl00_cntMainBody_PSCLIENT__NATIONALITYRD").val(NationalONloadValue);
        			var dateofbirth = $("#ctl00_cntMainBody_txtDOB").val();
        			dateofbirth = dateofbirth.replace('/', '');
        			dateofbirth = dateofbirth.replace('/', '');
        			var day = dateofbirth.substring(0, 2);
        			var month = dateofbirth.substring(2, 4);
        			var year = dateofbirth.substring(6, 8);
        			lastString = year + month + day;
        			$("#ctl00_cntMainBody_PSCLIENT__DATEOFB").val(lastString);
                });
        
        
                $(document).ready(function () {
                    $("#ctl00_cntMainBody_txtDOB").change(function () {
                        var dateofbirth = $("#ctl00_cntMainBody_txtDOB").val();
                        dateofbirth = dateofbirth.replace('/', '');
                        dateofbirth = dateofbirth.replace('/', '');
                        var day = dateofbirth.substring(0, 2);
                        var month = dateofbirth.substring(2, 4);
                        var year = dateofbirth.substring(6, 8);
                        lastString = year + month + day;
                        $("#ctl00_cntMainBody_PSCLIENT__DATEOFB").val(lastString);
                    });
                });
        
        
                $(document).ready(function () {
                    $("#ctl00_cntMainBody_PSCLIENT__IDNUMB").change(function () {
                        var dateofbirth = $("#ctl00_cntMainBody_PSCLIENT__IDNUMB").val();
                        dateofbirth = dateofbirth.substring(0, 6);        
                        $("#ctl00_cntMainBody_PSCLIENT__COMPDB").val(dateofbirth);
                    });
                });
        
                $(document).ready(function () {
                    $("#ctl00_cntMainBody_GISCorporate_Nationality").change(function () {
                        var Nationality = this.value;
                        $("#ctl00_cntMainBody_PSCLIENT__NATIONALITYRD").val(Nationality);
                    });
                });
        	
}
function onValidate_PSCLIENT__TYPEOFIDN(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PSCLIENT", "TYPEOFIDN", "List");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PSCLIENT", "TYPEOFIDN");
        		}
        		//window.setProperty(field, "VEM", "{1}", "{2}", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "{1}",
            paramElseValue = "{2}",
            paramValidationMessage = "{3}";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
              events.listen(condition, "change", update);
              update();
            } else {
              // Set to the value
              paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
              SetControlProperties(field, true, paramValue, undefined, paramValidationMessage);
            }
        
        	}
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("PSCLIENT", "TYPEOFIDN");
        		var errorMessage = "Type of Identification is mandatory and an option must be selected";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("PSCLIENT.TYPEOFIDN");
        			window.setControlWidth(field, "0.8", "PSCLIENT", "TYPEOFIDN");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblPSCLIENT_TYPEOFIDN");
        			    var ele = document.getElementById('ctl00_cntMainBody_PSCLIENT__TYPEOFIDN');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PSCLIENT__TYPEOFIDN_lblFindParty");
        			    }
        			}
        			var bounds = goog.style.getBounds(label);
        			//if (bounds.width != 0)
        				//standardWidth = bounds.width;
        			
        			//var bounds = window.getBounds(ele);
        			//if (label != null)
        				//label.style.width = Math.round(width * standardWidth) + "px";
        			var sWidthClass2="col-md-4 col-sm-3 control-label";
        			if (width>=1)
        		sWidthClass2 = "col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	
        	if (width>=0.1 && width <0.3 )
        		sWidthClass2 ="col-md-1 col-sm-1 control-label";
        	
        	label.className = sWidthClass2;
        		}, 4);
        	}
        })();
}
function onValidate_PSCLIENT__VAT_NUMBER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PSCLIENT", "VAT_NUMBER", "Text");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("PSCLIENT.VAT_NUMBER");
        			window.setControlWidth(field, "0.8", "PSCLIENT", "VAT_NUMBER");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
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
        			var sWidthClass2="col-md-4 col-sm-3 control-label";
        			if (width>=1)
        		sWidthClass2 = "col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	
        	if (width>=0.1 && width <0.3 )
        		sWidthClass2 ="col-md-1 col-sm-1 control-label";
        	
        	label.className = sWidthClass2;
        		}, 4);
        	}
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("'The vat number is invalid'")) ? "'The vat number is invalid'" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PSCLIENT".toUpperCase() + "__" + "VAT_NUMBER");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PSCLIENT".toUpperCase() + "_" + "VAT_NUMBER");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("Matches('^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][5]$', PSCLIENT.VAT_NUMBER)||PSCLIENT.VAT_NUMBER=''||PSCLIENT.VAT_NUMBER=null");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_PSCLIENT__IDNUMB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PSCLIENT", "IDNUMB", "Text");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PSCLIENT", "IDNUMB");
        		}
        		//window.setProperty(field, "VEM", "(PSCLIENT.TYPEOFIDN==1&&PSCLIENT.NATIONALITYRD =='NAMIBIAN')||PSCLIENT.TYPEOFIDN==1||PSCLIENT.TYPEOFIDN=''", "R", "ID Number is mandatory and must be entered");
        
            var paramValue = "VEM",
            paramCondition = "(PSCLIENT.TYPEOFIDN==1&&PSCLIENT.NATIONALITYRD =='NAMIBIAN')||PSCLIENT.TYPEOFIDN==1||PSCLIENT.TYPEOFIDN=''",
            paramElseValue = "R",
            paramValidationMessage = "ID Number is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
              events.listen(condition, "change", update);
              update();
            } else {
              // Set to the value
              paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
              SetControlProperties(field, true, paramValue, undefined, paramValidationMessage);
            }
        
        	}
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("PSCLIENT.IDNUMB");
        			window.setControlWidth(field, "0.8", "PSCLIENT", "IDNUMB");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblPSCLIENT_IDNUMB");
        			    var ele = document.getElementById('ctl00_cntMainBody_PSCLIENT__IDNUMB');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PSCLIENT__IDNUMB_lblFindParty");
        			    }
        			}
        			var bounds = goog.style.getBounds(label);
        			//if (bounds.width != 0)
        				//standardWidth = bounds.width;
        			
        			//var bounds = window.getBounds(ele);
        			//if (label != null)
        				//label.style.width = Math.round(width * standardWidth) + "px";
        			var sWidthClass2="col-md-4 col-sm-3 control-label";
        			if (width>=1)
        		sWidthClass2 = "col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	
        	if (width>=0.1 && width <0.3 )
        		sWidthClass2 ="col-md-1 col-sm-1 control-label";
        	
        	label.className = sWidthClass2;
        		}, 4);
        	}
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("The ID number entered is invalid, the number of characters is incorrect")) ? "The ID number entered is invalid, the number of characters is incorrect" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PSCLIENT".toUpperCase() + "__" + "IDNUMB");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PSCLIENT".toUpperCase() + "_" + "IDNUMB");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(Matches('^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$',PSCLIENT.IDNUMB) && PSCLIENT.NATIONALITYRD == 'NAMIBIAN' && PSCLIENT.TYPEOFIDN==1 ) || PSCLIENT.NATIONALITYRD != 'NAMIBIAN' || PSCLIENT.TYPEOFIDN==2 ||  PSCLIENT.TYPEOFIDN==3");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("The Date of birth does not match the Identification Number")) ? "The Date of birth does not match the Identification Number" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PSCLIENT".toUpperCase() + "__" + "IDNUMB");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PSCLIENT".toUpperCase() + "_" + "IDNUMB");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(PSCLIENT.DATEOFB ==PSCLIENT.COMPDB &&PSCLIENT.TYPEOFIDN==1)||PSCLIENT.TYPEOFIDN==2||PSCLIENT.TYPEOFIDN==3||(PSCLIENT.DATEOFB ==PSCLIENT.COMPDB &&PSCLIENT.TYPEOFIDN==0)");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_PSCLIENT__PASSPORT(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PSCLIENT", "PASSPORT", "Text");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PSCLIENT", "PASSPORT");
        		}
        		//window.setProperty(field, "VEM", "PSCLIENT.TYPEOFIDN==3", "R", "{3}");
        
            var paramValue = "VEM",
            paramCondition = "PSCLIENT.TYPEOFIDN==3",
            paramElseValue = "R",
            paramValidationMessage = "{3}";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
              events.listen(condition, "change", update);
              update();
            } else {
              // Set to the value
              paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
              SetControlProperties(field, true, paramValue, undefined, paramValidationMessage);
            }
        
        	}
        })();
        /**
         * @fileoverview
         * Check if a mandatory field has been left empty.
         * Check performed only when the page is submitted
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("PSCLIENT", "PASSPORT");
        		var errorMessage = "Passport is mandatory and must be entered";
        		field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        	};
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("The passport number entered is invalid, the number of characters is incorrect")) ? "The passport number entered is invalid, the number of characters is incorrect" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "PSCLIENT".toUpperCase() + "__" + "PASSPORT");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "PSCLIENT".toUpperCase() + "_" + "PASSPORT");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(Matches('^[P][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$',PSCLIENT.PASSPORT) &&PSCLIENT.TYPEOFIDN==3&&PSCLIENT.NATIONALITYRD=='NAMIBIAN')||PSCLIENT.TYPEOFIDN==2||PSCLIENT.TYPEOFIDN==1||PSCLIENT.TYPEOFIDN==0||(PSCLIENT.NATIONALITYRD!='NAMIBIAN'&& PSCLIENT.TYPEOFIDN==3)");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("PSCLIENT.PASSPORT");
        			window.setControlWidth(field, "0.8", "PSCLIENT", "PASSPORT");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblPSCLIENT_PASSPORT");
        			    var ele = document.getElementById('ctl00_cntMainBody_PSCLIENT__PASSPORT');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PSCLIENT__PASSPORT_lblFindParty");
        			    }
        			}
        			var bounds = goog.style.getBounds(label);
        			//if (bounds.width != 0)
        				//standardWidth = bounds.width;
        			
        			//var bounds = window.getBounds(ele);
        			//if (label != null)
        				//label.style.width = Math.round(width * standardWidth) + "px";
        			var sWidthClass2="col-md-4 col-sm-3 control-label";
        			if (width>=1)
        		sWidthClass2 = "col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	
        	if (width>=0.1 && width <0.3 )
        		sWidthClass2 ="col-md-1 col-sm-1 control-label";
        	
        	label.className = sWidthClass2;
        		}, 4);
        	}
        })();
}
function onValidate_PSCLIENT__DRIVERS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PSCLIENT", "DRIVERS", "Text");
        })();
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("{name}" != "{na" + "me}"){
        			field = Field.getLabel("{name}");
        		} else { 
        			field = Field.getInstance("PSCLIENT", "DRIVERS");
        		}
        		//window.setProperty(field, "R", "PSCLIENT.TYPEOFIDN==3 ||PSCLIENT.TYPEOFIDN==1||PSCLIENT.TYPEOFIDN=''", "VEM", "Driver's License is mandatory and must be entered");
        
            var paramValue = "R",
            paramCondition = "PSCLIENT.TYPEOFIDN==3 ||PSCLIENT.TYPEOFIDN==1||PSCLIENT.TYPEOFIDN=''",
            paramElseValue = "VEM",
            paramValidationMessage = "Driver's License is mandatory and must be entered";
            
            paramValidationMessage = (Expression.isValidParameter(paramValidationMessage)) ? paramValidationMessage : undefined;
            
            if (paramValue != ""){
              var paramValueExpression = new Expression(paramValue);
            }
            if (Expression.isValidParameter(paramCondition)){
              // Check for condition
              
              var condition = new Expression(paramCondition);
              var update = function(){
                paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
                var value = condition.getValue();
                if (value == true){
                  SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                } else if (Expression.isValidParameter(paramElseValue)){
                  if (paramElseValue != "U") {
                    SetControlProperties(field, value, paramValue, paramElseValue, paramValidationMessage);
                  }
                } else {
                  // No else value provided
                  // Set field to not visible/ non editable/ non mandatory
                  field.setVisible(false);
                  field.setMandatory(false);
                  field.setReadOnly(true);
                }
              };
              events.listen(condition, "change", update);
              update();
            } else {
              // Set to the value
              paramValue = (paramValueExpression) ? paramValueExpression.getValue() : paramValue;
              SetControlProperties(field, true, paramValue, undefined, paramValidationMessage);
            }
        
        	}
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("PSCLIENT.DRIVERS");
        			window.setControlWidth(field, "0.8", "PSCLIENT", "DRIVERS");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblPSCLIENT_DRIVERS");
        			    var ele = document.getElementById('ctl00_cntMainBody_PSCLIENT__DRIVERS');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PSCLIENT__DRIVERS_lblFindParty");
        			    }
        			}
        			var bounds = goog.style.getBounds(label);
        			//if (bounds.width != 0)
        				//standardWidth = bounds.width;
        			
        			//var bounds = window.getBounds(ele);
        			//if (label != null)
        				//label.style.width = Math.round(width * standardWidth) + "px";
        			var sWidthClass2="col-md-4 col-sm-3 control-label";
        			if (width>=1)
        		sWidthClass2 = "col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	
        	if (width>=0.1 && width <0.3 )
        		sWidthClass2 ="col-md-1 col-sm-1 control-label";
        	
        	label.className = sWidthClass2;
        		}, 4);
        	}
        })();
}
function onValidate_PSCLIENT__FIA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PSCLIENT", "FIA", "Checkbox");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("PSCLIENT.FIA");
        			window.setControlWidth(field, "0.8", "PSCLIENT", "FIA");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
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
        			var sWidthClass2="col-md-4 col-sm-3 control-label";
        			if (width>=1)
        		sWidthClass2 = "col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	
        	if (width>=0.1 && width <0.3 )
        		sWidthClass2 ="col-md-1 col-sm-1 control-label";
        	
        	label.className = sWidthClass2;
        		}, 4);
        	}
        })();
}
function onValidate_PSCLIENT__NATIONALITYRD(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PSCLIENT", "NATIONALITYRD", "Text");
        })();
        /**
         * @fileoverview
         * NotOnPage. Set field to hidden, hidden doesn't take up space in the document.
         */
        (function(){
        	if (isOnLoad) {		
        		if ("{name}" != ("{na" + "me}")){
        			var field = Field.getLabel("{name}");
        		} else {
        			var field = Field.getInstance("PSCLIENT", "NATIONALITYRD");
        		}
        		var exp = Expression.isValidParameter("{0}") ? new Expression("{0}") : true;
        
        		var update = function(){
        			var isHidden = (exp === true || exp.getValue() == true);
        			field.setHidden(isHidden);
        		};
        		if (Expression.isValidParameter("{0}")){
        			events.listen(exp, "change",update);
        			events.listen(exp, "visibilitychange",update);
        			events.listen(exp, "displaychange",update);
        		}
        		update();
        	};
        })();
}
function onValidate_PSCLIENT__DATEOFB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PSCLIENT", "DATEOFB", "Text");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("PSCLIENT.DATEOFB");
        			window.setControlWidth(field, "0.8", "PSCLIENT", "DATEOFB");
        		})();
        	}
        })();
        /**
         * Set the label width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		window.setTimeout(function(){
        
        			var width = window.parseFloat("1");
        			var standardWidth = 165;
        			if ("{name}" != "{na" + "me}"){
        				var label = document.getElementById("{name}");
        				// Walk up the dom, if a co-cell is found use that intead
        				if (label.parentNode.parentNode.parentNode.className.toLowerCase() == "co-cell")
        					label = label.parentNode.parentNode.parentNode;
        			} else {
        			    var label = document.getElementById("ctl00_cntMainBody_lblPSCLIENT_DATEOFB");
        			    var ele = document.getElementById('ctl00_cntMainBody_PSCLIENT__DATEOFB');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_PSCLIENT__DATEOFB_lblFindParty");
        			    }
        			}
        			var bounds = goog.style.getBounds(label);
        			//if (bounds.width != 0)
        				//standardWidth = bounds.width;
        			
        			//var bounds = window.getBounds(ele);
        			//if (label != null)
        				//label.style.width = Math.round(width * standardWidth) + "px";
        			var sWidthClass2="col-md-4 col-sm-3 control-label";
        			if (width>=1)
        		sWidthClass2 = "col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.9 && width <1.0)
        		sWidthClass2 ="col-md-4 col-sm-3 control-label";
        	
        	if (width>=0.8 && width <0.9)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.7 && width <0.8)
        		sWidthClass2 ="col-md-3 col-sm-2 control-label";
        	
        	if (width>=0.5 && width <0.7)
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	if (width>=0.3 && width <0.5 )
        		sWidthClass2 ="col-md-2 col-sm-1 control-label";
        	
        	if (width>=0.1 && width <0.3 )
        		sWidthClass2 ="col-md-1 col-sm-1 control-label";
        	
        	label.className = sWidthClass2;
        		}, 4);
        	}
        })();
        /**
         * @fileoverview
         * NotOnPage. Set field to hidden, hidden doesn't take up space in the document.
         */
        (function(){
        	if (isOnLoad) {		
        		if ("{name}" != ("{na" + "me}")){
        			var field = Field.getLabel("{name}");
        		} else {
        			var field = Field.getInstance("PSCLIENT", "DATEOFB");
        		}
        		var exp = Expression.isValidParameter("{0}") ? new Expression("{0}") : true;
        
        		var update = function(){
        			var isHidden = (exp === true || exp.getValue() == true);
        			field.setHidden(isHidden);
        		};
        		if (Expression.isValidParameter("{0}")){
        			events.listen(exp, "change",update);
        			events.listen(exp, "visibilitychange",update);
        			events.listen(exp, "displaychange",update);
        		}
        		update();
        	};
        })();
}
function onValidate_PSCLIENT__COMPDB(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "PSCLIENT", "COMPDB", "Text");
        })();
        /**
         * @fileoverview
         * NotOnPage. Set field to hidden, hidden doesn't take up space in the document.
         */
        (function(){
        	if (isOnLoad) {		
        		if ("{name}" != ("{na" + "me}")){
        			var field = Field.getLabel("{name}");
        		} else {
        			var field = Field.getInstance("PSCLIENT", "COMPDB");
        		}
        		var exp = Expression.isValidParameter("{0}") ? new Expression("{0}") : true;
        
        		var update = function(){
        			var isHidden = (exp === true || exp.getValue() == true);
        			field.setHidden(isHidden);
        		};
        		if (Expression.isValidParameter("{0}")){
        			events.listen(exp, "change",update);
        			events.listen(exp, "visibilitychange",update);
        			events.listen(exp, "displaychange",update);
        		}
        		update();
        	};
        })();
}
function DoLogic(isOnLoad) {
    onScreenLogic(null, null, null, isOnLoad);
    onValidate_PSCLIENT__TYPEOFIDN(null, null, null, isOnLoad);
    onValidate_PSCLIENT__VAT_NUMBER(null, null, null, isOnLoad);
    onValidate_PSCLIENT__IDNUMB(null, null, null, isOnLoad);
    onValidate_PSCLIENT__PASSPORT(null, null, null, isOnLoad);
    onValidate_PSCLIENT__DRIVERS(null, null, null, isOnLoad);
    onValidate_PSCLIENT__FIA(null, null, null, isOnLoad);
    onValidate_PSCLIENT__NATIONALITYRD(null, null, null, isOnLoad);
    onValidate_PSCLIENT__DATEOFB(null, null, null, isOnLoad);
    onValidate_PSCLIENT__COMPDB(null, null, null, isOnLoad);
}
</script>

    
	<script type="text/javascript">
	
	<%
		Dim xmlset As String = Session(Nexus.Constants.CNParty).XMLDataset
		If xmlset is Nothing Then
			xmlset = "<?xml version=""1.0"" encoding=""UTF-16"" standalone=""no""?><DATA_SET />"
		Else
			xmlset = xmlset.Replace("'", "\'").Replace(vbCr, "").Replace(vbLf, "")
			xmlset = xmlset.Substring(0, xmlset.IndexOf("<!DOCTYPE DATA_SET")) & xmlset.Substring(xmlset.IndexOf("<DATA_SET"))
		End If
		
		' Output the IO Number
		Dim oOIText As String
		Dim oOI As Collections.Stack
		oOI = Session.Item(Nexus.Constants.CNOI)
		If Not oOI is Nothing Then
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
<div id="idbc2b32ecff3243bbbc718c42edef4083" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="frmInformationBox" class="column-layout-container,no-border  ">
		
				
	              <legend><asp:Label ID="lblHeading1" runat="server" Text=" " /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="PSCLIENT" 
		data-property-name="TYPEOFIDN" 
		id="pb-container-list-PSCLIENT-TYPEOFIDN">
		<asp:Label ID="lblPSCLIENT_TYPEOFIDN" runat="server" AssociatedControlID="PSCLIENT__TYPEOFIDN" 
			Text="Type of Identification" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="PSCLIENT__TYPEOFIDN" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_TYPE_OF_ID" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_PSCLIENT__TYPEOFIDN(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valPSCLIENT_TYPEOFIDN" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Type of Identification"
			ClientValidationFunction="onValidate_PSCLIENT__TYPEOFIDN" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
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
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="PSCLIENT" 
		data-property-name="IDNUMB" 
		 
		
		 
		id="pb-container-text-PSCLIENT-IDNUMB">

		
		<asp:Label ID="lblPSCLIENT_IDNUMB" runat="server" AssociatedControlID="PSCLIENT__IDNUMB" 
			Text="ID Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PSCLIENT__IDNUMB" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPSCLIENT_IDNUMB" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for ID Number"
					ClientValidationFunction="onValidate_PSCLIENT__IDNUMB"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="PSCLIENT" 
		data-property-name="PASSPORT" 
		 
		
		 
		id="pb-container-text-PSCLIENT-PASSPORT">

		
		<asp:Label ID="lblPSCLIENT_PASSPORT" runat="server" AssociatedControlID="PSCLIENT__PASSPORT" 
			Text="Passport" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PSCLIENT__PASSPORT" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPSCLIENT_PASSPORT" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Passport"
					ClientValidationFunction="onValidate_PSCLIENT__PASSPORT"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="PSCLIENT" 
		data-property-name="DRIVERS" 
		 
		
		 
		id="pb-container-text-PSCLIENT-DRIVERS">

		
		<asp:Label ID="lblPSCLIENT_DRIVERS" runat="server" AssociatedControlID="PSCLIENT__DRIVERS" 
			Text="Driver's License" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PSCLIENT__DRIVERS" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPSCLIENT_DRIVERS" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Driver's License"
					ClientValidationFunction="onValidate_PSCLIENT__DRIVERS"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
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
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="PSCLIENT" 
		data-property-name="NATIONALITYRD" 
		 
		
		 
		id="pb-container-text-PSCLIENT-NATIONALITYRD">

		
		<asp:Label ID="lblPSCLIENT_NATIONALITYRD" runat="server" AssociatedControlID="PSCLIENT__NATIONALITYRD" 
			Text="NATIONALITY" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PSCLIENT__NATIONALITYRD" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPSCLIENT_NATIONALITYRD" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for NATIONALITY"
					ClientValidationFunction="onValidate_PSCLIENT__NATIONALITYRD"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="PSCLIENT" 
		data-property-name="DATEOFB" 
		 
		
		 
		id="pb-container-text-PSCLIENT-DATEOFB">

		
		<asp:Label ID="lblPSCLIENT_DATEOFB" runat="server" AssociatedControlID="PSCLIENT__DATEOFB" 
			Text="Date of birth " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PSCLIENT__DATEOFB" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPSCLIENT_DATEOFB" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Date of birth "
					ClientValidationFunction="onValidate_PSCLIENT__DATEOFB"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="PSCLIENT" 
		data-property-name="COMPDB" 
		 
		
		 
		id="pb-container-text-PSCLIENT-COMPDB">

		
		<asp:Label ID="lblPSCLIENT_COMPDB" runat="server" AssociatedControlID="PSCLIENT__COMPDB" 
			Text="6 Characters" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="PSCLIENT__COMPDB" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valPSCLIENT_COMPDB" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for 6 Characters"
					ClientValidationFunction="onValidate_PSCLIENT__COMPDB"
					ValidationGroup=""
					Display="None"
					EnableClientScript="true"
					/>
                </div>
					
		
	
		
	</span>
</div>
        
<!-- /Text -->
								
									</li>
							
							
						
					</ul>
				
				</div>
				
			
</div>


<script type="text/javascript">
	var labelAlign = "";
	var textAlign = "";
	var labelWidth = "";	
	
	$(document).ready(function(){
		var liElementHeight = 0;	
		var liMaxHeight = 0;
		var liMinHeight = 46;
		var liRowElement = 0;
		var recordArray = new Array();
		var arrayCount = 0;
		if ($("#frmInformationBox div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmInformationBox div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmInformationBox div ul li").each(function(){		  
			  liElementHeight = $(this).height();	
				
			  if (liElementHeight < liMinHeight)
			  {
				  liElementHeight = liMinHeight;			  
			  }
			  
			  if (liMaxHeight != 0 && liMaxHeight > liMinHeight)
			  {
				  if (liElementHeight > liMaxHeight)
				  {
					  liElementHeight = liMaxHeight;			  
				  }	
			  }			 

			  if (liRowElement == (columnCount -1))
			  {
				  liRowElement = 0;			 
				  recordArray[arrayCount] = liElementHeight;		  
				  arrayCount++;
				  liElementHeight = 0;
				  
			  }
			  else{
				  liRowElement++;
			  }		
			  
			});
			
			liRowElement =0;
			arrayCount= 0;
			$("#frmInformationBox div ul li").each(function(){		  
			  $(this).height(recordArray[arrayCount]);
			  if (liRowElement == (columnCount -1))
			   {
				liRowElement = 0;
				arrayCount++;
			   }
			  else{
				liRowElement++;
			  } 		  
			});
			}
	});	
	
	var styleString = "";
	if (labelWidth != ""){
		if ((new Expression("IsNumeric('" + labelWidth + "')")).valueOf()){
			labelWidth = labelWidth + "px";
		}
		styleString += "#frmInformationBox label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmInformationBox label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmInformationBox label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmInformationBox label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmInformationBox input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmInformationBox input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmInformationBox input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
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
</asp:Content>
