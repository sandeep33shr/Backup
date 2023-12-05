<%@ page language="VB" autoeventwireup="false" inherits="Nexus.secure_InsurerPayments, Pure.Portals" masterpagefile="~/default.master" enableEventValidation="false" %>

<%@ Register Src="~/controls/CalendarLookup.ascx" TagName="CalendarLookup" TagPrefix="uc1" %>
<%@ Register Src="~/controls/MultiSelectDD.ascx" TagName="MultiSelectDD" TagPrefix="uc2" %>
<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">

    <script language="javascript" type="text/javascript">

        //Enable or Disable the calender control and linked textbox 
        //on change of associated checkbox
        function EnableCalender(status) {
            var txtDateTo = document.getElementById('<%= txtDateTo.ClientId%>');

            if (status == true) {
                $('#<%= txtDateTo.ClientId %>').removeAttr('disabled');
                $('#ctl00_cntMainBody_calEffectiveDate_lblCalenderIcon').removeAttr("style", "pointer-events:none!important");
                $('#ctl00_cntMainBody_calEffectiveDate_lblCalenderIcon').removeAttr("readonly", true);
            }
            else {
                $('#<%= txtDateTo.ClientId %>').attr('disabled', 'disabled');
                $('#ctl00_cntMainBody_calEffectiveDate_lblCalenderIcon').attr("style", "pointer-events:none!important");
                $('#ctl00_cntMainBody_calEffectiveDate_lblCalenderIcon').attr("readonly", true);
            }
        }

        $(document).ready(function () {
            EnableCalender(document.getElementById('<%= chkDateTo.ClientID%>').value)
        });


        //Atleast on transaction is required to select
        function SelectTransaction(source, arguments) {
            var sTotalTransactionSelected = document.getElementById('<%= hiddentxtTotalTransactionSelected.ClientId%>').value;
            if (sTotalTransactionSelected > 0) {
                arguments.IsValid = true;
            }
            else {
                arguments.IsValid = false;
                return false;
            }
        }

        //The Document must balance to zero
        function ValidateMarkedAmount(source, arguments) {
            var sTotalMarkedAmount = document.getElementById('<%= hiddentxtTotalMarked.ClientId%>').value;
            if (isNaN(parseFloat(sTotalMarkedAmount.value))) { sTotalMarkedAmount.value = 0 }
            if (parseFloat(sTotalMarkedAmount) == 0) {
                arguments.IsValid = true;
                return true;
            }
            else {
                arguments.IsValid = false;
                return false;
            }
        }

        //Take confirmation before 'Auto Allocate process'
        function ConfirmAutoAllocateProcess() {
            var isPageValid = true;
            isPageValid = Page_ClientValidate("btnAllocate");

            if (isPageValid) {
                var sconfirmMsg = "Are you sure you want to go ahead with the allocation?";
                var bResponse;

                bResponse = window.confirm(sconfirmMsg);

                return bResponse;
            }
            else {
                return false;
            }
        }

        function openReport() {
            var fileName = $("#<%=hdnFileName.ClientID%>").val();
            var directoryName = $("#<%=hdnDirectoryName.ClientID%>").val();
            var partyKey = $("#<%=hPartyKey.ClientID%>").val();
            if ((fileName.length > 0) && (directoryName.length > 0))
                tb_show(null, '../Modal/Report.aspx?mode=add&modal=true&FromPage=WM&KeepThis=true&TB_iframe=true&height=500&width=750&onQueryClick=true&reportfile=' + fileName + '&folder=' + directoryName + '&PartyKey=' + partyKey + '', null);
            return true;
        }

        function setAccount(sShortCode, shiddenShortCode, sAccountName, sPartyKey, sCurrencyCode, htype, sLedgerCode, sContactName) {
            tb_remove();
            document.getElementById('<%= txtAccountCode.ClientId%>').value = unescape(sShortCode);
            document.getElementById('<%= hiddenAccountCode.ClientId%>').value = shiddenShortCode;
            document.getElementById('<%= ddlPaymentGroup.ClientId%>').disabled = false;
            document.getElementById('<%= hCurrencyCode.ClientId%>').value = sCurrencyCode;
            document.getElementById('<%= hPartyKey.ClientId%>').value = sPartyKey;

            __doPostBack("InsurerPayment", "RefreshIP");
        }


        function setAccountTest() {
            alert('Called');
        }


        function openEmail() {
            var branch = $("#<%=hdnBranch.ClientID%>").val();
            var partyKey = $("#<%=hPartyKey.ClientID%>").val();
            tb_show(null, '../Modal/SendEmail.aspx?mode=add&modal=true&FromPage=WM&KeepThis=true&TB_iframe=true&height=500&width=750&onQueryClick=true&loc=report&branch=' + branch + '&PartyKey=' + partyKey + '', null);
            return false;
        }

        function showAlert(msg)
        {
            alert(msg);
        }

    </script>

    <div id="secure_InsurerPayments">
          <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>
                <asp:Panel ID="PnlInsurerPayments" runat="server" DefaultButton="btnFindNow" CssClass="card">
                    <div class="card-heading">
                        <h1>
                            <asp:Literal ID="litInsurerPaymentsHeader" runat="server" Text="<%$ Resources:lbl_InsurerPayments_Header %>"></asp:Literal></h1>
                    </div>
                    <div class="card-body clearfix">
                        <div class="noxscroll form-horizontal">
                            <legend>
                                <asp:Label ID="lblInsurerPayment" runat="server" Text="<%$ Resources:lbl_Page_header %>"></asp:Label>
                            </legend>

                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblDateTo" runat="server" AssociatedControlID="txtDateTo" Text="<%$ Resources:lbl_DateTo %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <asp:CheckBox ID="chkDateTo" runat="server" OnClick="EnableCalender(this.checked)" Text=" " CssClass="asp-check"></asp:CheckBox>
                                        </span>
                                        <asp:TextBox ID="txtDateTo" CssClass="form-control" runat="server"></asp:TextBox>
                                        <uc1:CalendarLookup ID="calEffectiveDate" runat="server" LinkedControl="txtDateTo" HLevel="2"></uc1:CalendarLookup>
                                    </div>
                                </div>
                                <asp:RangeValidator ID="rngDateTo" runat="Server" Type="Date" Display="none" ControlToValidate="txtDateTo" SetFocusOnError="True" ErrorMessage="<%$ Resources:lbl_DateTo_Range_Err %>"></asp:RangeValidator>
                            </div>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label runat="Server" CssClass="col-md-4 col-sm-3 control-label" AssociatedControlID="txtAccountCode" Text="<%$ Resources:lbl_AccountCode%>" ID="lblbtnAccountCode"></asp:Label><div class="col-md-8 col-sm-9">
                                    <div class="input-group">
                                        <asp:TextBox ID="txtAccountCode" runat="server" CssClass="form-control"></asp:TextBox><span class="input-group-btn"><asp:LinkButton ID="btnAccountCode" CausesValidation="false" runat="server" SkinID="btnModal">
                                            <i class="glyphicon glyphicon-search"></i>
                                            <span class="btn-fnd-txt">A/C Handler</span>
                                        </asp:LinkButton></span>
                                    </div>
                                </div>
                                <asp:HiddenField ID="hiddenAccountCode" runat="server"></asp:HiddenField>
                                <asp:RequiredFieldValidator ID="vldrqdAccountCode" runat="server" ControlToValidate="txtAccountCode" Display="none" Enabled="true" SetFocusOnError="true" ErrorMessage="<%$ Resources:lbl_ErrMsg_Branch%>"></asp:RequiredFieldValidator>
                            </div>
                           
                             <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblPolicyNumber" runat="server" AssociatedControlID="txtPolicyNumber" Text="<%$ Resources:lblPolicyNumber %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                  <div class="col-md-8 col-sm-9">
                                    <asp:TextBox ID="txtPolicyNumber" CssClass="form-control" runat="server"></asp:TextBox>
                                      </div>
                            </div>
                             <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblAlternateRef" runat="server" AssociatedControlID="txtAlternateRef" Text="<%$ Resources:lbl_AlternateRef %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <asp:TextBox ID="txtAlternateRef" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblPaymentGroup" runat="server" AssociatedControlID="ddlPaymentGroup" Text="<%$ Resources:lbl_PaymentGroup %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <asp:DropDownList ID="ddlPaymentGroup" runat="server" CssClass="field-medium form-control" EnableViewState="true" Enabled="false">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblMarkedStatus" runat="server" AssociatedControlID="ddlMarkedStatus" Text="<%$ Resources:lbl_MarkedStatus %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <asp:DropDownList ID="ddlMarkedStatus" runat="server" CssClass="field-medium form-control">
                                        <asp:ListItem Value="0">No</asp:ListItem>
                                        <asp:ListItem Value="1">Yes</asp:ListItem>
                                        <asp:ListItem Value="2" Selected="True">Any</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblMonth" runat="server" AssociatedControlID="ddlMonth" Text="<%$ Resources:lbl_Month %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="field-medium form-control">
                                        <asp:ListItem Value="0">All</asp:ListItem>
                                        <asp:ListItem Value="1">January</asp:ListItem>
                                        <asp:ListItem Value="2">Februray</asp:ListItem>
                                        <asp:ListItem Value="3">March</asp:ListItem>
                                        <asp:ListItem Value="4">April</asp:ListItem>
                                        <asp:ListItem Value="5">May</asp:ListItem>
                                        <asp:ListItem Value="6">June</asp:ListItem>
                                        <asp:ListItem Value="7">July</asp:ListItem>
                                        <asp:ListItem Value="8">August</asp:ListItem>
                                        <asp:ListItem Value="9">September</asp:ListItem>
                                        <asp:ListItem Value="10">October</asp:ListItem>
                                        <asp:ListItem Value="11">November</asp:ListItem>
                                        <asp:ListItem Value="12">December</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblDateOption" runat="server" AssociatedControlID="rblDateOption" Text="<%$ Resources:lbl_DateOption %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <asp:RadioButtonList ID="rblDateOption" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" Font-Size="12px" CssClass="asp-radio">
                                        <asp:ListItem  Text="<%$ Resources:lbl_EffectiveDate %>" Value="0" Selected="True"></asp:ListItem>
                                        <asp:ListItem  Text="<%$ Resources:lbl_TransactionDate %>" Value="1"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                            </div>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblViewBy" runat="server" AssociatedControlID="rblViewby" Text="<%$ Resources:lbl_ViewBy %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <asp:RadioButtonList ID="rblViewby" runat="server" AutoPostBack="true" RepeatDirection="Horizontal" RepeatLayout="Flow" Font-Size="12px" CssClass="asp-radio">
                                        <asp:ListItem  Text="<%$ Resources:lbl_TransactionCurrency %>" Value="TC" Selected="True"></asp:ListItem>
                                        <asp:ListItem  Text="<%$ Resources:lbl_AccountCurrency %>" Value="AC"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                            </div>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblCurrency" runat="server" AssociatedControlID="ddlCurrency" Text="<%$ Resources:lbl_Currency %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <asp:DropDownList ID="ddlCurrency" runat="server" CssClass="field-medium form-control">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblAllocationPeriod" runat="server" Text="<%$ Resources:lbl_AllocationPeriod %>" CssClass="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <uc2:MultiSelectDD ID="MultiSelectDD1" runat="server"></uc2:MultiSelectDD>
                                </div>
                            </div>
                            <asp:UpdatePanel ID="upUpdateAmount" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                        <ContentTemplate>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblTotalMarked" runat="server" AssociatedControlID="txtTotalMarked" Text="<%$ Resources:lbl_TotalMarked %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <asp:TextBox ID="txtTotalMarked" CssClass="e-num2 form-control" runat="server" ReadOnly="true"></asp:TextBox>
                                    
                                </div>
                                
                            </div>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblTotalWriteOff" runat="server" AssociatedControlID="txtTotalWriteOff" Text="<%$ Resources:lbl_TotalWriteOff %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <asp:TextBox ID="txtTotalWriteOff" CssClass="e-num2 form-control" runat="server" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>
                            <asp:HiddenField ID="hiddentxtTotalMarked" runat="server"></asp:HiddenField>
                            <asp:HiddenField ID="hiddentxtTotalTransactionSelected" runat="server"></asp:HiddenField>

                            </ContentTemplate>
                                </asp:UpdatePanel>

                    </div>
                        <asp:UpdatePanel ID="upUpdateButtons" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                        <ContentTemplate>
                    <div class="card-footer">
                        <asp:LinkButton ID="btnNewsearch" runat="server" Text="<%$ Resources:btn_NewSearch %>" CausesValidation="false" SkinID="btnSecondary"></asp:LinkButton>
                        <asp:LinkButton ID="btnPay" runat="server" Text="<%$ Resources:btn_Pay %>" Visible="false" ValidationGroup="btnPay" SkinID="btnPrimary"></asp:LinkButton>
                        <asp:LinkButton ID="btnAllocate" runat="server" Text="<%$ Resources:btn_Allocate %>" ValidationGroup="btnAllocate" Enabled="false" OnClientClick="return ConfirmAutoAllocateProcess();" SkinID="btnPrimary"></asp:LinkButton>
                        <asp:LinkButton ID="btnDrill" runat="server" Text="<%$ Resources:btn_Drill %>" Enabled="false" Visible="false" SkinID="btnPrimary"></asp:LinkButton>
                        <asp:LinkButton ID="btnFindNow" runat="server" Text="<%$ Resources:btn_FindNow %>" SkinID="btnPrimary"></asp:LinkButton>

                    </div></ContentTemplate>
                            </asp:UpdatePanel>
                </asp:Panel>
                <asp:HiddenField ID="hCurrencyCode" runat="server"></asp:HiddenField>
                <asp:HiddenField ID="hPartyKey" runat="server"></asp:HiddenField>
                <Nexus:WildCardValidator ID="vldWildCard" AllowWildCardAtEndErrorMessage="<%$ Resources:Err_WildCardAtEnd %>" NoWildCardErrorMessage="<%$ Resources:Err_NoWildCard %>" ControlsToValidate="txtAccountCode,txtAlternateRef,txtPolicyNumber" Condition="Auto" Display="none" runat="server" EnableClientScript="true">
                </Nexus:WildCardValidator>
                <asp:CustomValidator ID="IsFound" runat="server" Display="None" ErrorMessage="<%$ Resources:Err_InvalidAccountCode %>"></asp:CustomValidator>
                <asp:CustomValidator ID="custvldSelectTransaction" runat="server" ErrorMessage="<%$ Resources:Err_SelectTransaction %>" ClientValidationFunction="SelectTransaction" SetFocusOnError="true" Display="None" ValidationGroup="btnAllocate"></asp:CustomValidator>
                <asp:CustomValidator ID="custvldValidateMarkedAmount" runat="server" ErrorMessage="<%$ Resources:Err_MarkedAmount %>" ClientValidationFunction="ValidateMarkedAmount" SetFocusOnError="true" Display="None" ValidationGroup="btnAllocate"></asp:CustomValidator>
                <asp:ValidationSummary ID="vldSummaryAutoAllocateProcess" runat="server" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" ValidationGroup="btnAllocate" CssClass="validation-summary"></asp:ValidationSummary>
                <asp:ValidationSummary ID="vldSummaryFindNow" runat="server" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" CssClass="validation-summary"></asp:ValidationSummary>
                <asp:ValidationSummary ID="vldSummaryPay" runat="server" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" ValidationGroup="btnPay" CssClass="validation-summary"></asp:ValidationSummary>
                <asp:CustomValidator ID="cvSingleSRPnSPYPay" runat="server" SetFocusOnError="true" Display="None" ValidationGroup="btnPay" OnServerValidate="ValidateSelectedTransaction"></asp:CustomValidator>
                <asp:CustomValidator ID="cvSingleSRPnSPYAllocate" runat="server" SetFocusOnError="true" Display="None" ValidationGroup="btnAllocate" OnServerValidate="ValidateSelectedTransaction"></asp:CustomValidator>
                <Nexus:ProgressIndicator ID="upProgressUI" OverlayCssClass="updating" AssociatedUpdatePanelID="upInsurerPayment_UI" runat="server">
                    <progresstemplate>
                                </progresstemplate>
                </Nexus:ProgressIndicator>
                <asp:UpdatePanel ID="upInsurerPayment_UI" runat="server" UpdateMode="Always" ChildrenAsTriggers="true">
                    <ContentTemplate>
                        <div class="grid-card table-responsive">
                            <asp:GridView ID="grdvResultInsurerPayments" runat="server" AllowPaging="True" PagerSettings-Mode="Numeric" AutoGenerateColumns="False" GridLines="None" Caption="<%$ Resources:lblResultInsurerPayments_g %>" EmptyDataRowStyle-CssClass="noData" EmptyDataText="<%$ Resources:ErrorMessage %>" AllowSorting="true">
                                <Columns>
                                    <asp:BoundField DataField="companyid" HeaderText="<%$ Resources:lbl_Branch_g %>" SortExpression="CompanyId"></asp:BoundField>
                                    <asp:BoundField DataField="ResolvedName" HeaderText="<%$ Resources:lbl_Client_g %>" SortExpression="ResolvedName"></asp:BoundField>
                                    <asp:BoundField DataField="InsurerRef" HeaderText="<%$ Resources:lbl_Reference_g %>" SortExpression="InsurerRef"></asp:BoundField>
                                    <asp:BoundField DataField="DocumentRef" HeaderText="<%$ Resources:lbl_DocumentRef_g %>" SortExpression="DocumentRef"></asp:BoundField>
                                    <asp:BoundField DataField="AlternateReference" HeaderText="<%$ Resources:lbl_AlternateReference_g %>" SortExpression="AlternateReference"></asp:BoundField>
                                    <asp:BoundField DataField="EffectiveDate" HeaderText="<%$ Resources:lbl_EffectiveDate_g %>" DataFormatString="{0:d}" HtmlEncode="False" SortExpression="EffectiveDate"></asp:BoundField>
                                    <asp:BoundField DataField="AccountingDate" HeaderText="<%$ Resources:lbl_AccountingDate_g %>" DataFormatString="{0:d}" HtmlEncode="False" SortExpression="AccountingDate"></asp:BoundField>
                                    <asp:BoundField DataField="DueDate" HeaderText="<%$ Resources:lbl_DueDate_g %>" DataFormatString="{0:d}" HtmlEncode="False" SortExpression="DueDate"></asp:BoundField>
                                    <Nexus:BoundField DataField="TotalAmount" HeaderText="<%$ Resources:lbl_Amount_g %>" DataType="Currency" SortExpression="TotalAmount"></Nexus:BoundField>
                                    <Nexus:BoundField DataField="TotalPaidAmount" HeaderText="<%$ Resources:lbl_PaidAccountAmount_g %>" DataType="Currency" SortExpression="TotalPaidAmount"></Nexus:BoundField>
                                    <Nexus:BoundField DataField="TotalOutstandingAmount" HeaderText="<%$ Resources:lbl_OutstandingAmount_g %>" DataType="Currency" SortExpression="TotalOutstandingAmount"></Nexus:BoundField>
                                    <Nexus:BoundField DataField="TotalMarkedAmount" HeaderText="<%$ Resources:lbl_MarkedAmount_g %>" DataType="Currency" SortExpression="TotalMarkedAmount"></Nexus:BoundField>
                                    <Nexus:BoundField DataField="TotalClientOutstandingAmount" HeaderText="<%$ Resources:lbl_ClientOutstandingAccountAmount_g %>" DataType="Currency" SortExpression="TotalClientOutstandingAmount"></Nexus:BoundField>
                                    <asp:BoundField DataField="ShortName" HeaderText="<%$ Resources:lbl_ResolvedName_g %>" SortExpression="ShortName"></asp:BoundField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:HiddenField runat="server" ID="HidTransID"></asp:HiddenField>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_AllPeriod_g %>" SortExpression="PeriodName">
                                        <ItemTemplate>
                                            <%#Eval("PeriodName")%>
                                            <%#Eval("YearName")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox runat="server" ID="chkSelectAll" AutoPostBack="True" OnCheckedChanged="chkInsurerPaymentsSelectAll_CheckedChanged" Text=" " CssClass="asp-check"></asp:CheckBox>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkMarked" runat="server" AutoPostBack="true" OnCheckedChanged="chkMarked_CheckedChanged" Text=" " CssClass="asp-check"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <div class="rowMenu">
                                                <ol class="list-inline no-margin">
                                                    <li class="dropdown no-padding"><a href="#" title="Action Menu" md-ink-ripple="" data-toggle="dropdown" class="md-btn grey-100 md-flat md-btn-circle"><i class="fa fa-ellipsis-v" aria-hidden="true"></i></a>
                                                        <ol id='menu_<%# Eval("DocumentKey") %>' class="dropdown-menu dropdown-menu-scale pull-right pull-up top text-color">
                                                            <li>
                                                                <asp:LinkButton ID="lnkbutSelect" runat="server" Text="<%$ Resources:lbl_select %>"></asp:LinkButton>
                                                            </li>
                                                            <li>
                                                                <asp:LinkButton ID="lnkbutQuery" runat="server" Text="<%$ Resources:lbl_query %>"></asp:LinkButton>
                                                            </li>
                                                        </ol>
                                                    </li>
                                                </ol>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <div id="divOutstandingTransDetails" runat="server" visible="false">
                            <legend>
                                <asp:Literal ID="ltOutstandingTransaction" runat="server" Text="<%$ Resources:lbl_OutstandingTransaction %>"></asp:Literal></legend>
                            <div class="grid-card table-responsive">
                                <asp:GridView ID="grdvOutstandingTransaction" runat="server" AllowPaging="True" PagerSettings-Mode="Numeric" AutoGenerateColumns="False" GridLines="None" Caption="<%$ Resources:lblResultOutstandingTransactions_g %>" EmptyDataRowStyle-CssClass="noData" EmptyDataText="<%$ Resources:ErrorMessage %>">
                                    <Columns>
                                        <asp:BoundField DataField="companyid" HeaderText="<%$ Resources:lbl_Branch_g %>"></asp:BoundField>
                                        <asp:BoundField DataField="PeriodName" HeaderText="<%$ Resources:lbl_PeriodName_g %>"></asp:BoundField>
                                        <asp:BoundField DataField="DocumentRef" HeaderText="<%$ Resources:lbl_DocumentRefOutStd_g %>"></asp:BoundField>
                                        <Nexus:BoundField DataField="AccountAmount" HeaderText="<%$ Resources:lbl_Amount_g %>" DataType="Currency"></Nexus:BoundField>
                                        <Nexus:BoundField DataField="PaidAmount" HeaderText="<%$ Resources:lbl_PaidAccountAmount_g %>" DataType="Currency"></Nexus:BoundField>
                                        <Nexus:BoundField DataField="OutstandingAmount" HeaderText="<%$ Resources:lbl_OutstandingAmount_g %>" DataType="Currency"></Nexus:BoundField>
                                        <Nexus:BoundField DataField="MarkedAmount" HeaderText="<%$ Resources:lbl_MarkedAmount_g %>" DataType="Currency"></Nexus:BoundField>
                                        <asp:BoundField DataField="Spare" HeaderText="<%$ Resources:lbl_MediaRef_g %>"></asp:BoundField>
                                        <asp:BoundField DataField="AlternateReference" HeaderText="<%$ Resources:lbl_AlternateReference_g %>"></asp:BoundField>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:HiddenField runat="server" ID="HidTransID"></asp:HiddenField>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="<%$ Resources:lbl_AllPeriod_g %>">
                                            <ItemTemplate>
                                                <%#Eval("PeriodName")%>
                                                <%#Eval("YearName")%>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <asp:CheckBox runat="server" ID="chkOTSelectAll" AutoPostBack="True" OnCheckedChanged="chkOTSelectAll_CheckedChanged" Text=" " CssClass="asp-check"></asp:CheckBox>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkMarkedOutTran" runat="server" AutoPostBack="true" OnCheckedChanged="chkMarkedOutTran_CheckedChanged" Text=" " CssClass="asp-check"></asp:CheckBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <div class="rowMenu">
                                                    <ol id='menu_<%# Eval("TransdetailId") %>' class="list-inline no-margin">
                                                        <li>
                                                            <asp:LinkButton ID="hypPartypay" runat="server" Text="<%$ Resources:lbl_PartyPay %>" SkinID="btnGrid"></asp:LinkButton>
                                                        </li>
                                                    </ol>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                        <asp:HiddenField ID="hdnFileName" runat="server"></asp:HiddenField>
                        <asp:HiddenField ID="hdnDirectoryName" runat="server"></asp:HiddenField>
                        <asp:HiddenField ID="hdnBranch" runat="server"></asp:HiddenField>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnPay" EventName="Click"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="btnAllocate" EventName="Click"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="btnDrill" EventName="Click"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="btnFindNow" EventName="Click"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="btnNewsearch" EventName="Click"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="grdvOutstandingTransaction" EventName="PageIndexChanging"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="grdvOutstandingTransaction" EventName="RowCreated"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="grdvOutstandingTransaction" EventName="RowDataBound"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="grdvResultInsurerPayments" EventName="PageIndexChanging"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="grdvResultInsurerPayments" EventName="RowCreated"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="grdvResultInsurerPayments" EventName="RowDataBound"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="grdvResultInsurerPayments" EventName="RowCommand"></asp:AsyncPostBackTrigger>
                    </Triggers>
                </asp:UpdatePanel>
    </div>
</asp:Content>
