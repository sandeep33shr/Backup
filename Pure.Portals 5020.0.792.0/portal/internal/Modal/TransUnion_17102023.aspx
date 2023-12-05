<%@ Page Language="VB" AutoEventWireup="false" CodeFile="TransUnion.aspx.vb" Inherits="Nexus.Modal_TransUnion"
    MasterPageFile="~/default.master" EnableViewState="true" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("h1").hide();
        });
    </script>

    <asp:ScriptManager ID="smTransUnion" runat="server" />
    <div id="Modal_TransUnion">
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
                                    <div class="nexus-tabs">
                                        <asp:GridView ID="grdvTransUnion" runat="server" ShowHeaderWhenEmpty="False" EmptyDataText="No Vehicles Found" AllowSorting="true" AutoGenerateColumns="false"
                                            GridLines="None" AllowPaging="true" OnPageIndexChanging="grdvTransUnion_PageIndexChange" PageSize="12" OnRowCommand="grdvTransUnion_RowCommand">
                                            <Columns>
                                                <asp:BoundField HeaderText="MM Code" DataField="MMCode" />
                                                <asp:BoundField HeaderText="Make" DataField="Make" />
												<asp:BoundField HeaderText="Model" DataField="Model" />
                                                <asp:BoundField HeaderText="Variant" DataField="Variant" />
												<asp:BoundField HeaderText="Manufacture Year" DataField="YearMan" />
                                                <asp:BoundField HeaderText="Body Type" DataField="BodyType" />
                                                <asp:BoundField HeaderText="Cubic Capacity" DataField="CubicCap" />
												<asp:BoundField HeaderText="Fuel Type" DataField="FuelType" />
                                                <asp:BoundField HeaderText="Kilo Watts" DataField="KiloWatts" />
                                                <asp:BoundField HeaderText="Mass" DataField="Mass" />
                                                <asp:BoundField HeaderText="GVM" DataField="GVM" />
												<asp:BoundField HeaderText="Vehicle Value" DataField="VehicleValue" />
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