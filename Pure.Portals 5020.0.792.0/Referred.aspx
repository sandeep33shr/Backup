<%@ page language="VB" autoeventwireup="false" inherits="Nexus.secure_Referred, Pure.Portals" masterpagefile="~/default.master" enableEventValidation="false" %>

<%@ Register assembly="Pure.Portals"  TagPrefix="Nexus" Namespace="Nexus" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="Referred">
        <div class="card">
            <div class="card-body clearfix">

                <div class="grid-card table-responsive">
                    <asp:GridView ID="grdvReferralReasons" runat="server" AutoGenerateColumns="false">
                        <Columns>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_ReferReasonsHeading%>" DataField="REFER_REASON"></asp:BoundField>
                        </Columns>
                    </asp:GridView>
                    <asp:Label ID="lblReferMsg" runat="server" Text="<%$ Resources:lbl_ReferMsg %>" Visible="false"></asp:Label>
                </div>
            </div>

        </div>

        <div class="card-footer">
            <asp:LinkButton ID="btn_SaveQuote" Text="<%$ Resources:btn_SaveQuote %>" runat="server" SkinID="btnPrimary"></asp:LinkButton>
            <asp:LinkButton ID="btn_SaveRisk" Text="<%$ Resources:btn_SaveRisk %>" runat="server" SkinID="btnPrimary"></asp:LinkButton>
        </div>
    </div>
</asp:Content>
