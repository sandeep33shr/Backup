<%@ page language="VB" autoeventwireup="false" inherits="Modal_Viewallocation, Pure.Portals" masterpagefile="~/default.master" enableEventValidation="false" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">

    <script type="text/javascript" language="javascript">
        function ShowMsg(sErrorMessage) {
            alert(sErrorMessage);
            return false;
        }

        function ReversalConfirmation(sWarningMessage, sSplitMessage) {
            var IsSplitReceipt = getQuerystring('IsSplitReceipt');
            var IsLeadAgent = getQuerystring('IsLeadAgent');
            if (IsSplitReceipt == "True" && IsLeadAgent == "True") {
                var Split = confirm(sSplitMessage);
                if (Split) {
                    var result = confirm(sWarningMessage);
                    document.getElementById('<%=hidChkChoice.ClientID %>').value = result;
                    return result;
                }
            }
            else {
                var result = confirm(sWarningMessage);
                document.getElementById('<%=hidChkChoice.ClientID %>').value = result;
                return result;
            }
        }

        function getQuerystring(key, default_) {

            if (default_ == null) default_ = "";
            key = key.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
            var regex = new RegExp("[\\?&]" + key + "=([^&#]*)");
            var qs = regex.exec(window.location.href);
            if (qs == null)
                return default_;
            else
                return qs[1];

        }

    </script>

    <div id="Modal_Viewallocation">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="lblPageHeader" runat="server" Text="<%$ Resources:lblPageHeader%>"></asp:Literal></h1>
            </div>
            <div class="card-body clearfix">
                <legend>
                    <asp:Label ID="lblViewallocation" runat="server" Text="<%$ Resources:lbl_Credit %>"></asp:Label></legend>
                <asp:Label ID="lblInformation" runat="server" Visible="false"></asp:Label>
                <div class="grid-card table-responsive maxheight">
                    <asp:GridView ID="gvCredits" runat="server" AutoGenerateColumns="false" GridLines="None" EmptyDataRowStyle-CssClass="noData" EmptyDataText="<%$ Resources:ErrorMessage %>">
                        <Columns>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_DocRef %>" DataField="DocRef"></asp:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_TransDate %>" DataField="TransDate" DataFormatString="{0:d}"></asp:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_AllocatedDate %>" DataField="AllocatedDate" DataFormatString="{0:d}"></asp:BoundField>
                            <Nexus:BoundField HeaderText="<%$ Resources:lbl_AllocatedAmount %>" DataField="AllocatedAmount" DataType="Currency"></Nexus:BoundField>
                            <Nexus:BoundField HeaderText="<%$ Resources:lbl_OriginalAmount %>" DataField="OriginalAmount" DataType="Currency"></Nexus:BoundField>
                            <Nexus:BoundField HeaderText="<%$ Resources:lbl_WriteOffAmount %>" DataField="WriteOffAmount" DataType="Currency"></Nexus:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_DocType %>" DataField="DocType"></asp:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_InsuranceRef %>" DataField="InsuranceRef"></asp:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_Account %>" DataField="Account"></asp:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_User %>" DataField="User"></asp:BoundField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <div class="rowMenu">
                                        <ol id='menu_<%# Eval("DocRef") %>' class="list-inline no-margin">
                                            <li>
                                                <asp:LinkButton ID="btnSelect" runat="server" Text="<%$ Resources:btnSelect%>" CommandName="Select" CausesValidation="false" SkinID="btnGrid"></asp:LinkButton>
                                            </li>
                                        </ol>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <legend>
                    <asp:Label ID="lblDebit" runat="server" Text="<%$ Resources:lbl_Debit %>"></asp:Label></legend>
                <div class="grid-card table-responsive maxheight">
                    <asp:GridView ID="gvDebit" runat="server" AutoGenerateColumns="false" GridLines="None" EmptyDataRowStyle-CssClass="noData" EmptyDataText="<%$ Resources:ErrorMessage %>">
                        <Columns>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_DocRef %>" DataField="DocRef"></asp:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_TransDate %>" DataField="TransDate" DataFormatString="{0:d}"></asp:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_AllocatedDate %>" DataField="AllocatedDate" DataFormatString="{0:d}"></asp:BoundField>
                            <Nexus:BoundField HeaderText="<%$ Resources:lbl_AllocatedAmount %>" DataField="AllocatedAmount" DataType="Currency"></Nexus:BoundField>
                            <Nexus:BoundField HeaderText="<%$ Resources:lbl_OriginalAmount %>" DataField="OriginalAmount" DataType="Currency"></Nexus:BoundField>
                            <Nexus:BoundField HeaderText="<%$ Resources:lbl_WriteOffAmount %>" DataField="WriteOffAmount" DataType="Currency"></Nexus:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_DocType %>" DataField="DocType"></asp:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_InsuranceRef %>" DataField="InsuranceRef"></asp:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_Account %>" DataField="Account"></asp:BoundField>
                            <asp:BoundField HeaderText="<%$ Resources:lbl_User %>" DataField="User"></asp:BoundField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <div class="rowMenu">
                                        <ol id='menu_<%# Eval("DocRef") %>' class="list-inline no-margin">
                                            <li>
                                                <asp:LinkButton ID="btnSelect" runat="server" Text="<%$ Resources:btnSelect%>" CommandName="Select" CausesValidation="false" SkinID="btnGrid"></asp:LinkButton>
                                            </li>
                                        </ol>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:HiddenField ID="hidChkAuthority" runat="server"></asp:HiddenField>
                    <asp:HiddenField ID="hidTransID" runat="server"></asp:HiddenField>
                    <asp:HiddenField ID="hidAllocID" runat="server"></asp:HiddenField>
                    <asp:HiddenField ID="hidNoOfDays" runat="server"></asp:HiddenField>
                    <asp:HiddenField ID="hidAllocationDate" runat="server"></asp:HiddenField>
                    <asp:HiddenField ID="hidChkChoice" runat="server"></asp:HiddenField>
                    <asp:HiddenField ID="hidExpAlloc" runat="server"></asp:HiddenField>
                </div>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btnClose" runat="server" Text="<%$ Resources:btnClose %>" OnClientClick="self.parent.tb_remove(); return false;" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnReverseAllocation" runat="server" Text="<%$ Resources:btnReverseAllocation %>" Visible="false" SkinID="btnPrimary"></asp:LinkButton>
                
            </div>
        </div>
    </div>
</asp:Content>
