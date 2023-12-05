<%@ Page Language="VB" AutoEventWireup="false" CodeFile="TransUnionCT.aspx.vb" Inherits="Nexus.Modal_TransUnionCT"
    MasterPageFile="~/default.master" EnableViewState="true" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("h1").hide();
        });
    </script>

    <asp:ScriptManager ID="smTransUnionCT" runat="server" />
    <div id="Modal_TransUnionCT">
        <div class="nexus-fluid-layout">
            <h1>
                <asp:Literal ID="lblPageHeader" runat="server" Text="Vehicle Details" /></h1>
            <div class="page-container">
                <div class="page-container-content">
                    <div class="top-corners">
                    </div>
                    <div class="standard-form">
                        <div class="fieldset-wrapper">
                            <div class="top-corners">
                            </div>
                            <fieldset>
                                <div class="standard-form p-b-100">
                                    <div class="grid-card table-responsive no-margin">
                                        <asp:GridView ID="grdvTransUnion" runat="server" EmptyDataText="No Vehicles Found" AllowSorting="true" AutoGenerateColumns="false"
                                            GridLines="None" AllowPaging="true" OnPageIndexChanging="grdvTransUnion_PageIndexChange" PageSize="12" OnRowCommand="grdvTransUnion_RowCommand">
                                            <Columns>
                                                <asp:BoundField HeaderText="MM Code" DataField="MMCode" />
                                                <asp:BoundField HeaderText="Make/Model" DataField="MakeModel" />
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkbutton" SkinID="buttonPrimary" class="btn btn-sm btn-primary" runat="server" CommandName="SelectLink" Text="Select" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>

                            </fieldset>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>