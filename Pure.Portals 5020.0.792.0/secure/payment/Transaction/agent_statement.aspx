<%@ page language="VB" autoeventwireup="false" masterpagefile="~/default.master" inherits="Nexus.secure_payment_Transaction_agent_statement, Pure.Portals" enableEventValidation="false" %>

<%@ Register Src="~/Controls/ProgressBar.ascx" TagName="ProgressBar" TagPrefix="uc3" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="secure_payment_Transaction_agent_statement">
        
    
            
        
                
                
            
                    
                    <div class="card">
                        <div class="card-body clearfix">
                            
                            <uc3:ProgressBar ID="ucProgressBar" runat="server"></uc3:ProgressBar>
                        </div>
                        
                    </div>
                </div>
</asp:Content>
