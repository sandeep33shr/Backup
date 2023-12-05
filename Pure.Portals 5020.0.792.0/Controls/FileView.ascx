<%@ control language="VB" autoeventwireup="false" inherits="Controls_FileView, Pure.Portals" enableviewstate="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register assembly="Pure.Portals"  TagPrefix="Nexus" Namespace="Nexus" %>

<script type="text/javascript">

    //$(document).ready(function () {
    //    $("#document-filter-toggle").click(function () {
    //        $("#document-filter").show(300, function () { $("#document-filter-toggle").removeClass('docexpand'); });
    //    });
    //    $("#document-filter-title").click(function () {
    //        $("#document-filter").hide(300, function () { $("#document-filter-toggle").addClass('docexpand'); });
    //    });

    //    $("#document-upload-toggle").click(function () {
    //        $("#UploadStatusMessage").text('');
    //        $("#document-upload").show(300, function () { $("#document-upload-toggle").removeClass('docexpand'); });
    //    });
    //    $("#document-upload-title").click(function () {
    //        $("#document-upload").hide(300, function () { $("#document-upload-toggle").addClass('docexpand'); });
    //    });
    //    resizeDocManager();
    //});

    //$(window).resize(resizeDocManager);

    //function resizeDocManager() {
    //    var subHeight = 173;
    //    $("#document-browser").height($(window).height() - subHeight);
    //    $("#document-viewer").height($(window).height() - subHeight);
    //}

    function CheckfileType(sender, args) {

        //Check the filename
        var filename = args.get_fileName();

        var filext = filename.substring(filename.lastIndexOf(".") + 1);
        filext = filext.toUpperCase();
        if (filext == "DOC" || filext == "DOCX" || filext == "JPG" || filext == "XLS" || filext == "XLSX" || filext == "PDF" || filext == "TIFF" || filext == "TIF" || filext == "TXT" || filext == "MSG") {
            return true;
        }
        else {

            var err = new Error();
            err.name = 'Input Error';
            err.message = 'File Type Error';
            throw (err);
            return false;
        }
    }

    function showConfirmation(sender, args) {

        document.getElementById('<%= HidImportFile.ClientId%>').value = args.get_fileName();
        $("#UploadStatusMessage").addClass("Confirmationupload");
        $("#UploadStatusMessage").text('<%= GetLocalResourceObject("Msg_FileUpload").ToString() %>');
        __doPostBack('', 'UpdateImport');

    }

    function showError(sender, args) {
        $("#UploadStatusMessage").addClass("errorupload");
        if (args._errorMessage == "File Type Error") {
            $("#UploadStatusMessage").text('<%= GetLocalResourceObject("Msg_FileTypeError").ToString() %>');
        }
        else {
            $("#UploadStatusMessage").text('<%= GetLocalResourceObject("Msg_FileUploadError").ToString() %>');
        }
    }

    function setFolder(sCurrentFolder, sFolderNum) {
        var col_array = sCurrentFolder.split("|");
        var part_num = col_array.length;
        //this should change the “CurrentFolder” property and repopulate the control asynchronously
        document.getElementById('<%= HidCurrentFolder.ClientId%>').value = sCurrentFolder.replace('+',' ');
        document.getElementById('<%= HidFolderNum.ClientId%>').value = sFolderNum;
        // if Depth is greater then one
        if (part_num > 1) {
            __doPostBack('updDocumentResults', 'RefreshDocumentList');
        }
    }


</script>

<div id="Controls_FileView">
    <div id="document-viewer">
        <asp:UpdatePanel runat="server" ID="updDocumentResults" UpdateMode="Conditional"
            ChildrenAsTriggers="true">
            <ContentTemplate>
                <div id="document-upload" class="card card-secondary">
                    <div class="card-heading">
                        <h4>
                            <asp:Literal ID="lblHeading" runat="server" Text="<%$ Resources:lblPageHeader %>" /></h4>
                    </div>
                    <div class="card-body clearfix">
                        <div id="liUpload" runat="server">
                            <cc1:AsyncFileUpload ID="CntAsyncFileUpload" runat="server" OnClientUploadStarted="CheckfileType"
                                OnClientUploadComplete="showConfirmation" OnClientUploadError="showError" CssClass="md-btn md-raised bg-white waves-effect" UploaderStyle="Traditional" />
                            <span id="UploadStatusMessage">
                                <asp:Literal ID="lblFileUploadMessage" runat="server" /></span>
                        </div>
                    </div>
                </div>
                <div id="document-list" class="card card-secondary">
                    <div class="card-heading">
                        <h4>
                            <asp:Literal ID="lblFilesHeader" runat="server" Text="<%$ Resources:lblFilesHeader %>" /></h4>
                    </div>
                    <div class="card-body clearfix">
                        <legend>
                            <asp:Label ID="lblSubHeader" runat="server" Text="<%$ Resources:lbl_DeselectedHeader %>"></asp:Label></legend>
                        <div class="grid-card table-responsive no-margin">
                            <asp:GridView ID="grdvDocumentResults" runat="server" PageSize="10" AllowPaging="true"
                                PagerSettings-Mode="Numeric" EmptyDataText="<%$ Resources:ErrorMessage %>"
                                AutoGenerateColumns="false">
                                <Columns>
                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Name%>">
                                        <ItemTemplate>
                                            <div class="rowMenu">
                                                <ol id='menu_<%# Eval("DocNum") %>' class="list-inline no-margin">
                                                    <li class="no-padding">
                                                        <asp:HyperLink ID="hypDocDescription" SkinID="btnHGrid" runat="server" Target="_blank"></asp:HyperLink></li>
                                                    </li>
                                                </ol>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CreateDate" HeaderText="<%$ Resources:lbl_Created%>"  />
                                    <asp:TemplateField HeaderText="<%$ Resources:lbl_Type%>">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDocumentType" runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <asp:HiddenField ID="HidCurrentFolder" runat="server" />
                        <asp:HiddenField ID="HidFolderNum" runat="server" />
                        <asp:HiddenField ID="HidImportFile" runat="server" />
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="grdvDocumentResults" EventName="DataBound" />
                <asp:AsyncPostBackTrigger ControlID="grdvDocumentResults" EventName="PageIndexChanging" />
                <asp:AsyncPostBackTrigger ControlID="grdvDocumentResults" EventName="RowCommand" />
                <asp:AsyncPostBackTrigger ControlID="grdvDocumentResults" EventName="RowDataBound" />
                <asp:AsyncPostBackTrigger ControlID="grdvDocumentResults" EventName="RowEditing" />
            </Triggers>
        </asp:UpdatePanel>
        <nexus:ProgressIndicator ID="upSearchFileView" OverlayCssClass="updating" AssociatedUpdatePanelID="updDocumentResults"
            runat="server">
            <ProgressTemplate>
            </ProgressTemplate>
        </nexus:ProgressIndicator>
    </div>
</div>
