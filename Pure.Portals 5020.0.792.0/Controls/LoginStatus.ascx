<%@ control language="VB" autoeventwireup="false" inherits="Nexus.LoginStatus, Pure.Portals" %>

<ul class="dropdown-menu dropdown-menu-scale pull-right text-color">
    <li>
        <asp:PlaceHolder ID="PnlBranchName" runat="server">
            <asp:HyperLink ID="hypChangeBranchName" runat="server" data="modal" Visible="false"><i class="fa fa-map-marker" aria-hidden="true"></i> Change Branch</asp:HyperLink>
        </asp:PlaceHolder>
    </li>
    <li>
        <asp:LinkButton ID="lbtnChangePassword" runat="server" CausesValidation="false"><i class="fa fa-lock" aria-hidden="true"></i> Change Password</asp:LinkButton>
    </li>
    <li class="divider"></li>
    <li><a id="navLogout" runat="server" href="~/logout.aspx" onclick="setCookie('FolderMenu', 'Off', 1);"><i class="fa fa-power-off" aria-hidden="true"></i> Logout</a></li>
</ul>

