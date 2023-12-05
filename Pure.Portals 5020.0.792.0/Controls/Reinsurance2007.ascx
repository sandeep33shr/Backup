<%@ control language="VB" autoeventwireup="false" inherits="Nexus.Controls_Reinsurance2007, Pure.Portals" %>
<%@ Register Src="~/Controls/RIModelSummary.ascx" TagName="RIModel" TagPrefix="uc1" %>


<script type="text/javascript" language="javascript">

    $(document).ready(function () {
        var currentURL = location.toString();
        if ((currentURL.indexOf("?RICode") != -1)) {
            $('.nav-tabs a[href="#tab-ReinsuranceCntrl"]').tab('show')
        }
        gridButtonHandling();
    });

    function configPercentage(byControl, e_format) {
        $(byControl).each(function () {
            $(this).numeric(".");

            $(this).focus(function () {
                $(this).select();
            });
            $(this).keypress(function (event) {
                if ($(this).val().split('.').length > 1) {
                    var strNumber = $(this).val();
                    var strAfterDecimal = strNumber.split('.')[1];
                    var iCursorPosition = $(this).caret().start;
                    if (($(this).val().indexOf('%')) > 0) {
                        if (strAfterDecimal.length > 4 && iCursorPosition > $(this).val().indexOf('.')) {
                            event.preventDefault();
                        }
                    }
                    else {
                        if (strAfterDecimal.length > 3 && iCursorPosition > $(this).val().indexOf('.')) {
                            event.preventDefault();
                        }
                    }
                }
            });
            $(this).bind('paste', function (e) {
                var browserName = navigator.appName;
                if (browserName == "Microsoft Internet Explorer") {
                    var strNumber = clipboardData.getData("text");
                    var havePercentSymbol = false;
                    if (strNumber.indexOf('%') > 0) {
                        strNumber = strNumber.replace('%', '')
                        havePercentSymbol = true;
                    }
                    var strBeforeDecimal = strNumber.split('.')[0];
                    var strAfterDecimal = strNumber.split('.')[1];

                    if (strAfterDecimal.length > 4) {
                        strAfterDecimal = strAfterDecimal.substring(0, 4)
                    }
                    var numberToPaste = strBeforeDecimal + '.' + strAfterDecimal;
                    if (havePercentSymbol == true) {
                        numberToPaste = numberToPaste + '%';
                    }
                    clipboardData.setData("text", numberToPaste);
                }
            });
        });

        $(byControl).css('text-align', 'right');
    }

    function alertMe(sMessage) {
        alert(sMessage);
    }

    function ShowMsg(sMessage) {
        alert(sMessage);
    }

    function ConfirmRIMsg(sMessage) {
        var ret = confirm(sMessage);
        return ret;
    }

    function gridButtonHandling() {
        $('.rowMenu').each(function () {
            if ($(this).find('a[data-toggle^="dropdown"]').length > 0) {
                if ($(this).find('a').length <= 1) {
                    $(this).hide();
                }
            }
        });
    }

    function DisableButton(sender, args) {
        //disable the button (or whatever else we need to do) here
        var btnOK = document.getElementById('<%= btnOK.ClientId%>');
        if (btnOK != null) {
            btnOK.disabled = true;
        }
        gridButtonHandling();
    }

    function EnableButton(sender, args) {
        //enable the button (or whatever else we need to do) here
        var btnOK = document.getElementById('<%= btnOK.ClientId%>');
            if (btnOK != null) {
                btnOK.disabled = false;
            }
            gridButtonHandling();
        }

        function pageLoad() {
            //this is needed if the trigger is external to the update panel   
            var manager = Sys.WebForms.PageRequestManager.getInstance();
            manager.add_beginRequest(DisableButton);
            manager.add_endRequest(EnableButton);
        }

        function ValidateXOLRiModelAndRIModelExistance(sMessage, bIsPTAmendment) {
            alert(sMessage);
            if (bIsPTAmendment == true) {
                window.location = '<%=ResolveClientUrl("~/secure/RIAmendRiskList.aspx") %>';
            }
            else {
                window.location = '<%=ResolveClientUrl("~/secure/PremiumDisplay.aspx") %>';
            }
        }

