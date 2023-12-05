<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SummaryCoverCntlr.ascx.vb" Inherits="PrivateCar_SummaryOfCover" %>
<%@ Register Src="~/Controls/PolicyFees.ascx" TagName="PolicyFeesCntrl" TagPrefix="uc1" %>
<%@ Register Src="~/portal/internal/Controls/EditTax.ascx" TagName="EditTaxCntrl" TagPrefix="uc2" %>
<%@ Register Src="~/Controls/AgentCommission.ascx" TagName="AgentCommissionCntrl" TagPrefix="uc3" %>
<%@ Register Src="~/Controls/DocumentList.ascx" TagName="DocumentListCtrl" TagPrefix="uc4" %>
<%@ Register Src="~/Controls/PolicyDetails.ascx" TagName="PolicyDetails" TagPrefix="uc7" %>
<%@ Register Src="~/Controls/Document.ascx" TagName="Document" TagPrefix="uc5" %>
<%@ Register Src="~/Controls/DocumentManager.ascx" TagName="DocumentManager" TagPrefix="uc8" %>
<%@ Register TagPrefix="Nexus" Namespace="Nexus" %>
<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>

<div>
    <div>
        <uc7:PolicyDetails ID="ucPolicyDetails" runat="server" />
        <uc1:PolicyFeesCntrl ID="PolicyFeesCntrl" runat="server" />
        <uc2:EditTaxCntrl ID="EditTaxCntrl" runat="server" />
        <uc3:AgentCommissionCntrl ID="AgentCommissionCntrl" runat="server" />
		<uc8:DocumentManager runat="server" id="docMgr" Autoarchiveselected="false" Documents = "NBSchedule" />
    </div>


</div>


