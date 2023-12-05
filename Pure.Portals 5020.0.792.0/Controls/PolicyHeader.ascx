<%@ control language="VB" autoeventwireup="false" inherits="Controls_PolicyHeader, Pure.Portals" %>
    <script type="text/javascript">
        var bMainDetailChanged = false;
        function TrackChanges() {
            bMainDetailChanged = true;
        }
        var isNewQuote = false;
        function SetTransactionType() {
            isNewQuote = true;
        }
    
        var dialogConfirmed = false;
        function ConfirmToSaveChanges(obj) {
            if (isNewQuote == true) {
                return false;
            }
            if (bMainDetailChanged == true) {
                if (!dialogConfirmed) {
                    var sChangeMessage = '<%= sChangeMessage %>';
                BootstrapDialog.show({
                    title: 'Confirm',
                    closable: false,
                    type: BootstrapDialog.TYPE_WARNING,
                    message: sChangeMessage,
                    buttons: [{
                        id: 'btn-No',
                        icon: 'fa fa-close',
                        label: 'No',
                        cssClass: 'btn btn-sm btn-dark',
                        autospin: false,
                        action: function (dialogRef) {
                            dialogRef.close();                            
                                        }
                                    },
                {
                    id: 'btn-Yes',
                    icon: 'fa fa-check',
                    label: 'Yes',
                    cssClass: 'btn btn-sm btn-primary',
                    autospin: false,
                    action: function (dialogRef) {
                        dialogRef.close();
                        dialogConfirmed = true;
                        if (obj) obj.click();
                    }
                }]
                    });
            }
            return dialogConfirmed;
        }
    }
</script>
<div class="md-whiteframe-z0 bg-white">
<ul id="policyHeader" class="nav nav-lines nav-tabs b-danger">
    <li id="liMainDetails" runat="server">
        <asp:LinkButton ID="lbtnMainDetail" runat="server" Text="<%$ Resources:lbl_PolicyHeader %>" PostBackUrl="~\secure\MainDetails.aspx" CausesValidation="false"></asp:LinkButton>
    </li>
    <li id="liPolicySummary" runat="server">
        <asp:LinkButton ID="lbtnPolicySummary" runat="server" Text="<%$ Resources:lbl_SummaryCover %>" PostBackUrl="~\secure\PremiumDisplay.aspx" CausesValidation="false" OnClientClick="return ConfirmToSaveChanges(this);"></asp:LinkButton>
    </li>
</ul>
</div>