<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ClientAccounts.ascx.vb" Inherits="Nexus.Controls_ClientAccounts" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<%@ Register TagPrefix="Nexus" Namespace="Nexus" %>

<script lang="javascript" type="text/javascript">
    function collapseAccountGrid() {
        //Collapse all child grids as default
        $("[id$='_gvClientAccountChild']").css("display", "none");
        ReApplyPaging(); 
    }

    function toggleExpandCollapse(obj, flag) {

        var imgid = document.getElementById(obj).id;
        if (flag) {
            document.getElementById(obj.substr(0, 61).replace(obj.substr(0, 18), "ctl00_cntMainBody_") + 'gvClientAccountChild').style.display = 'none';
            document.getElementById(obj).style.display = 'none';
            document.getElementById(obj.substr(0, 64) + 'Expand').style.display = 'block';
            $('#' + imgid).closest("tr").removeClass('grid-sel-r');

        }
        else {

            var grid = document.getElementById(obj.substr(0, 61).replace(obj.substr(0, 18), "ctl00_cntMainBody_") + 'gvClientAccountChild');
            document.getElementById(obj.substr(0, 61).replace(obj.substr(0, 18), "ctl00_cntMainBody_") + 'gvClientAccountChild').style.display = 'block';
            document.getElementById(obj).style.display = 'block';
            document.getElementById(obj.substr(0, 64) + 'Collapse').style.display = 'block';
            document.getElementById(obj.substr(0, 64) + 'Expand').style.display = 'none';

            $('#' + imgid).closest("tr").addClass('grid-sel-r');
        }
    }

    (function ($) {

        $.fn.tablePagination = function (settings) {
            var defaults = {
                firstArrow: (new Image()).src = "./PagingImages/first.gif",
                prevArrow: (new Image()).src = "./PagingImages/prev.gif",
                lastArrow: (new Image()).src = "./PagingImages/last.gif",
                nextArrow: (new Image()).src = "./PagingImages/next.gif",
                rowsPerPage: 25,
                currPage: 1,
                optionsForRows: [25],
                ignoreRows: []
            };
            settings = $.extend(defaults, settings);

            return this.each(function () {
                var table = $(this)[0];
                var totalPagesId = '#' + table.id + '+#tablePagination #tablePagination_totalPages';
                var currPageId = '#' + table.id + '+#tablePagination #tablePagination_currPage';
                var rowsPerPageId = '#' + table.id + '+#tablePagination #tablePagination_rowsPerPage';
                var firstPageId = '#' + table.id + '+#tablePagination #tablePagination_firstPage';
                var prevPageId = '#' + table.id + '+#tablePagination #tablePagination_prevPage';
                var nextPageId = '#' + table.id + '+#tablePagination #tablePagination_nextPage';
                var lastPageId = '#' + table.id + '+#tablePagination #tablePagination_lastPage';




                var possibleTableRows = $.makeArray($('tbody tr', table));
                var tableRows = $.grep(possibleTableRows, function (value, index) {
                    return ($.inArray(value, defaults.ignoreRows) == -1);
                }, false)

                var numRows = tableRows.length
                var totalPages = resetTotalPages();
                var currPageNumber = (defaults.currPage > totalPages) ? 1 : defaults.currPage;
                if ($.inArray(defaults.rowsPerPage, defaults.optionsForRows) == -1)
                    defaults.optionsForRows.push(defaults.rowsPerPage);


                function hideOtherPages(pageNum) {
                    if (pageNum == 0 || pageNum > totalPages)
                        return;
                    var startIndex = (pageNum - 1) * defaults.rowsPerPage;
                    var endIndex = (startIndex + defaults.rowsPerPage - 1);
                    $(tableRows).show();
                    for (var i = 0; i < tableRows.length; i++) {
                        if (i < startIndex || i > endIndex) {
                            $(tableRows[i]).hide()
                        }
                    }
                }

                function resetTotalPages() {
                    var preTotalPages = Math.round(numRows / defaults.rowsPerPage);
                    var totalPages = (preTotalPages * defaults.rowsPerPage < numRows) ? preTotalPages + 1 : preTotalPages;
                    if ($(totalPagesId).length > 0)
                        $(totalPagesId).html(totalPages);
                    return totalPages;
                }

                function resetCurrentPage(currPageNum) {
                    if (currPageNum < 1 || currPageNum > totalPages)
                        return;
                    currPageNumber = currPageNum;
                    hideOtherPages(currPageNumber);
                    $(currPageId).val(currPageNumber)
                }

                function resetPerPageValues() {
                    var isRowsPerPageMatched = false;
                    var optsPerPage = defaults.optionsForRows;
                    optsPerPage.sort();
                    var perPageDropdown = $(rowsPerPageId)[0];
                    perPageDropdown.length = 0;
                    for (var i = 0; i < optsPerPage.length; i++) {
                        if (optsPerPage[i] == defaults.rowsPerPage) {
                            perPageDropdown.options[i] = new Option(optsPerPage[i], optsPerPage[i], true, true);
                            isRowsPerPageMatched = true;
                        }
                        else {
                            perPageDropdown.options[i] = new Option(optsPerPage[i], optsPerPage[i]);
                        }
                    }
                    if (!isRowsPerPageMatched) {
                        defaults.optionsForRows == optsPerPage[0];
                    }
                }

                function createPaginationElements() {
                    var htmlBuffer = [];
                    htmlBuffer.push("<div id='tablePagination'>");
                    htmlBuffer.push("<span id='tablePagination_perPage'>");
                    htmlBuffer.push("<select id='tablePagination_rowsPerPage'><option value='5'>5</option></select>");
                    htmlBuffer.push("per page");
                    htmlBuffer.push("</span>");
                    htmlBuffer.push("<span id='tablePagination_paginater'>");
                    htmlBuffer.push("<img id='tablePagination_firstPage' src='" + defaults.firstArrow + "'>");
                    htmlBuffer.push("<img id='tablePagination_prevPage' src='" + defaults.prevArrow + "'>");
                    htmlBuffer.push("Page");
                    htmlBuffer.push("<input id='tablePagination_currPage' type='input' value='" + currPageNumber + "' size='1'>");
                    htmlBuffer.push("of <span id='tablePagination_totalPages'>" + totalPages + "</span>");
                    htmlBuffer.push("<img id='tablePagination_nextPage' src='" + defaults.nextArrow + "'>");
                    htmlBuffer.push("<img id='tablePagination_lastPage' src='" + defaults.lastArrow + "'>");
                    htmlBuffer.push("</span>");
                    htmlBuffer.push("</div>");
                    return htmlBuffer.join("").toString();
                }

                if ($(totalPagesId).length == 0) {
                    $(this).after(createPaginationElements());
                }
                else {
                    $('#tablePagination_currPage').val(currPageNumber);
                }
                resetPerPageValues();
                hideOtherPages(currPageNumber);

                $(firstPageId).bind('click', function (e) {
                    resetCurrentPage(1)
                });

                $(prevPageId).bind('click', function (e) {
                    resetCurrentPage(currPageNumber - 1)
                });

                $(nextPageId).bind('click', function (e) {
                    resetCurrentPage(currPageNumber + 1)
                });

                $(lastPageId).bind('click', function (e) {
                    resetCurrentPage(totalPages)
                });

                $(currPageId).bind('change', function (e) {
                    resetCurrentPage(this.value)
                });

                $(rowsPerPageId).bind('change', function (e) {
                    defaults.rowsPerPage = parseInt(this.value, 10);
                    totalPages = resetTotalPages();
                    resetCurrentPage(1)
                });

            })
        };
    })(jQuery);
