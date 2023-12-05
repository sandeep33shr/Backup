<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SummaryCoverCntlr.ascx.vb"
    Inherits="Products_MOTOR_SummaryOfCover" %>

<%@ Register Src="~/controls/CalendarLookup.ascx" TagName="CalendarLookup" TagPrefix="NexusControl" %>
<%@ Register Src="~/Controls/PolicyDetails.ascx" TagName="PolicyDetails" TagPrefix="uc1" %>
<%@ Register Src="~/Controls/PolicyTax.ascx" TagName="PolicyTaxCntrl" TagPrefix="uc2" %>
<%@ Register Src="~/Controls/AgentCommission.ascx" TagName="AgentCommissionCntrl" TagPrefix="uc3" %>
<%@ Register Src="~/Controls/EditTax.ascx" TagName="EditTaxCntrl" TagPrefix="uc4" %>
<%@ Register Src="~/Controls/PolicyFees.ascx" TagName="PolicyFeesCntrl" TagPrefix="uc5" %>
<%@ Register Src="~/Controls/RiskFees.ascx" TagName="RiskFeesCntrl" TagPrefix="uc6" %>
<%@ Register Src="~/Controls/RiskTax.ascx" TagName="RiskTaxCntrl" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/DocumentManager.ascx" TagName="DocMgrCntrl" TagPrefix="uc8" %>
<script type="text/javascript" lang="javascript">
    $(document).ready(function () {

    });
</script>
<div>
    <div>
        <uc1:PolicyDetails ID="PolicyDetails" runat="server" />
        <uc3:AgentCommissionCntrl ID="AgentCommissionCntrl" runat="server" />
        <uc4:EditTaxCntrl ID="EditTaxCntrl" runat="server" />
        <uc8:DocMgrCntrl ID="DocMgr" runat="server" AutoArchiveSelected="false" Documents="" />
    </div>

    <div id="divWarning" runat="server" visible ="false">
        <br />
        <h4>&nbsp;&nbsp;Policy Bind Warnings</h4>
        <asp:BulletedList ID="WarningList" runat="server" ForeColor="Red">
        </asp:BulletedList>
    </div>
</div>
