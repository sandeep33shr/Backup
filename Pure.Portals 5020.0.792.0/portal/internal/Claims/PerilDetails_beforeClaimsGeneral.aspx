<%@ page language="VB" autoeventwireup="false" CodeFile="PerilDetails.aspx.vb"inherits="Nexus.Claims_PerilDetails" masterpagefile="~/default.master" enableEventValidation="false" %>

<%@ Register TagPrefix="OC" Namespace="Nexus" %>
<%@ Register Src="~/Controls/ClaimsProgressBar.ascx" TagName="ProgressBar" TagPrefix="uc3" %>
<%@ Register Src="~/Controls/ReserveAndRecovery.ascx" TagName="ReserveARecovery"
    TagPrefix="uc4" %>
<%@ Register Src="~/portal/internal/Controls/PayClaim.ascx" TagName="PayClaim" TagPrefix="uc5" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="server">
   <script language="javascript" type="text/javascript">
		// Section Added to Get the transaction type
       window['TransactionType'] = '<%=GetTransactionType()%>';
       window['ClaimDecision'] = '<%=GetClaimDecision()%>';
        
		$(document).ready(function () {
            
            //SET TAB DEFAULTS
            if ($('#<%= hfRememberTabs.ClientID %>').val() == "1") {
                //$('.nav-tabs li:eq(0) a').tab('show');
                $('#liReseveAndRecovery a').tab('show');
            }
            if ($('#<%= hfRememberTabs.ClientID %>').val() == "2") {
                //$('.nav-tabs li:eq(1) a').tab('show');
                $('#liPaymentDetail a').tab('show');
                document.getElementById('<%= hfRememberTabs.ClientId%>').value = 1;
                $('#<%= hfRememberTabs.ClientID %>').val('1');
            }
			
            
            var sTransactionType = '<%=GetTransactionType()%>';
            var ClaimDecision = '<%=GetClaimDecision()%>';
			if (sTransactionType =="PAYCLAIM") {
                	$('#liReseveAndRecovery a').hide();
                    $('#tab-ReseveAndRecovery').hide();
               
                if (ClaimDecision == 6) {
                    
                        $('#liPaymentDetail a').hide();
                        $('#tab-PaymentDetails').hide();
                    alert("Claim Decision status is set to 'Input Error', No payment is allowed");
                    
                    }
                    else {
                        $('#liPaymentDetail a').show();
                        $('#tab-PaymentDetails').show();
                    }
			}
				
			if (sTransactionType =="NEWCLAIM" || sTransactionType =="EDITCLAIM") {
				$('#liReseveAndRecovery a').show();
				$('#tab-ReseveAndRecovery').show();
				$('#liPaymentDetail a').hide();
                $('#tab-PaymentDetails').hide();
               
			}
							
        });

   </script>
    <div id="Claims_EditReserveItems">
        <uc3:ProgressBar ID="ucProgressBar" runat="server"></uc3:ProgressBar>
        <OC:ImprovedTabIndex ID="TabIndex" runat="server" CssClass="TabContainer" TabContainerClass="page-progress" ActiveTabClass="ActiveTab" DisabledClass="DisabledTab"></OC:ImprovedTabIndex>
        <asp:ScriptManager ID="smPerilDetails" runat="server"></asp:ScriptManager>

        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal runat="server" Text="<%$ Resources:PerilDetails_pageheading %>" ID="ltPageHeading"></asp:Literal></h1>
            </div>
            <div class="card-body clearfix">
                <div class="md-whiteframe-z0 bg-white">
                    <ul class="nav nav-lines nav-tabs b-danger">
                        <li id="liReseveAndRecovery" class="active"><a href="#tab-ReseveAndRecovery" data-toggle="tab" aria-expanded="true">
                            <asp:Literal ID="liTabReserveAndRecovery" Text="<%$ Resources:lbl_TabReserveAndRecovery %>" runat="server"></asp:Literal></a></li>
                        <li id="liPaymentDetail"><a href="#tab-PaymentDetails" data-toggle="tab" aria-expanded="true">
                            <asp:Literal ID="liTabPaymentDetails" Text="<%$ Resources:lbl_TabPaymentDetails %>" runat="server"></asp:Literal></a></li>
                    </ul>
                    <div class="tab-content clearfix p b-t b-t-2x">
                        <div id="tab-ReseveAndRecovery" class="tab-pane animated fadeIn active" role="tabpanel">
                            <uc4:ReserveARecovery ID="ReserveARecovery_ctrl" runat="server"></uc4:ReserveARecovery>
                        </div>
                        <div id="tab-PaymentDetails" class="tab-pane animated fadeIn" role="tabpanel">
                            <uc5:PayClaim ID="PayClaim_ctrl" runat="server"></uc5:PayClaim>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <asp:LinkButton ID="btn_Back" runat="server" UseSubmitBehavior="false" Text="<%$ Resources:btn_Back %>" OnClick="BackButton" SkinID="btnSecondary"></asp:LinkButton>
                <asp:LinkButton ID="btn_Next" runat="server" UseSubmitBehavior="true" Text="<%$ Resources:btn_Ok %>" OnClick="NextButton" SkinID="btnPrimary" OnClientClick="CheckPaidAmount()"></asp:LinkButton>
            </div>
        </div>
        <asp:CustomValidator ID="IsValidReserve" runat="server" Display="none"></asp:CustomValidator>
        <asp:CustomValidator ID="cvMediaTypeAndDefaultBankAccountForReciept" runat="server" Display="none"></asp:CustomValidator>
        <asp:ValidationSummary ID="ValidationSummary" DisplayMode="BulletList" HeaderText="<%$ Resources:lbl_ValidationSummary %>" runat="server" CssClass="validation-summary"></asp:ValidationSummary>
        <asp:HiddenField ID="hfRememberTabs" Value="1" runat="server"></asp:HiddenField>
    </div>
</asp:Content>
