<%@ page language="VB" autoeventwireup="false" inherits="Modal_Report, Pure.Portals" enableEventValidation="false" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <CR:CrystalReportViewer ID="viewerReportViewer" runat="server" ReportSourceID="sourceReportSource"></CR:CrystalReportViewer>
            <CR:CrystalReportSource ID="sourceReportSource" runat="server"></CR:CrystalReportSource>
        </div>
        <div>
            <asp:Button ID="btnOK" CssClass="buttonOk" runat="server" Text="OK"></asp:Button>
        </div>
    </form>
</body>
</html>
