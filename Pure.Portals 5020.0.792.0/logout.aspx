<%@ page language="VB" autoeventwireup="false" masterpagefile="~/default.master" inherits="Nexus.secure_logout, Pure.Portals" enableEventValidation="false" %>
<asp:Content ID="cntMainBody" runat="server" ContentPlaceHolderID="cntMainBody">
   <script language="javascript" type="text/javascript">
       function logout(sMessage) {
           if (sMessage != '') {
               alert(sMessage);
           }
           location.href = "default.aspx";
       }     
</script>
</asp:Content>