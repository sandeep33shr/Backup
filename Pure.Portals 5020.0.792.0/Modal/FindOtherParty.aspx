<%@ page language="VB" autoeventwireup="false" inherits="Nexus.Modal_FindOtherParty, Pure.Portals" masterpagefile="~/default.master" enableviewstate="true" enableEventValidation="false" %>

<%@ Register assembly="Pure.Portals"  TagPrefix="Nexus" Namespace="Nexus" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <asp:ScriptManager runat="server"></asp:ScriptManager>
    <div id="Modal_FindOtherParty">
        <asp:Panel ID="PnlFindOtherParty" runat="server" DefaultButton="btnSearch" CssClass="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="litFindClientHeader" runat="server" Text="<%$ Resources:lbl_Page_header %>" EnableViewState="false"></asp:Literal>
                </h1>
            </div>
            <div class="card-body clearfix">
                <div class="form-horizontal">
                    <legend>
                        <asp:Label ID="lblPageheader" runat="server" Text="<%$ Resources:lbl_Page_header%>"></asp:Label>
                    </legend>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblname" runat="server" AssociatedControlID="txtName" Text="<%$ Resources:lblname %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtName" TabIndex="1" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblClientCode" runat="server" AssociatedControlID="txtClientCode" Text="<%$ Resources:lblClientCode %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtClientCode" TabIndex="2" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblFileCode" runat="server" AssociatedControlID="txtFileCode" Text="<%$ Resources:lblFileCode %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtFileCode" TabIndex="3" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblAddress" runat="server" AssociatedControlID="txtAddress" Text="<%$ Resources:lblAddress %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtAddress" TabIndex="4" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblClaimNumber" runat="server" AssociatedControlID="txtClaimNumber" Text="<%$ Resources:lblClaimNumber %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtClaimNumber" TabIndex="5" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblRiskIndex" runat="server" AssociatedControlID="txtRiskIndex" Text="<%$ Resources:lblRiskIndex %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtRiskIndex" TabIndex="6" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblPhone" runat="server" AssociatedControlID="txtPhone" Text="<%$ Resources:lblPhone %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtPhone" TabIndex="7" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblPostcode" runat="server" AssociatedControlID="txtPostcode" Text="<%$ Resources:lblPostcode %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtPostcode" TabIndex="8" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblType" runat="server" AssociatedControlID="txtType" Text="<%$ Resources:lblType %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtType" TabIndex="8" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblPartyType" runat="server" AssociatedControlID="txtPartyType" Text="<%$ Resources:lblPartyType %>" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:TextBox ID="txtPartyType" TabIndex="8" CssClass="form-control" runat="server"></asp:TextBox>
                            <asp:DropDownList ID="ddlPartyType" runat="server" Visible="false" CssClass="form-control">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:Label ID="lblIncludeClosedBranches" runat="server" AssociatedControlID="chkIncludeClosedBranches" class="col-md-4 col-sm-3 control-label">
                            <asp:Literal ID="litIncludeClosedBranches" runat="server" Text="<%$ Resources:chkIncludeClosedBranches  %>"></asp:Literal></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:CheckBox ID="chkIncludeClosedBranches" runat="server" Text=" " CssClass="asp-check"></asp:CheckBox>
                        </div>
                    </div>
                </div>
                <asp:Panel CssClass="error" ID="PnlError" runat="server" Visible="false">
                    <asp:Label runat="server" ID="lblError" Text="<%$ Resources:ErrorMessage %>"></asp:Label>
                </asp:Panel>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnReset" runat="server" TabIndex="6" Text="<%$ Resources:btnReset %>" CausesValidation="false" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnSearch" runat="server" TabIndex="5" Text="<%$ Resources:btnSearch %>" SkinID="btnPrimary"></asp:LinkButton>
                
            </div>
        </asp:Panel>
        <nexus:WildCardValidator ID="vldWildCard" AllowWildCardAtEndErrorMessage="<%$Resources:lbl_WildCardAtEnd_Error %>" NoWildCardErrorMessage="<%$Resources:lbl_NoWildCard_Error %>" ControlsToValidate="txtName,txtClientCode,txtFileCode,txtAddress,txtClaimNumber,txtRiskIndex,txtPhone,txtPostcode" Condition="Auto" Display="none" runat="server" EnableClientScript="true">
        </nexus:WildCardValidator>
        <asp:ValidationSummary ID="vldFindInsuranceFileSummary" runat="server" DisplayMode="BulletList" ShowSummary="true" HeaderText="<%$Resources:lbl_ValidationSummary %>" CssClass="validation-summary"></asp:ValidationSummary>
        <asp:UpdatePanel ID="updFindOtherParty" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="True">
            <ContentTemplate>
                <div class="grid-card table-responsive">
                    <asp:GridView ID="grdvSearchResults" runat="server" AllowPaging="True" PagerSettings-Mode="Numeric" AutoGenerateColumns="False" GridLines="None" OnPageIndexChanging="grdvSearchResults_PageIndexChanging" OnRowCommand="grdvSearchResults_RowCommand" DataKeyNames="UserName" EmptyDataRowStyle-CssClass="noData" EmptyDataText="<%$ Resources:ErrorMessage %>">
                        <Columns>
                            <asp:BoundField DataField="UserName" HeaderText="<%$ Resources:lblUserName_g %>" HtmlEncode="false"></asp:BoundField>
                            <asp:BoundField DataField="ResolvedName" HeaderText="<%$ Resources:lblResolvedName_g %>" HtmlEncode="false"></asp:BoundField>
                            <asp:BoundField DataField="AddressLine1" HeaderText="<%$ Resources:lblAddressLine1_g %>" HtmlEncode="false"></asp:BoundField>
                            <asp:BoundField DataField="AddressLine2" HeaderText="<%$ Resources:lblAddressLine2_g %>"></asp:BoundField>
                            <asp:BoundField DataField="PostCode" HeaderText="<%$ Resources:lblPostcode_g %>"></asp:BoundField>
                            <asp:BoundField DataField="Type" HeaderText="<%$ Resources:lblType_g %>"></asp:BoundField>
                            <asp:BoundField DataField="PartySourceDescription" HeaderText="<%$ Resources:lblPartySourceDescription_g %>"></asp:BoundField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <div class="rowMenu">
                                        <ol id="menu_<%# Eval("UserName") %>" class="list-inline no-margin">
                                            <li>
                                                <asp:LinkButton ID="btnSelect" SkinID="btnGrid" runat="server" OnClientClick=<%# "self.parent.set" + Request.QueryString("ClientID") + "OtherParty('" + Nexus.Utils.PureEncode(Eval("ResolvedName")).ToString() + "','" + Eval("Key").ToString() + "','" + Nexus.Utils.PureEncode(Eval("UserName")).ToString() + "');"%>><i class='fa fa-check' aria-hidden='true'></i> Select</asp:LinkButton>
                                            </li>
                                        </ol>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="grdvSearchResults" EventName="DataBound"></asp:AsyncPostBackTrigger>
                <asp:AsyncPostBackTrigger ControlID="grdvSearchResults" EventName="PageIndexChanging"></asp:AsyncPostBackTrigger>
                <asp:AsyncPostBackTrigger ControlID="grdvSearchResults" EventName="RowDataBound"></asp:AsyncPostBackTrigger>
                <asp:AsyncPostBackTrigger ControlID="grdvSearchResults" EventName="RowCommand"></asp:AsyncPostBackTrigger>
            </Triggers>
        </asp:UpdatePanel>
        <nexus:ProgressIndicator ID="upFindOtrParty" OverlayCssClass="updating" AssociatedUpdatePanelID="updFindOtherParty" runat="server">
            <progresstemplate>
            </progresstemplate>
        </nexus:ProgressIndicator>
    </div>
</asp:Content>
