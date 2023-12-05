<%@ control language="VB" autoeventwireup="false" inherits="Controls_SideInfo, Pure.Portals" enableviewstate="true" %>

<%@ Register Src="~/Controls/ClientInfo.ascx" TagName="ClientInfo" TagPrefix="uc2" %>
<%@ Register Src="~/Controls/ClaimInfo.ascx" TagName="ClaimInfo" TagPrefix="uc3" %>
<div id="Controls_SideInfo">
    <div class="modal fade" id="infoSection" data-backdrop="false">
        <div class="right w-xxl bg-white md-whiteframe-z2">
            <div class="box">
                <div class="p p-h-md bg-light">
                    <a href="#" data-dismiss="modal" class="pull-right text-muted-lt text-2x m-t-n inline p-sm">&times;</a>
                    <strong>Info Section</strong>
                </div>
                <div class="box-row">
                    <div class="box-cell">
                        <div class="box-inner">
                            <div class="list-group no-radius no-borders">
                                <!-- Info section -->
                                <div id="side-accordion">
                                    <div class="md-whiteframe-z0 m-b-lg no-margin">
                                        <ul class="nav scroll-y" ui-nav="">
                                            <li id="ClientInfo" runat="server" visible="false" class="active">
                                                <a href="#" class="auto" md-ink-ripple="">
                                                    <span class="pull-right text-muted m-r-xs">
                                                        <i class="fa fa-plus inline"></i>
                                                        <i class="fa fa-minus none"></i>
                                                    </span>
                                                    <asp:Label ID="Label1" Text="<%$ Resources:lbl_ClientInfoHeader %>" runat="server"></asp:Label>
                                                </a>
                                                <div class="nav nav-sub nav-sm" style="display: block;">
                                                    <uc2:ClientInfo ID="ClientInfoCtrl" runat="server"></uc2:ClientInfo>
                                                </div>
                                            </li>
                                            <li id="ClaimInfo" runat="server" visible="false" class="active">
                                                <a href="#" class="auto" md-ink-ripple="">
                                                    <span class="pull-right text-muted m-r-xs">
                                                        <i class="fa fa-plus inline"></i>
                                                        <i class="fa fa-minus none"></i>
                                                    </span>
                                                    <asp:Label ID="Label2" Text="<%$ Resources:lbl_ClaimInfoHeader %>" runat="server"></asp:Label>
                                                </a>
                                                <div class="nav nav-sub nav-sm" style="display: block;">
                                                    <uc3:ClaimInfo ID="ClaimInfoCtrl" runat="server"></uc3:ClaimInfo>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <!-- Info section -->
                            </div>
                        </div>
                    </div>
                </div>
                <div class="p-h-md p-v bg-light">
                    <div id="ManualTransfer" runat="server" visible="false" class="error">
                        <asp:Label ID="lblManualTransfer" Text="<%$ Resources:lbl_ManualTransfer %>" Visible="false" runat="server"></asp:Label>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>


