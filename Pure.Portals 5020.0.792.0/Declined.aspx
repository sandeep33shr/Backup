<%@ page language="VB" autoeventwireup="false" inherits="Nexus.secure_Declined, Pure.Portals" masterpagefile="~/default.master" enableEventValidation="false" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="Declined">
        <div class="card">
            <div class="card-body clearfix">

                <h2 class="image-header">
                    <asp:Image ID="imgPerson" runat="server" SkinID="person.icon"></asp:Image>
                    <asp:Label ID="lblHeading" runat="server" Text="<%$ Resources:lbl_Heading %>"></asp:Label></h2>
                <div id="form-wrapper">
                    <asp:GridView ID="grdvDeclinedReasons" runat="server" AutoGenerateColumns="false">
                        <Columns>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_DeclinedReasonsHeading%>" DataField="DECLINE_REASON"></asp:BoundField>
                        </Columns>
                    </asp:GridView>
                    <asp:Label ID="lblDeclinedMsg" runat="server" Text="<%$ Resources:lbl_DeclinedMsg %>" Visible="false"></asp:Label>
                </div>
            </div>

        </div>
        <div class="card-footer">
            <asp:LinkButton ID="btn_SaveQuote" Text="<%$ Resources:btn_SaveQuote %>" runat="server" SkinID="btnPrimary"></asp:LinkButton>
            <asp:LinkButton ID="btn_SaveRisk" Text="<%$ Resources:btn_SaveRisk %>" runat="server" SkinID="btnPrimary"></asp:LinkButton>
        </div>
    </div>
</asp:Content>
