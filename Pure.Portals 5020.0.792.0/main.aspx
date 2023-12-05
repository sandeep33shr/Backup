<%@ page language="VB" masterpagefile="~/Default.master" autoeventwireup="false" inherits="Nexus.main, Pure.Portals" enableEventValidation="false" %>

<asp:Content ID="cntMainBody" runat="server" ContentPlaceHolderID="cntMainBody">
    <div id="main">
        
    
            
        
                
                
            
                    
                    <div class="card">
                        <div class="card-body clearfix">
                            
                            <div class="card-heading"><h1>
                                <asp:Label ID="LblTitle" runat="server" Text="Label"></asp:Label></h1></div>
                            <asp:Literal ID="ltContent" runat="server" EnableViewState="False"></asp:Literal>
                        </div>
                        
                    </div>
                </div>
</asp:Content>
