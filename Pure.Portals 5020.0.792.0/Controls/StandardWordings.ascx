<%@ control language="VB" autoeventwireup="false" inherits="Nexus.Controls_StandardWordings, Pure.Portals" %>
<div id="Controls_StandardWordings">

    <script language="javascript" type="text/javascript">

        $(document).ready(function () {
            if ($('#<%= hdSelect.ClientID%>').val() == "VIEW") {
                document.getElementById("_btnShowSelect").style.display = "none";
            }
        });

        function OpenDoc(sDocPath) {
             window.location.href = sDocPath;
            //window.open(sDocPath, '_newtab');
         
        }
    </script>
    <script type="text/javascript">
        function OpenDoc(sDocPath) {
            window.location.href = sDocPath;
        }
        function refreshSelected() {
            NexusPickList_RefreshSelected('<%= Me.ClientID%>_PckTemplates_CurrentList', '<%= Me.ClientID%>_PckTemplates_AvailList');
            //NexusPickList_RefreshSelected('"<%= Me.ClientID%> + '_PckTemplates_CurrentList', <%= Me.ClientID%> + '_PckTemplates_AvailList');
        }
    </script>


    <div class="grid-card table-responsive">
        <asp:GridView runat="server" ID="grdWordings" AutoGenerateColumns="false" GridLines="both" EmptyDataRowStyle-CssClass="noData" EmptyDataText="<%$ Resources:ErrorMessage %>" datakeynames="DocumentTemplateId">
                        <Columns>
                <asp:BoundField HeaderText="<%$ Resources:lbl_Code_g %>" DataField="Code"></asp:BoundField>
                <asp:BoundField HeaderText="<%$ Resources:lbl_Description_g %>" DataField="Description"></asp:BoundField>
                            <asp:TemplateField>
                                <ItemTemplate>
                        <asp:LinkButton ID="lnkUp" runat="server" Text="<%$ Resources:lbl_Up_g %>" SkinID="btnGrid" CommandName="MoveUp" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                        <asp:LinkButton ID="lnkDown" runat="server" Text="<%$ Resources:lbl_Down_g %>" SkinID="btnGrid" CommandName="MoveDown" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                        <asp:LinkButton ID="lnkEdit" runat="server" Text="<%$ Resources:lbl_Edit_g %>" SkinID="btnGrid" CommandName="EditEndorsement" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                        <asp:LinkButton ID="lnkView" runat="server" Text="<%$ Resources:lbl_View_g %>" SkinID="btnGrid" CommandName="View" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                        <asp:LinkButton ID="lnkPreview" runat="server" Text="<%$ Resources:lbl_Preview_g %>" SkinID="btnGrid" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"Code")%>' CommandName="View" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                        <asp:LinkButton ID="lnkDelete" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"Code")%>' SkinID="btnGrid" Text="<%$ Resources:lbl_Delete_g %>" CommandName="Delete" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <div class="submitarea">
                    <input id="_btnShowSelect" alt="#TB_inline?height=200&width=800&inlineId=PickListContainer"
                        class="thickbox , submit" value="select" type="button" causesvalidation="false"
                        onclick="NexusPickList_RefreshSelected('<%= Me.ClientID%>_PckTemplates_CurrentList','<%= Me.ClientID%>_PckTemplates_AvailList')" />
                </div>                
    <asp:HiddenField ID="hdSelect" runat="server"></asp:HiddenField>
    <asp:CustomValidator ID="custVldIsDocumentAlreadyOpen" runat="server" CssClass="error" ErrorMessage="<%$ Resources:msg_IsDocumentAlreadyOpen %>" Display="none"></asp:CustomValidator>
    <div id="PickListContainer" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Clause Selection </h4>
                </div>
                <div class="modal-body">
                    <div class="table-responsive">
                        <nexus:PickList ID="PckTemplates" EnableViewState="true" CssClass="picklist-table"
                            runat="server" AvailableLabelText="<%$ Resources:lbl_Available %>"
                            AddAllButtonText="<%$ Resources:lbl_AddAll %>" AddButtonText="<%$ Resources:lbl_Add %>"
                            RemoveAllButtonText="<%$ Resources:lbl_RemoveAll %>" RemoveButtonText="<%$ Resources:lbl_Remove %>"
                            CurrentLabelText="<%$ Resources:lbl_Selected %>" FilterLabelText="<%$ Resources:lbl_Filter %>"
                            DisplayAddAllButton="true" DisplayRemoveAllButton="true" DisplayAddButton="true"
                            DisplayRemoveButton="true" AddCode="true" EnableFilter="true">
                        </nexus:PickList>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:LinkButton ID="btnApplySelection" runat="server" Text="<%$ Resources:btnApplySelection %>" OnClientClick="tb_remove(); return true;" CausesValidation="false" SkinID="btnPrimary"></asp:LinkButton>
        </div>
            </div>
        </div>
    </div>
</div>


