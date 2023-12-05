<%@ page language="VB" masterpagefile="~/default.master" CodeFile="Complete.aspx.vb" autoeventwireup="false" inherits="Nexus.Framework_Complete" enableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register TagPrefix="OC" Namespace="Nexus" %>
<%@ Register Src="~/Controls/ClaimsProgressBar.ascx" TagName="ProgressBar" TagPrefix="uc3" %>
<%@ Register Src="~/Controls/RiskData.ascx" TagName="TransactionConfirmation" TagPrefix="uc1" %>
<%@ Register Src="~/Controls/DocumentManager.ascx" TagName="DocumentManager" TagPrefix="uc4" %>
<%@ Register Src="~/Controls/Document.ascx" TagName="Document" TagPrefix="uc4" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
  
    <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></asp:ToolkitScriptManager> 
    <div id="Claims_Complete">

     
        <uc3:ProgressBar ID="ucProgressBar" runat="server" />
        <div class="nexus-fluid-layout">
            <div class="page-container">
                <div class="page-container-content">
                    <div class="top-corners">
                    </div>
                    <div class="standard-form">
                        <div id="Content">
                            <h1>
                                <asp:Label ID="ltClaimStatus" runat="server" Text="<%$ resources:lbl_ClaimStatus_Heading %>" />
                            </h1>
                            <div class="fieldset-wrapper">
                                <div class="top-corners">
                                </div>
                                <fieldset>  
                                     <asp:Literal runat="server" ID="ltrlThankyouRegister" Visible="false" Text="<%$ Resources:ltrl_thankyou_register %>" />
                                     <asp:Literal runat="server" ID="ltrlThankyouUpdate" Visible="false" Text="<%$ Resources:ltrl_thankyou_update %>" />
                                     <asp:Literal runat="server" ID="ltrlAuthorizeClaimPayment" Visible="false" Text="<%$ Resources:ltrlAuthorizeClaimPayment %>" />
                                     <asp:Literal runat="server" ID="ltrlCloseClaim" Visible="false" Text="<%$ Resources:ltrl_ltrlCloseClaim %>" />                                        
                                     <asp:LinkButton ID="hypClaimNumber"  runat="server"/>
                                     <uc1:TransactionConfirmation ID="TransactionConfirmation" runat="server" />
									</fieldset>
                            </div>
                            <div class="bottom-corners">
                                <div>
									<uc4:DocumentManager runat="server" id="docMgr" Autoarchiveselected="true" Documents="Treaty RI Notification"/>
                                </div>
                            </div>
                             <div class="submitarea">
                                <asp:Button ID="btnReturnToCase" CssClass="submit" runat="server" Text="<%$ Resources:btn_ReturnToCase %>"
                                    Visible="false" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bottom-corners">
                    <div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
