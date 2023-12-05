<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.Modal_Commission, Pure.Portals" title="Premium and Commission by Policy Section" enableEventValidation="false" %>

<%@ Register Src="~/Controls/Commission.ascx" TagName="Commission" TagPrefix="uc1" %>
<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <script language="javascript" type="text/javascript">
        function CloseCommission() {
            tb_remove();
        }
    </script>
    <div id="Modal_Commission">
        <uc1:Commission ID="Commission" ShowEditLinks="false" cssclass="submit" runat="server"></uc1:Commission>
    </div>
</asp:Content>

