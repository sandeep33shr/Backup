<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" validaterequest="false" title="Edit Document" inherits="Nexus.Modal_EditDocument, Pure.Portals" enableEventValidation="false" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <script type="text/javascript" language="javascript">
        var bReadOnly = false;
        if ('<%= sMode %>' == 'View') {
            bReadOnly = true;
        }

        tinyMCE.init({
            // General options
            mode: "textareas",
            theme: "advanced",
            // Theme options
            content_css: "jscripts/custom_content.css",
            theme_advanced_buttons1: "bold,italic,underline,|,fontselect,fontsizeselect,|,justifyleft,justifycenter,justifyright,|,bullist,numlist,|,styleselect,formatselect,fontselect,fontsizeselect,|cut,copy,paste,undo,redo,anchor,|,forecolor,backcolor",
            theme_advanced_buttons2: "",
            theme_advanced_toolbar_location: "top",
            theme_advanced_toolbar_align: "left",
            readonly: bReadOnly,
            width: "100%",
            height: "275"
        });

    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="Modal_EditDocument">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="lblPageHeader" runat="server" Text="<%$ Resources:lbl_Edit_g %>"></asp:Literal></h1>
            </div>
            <div class="card-body clearfix">
                <div class="form-horizontal">
                    <legend>
                        <asp:Label ID="lblHeader" runat="server" Text="<%$ Resources:lbl_Edit_g %>"></asp:Label>
                    </legend>
                    <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                        <asp:TextBox ID="txtDocumentEditor" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="card-footer"> 
                  <asp:LinkButton ID="btnCancel" runat="server" Text="<%$ Resources:btn_Cancel %>" CausesValidation="false" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btnSave" runat="server" Text="<%$ Resources:btn_Ok %>" UseSubmitBehavior="true" SkinID="btnPrimary"></asp:LinkButton>
             
            </div>
        </div>
        <asp:ValidationSummary ID="ValidationSummary" ShowSummary="true" DisplayMode="BulletList" HeaderText="Error List" runat="server" CssClass="validation-summary"></asp:ValidationSummary>
    </div>
</asp:Content>