</script>
<div id="Controls_Reinsurance2007">
    <div class="md-whiteframe-z0 bg-white">
        <ul class="nav nav-lines nav-tabs b-danger">
            <li class="active"><a href="#tab-ReinsuranceMain" data-toggle="tab" aria-expanded="true">
                <asp:Literal ID="lbltab_ReinsuranceMain" runat="server" Text="<%$Resources:lbl_tab_Reinsurance %>"></asp:Literal></a></li>
            <li><a href="#tab-ReinsuranceModelSummary" data-toggle="tab" aria-expanded="true">
                <asp:Literal ID="lbltab_ReinsuranceModelSummary" runat="server" Text="<%$Resources:lbl_tab_RIModelSummary %>"></asp:Literal></a></li>
        </ul>
        <div class="tab-content clearfix p b-t b-t-2x">
            <div id="tab-ReinsuranceMain" class="tab-pane animated fadeIn active" role="tabpanel">
                <asp:UpdatePanel ID="UpdatePanelReinsurance" runat="server" UpdateMode="Always" ChildrenAsTriggers="true">
                    <ContentTemplate>
                        <div class="form-horizontal">
                            <legend>
                                <asp:Label ID="lblReinsuranceMain" runat="server" Text="<%$ Resources:lbl_Reinsurance %>"></asp:Label></legend>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <asp:Label ID="lblReinsuranceBand" runat="server" AssociatedControlID="ddlReinsurance" Text="<%$ Resources:lblReinsuranceBand %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <div class="col-md-8 col-sm-9">
                                    <asp:DropDownList ID="ddlReinsurance" runat="server" CssClass="field-medium form-control" AutoPostBack="True"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                                <div class="col-md-8 col-sm-9">
                                    <asp:DropDownList ID="ddlRIVersion" runat="server" CssClass="field-medium form-control" AutoPostBack="True" Visible="false"></asp:DropDownList>
                                </div>
                                <asp:Label ID="lblEffectiveDate" runat="server" Visible="false" Text="<%$ Resources:lblEffectiveDate %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                                <asp:Label ID="lblVersionEffectiveDate" runat="server" Visible="false" class="col-md-4 col-sm-3 control-label"></asp:Label>
                            </div>
                        </div>
                        <div class="grid-card table-responsive no-margin">
                            <asp:GridView ID="gvReinsurance" runat="server" AutoGenerateColumns="False" GridLines="None" AllowPaging="false" ShowHeader="True" EmptyDataRowStyle-CssClass="noData" EmptyDataText="<%$ Resources:ErrorMessage %>">
                                <Columns>
                                    <asp:BoundField DataField="IsNew" HeaderText="Is New"></asp:BoundField>
                                    <asp:BoundField DataField="IsEdited" HeaderText="Is Edited"></asp:BoundField>
                                    <asp:BoundField DataField="Placement" HeaderText="<%$ Resources:lblPlacement %>"></asp:BoundField>
                                    <asp:BoundField DataField="Name" HeaderText="<%$ Resources:lblName %>" HtmlEncode="False"></asp:BoundField>
                                    <nexus:BoundField DataField="Retained" HeaderText="<%$ Resources:lblRetained %>" DataType="Percentage"></nexus:BoundField>
                                    <nexus:BoundField DataField="DefaultPerc" HeaderText="<%$ Resources:lblDefault %>" DataType="Percentage" ItemStyle-CssClass="Perc" HeaderStyle-CssClass="Perc"></nexus:BoundField>
                                    <nexus:TemplateField HeaderText="<%$ Resources:lblThis %>" ItemStyle-CssClass="Perc" HeaderStyle-CssClass="Perc" DataType="Percentage">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtThisPerc" runat="server" Visible="false" Text='<%# XPath("@ThisPerc") %>' ToolTip='<%# XPath("@RIArrangementLineKey")%>' OnTextChanged="txtThisPerc_TextChanged" AutoPostBack="true" CssClass="PercTextBox"></asp:TextBox>
                                            <asp:RangeValidator ID="rngThisPerc" runat="server" Display="None" ControlToValidate="txtThisPerc" MinimumValue="0.0001" MaximumValue="100" Type="Double" ErrorMessage="<%$ Resources:Err_InvalidRange %>" Enabled="false"></asp:RangeValidator>
                                            <asp:Label ID="lblThisPerc" runat="server" Visible="false" Text='<%# String.Format("{0}{1}",XPath("@ThisPerc"),"%")%>' HtmlEncode="false" CssClass="Perc"></asp:Label>
                                        </ItemTemplate>
                                    </nexus:TemplateField>
                                    <nexus:BoundField DataField="LowerLimit" HeaderText="<%$ Resources:lblLowerLimit %>" DataType="Currency"></nexus:BoundField>
                                    <nexus:BoundField DataField="LineLimit" HeaderText="<%$ Resources:lblUpperLimit %>" DataType="Currency"></nexus:BoundField>
                                    <nexus:TemplateField HeaderText="<%$ Resources:lblSumInsured %>" DataType="Currency">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtSumInsured" runat="server" Visible="false" Text='<%# XPath("@SumInsured")%>' ToolTip='<%# XPath("@RIArrangementLineKey")%>' OnTextChanged="txtSumInsured_TextChanged" AutoPostBack="true" CssClass="form-control"></asp:TextBox>
                                            <asp:Label ID="lblSumInsured" runat="server" Visible="false" Text='<%# XPath("@SumInsured")%>' CssClass="Doub"></asp:Label>
                                        </ItemTemplate>
                                    </nexus:TemplateField>
                                    <nexus:BoundField DataField="Premium" HeaderText="<%$ Resources:lblPremium %>" DataType="Currency"></nexus:BoundField>
                                    <nexus:BoundField DataField="Tax" HeaderText="<%$ Resources:lblTax %>" DataType="Currency"></nexus:BoundField>
                                    <nexus:TemplateField HeaderText="<%$ Resources:lblCommissionPercentage %>" DataType="Percentage">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtCommissionPerc" runat="server" Visible="false" Text='<%# String.Format("{0}{1}",XPath("@CommissionPerc"),"%")%>' ToolTip='<%# XPath("@RIArrangementLineKey")%>' OnTextChanged="txtCommissionPerc_TextChanged" AutoPostBack="true" CssClass="PercTextBox"></asp:TextBox>
                                            <asp:Label ID="lblCommissionPerc" runat="server" Visible="false" Text='<%# String.Format("{0}{1}",XPath("@CommissionPerc"),"%")%>' CssClass="Perc"></asp:Label>
                                        </ItemTemplate>
                                    </nexus:TemplateField>
                                    <nexus:BoundField DataField="Commission" HeaderText="<%$ Resources:lblCommission %>" DataType="Currency"></nexus:BoundField>
                                    <nexus:BoundField DataField="CommissionTax" HeaderText="<%$ Resources:lblCommTax %>" DataType="Currency"></nexus:BoundField>
                                    <asp:TemplateField HeaderText="<%$ Resources:lblAgreement %>" HeaderStyle-CssClass="str">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtAgreement" runat="server" Visible="false" Text='<%# XPath("@Agreement")%>' ToolTip='<%# XPath("@RIArrangementLineKey")%>' OnTextChanged="txtAgreement_TextChanged" AutoPostBack="true" CssClass="strTextBox"></asp:TextBox>
                                            <asp:Label ID="lblAgreement" runat="server" Visible="false" Text='<%# XPath("@Agreement")%>' CssClass="str"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <div class="rowMenu">
                                                <ol class="list-inline no-margin">
                                                    <li class="dropdown no-padding"><a href="#" title="Action Menu" md-ink-ripple="" data-toggle="dropdown" class="md-btn grey-100 md-flat md-btn-circle"><i class="fa fa-ellipsis-v" aria-hidden="true"></i></a>
                                                        <ol id="menu_<%# Eval("RIArrangementLineKey") %>" class="dropdown-menu dropdown-menu-scale pull-right pull-up top text-color">
                                                            <li>
                                                                <asp:LinkButton ID="lnkDelete" runat="server" Text="<%$ Resources:lbl_grdvPerils_linkDelete_text %>" Visible="false" ToolTip='<%# XPath("@RIArrangementLineKey")%>' CommandName="Delete"></asp:LinkButton>
                                                            </li>
                                                            <li>
                                                                <asp:LinkButton ID="lnkView" runat="server" Text="<%$ Resources:lbl_grdvPerils_linkView_text %>" Visible="false" ToolTip='<%# XPath("@RIArrangementLineKey")%>' CommandName="View"></asp:LinkButton>
                                                            </li>
                                                            <li>
                                                                <asp:LinkButton ID="lnkEdit" runat="server" Text="<%$ Resources:lbl_grdvPerils_linkEdit_text %>" Visible="false" ToolTip='<%# XPath("@RIArrangementLineKey")%>' CommandName="EditRow"></asp:LinkButton>
                                                            </li>
                                                        </ol>
                                                    </li>
                                                </ol>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="RIarrangementKey" HeaderText="RIarrangementKey" Visible="false"></asp:BoundField>
                                    <asp:BoundField DataField="RIArrangementLineKey" HeaderText="RIArrangementLineKey" Visible="false"></asp:BoundField>
                                    <asp:BoundField DataField="IsRIBroker" HeaderText="IsRIBroker" Visible="false"></asp:BoundField>
                                    <asp:BoundField DataField="Type" HeaderText="Type" Visible="false"></asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <p>
                            <asp:Label ID="lblOrgReinsurance" runat="server" AssociatedControlID="litOrgReinsurance">
                                <asp:Literal ID="litOrgReinsurance" runat="server" Text="<%$ Resources:lbl_OrgReinsurance %>"></asp:Literal></asp:Label>
                        </p>
                        <div class="grid-card table-responsive no-margin">
                            <asp:GridView ID="gvOrgReinsurance" runat="server" AutoGenerateColumns="False" GridLines="None" AllowPaging="false" ShowHeader="True" EmptyDataRowStyle-CssClass="noData" EmptyDataText="<%$ Resources:ErrorMessage %>">
                                <Columns>
                                    <asp:BoundField DataField="Placement" HeaderText="<%$ Resources:lblPlacement %>"></asp:BoundField>
                                    <asp:BoundField DataField="Name" HeaderText="<%$ Resources:lblOrgName %>"></asp:BoundField>
                                    <nexus:BoundField DataField="Retained" HeaderText="<%$ Resources:lblRetained %>" DataType="Percentage" ItemStyle-CssClass="Perc" HeaderStyle-CssClass="Perc"></nexus:BoundField>
                                    <nexus:BoundField DataField="DefaultPerc" HeaderText="<%$ Resources:lblOrgDefault %>" DataType="Percentage" ItemStyle-CssClass="Perc" HeaderStyle-CssClass="Perc"></nexus:BoundField>
                                    <nexus:BoundField DataField="ThisPerc" HeaderText="<%$ Resources:lblOrgThis %>" DataType="Percentage" ItemStyle-CssClass="Perc" HeaderStyle-CssClass="Perc"></nexus:BoundField>
                                    <nexus:BoundField DataField="LowerLimit" HeaderText="<%$ Resources:lblLowerLimit %>" DataType="Currency"></nexus:BoundField>
                                    <nexus:BoundField DataField="LineLimit" HeaderText="<%$ Resources:lblUpperLimit %>" DataType="Currency"></nexus:BoundField>
                                    <nexus:BoundField DataField="SumInsured" HeaderText="<%$ Resources:lblOrgSumInsured %>" DataType="Currency"></nexus:BoundField>
                                    <nexus:BoundField DataField="Premium" HeaderText="<%$ Resources:lblOrgPremium %>" DataType="Currency"></nexus:BoundField>
                                    <nexus:BoundField DataField="Tax" HeaderText="<%$ Resources:lblOrgTax %>" DataType="Currency"></nexus:BoundField>
                                    <nexus:BoundField DataField="CommissionPerc" HeaderText="<%$ Resources:lblOrgCommissionPercentage %>" ItemStyle-CssClass="Perc" HeaderStyle-CssClass="Perc" DataType="Percentage"></nexus:BoundField>
                                    <nexus:BoundField DataField="Commission" HeaderText="<%$ Resources:lblOrgCommission %>" DataType="Currency"></nexus:BoundField>
                                    <nexus:BoundField DataField="CommissionTax" HeaderText="<%$ Resources:lblOrgCommTax %>" DataType="Currency"></nexus:BoundField>
                                    <asp:BoundField DataField="Agreement" HeaderText="<%$ Resources:lblOrgAgreement %>" ItemStyle-CssClass="str" HeaderStyle-CssClass="str"></asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="gvReinsurance" EventName="RowCommand"></asp:AsyncPostBackTrigger>
                    </Triggers>
                </asp:UpdatePanel>
                <nexus:ProgressIndicator ID="upReinsurance" OverlayCssClass="updating" AssociatedUpdatePanelID="UpdatePanelReinsurance" runat="server">
                    <ProgressTemplate>
                    </ProgressTemplate>
                </nexus:ProgressIndicator>

                <asp:UpdatePanel ID="updSubmitArea" runat="server">
                    <ContentTemplate>
                        <div class="p-v-sm text-right">
                            <asp:LinkButton ID="btnCancel" SkinID="btnSecondary" runat="server" Text="<%$ Resources:btnCancel%>" CausesValidation="false"></asp:LinkButton>
                            <asp:LinkButton ID="btnAddFacProp" SkinID="btnPrimary" runat="server" Text="<%$ Resources:btnAddFacProp%>" PostBackUrl="~/Modal/FACPlacement.aspx?Type=FACPROP" CausesValidation="false"></asp:LinkButton>
                            <asp:LinkButton ID="btnAddFacXOL" SkinID="btnPrimary" runat="server" Text="<%$ Resources:btnAddFacXOL%>" CausesValidation="false" PostBackUrl="~/Modal/FACPlacement.aspx?Type=FACXOL"></asp:LinkButton>
                            <asp:LinkButton ID="btnOk" SkinID="btnPrimary" runat="server" Text="<%$ Resources:btnOk%>" CausesValidation="false"></asp:LinkButton>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>

            </div>
            <div id="tab-ReinsuranceModelSummary" class="tab-pane animated fadeIn" role="tabpanel">
                <uc1:RIModel ID="RIModelSummaryCntrl" runat="server" Visible="false"></uc1:RIModel>
            </div>
        </div>
    </div>
</div>
