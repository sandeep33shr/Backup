<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CorporateClientDetails.aspx.vb" Inherits="Nexus.secure_CorporateClientDetails" Title="Untitled Page" MasterPageFile="~/default.master" EnableViewState="true" %>

<%@ Register Src="~/controls/CalendarLookup.ascx" TagName="CalendarLookup" TagPrefix="uc1" %>
<%@ Register TagPrefix="Nexus" Namespace="Nexus" %>
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
<%@ Register Src="~/Controls/ClientEvents.ascx" TagName="ClientEvents" TagPrefix="uc9" %>
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
            var strCookieValue = document.cookie;
            if (strCookieValue.indexOf("!~") != 0) {
                var intS = strCookieValue.indexOf("!~");
                var intE = strCookieValue.indexOf("~!");
                var strActiveTabName = strCookieValue.substring(intS + 2, intE);
                var jquerySearchStr = ".tab-container li a[href=" + strActiveTabName + "]";
                $("'" + jquerySearchStr + "'").click();
            }

            $("#ctl00_cntMainBody_pnlViewCC .tab-container li a").click(function () {
                document.cookie = "tabName!~" + $(this).attr("href") + "~!";
            });

            $(".tab-container li a").click(function () {
                $("div#inner_content").hide();
                var firsttab = $(".tab-container li a").first().html();
                var thistab = $(this).html();
                if (thistab == firsttab) {
                    $("div#inner_content").show();
                }
            });
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
                            <li><a href="#tab-editaccount"  data-toggle="tab" aria-expanded="true">Accounts</a></li>
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
                                        <asp:CustomValidator ID="cusvlPreferredCorrespondence" runat="server" Display="None" OnServerValidate="cusvlPreferredCorrespondence_ServerValidate" ValidationGroup="CorporateClientGroup"></asp:CustomValidator>
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
                            <div id="tab-editaccount"  class="tab-pane animated fadeIn" role="tabpanel">
                                <uc10:ClientAccounts ID="ClientAccounts" runat="server"></uc10:ClientAccounts> />
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
        /**
         * Set the value of a field. When any of the passed in expressions
         * change the set value is re-evaluated.
         * @param {pb.fields.AbstractBase} field The field
         * @param {Expression} value The value to give the field
         * @param {Expression} opt_condition If specified the value will 
         * only be set when this evaluates to true.
         * @param {Expression} opt_elseValue If specified this is the value
         * that will be set when the condition evaluates to false, if 
         * omitted then no value will be set on condition false.
         */
        window.setValue = function(field, value, opt_condition, opt_elseValue){
        	
        		// Helper class to handle the condition and else logic.
        		var valueWhen = new ValueWhenHelper(value, opt_condition, opt_elseValue);
        		
        		var update;
        		events.listen(valueWhen, "change", update = function(e){
        			// Don't set a value if one doesn't exist, this occurs if the condition
        			// is false but no else value is provided.
        			var value = valueWhen.valueOf();
        			// null is a valid value
        			if (value === undefined)
        				return;
        			
        			field.setValue(value);
        		}, false, this);
        		update();
        };
        
        
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
function onScreenLogic(source, args, sender, isOnLoad) {
        
        		
         $(document).ready(function () {
                  $("#ctl00_cntMainBody_btnSubmit").click(function () {
        		var CompanyReg = $("#ctl00_cntMainBody_CCLIENT__COMP_REG_NUMBER").val();
                      $("#ctl00_cntMainBody_txtFileCode").val(CompanyReg);
                  });
              });
        
        
         $(document).ready(function () {
               $("#ctl00_cntMainBody_btnSubmit").click(function () {
                var FileCode = $("#ctl00_cntMainBody_txtFileCode").val();
                   $("#ctl00_cntMainBody_CCLIENT__COMP_REG_NUMBER").val(FileCode);
        
               });
           });
        
        $(document).ready(function () {
                $("#ctl00_cntMainBody_txtFileCode").change(function () {
                    var FileCode = this.value;
                    $("#ctl00_cntMainBody_CCLIENT__COMP_REG_NUMBER").val(FileCode);
        
        
        
                });
            });
        
        $(document).ready(function () {
                $("#ctl00_cntMainBody_CCLIENT__COMP_REG_NUMBER").change(function () {
                    var FileCode = this.value;
                    $("#ctl00_cntMainBody_txtFileCode").val(FileCode);
        
                });
            });
        
        
         $(document).ready(function () {
         var FileCode = $("#ctl00_cntMainBody_txtFileCode").val();
         var FileCodeLabel = $("#ctl00_cntMainBody_lblFileCode_view").text();
         
         if (FileCodeLabel!="") 
         {
        	 
                    $("#ctl00_cntMainBody_CCLIENT__COMP_REG_NUMBER").val(FileCodeLabel);
         }
         
         else if (FileCode!="")
         {
        	     $("#ctl00_cntMainBody_CCLIENT__COMP_REG_NUMBER").val(FileCode);
         }
        });
        
        
        
        
        
        
        
        
        		
}
function onValidate_CCLIENT__VAT_NUMBER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "VAT_NUMBER", "Text");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.VAT_NUMBER");
        			window.setControlWidth(field, "0.8", "CCLIENT", "VAT_NUMBER");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCCLIENT_VAT_NUMBER");
        			    var ele = document.getElementById('ctl00_cntMainBody_CCLIENT__VAT_NUMBER');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_CCLIENT__VAT_NUMBER_lblFindParty");
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
        			var message = (Expression.isValidParameter("Please enter a valid vat number")) ? "Please enter a valid vat number" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "CCLIENT".toUpperCase() + "__" + "VAT_NUMBER");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "CCLIENT".toUpperCase() + "_" + "VAT_NUMBER");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("Matches('^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][5]$', CCLIENT.VAT_NUMBER)||(CCLIENT.VAT_NUMBER='')");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_CCLIENT__TYPECOMPANY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "TYPECOMPANY", "List");
        })();
        /**
         * @fileoverview
         * RequiredWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("CCLIENT", "TYPECOMPANY");
        		var exp = new Expression("CCLIENT.TYPECOMPANY==''");
        		var errorMessage = "Type of Company is mandatory and an option must be selected";
        		var go = function(){
        			if (exp.getValue() == true){
        				field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        			} else {
        				field.setMandatory(false);
        			}
        		};
        		go();
        		events.listen(exp, "change", go);
        		// If the field is hidden it may have a required when isVisible in the rule.
        		events.listen(field, "visibilitychange", go);
        		events.listen(field, "displaychange", go);
        		
        	};
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.TYPECOMPANY");
        			window.setControlWidth(field, "0.8", "CCLIENT", "TYPECOMPANY");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCCLIENT_TYPECOMPANY");
        			    var ele = document.getElementById('ctl00_cntMainBody_CCLIENT__TYPECOMPANY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_CCLIENT__TYPECOMPANY_lblFindParty");
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
function onValidate_CCLIENT__DTOFINC(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "DTOFINC", "Date");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.DTOFINC");
        			window.setControlWidth(field, "0.8", "CCLIENT", "DTOFINC");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCCLIENT_DTOFINC");
        			    var ele = document.getElementById('ctl00_cntMainBody_CCLIENT__DTOFINC');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_CCLIENT__DTOFINC_lblFindParty");
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
function onValidate_CCLIENT__COMP_REG_NUMBER(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "COMP_REG_NUMBER", "Text");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.COMP_REG_NUMBER");
        			window.setControlWidth(field, "0.8", "CCLIENT", "COMP_REG_NUMBER");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCCLIENT_COMP_REG_NUMBER");
        			    var ele = document.getElementById('ctl00_cntMainBody_CCLIENT__COMP_REG_NUMBER');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_CCLIENT__COMP_REG_NUMBER_lblFindParty");
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
function onValidate_CCLIENT__FIA(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "FIA", "Checkbox");
        })();
        /**
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.FIA");
        			window.setControlWidth(field, "0.8", "CCLIENT", "FIA");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCCLIENT_FIA");
        			    var ele = document.getElementById('ctl00_cntMainBody_CCLIENT__FIA');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_CCLIENT__FIA_lblFindParty");
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
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=CCLIENT&propertyName=FIA&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("CCLIENT.FIA = null")) ? new Expression("CCLIENT.FIA = null") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
}
function onValidate_CCLIENT__PRIMARY_INDUSTRY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "PRIMARY_INDUSTRY", "RateList");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCCLIENT_PRIMARY_INDUSTRY");
        			    var ele = document.getElementById('ctl00_cntMainBody_CCLIENT__PRIMARY_INDUSTRY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_CCLIENT__PRIMARY_INDUSTRY_lblFindParty");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.PRIMARY_INDUSTRY");
        			window.setControlWidth(field, "0.8", "CCLIENT", "PRIMARY_INDUSTRY");
        		})();
        	}
        })();
}
function onValidate_CCLIENT__SECOND_INDUSTRY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "SECOND_INDUSTRY", "RateList");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCCLIENT_SECOND_INDUSTRY");
        			    var ele = document.getElementById('ctl00_cntMainBody_CCLIENT__SECOND_INDUSTRY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_CCLIENT__SECOND_INDUSTRY_lblFindParty");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.SECOND_INDUSTRY");
        			window.setControlWidth(field, "0.8", "CCLIENT", "SECOND_INDUSTRY");
        		})();
        	}
        })();
}
function onValidate_CCLIENT__TERTIARY_INDUSTRY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "TERTIARY_INDUSTRY", "RateList");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCCLIENT_TERTIARY_INDUSTRY");
        			    var ele = document.getElementById('ctl00_cntMainBody_CCLIENT__TERTIARY_INDUSTRY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_CCLIENT__TERTIARY_INDUSTRY_lblFindParty");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.TERTIARY_INDUSTRY");
        			window.setControlWidth(field, "0.8", "CCLIENT", "TERTIARY_INDUSTRY");
        		})();
        	}
        })();
}
function onValidate_CCLIENT__INDUSTRY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "INDUSTRY", "RateList");
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCCLIENT_INDUSTRY");
        			    var ele = document.getElementById('ctl00_cntMainBody_CCLIENT__INDUSTRY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_CCLIENT__INDUSTRY_lblFindParty");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.INDUSTRY");
        			window.setControlWidth(field, "0.8", "CCLIENT", "INDUSTRY");
        		})();
        	}
        })();
}
function onValidate_CCLIENT__IS_BONDS(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "IS_BONDS", "Checkbox");
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
        			field = Field.getInstance("CCLIENT", "IS_BONDS");
        		}
        		//window.setProperty(field, "VE", "CCLIENT.USERLEVEL = 3", "V", "{3}");
        
            var paramValue = "VE",
            paramCondition = "CCLIENT.USERLEVEL = 3",
            paramElseValue = "V",
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCCLIENT_IS_BONDS");
        			    var ele = document.getElementById('ctl00_cntMainBody_CCLIENT__IS_BONDS');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_CCLIENT__IS_BONDS_lblFindParty");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.IS_BONDS");
        			window.setControlWidth(field, "0.8", "CCLIENT", "IS_BONDS");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * SetValue
         */
        (function(){
        	if (isOnLoad) {		
        		// Get the field
        		var field = Field.getWithQuery("type=Checkbox&objectName=CCLIENT&propertyName=IS_BONDS&name={name}");
        		
        		var value = new Expression("0"), 
        			condition = (Expression.isValidParameter("CCLIENT.IS_BONDS = null")) ? new Expression("CCLIENT.IS_BONDS = null") : null, 
        			elseValue = (Expression.isValidParameter("{2}")) ? new Expression("{2}") : null;
        		
        		window.setValue(field, value, condition, elseValue);
        	};
        })();
        /** 
         * ToggleContainer
         * @param frmFacility2 The element to toggle
         * @param {1} True if the element should be toggle'd when the control is unticked instead of ticked.
         * Defaults to false.
         */
        (function(){
        	
        	
        	if (isOnLoad) {
        		var field = Field.getInstance("CCLIENT","IS_BONDS");
        	
        		var inverse = (Expression.isValidParameter("{1}") && ("{1}".toLowerCase() == "true")) ? true : false;
        		var update = function(){
        			var value = (field.getValue() != true) ? "false" : "true";
        			
        			if (!inverse){
        				(new Expression("SetElementDisplay('frmFacility2', !!" + value + ")")).valueOf();
        			} else {
        				(new Expression("SetElementDisplay('frmFacility2', !" + value + ")")).valueOf();
        			}
        		};
        		events.listen(Field.getInstance("CCLIENT", "IS_BONDS"), "change", update);
        		update();
        	}
        
        })();
}
function onValidate_label1(source, args, sender, isOnLoad) {
        /**
         * @fileoverview
         * Set property
         */
        (function(){
        	if (isOnLoad) {	
        		var field
        		if ("label1" != "{na" + "me}"){
        			field = Field.getLabel("label1");
        		} else { 
        			field = Field.getInstance("", "");
        		}
        		//window.setProperty(field, "V", "CCLIENT.USERLEVEL <> 3", "R", "{3}");
        
            var paramValue = "V",
            paramCondition = "CCLIENT.USERLEVEL <> 3",
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
}
function onValidate_CCLIENT__USERLEVEL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "USERLEVEL", "Integer");
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
        			var field = Field.getInstance("CCLIENT", "USERLEVEL");
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
function onValidate_CCLIENT__FACILITY_MAX(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "FACILITY_MAX", "Currency");
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
        			field = Field.getInstance("CCLIENT", "FACILITY_MAX");
        		}
        		//window.setProperty(field, "VEM", "CCLIENT.IS_BONDS = 1 && CCLIENT.USERLEVEL = 3", "V", "Current Maximum Facility is mandatory and an amount must be entered");
        
            var paramValue = "VEM",
            paramCondition = "CCLIENT.IS_BONDS = 1 && CCLIENT.USERLEVEL = 3",
            paramElseValue = "V",
            paramValidationMessage = "Current Maximum Facility is mandatory and an amount must be entered";
            
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
              var field = Field.getInstance("CCLIENT.FACILITY_MAX");
        			window.setControlWidth(field, "0.8", "CCLIENT", "FACILITY_MAX");
        		})();
        	}
        })();
}
function onValidate_CCLIENT__FACILITY_AVAIL(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "FACILITY_AVAIL", "Currency");
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
        			field = Field.getInstance("CCLIENT", "FACILITY_AVAIL");
        		}
        		//window.setProperty(field, "V", "{1}", "{2}", "{3}");
        
            var paramValue = "V",
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.FACILITY_AVAIL");
        			window.setControlWidth(field, "0.8", "CCLIENT", "FACILITY_AVAIL");
        		})();
        	}
        })();
}
function onValidate_CCLIENT__FACILITY_RATE(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "FACILITY_RATE", "Percentage");
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
        			field = Field.getInstance("CCLIENT", "FACILITY_RATE");
        		}
        		//window.setProperty(field, "VEM", "CCLIENT.IS_BONDS = 1 && CCLIENT.USERLEVEL = 3", "V", "Current Facility Rate is mandatory and a value must be entered");
        
            var paramValue = "VEM",
            paramCondition = "CCLIENT.IS_BONDS = 1 && CCLIENT.USERLEVEL = 3",
            paramElseValue = "V",
            paramValidationMessage = "Current Facility Rate is mandatory and a value must be entered";
            
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
              var field = Field.getInstance("CCLIENT.FACILITY_RATE");
        			window.setControlWidth(field, "0.8", "CCLIENT", "FACILITY_RATE");
        		})();
        	}
        })();
        /**
         * @fileoverview
         * ValidWhen
         */
        (function(){
        	
        	if (args && args.IsValid == true){
        	
        		var setInvalid = function(){
        			var message = (Expression.isValidParameter("Facility Rate entered must be between 0 and 100")) ? "Facility Rate entered must be between 0 and 100" : null;
        			args.IsValid = false;
        			if (message != null){
        				var node = document.getElementById("ctl00_cntMainBody_val" + "CCLIENT".toUpperCase() + "__" + "FACILITY_RATE");
        				if (node == null){
        					// Try slightly different format with only one underscore
        					node = document.getElementById("ctl00_cntMainBody_val" + "CCLIENT".toUpperCase() + "_" + "FACILITY_RATE");
        				}
        				if (node != null){
        					node.errormessage = message;
        				}
        			}
        		};
        	
        		var exp;
        		try {
        			exp = new Expression("(CCLIENT.FACILITY_RATE > 0 && CCLIENT.FACILITY_RATE <= 100) || CCLIENT.IS_BONDS = 0");
        		} catch (e){
        			setInvalid();
        			return;
        		}
        		if (exp.getValue() != true)
        			setInvalid();
        	}
        })();
}
function onValidate_CCLIENT__FACILITY_EXPIRY(source, args, sender, isOnLoad) {
        
        /**
         * @fileoverview
         * GeneralValidation
         */
        (function(){
        	GeneralValidationHandler.Validate(isOnLoad, args, "CCLIENT", "FACILITY_EXPIRY", "Date");
        })();
        /**
         * @fileoverview
         * RequiredWhen
         */
        (function(){
        	
        	if (isOnLoad) {		
        		var field = Field.getInstance("CCLIENT", "FACILITY_EXPIRY");
        		var exp = new Expression("CCLIENT.IS_BONDS = 1 && CCLIENT.USERLEVEL = 3");
        		var errorMessage = "{1}";
        		var go = function(){
        			if (exp.getValue() == true){
        				field.setMandatory(true, (Expression.isValidParameter(errorMessage)) ? errorMessage : undefined);
        			} else {
        				field.setMandatory(false);
        			}
        		};
        		go();
        		events.listen(exp, "change", go);
        		// If the field is hidden it may have a required when isVisible in the rule.
        		events.listen(field, "visibilitychange", go);
        		events.listen(field, "displaychange", go);
        		
        	};
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
        			    var label = document.getElementById("ctl00_cntMainBody_lblCCLIENT_FACILITY_EXPIRY");
        			    var ele = document.getElementById('ctl00_cntMainBody_CCLIENT__FACILITY_EXPIRY');
        			    if (ele.firstElementChild != null && ele.firstElementChild.id == 'Controls_FindParty') {
        			        label = document.getElementById("ctl00_cntMainBody_CCLIENT__FACILITY_EXPIRY_lblFindParty");
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
         * Set the control width
         */
        (function(){
        	
        	if (isOnLoad) {	
        		(function(){
              var field = Field.getInstance("CCLIENT.FACILITY_EXPIRY");
        			window.setControlWidth(field, "0.8", "CCLIENT", "FACILITY_EXPIRY");
        		})();
        	}
        })();
}
function DoLogic(isOnLoad) {
    onScreenLogic(null, null, null, isOnLoad);
    onValidate_CCLIENT__VAT_NUMBER(null, null, null, isOnLoad);
    onValidate_CCLIENT__TYPECOMPANY(null, null, null, isOnLoad);
    onValidate_CCLIENT__DTOFINC(null, null, null, isOnLoad);
    onValidate_CCLIENT__COMP_REG_NUMBER(null, null, null, isOnLoad);
    onValidate_CCLIENT__FIA(null, null, null, isOnLoad);
    onValidate_CCLIENT__PRIMARY_INDUSTRY(null, null, null, isOnLoad);
    onValidate_CCLIENT__SECOND_INDUSTRY(null, null, null, isOnLoad);
    onValidate_CCLIENT__TERTIARY_INDUSTRY(null, null, null, isOnLoad);
    onValidate_CCLIENT__INDUSTRY(null, null, null, isOnLoad);
    onValidate_CCLIENT__IS_BONDS(null, null, null, isOnLoad);
    onValidate_label1(null, null, null, isOnLoad);
    onValidate_CCLIENT__USERLEVEL(null, null, null, isOnLoad);
    onValidate_CCLIENT__FACILITY_MAX(null, null, null, isOnLoad);
    onValidate_CCLIENT__FACILITY_AVAIL(null, null, null, isOnLoad);
    onValidate_CCLIENT__FACILITY_RATE(null, null, null, isOnLoad);
    onValidate_CCLIENT__FACILITY_EXPIRY(null, null, null, isOnLoad);
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
<div id="id509f05ba7bc74e6ea72c981cf2d66f6b" class="general-layout-container">
				
         
				
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="frmInformationBox" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading1" runat="server" Text=" " /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CCLIENT" 
		data-property-name="VAT_NUMBER" 
		 
		
		 
		id="pb-container-text-CCLIENT-VAT_NUMBER">

		
		<asp:Label ID="lblCCLIENT_VAT_NUMBER" runat="server" AssociatedControlID="CCLIENT__VAT_NUMBER" 
			Text="VAT Number " CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="CCLIENT__VAT_NUMBER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valCCLIENT_VAT_NUMBER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for VAT Number "
					ClientValidationFunction="onValidate_CCLIENT__VAT_NUMBER"
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
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CCLIENT" 
		data-property-name="TYPECOMPANY" 
		id="pb-container-list-CCLIENT-TYPECOMPANY">
		<asp:Label ID="lblCCLIENT_TYPECOMPANY" runat="server" AssociatedControlID="CCLIENT__TYPECOMPANY" 
			Text="Type of Company" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CCLIENT__TYPECOMPANY" runat="server" CssClass="form-control" ListType="PMLookup" ListCode="UDL_TYPE_COMP" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CCLIENT__TYPECOMPANY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCCLIENT_TYPECOMPANY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Type of Company"
			ClientValidationFunction="onValidate_CCLIENT__TYPECOMPANY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->

 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="CCLIENT" 
		data-property-name="DTOFINC" 
		id="pb-container-datejquerycompatible-CCLIENT-DTOFINC">
		<asp:Label ID="lblCCLIENT_DTOFINC" runat="server" AssociatedControlID="CCLIENT__DTOFINC" 
			Text="Date of Incorporation" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
		        <asp:TextBox ID="CCLIENT__DTOFINC" runat="server" CssClass="form-control" data-type="Date" />
		        <uc1:CalendarLookup ID="calCCLIENT__DTOFINC" runat="server" LinkedControl="CCLIENT__DTOFINC" HLevel="3" />
			</div>
		<asp:CustomValidator ID="valCCLIENT_DTOFINC" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Date of Incorporation"
			ClientValidationFunction="onValidate_CCLIENT__DTOFINC" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
			</div>
	</span>
	</div>
<!-- /Date -->


								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Text -->

<div class="form-group form-group-sm">
	<span class="field-container" 
		
		data-field-type="Text" 
		
		data-object-name="CCLIENT" 
		data-property-name="COMP_REG_NUMBER" 
		 
		
		 
		id="pb-container-text-CCLIENT-COMP_REG_NUMBER">

		
		<asp:Label ID="lblCCLIENT_COMP_REG_NUMBER" runat="server" AssociatedControlID="CCLIENT__COMP_REG_NUMBER" 
			Text="Company Registration Number" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		
		
			
		

		
		         <div class="col-md-8 col-sm-9">
					<asp:TextBox ID="CCLIENT__COMP_REG_NUMBER" runat="server" CssClass="form-control" data-type="Text" />
					<asp:CustomValidator ID="valCCLIENT_COMP_REG_NUMBER" 
					runat="server" 
					Text="*" 
					ErrorMessage="A validation error occurred for Company Registration Number"
					ClientValidationFunction="onValidate_CCLIENT__COMP_REG_NUMBER"
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
<label id="ctl00_cntMainBody_lblCCLIENT_FIA" for="ctl00_cntMainBody_CCLIENT__FIA" class="col-md-4 col-sm-3 control-label">
		FIA</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CCLIENT" 
		data-property-name="FIA" 
		id="pb-container-checkbox-CCLIENT-FIA">	
		
		<asp:TextBox ID="CCLIENT__FIA" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCCLIENT_FIA" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for FIA"
			ClientValidationFunction="onValidate_CCLIENT__FIA" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
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
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="frmIndustry" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading2" runat="server" Text=" " /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CCLIENT" 
		data-property-name="PRIMARY_INDUSTRY" 
		id="pb-container-list-CCLIENT-PRIMARY_INDUSTRY">
		<asp:Label ID="lblCCLIENT_PRIMARY_INDUSTRY" runat="server" AssociatedControlID="CCLIENT__PRIMARY_INDUSTRY" 
			Text="Primary Industry" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CCLIENT__PRIMARY_INDUSTRY" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="CMA_INDONE" ParentLookupListID="" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CCLIENT__PRIMARY_INDUSTRY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCCLIENT_PRIMARY_INDUSTRY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Primary Industry"
			ClientValidationFunction="onValidate_CCLIENT__PRIMARY_INDUSTRY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CCLIENT" 
		data-property-name="SECOND_INDUSTRY" 
		id="pb-container-list-CCLIENT-SECOND_INDUSTRY">
		<asp:Label ID="lblCCLIENT_SECOND_INDUSTRY" runat="server" AssociatedControlID="CCLIENT__SECOND_INDUSTRY" 
			Text="Secondary Industry" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CCLIENT__SECOND_INDUSTRY" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="CMA_INDTWO" ParentLookupListID="CCLIENT__PRIMARY_INDUSTRY" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CCLIENT__SECOND_INDUSTRY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCCLIENT_SECOND_INDUSTRY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Secondary Industry"
			ClientValidationFunction="onValidate_CCLIENT__SECOND_INDUSTRY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CCLIENT" 
		data-property-name="TERTIARY_INDUSTRY" 
		id="pb-container-list-CCLIENT-TERTIARY_INDUSTRY">
		<asp:Label ID="lblCCLIENT_TERTIARY_INDUSTRY" runat="server" AssociatedControlID="CCLIENT__TERTIARY_INDUSTRY" 
			Text="Tertiary Industry" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CCLIENT__TERTIARY_INDUSTRY" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="CMA_INDTHR" ParentLookupListID="CCLIENT__SECOND_INDUSTRY" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CCLIENT__TERTIARY_INDUSTRY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCCLIENT_TERTIARY_INDUSTRY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Tertiary Industry"
			ClientValidationFunction="onValidate_CCLIENT__TERTIARY_INDUSTRY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- List -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="List" 
		data-object-name="CCLIENT" 
		data-property-name="INDUSTRY" 
		id="pb-container-list-CCLIENT-INDUSTRY">
		<asp:Label ID="lblCCLIENT_INDUSTRY" runat="server" AssociatedControlID="CCLIENT__INDUSTRY" 
			Text="Industry" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
				<NexusProvider:LookupListV2 ID="CCLIENT__INDUSTRY" runat="server" CssClass="form-control" ListType="UserDefined" ListCode="CMA_INDUST" ParentLookupListID="CCLIENT__TERTIARY_INDUSTRY" DataItemValue="Code" DataItemText="Description" DefaultText="--Please Select--" onChange="onValidate_CCLIENT__INDUSTRY(null, null, this);" data-type="List" />
			<asp:CustomValidator ID="valCCLIENT_INDUSTRY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Industry"
			ClientValidationFunction="onValidate_CCLIENT__INDUSTRY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		  
	</span>
</div>
<!-- /List -->
								
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
		if ($("#frmIndustry div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmIndustry div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmIndustry div ul li").each(function(){		  
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
			$("#frmIndustry div ul li").each(function(){		  
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
		styleString += "#frmIndustry label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmIndustry label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmIndustry label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmIndustry label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmIndustry input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmIndustry input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmIndustry input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="frmFacility" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading3" runat="server" Text="Facility Details" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										 
 <!-- Checkbox -->
<div class="form-group form-group-sm">
<label id="ctl00_cntMainBody_lblCCLIENT_IS_BONDS" for="ctl00_cntMainBody_CCLIENT__IS_BONDS" class="col-md-4 col-sm-3 control-label">
		Bonds and Guarantees</label>
<div class="col-md-8 col-sm-9">
	<span class="field-container asp-check" 
		data-field-type="Checkbox" 
		data-object-name="CCLIENT" 
		data-property-name="IS_BONDS" 
		id="pb-container-checkbox-CCLIENT-IS_BONDS">	
		
		<asp:TextBox ID="CCLIENT__IS_BONDS" runat="server" CssClass="form-control hidden" />
		<asp:CustomValidator ID="valCCLIENT_IS_BONDS" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Bonds and Guarantees"
			ClientValidationFunction="onValidate_CCLIENT__IS_BONDS" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		
	</span>
	</div>
</div>
<!-- /Checkbox -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label0">
		<span class="label" id="label0"></span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Label -->
	<span id="pb-container-label-label1">
		<span class="label" id="label1">Note: You do not have sufficient authority to amend the Facility Details. Please contact a system administrator.</span>
	</span>
<!-- /Label -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Integer -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Integer" 
		data-object-name="CCLIENT" 
		data-property-name="USERLEVEL" 
		id="pb-container-integer-CCLIENT-USERLEVEL">
		<asp:Label ID="lblCCLIENT_USERLEVEL" runat="server" AssociatedControlID="CCLIENT__USERLEVEL" 
			Text="Authority Level" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		       <asp:TextBox ID="CCLIENT__USERLEVEL" runat="server" CssClass="form-control" />
			   <asp:CustomValidator ID="valCCLIENT_USERLEVEL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Authority Level"
			ClientValidationFunction="onValidate_CCLIENT__USERLEVEL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
		    </div>
		
	</span>
</div>
<!-- /Integer -->
								
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
		if ($("#frmFacility div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmFacility div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmFacility div ul li").each(function(){		  
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
			$("#frmFacility div ul li").each(function(){		  
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
		styleString += "#frmFacility label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmFacility label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmFacility label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmFacility label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmFacility input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmFacility input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmFacility input{text-align:left;}"; break;
		}
	}
	
	if (styleString != ""){
		goog.style.installStyles(styleString);
	}
</script>
<!-- /ColumnLayoutContainer -->	
							
							</div>
					 
					
						
						
							<div class="clearfix p-xs">
						
						
								<!-- ColumnLayoutContainer -->
<div id="frmFacility2" class="column-layout-container  ">
		
				
	              <legend><asp:Label ID="lblHeading4" runat="server" Text="Facility Details" /></legend>
				
				
				<div data-column-count="2" data-column-ratio="" data-layout="" class="clearfix form-horizontal">
				
					<ul class="column-content">
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CCLIENT" 
		data-property-name="FACILITY_MAX" 
		id="pb-container-currency-CCLIENT-FACILITY_MAX">
		<asp:Label ID="lblCCLIENT_FACILITY_MAX" runat="server" AssociatedControlID="CCLIENT__FACILITY_MAX" 
			Text="Current Maximum Facility" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CCLIENT__FACILITY_MAX" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCCLIENT_FACILITY_MAX" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Current Maximum Facility"
			ClientValidationFunction="onValidate_CCLIENT__FACILITY_MAX" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Currency --->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Currency" 
		data-object-name="CCLIENT" 
		data-property-name="FACILITY_AVAIL" 
		id="pb-container-currency-CCLIENT-FACILITY_AVAIL">
		<asp:Label ID="lblCCLIENT_FACILITY_AVAIL" runat="server" AssociatedControlID="CCLIENT__FACILITY_AVAIL" 
			Text="Capacity Available" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
		   <div class="col-md-8 col-sm-9">
		     <asp:TextBox ID="CCLIENT__FACILITY_AVAIL" runat="server" CssClass="form-control" />
		   </div>
		<asp:CustomValidator ID="valCCLIENT_FACILITY_AVAIL" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Capacity Available"
			ClientValidationFunction="onValidate_CCLIENT__FACILITY_AVAIL" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>	
<!-- /Currency -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Percentage -->
<div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Percentage" 
		data-object-name="CCLIENT" 
		data-property-name="FACILITY_RATE" 
		id="pb-container-percentage-CCLIENT-FACILITY_RATE">
		<asp:Label ID="lblCCLIENT_FACILITY_RATE" runat="server" AssociatedControlID="CCLIENT__FACILITY_RATE" 
			Text="Current Facility Rate" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			<div class="col-md-8 col-sm-9">
		        <asp:TextBox ID="CCLIENT__FACILITY_RATE" runat="server" CssClass="form-control" />
		    </div>
		<asp:CustomValidator ID="valCCLIENT_FACILITY_RATE" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Current Facility Rate"
			ClientValidationFunction="onValidate_CCLIENT__FACILITY_RATE" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
	</span>
</div>
<!-- /Percentage -->
								
									</li>
							
							
						
							
							
								
								
									<li class="co-cell"  style="width:50%;" >
								
								
										<!-- Date -->

 <div class="form-group form-group-sm">
	<span class="field-container"
		data-field-type="Date" 
		data-object-name="CCLIENT" 
		data-property-name="FACILITY_EXPIRY" 
		id="pb-container-datejquerycompatible-CCLIENT-FACILITY_EXPIRY">
		<asp:Label ID="lblCCLIENT_FACILITY_EXPIRY" runat="server" AssociatedControlID="CCLIENT__FACILITY_EXPIRY" 
			Text="Facility Expiry Date" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
			 <div class="col-md-8 col-sm-9">
			  <div class="input-group">
		        <asp:TextBox ID="CCLIENT__FACILITY_EXPIRY" runat="server" CssClass="form-control" data-type="Date" />
		        <uc1:CalendarLookup ID="calCCLIENT__FACILITY_EXPIRY" runat="server" LinkedControl="CCLIENT__FACILITY_EXPIRY" HLevel="3" />
			</div>
		<asp:CustomValidator ID="valCCLIENT_FACILITY_EXPIRY" 
			runat="server" 
			Text="*" 
			ErrorMessage="A validation error occurred for Facility Expiry Date"
			ClientValidationFunction="onValidate_CCLIENT__FACILITY_EXPIRY" 
			ValidationGroup=""
			Display="None"
			EnableClientScript="true"/>
			</div>
	</span>
	</div>
<!-- /Date -->


								
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
		if ($("#frmFacility2 div").attr("data-column-count") != "undefined")
		{
			columnCount = $("#frmFacility2 div").attr("data-column-count");		
		}
		
		if (columnCount > 1)
		{
			$("#frmFacility2 div ul li").each(function(){		  
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
			$("#frmFacility2 div ul li").each(function(){		  
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
		styleString += "#frmFacility2 label{width: " + labelWidth + ";}";
	}
	if (labelAlign != ""){
		switch (labelAlign.toLowerCase()){
			case "right": styleString += "#frmFacility2 label{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmFacility2 label{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmFacility2 label{text-align:left;}"; break;
		}
	}
	if (textAlign != ""){
		switch (textAlign.toLowerCase()){
			case "right": styleString += "#frmFacility2 input{text-align:right;}"; break;
			case "centre":
			case "center":
			case "middle": styleString += "#frmFacility2 input{text-align:center;}"; break;
			case "left": 
			default: styleString += "#frmFacility2 input{text-align:left;}"; break;
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
