<%@ page language="VB" autoeventwireup="false" inherits="Nexus.SessionExpired, Pure.Portals" masterpagefile="~/default.master" enableEventValidation="false" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="server">
    <div id="SessionExpired">
        
    
            
        
                
                
            
                    
                    <div class="card">
                        <div class="card-heading"><h1>
                            <asp:Label ID="lblTitle" runat="server" Text="<%$ Resources:lbl_Title %>"></asp:Label></h1></div>
                        <p>
                            <asp:Literal ID="ltContent" runat="server" Text="<%$ Resources:lt_Content %>"></asp:Literal>
                        </p>
                    </div>
                </div>
</asp:Content>
