<%@ page language="VB" masterpagefile="~/default.master" autoeventwireup="false" inherits="Nexus.Modal_SelectTreaty, Pure.Portals" title="Untitled Page" enableEventValidation="false" %>
<%@ Register TagPrefix="NexusProvider" Namespace="NexusProvider" Assembly="NexusProvider" %>

<asp:Content ID="cntMainBody" ContentPlaceHolderID="cntMainBody" runat="Server">
    <div id="Modal_SelectTreaty">
        <div class="card">
            <div class="card-heading">
                <h1>
                    <asp:Literal ID="lblTitle" runat="server" Text="Treaty"></asp:Literal></h1>
            </div>
          
                <div class="form-horizontal">
                                     <div class="form-group form-group-sm col-lg-6 col-md-6 col-sm-12">
                       <asp:Label ID="lblTreaty" runat="server" AssociatedControlID="ddlRIPropTreaties" Text="Treaty" class="col-md-4 col-sm-3 control-label"></asp:Label>
                        <div class="col-md-8 col-sm-9">
                            <asp:DropDownList ID="ddlRIPropTreaties" runat="server" CssClass="field-medium form-control" AutoPostBack="True"></asp:DropDownList>
                        </div>
                    </div>
                </div>

            <div class="card-footer">
                    <asp:LinkButton ID="btnOk" SkinID="btnPrimary" runat="server" Text="Ok" CausesValidation="false" ></asp:LinkButton>
                    <asp:LinkButton ID="btnCancel" SkinID="btnSecondary" runat="server" Text="Cancel" CausesValidation="false"  OnClick="btnCancel_Click"></asp:LinkButton>
            </div>
        </div>
    </div>
</asp:Content>
