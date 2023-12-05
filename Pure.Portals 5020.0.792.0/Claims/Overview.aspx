<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.Framework_overview, Pure.Portals" enableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register TagPrefix="uc2" TagName="Currency" Src="~/Controls/Currencies.ascx" %>
<%@ Register TagPrefix="uc1" TagName="CalendarLookup" Src="~/Controls/CalendarLookup.ascx" %>
<%@ Register assembly="Pure.Portals"  TagPrefix="OC" Namespace="Nexus" %>
<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<%@ Register Src="~/Controls/ClaimsProgressBar.ascx" TagName="ProgressBar" TagPrefix="uc3" %>
<%@ Register TagPrefix="uc4" TagName="ClaimHeader" Src="~/Controls/ClaimHeader.ascx" %>
<%@ Register TagPrefix="uc5" TagName="ChangeReason" Src="~/Controls/ChangeClaim.ascx" %>
<%@ Register TagPrefix="uc6" TagName="FindParty" Src="~/Controls/FindParty.ascx" %>
<%@ Register Src="~/Controls/CtrlLetterWriting.ascx" TagName="LetterWriting" TagPrefix="uc16" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">

    <script type="text/javascript">
        $(document).ready(function () {

            var hdnAttachedPartyName = document.getElementById('ctl00_cntMainBody_hdnAttachedPartyName').value;

            document.getElementById('<%=CONTROL__CLAIM_UNDERWRITINGYEAR.ClientId %>').disabled = true;

            if (hdnAttachedPartyName != '') {
                //document.getElementById('ctl00_cntMainBody_PartyName_txtPartyName').value = hdnAttachedPartyName;
                document.getElementById('ctl00_cntMainBody_PartyName_txtPartyName').readOnly = true;
                document.getElementById('ctl00_cntMainBody_PartyName_btnFindParty').style="pointer-events:none;"
               }
            if ("<%=bDisableLossdate%>") {
                $('.CONTROL__LOSS_TODATE').attr('disabled', true);
                $('.CONTROL__LOSS_DATE').attr('disabled', true);
                $('.CONTROL__LOSS_TIME').attr('disabled', true);

            }
            else {
                $('.CONTROL__LOSS_TODATE').attr('disabled', false);
                $('.CONTROL__LOSS_DATE').attr('disabled', false);
                $('.CONTROL__LOSS_TIME').attr('disabled', false);

            }
        });
        function ConfirmBox(sMessage, sMessageType) {

            if (sMessageType == 'CONFIRM') {
                if (confirm(sMessage) == true) {
                    __doPostBack('', 'NextButton');
                }
            }
            else {
                alert(sMessage)
            }
            //tb_show(null,'Pure.Portal31/Modal/WrmTask.aspx?modal=true&FromPage=WM&KeepThis=true&TB_iframe=true&height=500&width=750' , null);
            //return false;
            //tb_show("Confirm", "#TB_inline?height=200&width=300&inlineId=divConfirm", null);
        }
        function EnableLikelyToClaim(status) {
            var LikeyToClaim = document.getElementById('ctl00_cntMainBody_chkLikelyToClaim');
            LikeyToClaim.disabled = !status;
            if (!status) {
                LikeyToClaim.checked = false;
            }
        }
        onload = function () {
            var Information = document.getElementById('ctl00_cntMainBody_chkInformation');
            var LikeyToClaim = document.getElementById('ctl00_cntMainBody_chkLikelyToClaim');
            if (!Information.checked) {
                LikeyToClaim.disabled = true;
            }
        }

        function updated() {
            tb_remove();
        }

        function validateClaimStatus(reserveAmt, recoveryAmt, claimClosureMsg, claimReduceToZeroMsg, bIsClosed) {
            var sClaimStatus = $get('<%=CONTROL__PROGRESS_STATUS.ClientID%>');
            Page_ClientValidate();
            var status = sClaimStatus.value;
            var QPrompt;
            if (bIsClosed) {
                if (reserveAmt == 0 && recoveryAmt == 0)
                    QPrompt = confirm(claimClosureMsg);
                else
                    QPrompt = confirm(claimReduceToZeroMsg);

                     if (QPrompt)
                         return true;
                     else
                         return false;
                 }
             }
         
        

        function setctl00_cntMainBody_PartyNameOtherParty(sName, sKey, sAgentCode, sType) {
            document.getElementById('ctl00_cntMainBody_PartyName_txtPartyName').value = sAgentCode;
            document.getElementById('ctl00_cntMainBody_PartyName_hPartyKey').value = sKey;
            document.getElementById('ctl00_cntMainBody_PartyName_hPartyType').value = sType;

            if (self.parent != null && self.parent.thisModal != undefined) {
                self.parent.tb_remove();
            }
            if (sKey == 0) {
                ValidatorEnable($("#<%= cvParty.ClientID%>")[0], true);
            }
            else {
                ValidatorEnable($("#<%= cvParty.ClientID%>")[0], false);
            }
        }
        function fn_DateCompare(DateA, DateB) {
            var d1_str = DateA;
            var d2_str = DateB;
            var d1 = new Date(d1_str.split('/')[2], d1_str.split('/')[1], d1_str.split('/')[0]);
            var d2 = new Date(d2_str.split('/')[2], d2_str.split('/')[1], d2_str.split('/')[0]);

            if (typeof (Page_ClientValidate) == 'function') {
                Page_ClientValidate();
            }
            if (Page_IsValid) {
            }
            else {
                return false;
            }

            if (d1.getTime() > d2.getTime()) {
                return true;
            }
        }
        function getClaimNotificationDate() {

            return document.getElementById("<%=CONTROL__LOSS_DATE.ClientID %>").value;
        }
        function setLossToDate() {

            var lossdate;
            lossdate = document.getElementById("<%=CONTROL__LOSS_TODATE.ClientID %>").value;
            document.getElementById("<%=CONTROL__LOSS_TODATE.ClientID %>").value = document.getElementById("<%=CONTROL__LOSS_DATE.ClientID %>").value
            document.getElementById('<%= btnNext.ClientID %>').removeAttribute("onclick");
            __doPostBack('', 'LossDate');

        }
        function checkTextAreaMaxLength(textBox, e, length) {

            var mLen = textBox["MaxLength"];
            if (null == mLen)
                mLen = length;

            var maxLength = parseInt(mLen);
            if (!checkSpecialKeys(e)) {
                if (textBox.value.length > maxLength - 1) {
                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                        e.preventDefault();
                }
            }
        }

        function checkSpecialKeys(e) {
            if (e.keyCode != 8 && e.keyCode != 46 && e.keyCode != 35 && e.keyCode != 36 && e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40)
                return false;
            else
                return true;
        }
    </script>

    <div id="Claims_Overview" onkeypress="return WebForm_FireDefaultButton(event, '<%= btnNext.ClientID %>')">
        <asp:HiddenField ID="hdnClosedStatusCode" runat="server"></asp:HiddenField>
        <uc3:ProgressBar ID="ucProgressBar" runat="server"></uc3:ProgressBar>
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Label runat="server" Text="<%$ Resources:claimoverview_pageheading %>" ID="lblPageHeading"></asp:Label></h1>
            </div>
            <div class="card-body clearfix">
                <asp:ScriptManager ID="smOverview" runat="server">
                </asp:ScriptManager>
                <div class="form-horizontal">
                    <legend>
                        <asp:Label runat="server" ID="lblClaimOverviewLegend" Text="<%$ Resources:lblClaimOverviewLegend %>"></asp:Label></legend>
                    <div class="m-b-sm">
                        <asp:HyperLink ID="hypPaymentHistory" NavigateUrl="~/Modal/PaymentHistoryForClaims.aspx?modal=true&KeepThis=true&TB_iframe=true&height=500&width=700" data="modal" SkinID="btnHSM" Text="<%$ Resources:hyp_PaymentHistory %>" runat="server"></asp:HyperLink>
                        <asp:HyperLink ID="hypClaimVersion" NavigateUrl="~/Modal/ClaimVersion.aspx?modal=true&KeepThis=true&TB_iframe=true&height=500&width=700" data="modal" SkinID="btnHSM" Text="<%$ Resources:hyp_ClaimVersion %>" runat="server"></asp:HyperLink>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblRiskType" runat="server" AssociatedControlID="ddlRiskType" Text="<%$ Resources:claimoverview_RiskType %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:DropDownList ID="ddlRiskType" runat="server" CssClass="field-medium field-mandatory form-control" AutoPostBack="true"></asp:DropDownList>
                        </div>
                        <asp:RequiredFieldValidator ID="RqdRiskType" ControlToValidate="ddlRiskType" ValidationGroup="ClaimsOverviewGroup" runat="server" ErrorMessage="<%$ Resources:claimoverview_RiskTypeError %>" Display="none" SetFocusOnError="true" EnableClientScript="false"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblDesc" runat="server" AssociatedControlID="CONTROL__RISK_DESC" Text="<%$ Resources:claimoverview_Desc %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="CONTROL__RISK_DESC" runat="server" TextMode="multiline" Columns="15" CssClass="field-mandatory form-control" Rows="5" MaxLength="1000" onkeyDown="return checkTextAreaMaxLength(this,event,'1000');"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator ID="RqdRiskDesc" ControlToValidate="CONTROL__RISK_DESC" ValidationGroup="ClaimsOverviewGroup" runat="server" ErrorMessage="<%$ Resources:claimoverview_DescError %>" Display="none" SetFocusOnError="true"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="regexRiskDesc" runat="server" ControlToValidate="CONTROL__RISK_DESC" ErrorMessage="<%$ Resources:lbl_FailedLengthDescription %>" SetFocusOnError="true" Display="none" ValidationGroup="ClaimsOverviewGroup" ValidationExpression="^(.{0,1000})\s*$" EnableClientScript="true"></asp:RegularExpressionValidator>
                    </div>
                   
					 <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <uc6:FindParty ID="PartyName" TextToShow="<%$ Resources:lbl_OtherParty %>" Type="Third Party" runat="server" ModalURL="Modal/FindOtherParty.aspx" PassedClientID="ctl00_cntMainBody_PartyName" EnabledTextSearch="true"></uc6:FindParty>
                        <asp:HiddenField ID="hdnAttachedPartyName" runat="server"></asp:HiddenField>
                        <asp:CustomValidator ID="cvParty" runat="Server" ValidationGroup="ClaimsOverviewGroup" Enabled="true" EnableClientScript="true" OnServerValidate="cvParty_ServerValidate" ValidateEmptyText="True" ErrorMessage="Validation Failed"></asp:CustomValidator>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblProgressStatus" runat="server" AssociatedControlID="CONTROL__PROGRESS_STATUS" Text="<%$ Resources:lbl_ProgressStatus %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:DropDownList ID="CONTROL__PROGRESS_STATUS" runat="server" CssClass="field-medium field-mandatory form-control" AutoPostBack="true"></asp:DropDownList>
                        </div>
                        <asp:RequiredFieldValidator ID="RqdProgressStatus" runat="server" ControlToValidate="CONTROL__PROGRESS_STATUS" Display="none" Enabled="true" ValidationGroup="ClaimsOverviewGroup" SetFocusOnError="true" ErrorMessage="<%$ Resources:claimoverview_ProgressStatus%>"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblClaimType" runat="server" AssociatedControlID="CONTROL__PRIMARY_CAUSE" Text="<%$ Resources:claimoverview_ClaimType %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:DropDownList ID="CONTROL__PRIMARY_CAUSE" runat="server" CssClass="field-medium field-mandatory form-control" AutoPostBack="true"></asp:DropDownList>
                        </div>
                        <asp:RequiredFieldValidator ID="RqdTypeClaim" ControlToValidate="CONTROL__PRIMARY_CAUSE" ValidationGroup="ClaimsOverviewGroup" runat="server" ErrorMessage="<%$ Resources:claimoverview_PrimaryCauseError %>" Display="none" SetFocusOnError="true"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:UpdatePanel ID="UpdateSecondaryCause" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:Label ID="lblAdditionalInfo" runat="server" AssociatedControlID="CONTROL__SECONDARY_CAUSE" Text="<%$ Resources:claimoverview_AddInfo %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <asp:DropDownList ID="CONTROL__SECONDARY_CAUSE" runat="server" CssClass="field-medium form-control"></asp:DropDownList>
                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="CONTROL__PRIMARY_CAUSE" EventName="SelectedIndexChanged"></asp:AsyncPostBackTrigger>
                            </Triggers>
                        </asp:UpdatePanel>
                        <Nexus:ProgressIndicator ID="uprogSecCause" OverlayCssClass="updating" AssociatedUpdatePanelID="UpdateSecondaryCause" runat="server">
                            <progresstemplate>
                                            </progresstemplate>
                        </Nexus:ProgressIndicator>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblCatCode" runat="server" AssociatedControlID="CONTROL__CAT_CODE" Text="<%$ Resources:claimoverview_CatCode %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <NexusProvider:LookupList ID="CONTROL__CAT_CODE" runat="server" DataItemValue="Code" DataItemText="Description" Sort="ASC" ListType="PMLookup" ListCode="Catastrophe_code" DefaultText="(Please Select)" CssClass="field-medium form-control"></NexusProvider:LookupList>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblClaimsHandler" runat="server" AssociatedControlID="CONTROL__HANDLER_CODE" Text="<%$ Resources: claimoverview_Handler %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <NexusProvider:LookupList ID="CONTROL__HANDLER_CODE" runat="server" DataItemValue="Code" DataItemText="Description" Sort="ASC" ListType="PMLookup" ListCode="Handler" DefaultText="(Please Select)" CssClass="field-medium field-mandatory form-control"></NexusProvider:LookupList>
                        </div>
                        <asp:RequiredFieldValidator ID="RqdClaimHandler" ControlToValidate="CONTROL__HANDLER_CODE" ValidationGroup="ClaimsOverviewGroup" runat="server" ErrorMessage="<%$ Resources:claimoverview_claimHandlererror %>" Display="none" SetFocusOnError="true"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblLossToDate" runat="server" Text="<%$ Resources:claimoverview_LossToDate %>" AssociatedControlID="CONTROL__LOSS_TODATE" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <div class="input-group">
                                <asp:TextBox ID="CONTROL__LOSS_TODATE" runat="server" Columns="10" Enabled="false" CssClass="field-date form-control"></asp:TextBox>
                                <uc1:CalendarLookup ID="CoverStart_uctCalenderLookup3" runat="server" LinkedControl="CONTROL__LOSS_TODATE" HLevel="1"></uc1:CalendarLookup>
                            </div>
                        </div>
                        <asp:CustomValidator ID="rvLossToDate" runat="server" Display="None" SetFocusOnError="true" ValidationGroup="ClaimsOverviewGroup" ErrorMessage="<%$ Resources:lb_LossToDate %>"></asp:CustomValidator>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblLossDate" runat="server" AssociatedControlID="CONTROL__LOSS_DATE" Text="<%$ Resources:claimoverview_LossDate %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <div class="row-sm">
                                <div class="col-sm-8">
                                    <div class="input-group">
                                        <asp:TextBox ID="CONTROL__LOSS_DATE" Columns="10" runat="server" CssClass="field-date field-mandatory form-control" onchange="setLossToDate();"></asp:TextBox>
                                        <uc1:CalendarLookup ID="CoverStart_uctCalenderlookup4" runat="server" LinkedControl="CONTROL__LOSS_DATE" HLevel="1"></uc1:CalendarLookup>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <asp:TextBox ID="CONTROL__LOSS_TIME" runat="server" Enabled="false" CssClass="field-time field-mandatory form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <asp:RegularExpressionValidator ID="regexVldLossDate" runat="server" ValidationExpression="(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[012])/\d{4}" ControlToValidate="CONTROL__LOSS_DATE" ErrorMessage="<%$ Resources:claimoverview_DateFormat %>" ValidationGroup="ClaimsOverviewGroup" Display="None"></asp:RegularExpressionValidator>
                        <asp:RangeValidator ID="rvLossDate" runat="Server" Type="Date" ValidationGroup="ClaimsOverviewGroup" Display="none" ControlToValidate="CONTROL__LOSS_DATE" MinimumValue="01/01/1900" ErrorMessage="<%$ Resources:lb_LossDate %>" SetFocusOnError="true"></asp:RangeValidator>
                        <asp:RequiredFieldValidator ID="RqdLossDate" ControlToValidate="CONTROL__LOSS_DATE" ValidationGroup="ClaimsOverviewGroup" runat="server" ErrorMessage="<%$ Resources:claimoverview_LossDateerror %>" Display="none" SetFocusOnError="true"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblReportedDate" runat="server" AssociatedControlID="CONTROL__REPORTED_DATE" Text="<%$ Resources:claimoverview_ReportedDate %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <div class="row-sm">
                                <div class="col-sm-8">
                                    <div class="input-group">
                                        <asp:TextBox ID="CONTROL__REPORTED_DATE" Columns="10" runat="server" CssClass="field-date field-mandatory form-control"></asp:TextBox>
                                        <uc1:CalendarLookup ID="CoverStart_uctCalendarLookup2" runat="server" LinkedControl="CONTROL__REPORTED_DATE" HLevel="1"></uc1:CalendarLookup>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <asp:TextBox ID="CONTROL__REPORTED_TIME" runat="server" Enabled="false" CssClass="field-time field-mandatory form-control"></asp:TextBox>
                                </div>
                            </div>
                            <asp:RangeValidator ID="rvReportedDate" runat="Server" Type="Date" ValidationGroup="ClaimsOverviewGroup" Display="none" ControlToValidate="CONTROL__REPORTED_DATE" MinimumValue="01/01/1900" ErrorMessage="<%$ Resources:Report_date_Future_Error %>" SetFocusOnError="true"></asp:RangeValidator>
                            <asp:RequiredFieldValidator ID="RqdReportedDate" ControlToValidate="CONTROL__REPORTED_DATE" ValidationGroup="ClaimsOverviewGroup" runat="server" ErrorMessage="<%$ Resources:claimoverview_ReportedDateerror %>" Display="none" SetFocusOnError="true"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblClaimNumber" runat="server" AssociatedControlID="CONTROL__CLAIM_NUMBER" Text="<%$ Resources:claimoverview_ClaimNumber %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="CONTROL__CLAIM_NUMBER" runat="server" Columns="10" Enabled="false" CssClass="field-mandatory form-control"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator ID="RqdClaimNumber" ControlToValidate="CONTROL__CLAIM_NUMBER" ValidationGroup="ClaimsOverviewGroup" runat="server" ErrorMessage="<%$ Resources:claimoverview_claimnumbererror %>" Display="none" SetFocusOnError="true"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblClaimStatus" runat="server" Text="<%$ Resources:claimoverview_ClaimStatus %>" AssociatedControlID="CONTROL__CLAIM_STATUS" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="CONTROL__CLAIM_STATUS" runat="server" Columns="10" Enabled="false" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblClaimStatusDate" runat="server" Text="<%$ Resources:claimoverview_ClaimStatusDate %>" AssociatedControlID="CONTROL__CLAIM_STATUSDATE" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <div class="row-sm">
                                <div class="col-sm-8">
								<div class="input-group">
                                    <asp:TextBox ID="CONTROL__CLAIM_STATUSDATE" runat="server" Columns="10" Enabled="false" CssClass="form-control"></asp:TextBox>
									
								</div>
                                </div>
                                <div class="col-sm-4">
                                    <asp:TextBox ID="CONTROL__CLAIM_STATUSTIME" runat="server" Enabled="false" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblTown" runat="server" Text="<%$ Resources:claimoverview_Town %>" AssociatedControlID="CONTROL__CLAIM_TOWN" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <NexusProvider:LookupList ID="CONTROL__CLAIM_TOWN" runat="server" DataItemValue="Code" DataItemText="Description" Sort="ASC" ListType="PMLookup" ListCode="Town" DefaultText="(Please Select)" CssClass="field-medium form-control"></NexusProvider:LookupList>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblLocation" runat="server" Text="<%$ Resources:claimoverview_Location %>" AssociatedControlID="CONTROL__CLAIM_LOCATION" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="CONTROL__CLAIM_LOCATION" runat="server" Columns="10" Enabled="false" MaxLength="50" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblLastModifiedDate" runat="server" Text="<%$ Resources:claimoverview_LastModifiedDate %>" AssociatedControlID="CONTROL__CLAIM_LASTMODIFIEDDATE" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <div class="row-sm">
                                <div class="col-sm-8">
								<div class="input-group">
                                    <asp:TextBox ID="CONTROL__CLAIM_LASTMODIFIEDDATE" runat="server" Columns="10" Enabled="false" CssClass="form-control"></asp:TextBox>
									
								</div>
                                </div>
                                <div class="col-sm-4">
                                    <asp:TextBox ID="CONTROL__CLAIM_LASTMODIFIEDTIME" runat="server" Enabled="false" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>


                        </div>
                    </div>
                    <div id="liUnderwritingYear" runat="server" class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblUnderWritingYear" runat="server" Text="<%$ Resources:claimoverview_UnderWritingyear %>" AssociatedControlID="CONTROL__CLAIM_UNDERWRITINGYEAR" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <NexusProvider:LookupList ID="CONTROL__CLAIM_UNDERWRITINGYEAR" runat="server" DataItemValue="Code" DataItemText="Description" Sort="ASC" ListType="PMLookup" ListCode="UnderWriting_Year" DefaultText="(Please Select)" CssClass="field-medium form-control"></NexusProvider:LookupList>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblCurrency" runat="server" AssociatedControlID="CONTROL__CLAIM_CURRENCY" Text="<%$ Resources:claimoverview_Currency %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <NexusProvider:LookupList ID="CONTROL__CLAIM_CURRENCY" runat="server" DataItemValue="Code" DataItemText="Description" Sort="ASC" ListType="PMLookup" ListCode="Currency" DefaultText="(Please Select)" CssClass="field-medium form-control"></NexusProvider:LookupList>
                        </div>
                        <asp:RequiredFieldValidator ID="RqdLossCurrency" ControlToValidate="CONTROL__CLAIM_CURRENCY" ValidationGroup="ClaimsOverviewGroup" runat="server" ErrorMessage="<%$ Resources:claimoverview_losscurrencyerror %>" Display="none" SetFocusOnError="true"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblInformation" runat="server" AssociatedControlID="chkInformation" Text="<%$ Resources:lbl_Information %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:CheckBox ID="chkInformation" runat="server" Enabled="false" OnClick="EnableLikelyToClaim(this.checked)" Text=" " CssClass="asp-check"></asp:CheckBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblLikelyToClaim" runat="server" AssociatedControlID="chkLikelyToClaim" Text="<%$ Resources:lbl_LikelyToClaim %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:CheckBox ID="chkLikelyToClaim" runat="server" Text=" " CssClass="asp-check"></asp:CheckBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblClaimVersion" runat="server" Text="<%$ Resources:claimoverview_ClaimVersion %>" AssociatedControlID="CONTROL__CLAIM_VERSION" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="CONTROL__CLAIM_VERSION" runat="server" Columns="10" Enabled="false" style="width:110px" CssClass="field-small form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblCaseNumber" runat="server" Text="<%$ Resources:claimoverview_lblCaseNumber %>" AssociatedControlID="CONTROL__CASE_NUMBER" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="CONTROL__CASE_NUMBER" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <uc5:ChangeReason ID="uctChangeReason" runat="server"></uc5:ChangeReason>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnBack" runat="server" Text="<%$ Resources:ClaimsResource, claimoverview_btnback %>" CausesValidation="false" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnNext" runat="server" ValidationGroup="ClaimsOverviewGroup" Text="<%$ Resources:ClaimsResource, claimoverview_btnNext %>" SkinID="btnPrimary"></asp:LinkButton>
                <uc16:LetterWriting ID="ctrlLetterWriting" runat="server" Visible="false"></uc16:LetterWriting>
            </div>
        </div>
        <asp:CustomValidator ID="AllowClaimPayment" runat="server" ErrorMessage="<%$ Resources:lbl_AllowClaimPayment_error %>" Display="none" ValidationGroup="ClaimsOverviewGroup"></asp:CustomValidator>
        <asp:CustomValidator ID="ChkClosedClaim" runat="server" ErrorMessage="<%$ Resources:lbl_ClosedClaim_Error %>" Display="none" ValidationGroup="ClaimsOverviewGroup"></asp:CustomValidator>
        <asp:CustomValidator ID="vldMediaTypeStatus" runat="server" ErrorMessage="<%$ Resources:lbl_MediaTypeStatus_Error %>" Display="none" ValidationGroup="ClaimsOverviewGroup"></asp:CustomValidator>
        <asp:CustomValidator ID="VldTime" runat="server" Display="None" SetFocusOnError="true" ValidationGroup="ClaimsOverviewGroup" ErrorMessage="<%$ Resources:Err_InvalidTime %>"></asp:CustomValidator>
        <asp:ValidationSummary ID="ValidationSummary" DisplayMode="BulletList" ValidationGroup="ClaimsOverviewGroup" HeaderText="<%$ Resources:lbl_ValidationSummary %>" runat="server" CssClass="validation-summary"></asp:ValidationSummary>
        <asp:CustomValidator ID="chkPerilReserve" runat="server" Display="None" SetFocusOnError="true" ValidationGroup="ClaimsOverviewGroup" ErrorMessage="<%$ Resources:lbl_PerilReserve_Error %>"></asp:CustomValidator>
    </div>
</asp:Content>
