<%@ Control Language="VB" AutoEventWireup="false" CodeFile="TransactionConfirmation.ascx.vb" Inherits="Nexus.TransactionConfirmationCntrl" %>
<%@ Register Src="~/Controls/Document.ascx" TagName="Document" TagPrefix="uc4" %>
<%@ Register Src="~/Controls/DocumentManager.ascx" TagName="DocumentManager" TagPrefix="uc" %>
<%@ Register TagPrefix="Nexus" Namespace="Nexus" %>
<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<cc1:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
<h1>
    <asp:Literal ID="Literal1" runat="server" Text="You may view and print the following documents by clicking on the links below:"
        Visible="false" />
</h1>
<div class = "table-wrapper">
<uc:DocumentManager runat="server" id="docMgr" Autoarchiveselected="True" Documents=""/>

</div>