</script>


<style>
  
.grid-hdr{
    border-width: 0 1px 1px 0;
    background: #694F7A;
    color: #FFF;
    font-size: 14px;
    font-weight: normal;
    border-style: solid;
    border-left: 1px solid #a0a0a0;
    border-bottom: 1px solid #694F7A;
    padding: 3px 8px;
    height: auto;
    border-style: solid

}
td 
{
     padding: 3px 8px;
border-left: solid;
    border-width: 0 1px 1px 0;
    border-color:White;
  border-style: solid;
    font-size: 14px;
}

    #testTable { 
            width : 300px;
            margin-left: auto; 
            margin-right: auto; 
          }
         
           #tablePagination { 
            background-color:transparent; 
            font-size:  0.8em; 
            padding: 0px 5px; 
            height: 20px
          }
          
          #tablePagination_paginater { 
            margin-left: auto; 
            margin-right: auto;
          }
          
          #tablePagination img { 
            padding: 0px 2px; 
          }
          
          #tablePagination_perPage { 
            float: left; 
          }
          
          #tablePagination_paginater { 
            float: right; 
          }
</style>



<script type="text/javascript">
    $(document).ready(
 	function () {
 	        $('#ctl00_cntMainBody_ClientAccounts_gvClientAccountParent').tablePagination({});

 	});
 	    function ReApplyPaging() {

                    $(document).ready(
                    function () {
                    $('#ctl00_cntMainBody_ClientAccounts_gvClientAccountParent').tablePagination({});

                    });

 	   }
 	</script>


