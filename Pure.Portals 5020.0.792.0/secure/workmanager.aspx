<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.WorkManager, Pure.Portals" enableEventValidation="false" %>

<%@ Register Src="~/Controls/AddTaskButton.ascx" TagName="AddTask" TagPrefix="uc6" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="secure_workmanager">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="lblPageHeader" runat="server" Text="<%$ Resources:lblPageHeader%>"></asp:Literal></h1>
            </div>
            <div class="card-body clearfix">
                <legend>
                    <asp:Label ID="lblScheduledTasks" runat="server" Text="<%$ Resources:lbl_ScheduledTasks %>"></asp:Label>
                </legend>
                <div class="row row-sm">
                    <div class="form-group form-group-sm col-lg-2 col-md-4 col-sm-6">
                        <asp:DropDownList ID="ddlTaskStatus" CssClass="form-control" runat="server">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group form-group-sm col-lg-2 col-md-4 col-sm-6">
                        <asp:DropDownList ID="ddlUserGroups" CssClass="form-control" runat="server" AutoPostBack="true">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group form-group-sm col-lg-2 col-md-4 col-sm-6">
                        <asp:DropDownList ID="ddlUsers" CssClass="form-control" runat="server">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group form-group-sm col-lg-2 col-md-4 col-sm-6">
                        <asp:DropDownList ID="ddlDate" CssClass="form-control" runat="server">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group form-group-sm col-lg-1 col-md-4 col-sm-6">
                        <asp:DropDownList ID="ddlShowType" CssClass="form-control" runat="server" AutoPostBack="true">
                            <asp:ListItem Text="(All)" Value="All"></asp:ListItem>
                            <asp:ListItem Text="User" Value="User"></asp:ListItem>
                            <asp:ListItem Text="System" Value="Sys"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group form-group-sm col-lg-2 col-md-4 col-sm-6">
                        <asp:DropDownList ID="ddlParty" CssClass="form-control" runat="server">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group form-group-sm col-lg-1 col-md-12 col-sm-12 text-right">
                        <asp:LinkButton ID="btnUpdate" runat="server" SkinID="btnPrimary" Text="<%$ Resources:btnUpdate %>"></asp:LinkButton>
                    </div>
                </div>
                <asp:UpdatePanel ID="UpdWorkManager" runat="server" ChildrenAsTriggers="False" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="grid-card table-responsive no-margin">
                            <asp:GridView ID="gvWorkManager" runat="server" AutoGenerateColumns="False" AllowPaging="true" AllowSorting="true" PagerSettings-Mode="Numeric" DataKeyNames="TaskInstanceKey" EmptyDataRowStyle-CssClass="noData" EmptyDataText="<%$ Resources:ErrorMessage %>">
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <div class="rowMenu">
                                                <ol id="menu_<%# Eval("TaskInstanceKey") %>" class="list-inline no-margin">
                                                    <li>
                                                        <asp:LinkButton ID="lnkStart" runat="server" Text="<%$ Resources:lbl_Start %>" CommandName="Select" CausesValidation="false" SkinID="btnGrid"></asp:LinkButton>
                                                    </li>
                                                </ol>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="<%$ Resources:lbl_Urgent %>" DataField="Urgent" SortExpression="Urgent"></asp:BoundField>
                                    <asp:BoundField HeaderText="<%$ Resources:lbl_TaskStatus %>" DataField="TaskStatus" SortExpression="TaskStatus"></asp:BoundField>
                                    <asp:BoundField HeaderText="<%$ Resources:lbl_DueDate %>" DataField="DueDate" SortExpression="DueDate"></asp:BoundField>
                                    <asp:BoundField HeaderText="<%$ Resources:lbl_Description %>" DataField="Description" SortExpression="Description"></asp:BoundField>
                                    <asp:BoundField HeaderText="<%$ Resources:lbl_Customer %>" DataField="Customer" SortExpression="Customer"></asp:BoundField>
                                    <asp:BoundField HeaderText="<%$ Resources:lbl_Branch %>" DataField="Branch" SortExpression="Branch"></asp:BoundField>
                                    <asp:BoundField HeaderText="<%$ Resources:lbl_Type %>" DataField="Type" SortExpression="Type"></asp:BoundField>
                                    <asp:BoundField HeaderText="<%$ Resources:lbl_UserGroup %>" DataField="UserGroupDescription" SortExpression="UserGroupDescription"></asp:BoundField>
                                    <asp:BoundField HeaderText="<%$ Resources:lbl_User%>" DataField="UserCode" SortExpression="UserCode"></asp:BoundField>
                                    <asp:BoundField HeaderText="<%$ Resources:lbl_Party%>" DataField="PartyName" SortExpression="PartyName"></asp:BoundField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <div class="rowMenu" style="width: 60px;">
                                                <ol id="menu_<%# Eval("TaskInstanceKey") %>" class="list-inline no-margin">
                                                    <li>
                                                        <asp:HyperLink ID="hypOpen" runat="server" Text="<%$ Resources:lbl_HypOpen %>" NavigateUrl='<%# "~/Modal/WrmTask.aspx?TaskInstanceKey=" + Eval("TaskInstanceKey").ToString()+"&InsuranceFolderKey="+Eval("InsuranceFolderKey").ToString() %>' SkinID="btnHGrid"></asp:HyperLink>
                                                    </li>
                                                </ol>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblInsuranceFolderKey" runat="server" CausesValidation="False" Text='<%#Eval("InsuranceFolderKey") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="gvWorkManager" EventName="Load"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="gvWorkManager" EventName="PageIndexChanging"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="gvWorkManager" EventName="RowCommand"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="gvWorkManager" EventName="RowCreated"></asp:AsyncPostBackTrigger>
                        <asp:AsyncPostBackTrigger ControlID="gvWorkManager" EventName="RowDataBound"></asp:AsyncPostBackTrigger>
                    </Triggers>
                </asp:UpdatePanel>
                <Nexus:ProgressIndicator ID="UpWorkManager" OverlayCssClass="updating" AssociatedUpdatePanelID="UpdWorkManager" runat="server">
                    <progresstemplate>
                                    </progresstemplate>
                </Nexus:ProgressIndicator>
            </div>
            <div class="card-footer">
                <uc6:AddTask ID="AddTask1" runat="server"></uc6:AddTask>
            </div>
        </div>
        <asp:UpdatePanel ID="UpdValidation" runat="server" ChildrenAsTriggers="true" UpdateMode="Always">
            <ContentTemplate>
                <asp:CustomValidator ID="CstVldData" runat="server" Display="None" ErrorMessage="<%$ Resources:msg_Completed %>"></asp:CustomValidator>
                <asp:CustomValidator ID="CstVldMTA" runat="server" Display="None" ErrorMessage="<%$ Resources:lbl_FD_MTAExistMsg %>" Enabled="false"></asp:CustomValidator>
                <asp:ValidationSummary ID="ValidationSummary" ShowSummary="true" HeaderText="<%$ Resources:lbl_ValidationSummary %>" DisplayMode="BulletList" runat="server" CssClass="validation-summary"></asp:ValidationSummary>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
