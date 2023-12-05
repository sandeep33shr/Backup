<%@ page language="VB" autoeventwireup="false" inherits="Nexus.modal_ClaimPaymentSummary, Pure.Portals" masterpagefile="~/default.master" enableviewstate="false" enableEventValidation="false" %>

<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<%@ Register Src="~/controls/CalendarLookup.ascx" TagName="CalendarLookup" TagPrefix="uc1" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="Modal_ClaimPaymentSummary">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="lblTitle" runat="server" Text="<%$ Resources:lbl_Title %>"></asp:Literal></h1>
            </div>
            <div class="card-body clearfix">
                <div class="grid-card table-responsive">
                    <asp:GridView ID="grdvSearchResults" runat="server" AllowPaging="False" AutoGenerateColumns="False" GridLines="None" EmptyDataText="<%$ Resources:ErrorMessage %>" EmptyDataRowStyle-CssClass="noData">
                        <Columns>
                            <asp:BoundField DataField="StatusOfTransaction" HeaderText="<%$ Resources:lblStatusOfTransaction %>"></asp:BoundField>
                            <asp:BoundField DataField="MediaTypeCode" Visible="false" HeaderText="<%$ Resources:lblMediaTypeCode %>"></asp:BoundField>
                            <asp:TemplateField HeaderText="<%$ Resources:lblMediaTypeCode %>">
                                <ItemTemplate>
                                    <asp:Label ID="lblMediaType" runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="NoOfTransactions" HeaderText="<%$ Resources:lblNoOfTransactions %>"></asp:BoundField>
                            <Nexus:BoundField DataField="Amount" HeaderText="<%$ Resources:lblAmount %>" DataType="Currency"></Nexus:BoundField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnOK" runat="server" Text="<%$ Resources:lbl_btnOk %>" CausesValidation="false" SkinID="btnPrimary"></asp:LinkButton>
            </div>
        </div>
    </div>
</asp:Content>