<div id="Controls_ClientAccounts">
    <asp:Panel ID="pnlClientAccounts" runat="server" Visible="true" GroupingText="">
        <asp:UpdatePanel ID="updClientAccounts" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
            <ContentTemplate>
                <div class="card">
                    <div class="card-heading">
                        <h1>
                            <asp:Literal ID="litAccountsHeader" runat="server" Text="<%$ Resources:lbl_Account_header %>"></asp:Literal></h1>
                    </div>
                    <div class="card-body clearfix">
                        <div class="col-lg-6 col-md-12">
                            <div class="form-horizontal">
                                <div class="form-group form-group-sm ">
                                    <asp:Label ID="lblDocumentType" runat="server" AssociatedControlID="lkupDocumentType" CssClass="col-md-4 col-sm-3 control-label" Text="<%$ Resources:lbl_DocumentType%>"></asp:Label>
                                    <div class="col-md-8 col-sm-9">
                                        <NexusProvider:LookupList ID="lkupDocumentType" runat="server" DataItemValue="Code" DataItemText="Description" Sort="ASC" ListType="pmlookup" ListCode="DOCUMENTTYPE" CssClass="form-control" TabIndex="1" DefaultText="All"></NexusProvider:LookupList>
                                    </div>
                                </div>

                                <div class="form-group form-group-sm">
                                    <asp:Label ID="lblDocumentRef" runat="server" AssociatedControlID="txtDocumentRef" CssClass="col-md-4 col-sm-3 control-label" Text="<%$ Resources:lbl_DocumentRef%>"></asp:Label>
                                    <div class="col-md-8 col-sm-9">
                                        <asp:TextBox ID="txtDocumentRef" TabIndex="2" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="form-group form-group-sm">
                                    <asp:Label ID="lblPolicyNumber" runat="server" AssociatedControlID="txtPolicyNumber" CssClass="col-md-4 col-sm-3 control-label" Text="<%$ Resources:lbl_PolicyNumber%>"></asp:Label>
                                    <div class="col-md-8 col-sm-9">
                                        <asp:TextBox ID="txtPolicyNumber" TabIndex="3" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-12">
                            <div class="form-horizontal">
                                <div class="form-group form-group-sm">
                                    <div class="col-lg-12 col-sm-12">
                                        <asp:CheckBox ID="chkOutstandingTransaction" runat="server" TabIndex="4" Text="<%$ Resources:lbl_OutstandingTransaction%>" Checked="true" CssClass="asp-check"></asp:CheckBox>
                                    </div>
                                </div>
                                <div class="form-group form-group-sm">
                                    <div class="col-lg-12 col-sm-12">
                                        <asp:CheckBox ID="chkExcludeInstalments" runat="server" text="<%$ Resources:lbl_ExcludeInstalments%>" TabIndex="5" Checked="false" CssClass="asp-check"></asp:CheckBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <asp:LinkButton ID="btnSearch" runat="server" Text="<%$ Resources:btnSearch %>" EnableViewState="false" OnClick="btnSearch_Click" CausesValidation="false" SkinID="btnPrimary"></asp:LinkButton>
                    </div>
                </div>
                <div class="text-right p-v-sm">
                    <div class="form-inline">
                        <div class="form-group form-group-sm">

                            <asp:Label ID="lblAmountOutstanding" runat="server" AssociatedControlID="txtAmountOutstanding" CssClass="m-r-sm font-bold text-dark">
                                <asp:Literal ID="ltAmountOutstanding" runat="server" Text="<%$ Resources:lbl_AmountOutstanding%>"></asp:Literal></asp:Label>
                              
                            <asp:TextBox ID="txtAmountOutstanding" runat="server" CssClass="form-control Doub" Enabled="false"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <asp:Panel ID="pnlAccounts" runat="server">
                    <div class="grid-card table-responsive no-margin">
                        <asp:UpdatePanel ID="updPanelClientQuotes" runat="server">
                            <ContentTemplate>
                                <asp:GridView ID="gvClientAccountParent" AllowSorting="false" runat="server" AutoGenerateColumns="false" GridLines="None" PagerSettings-Mode="Numeric" EmptyDataRowStyle-CssClass="noData" EmptyDataText="<%$ Resources:ErrorMessage %>">
                                    <Columns>
                                        <asp:TemplateField SortExpression="True" InsertVisible="True">
                                            <ItemStyle CssClass="border"></ItemStyle>
                                            <ItemTemplate>
                                                <asp:Image ID="ImgCollapse" runat="server" ImageUrl="~/images/minus.png" Style="display: none;" onClick="toggleExpandCollapse(this.id,1);"></asp:Image>
                                                <asp:Image ID="ImgExpand" runat="server" ImageUrl="~/images/plus.png" onClick="toggleExpandCollapse(this.id,0);"></asp:Image>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="<%$ Resources:lbl_DocRef %>" DataField="DocRef" SortExpression="DocRef"></asp:BoundField>
                                        <asp:BoundField HeaderText="<%$ Resources:lbl_DocType %>" DataField="DocumentTypeCode" SortExpression="DocumentTypeCode"></asp:BoundField>
                                        <asp:BoundField HeaderText="<%$ Resources:lbl_EffectiveDate %>" DataField="EffectiveDate" HtmlEncode="False" DataFormatString="{0:d}" SortExpression="EffectiveDate"></asp:BoundField>
                                        <asp:BoundField HeaderText="<%$ Resources:lbl_TransDate %>" DataField="TransDate" HtmlEncode="False" DataFormatString="{0:d}" SortExpression="TransDate"></asp:BoundField>
                                        <asp:BoundField HeaderText="<%$ Resources:lbl_MediaType %>" DataField="MediaType" SortExpression="MediaType"></asp:BoundField>
                                        <nexus:BoundField HeaderText="<%$ Resources:lbl_AccountAmount %>" DataField="AccountAmount" DataType="Currency"></nexus:BoundField>
                                        <asp:BoundField HeaderText="<%$ Resources:lbl_PaidDate %>" DataField="PaidDate" HtmlEncode="False" DataFormatString="{0:d}" SortExpression="PaidDate"></asp:BoundField>
                                        <asp:BoundField HeaderText="<%$ Resources:lbl_PolicyNumber %>" DataField="Reference" SortExpression="Reference"></asp:BoundField>
                                        <nexus:BoundField HeaderText="<%$ Resources:lbl_AccountOutStandingAmount %>" DataField="AccountOutStandingAmount" DataType="Currency"></nexus:BoundField>
                                        <nexus:BoundField HeaderText="<%$ Resources:lbl_CurrencyAmount %>" DataField="CurrencyAmount" DataType="Currency"></nexus:BoundField>
                                        <nexus:BoundField HeaderText="<%$ Resources:lbl_OutStandingCurrencyAmount %>" DataField="OutStandingCurrencyAmount" DataType="Currency"></nexus:BoundField>

                                        <asp:TemplateField HeaderText="<%$ Resources:lbl_Plan %>" ShowHeader="false">
                                            <ItemTemplate>
                                                <div class="rowMenu">
                                                    <ol id='ViewPlan_<%# Eval("TransdetailId") %>' class="list-inline no-margin">
                                                        <li>
                                                            <asp:LinkButton ID="lnkbtnViewPlan" runat="server" CausesValidation="False" SkinID="btnGrid" Text="<i class='fa fa-eye' aria-hidden='true'></i> View Plan" CommandName="ViewPlan"></asp:LinkButton></li>
                                                    </ol>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>


                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <tr>
                                                    <td colspan="100%">
                                                        <div class="grid-card table-responsive no-margin">
                                                            <asp:GridView ID="gvClientAccountChild" runat="server" AutoGenerateColumns="false" GridLines="None" OnRowDataBound="gvClientAccountChild_RowDataBound" OnDataBinding="gvClientAccountChild_DataBinding" EmptyDataRowStyle-CssClass="noData" EmptyDataText="<%$ Resources:ErrorMessage %>">
                                                                <Columns>
                                                                    <asp:BoundField HeaderText="<%$ Resources:lbl_DocRef %>" DataField="" HtmlEncode="False"></asp:BoundField>
                                                                    <asp:BoundField HeaderText="<%$ Resources:lbl_EffectiveDate %>" DataField="EffectiveDate" HtmlEncode="False" DataFormatString="{0:d}"></asp:BoundField>
                                                                    <asp:BoundField HeaderText="<%$ Resources:lbl_TransDate %>" DataField="TransDate" HtmlEncode="False" DataFormatString="{0:d}"></asp:BoundField>
                                                                    <asp:BoundField HeaderText="<%$ Resources:lbl_MediaType %>" DataField="MediaType"></asp:BoundField>
                                                                    <asp:BoundField HeaderText="<%$ Resources:lbl_MediaRef %>" DataField="MediaRef"></asp:BoundField>
                                                                    <nexus:BoundField HeaderText="<%$ Resources:lbl_AccountAmount %>" DataField="AccountAmount" DataType="Currency"></nexus:BoundField>
                                                                    <asp:BoundField HeaderText="<%$ Resources:lbl_PaidDate %>" DataField="PaidDate" HtmlEncode="False" DataFormatString="{0:d}"></asp:BoundField>
                                                                    <asp:BoundField HeaderText="<%$ Resources:lbl_PolicyNumber %>" DataField="Reference"></asp:BoundField>
                                                                    <nexus:BoundField HeaderText="<%$ Resources:lbl_AccountOutStandingAmount %>" DataField="AccountOutStandingAmount" DataType="Currency"></nexus:BoundField>
                                                                    <nexus:BoundField HeaderText="<%$ Resources:lbl_CurrencyAmount %>" DataField="CurrencyAmount" DataType="Currency"></nexus:BoundField>
                                                                    <nexus:BoundField HeaderText="<%$ Resources:lbl_OutStandingCurrencyAmount %>" DataField="OutStandingCurrencyAmount" DataType="Currency"></nexus:BoundField>
                                                                </Columns>


                                                            </asp:GridView>
                                                               <asp:TextBox ID="txtOutstandingSubTotal" runat="server" CssClass="form-control Doub" Enabled="false" style="float:right; text-align:center;position:center;"></asp:TextBox>
                                                           <asp:Label ID="outstandingLbl" runat="server" Text="Label" style="float: Right;"></asp:Label>
                                                         
                                                         
                                                          </div>
                                                        
                                                    </td>
                                                </tr>

                                            </ItemTemplate>

                                        </asp:TemplateField>
                                    </Columns>

                                </asp:GridView>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="gvClientAccountParent" EventName="PageIndexChanging"></asp:AsyncPostBackTrigger>
                                  
                            </Triggers>
                        </asp:UpdatePanel>
                        <nexus:ProgressIndicator ID="upClientAccounts" OverlayCssClass="updating" AssociatedUpdatePanelID="updPanelClientQuotes" runat="server">
                            <ProgressTemplate>
                            </ProgressTemplate>
                        </nexus:ProgressIndicator>
                    </div>
                </asp:Panel>



            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>

    
</div>

