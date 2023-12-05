Imports CMS.Library
Imports Nexus.Library
Imports Nexus.Utils
Imports System.Web.Configuration
Imports System.Web.Configuration.WebConfigurationManager
Imports Nexus.Constants
Imports Nexus.Constants.Session
Imports Nexus
Imports System.IO
Partial Class Controls_FileView
    Inherits System.Web.UI.UserControl

    Dim oFileTypes As Config.FileTypes = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).FileTypes
    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
    Dim oDMEFolder As New NexusProvider.DME
    Dim b_EnableFileUpload As Boolean = True ' Default Set as true
    Public Const CNDocCollection As String = "CNDocCollection"
    Dim sCurrentBranchName As String = ""

    ''' <summary>
    ''' Page Load Event- Display DocumentList based on  CurrentFolder Path
    ''' </summary> 
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Set FileUpload Panel based on EnableFileUpload Properties Value
        If Session(CNMode) = Mode.View OrElse Session(CNMode) = Mode.ViewClaim Then
            b_EnableFileUpload = False
        End If

        CntAsyncFileUpload.Visible = b_EnableFileUpload
        If Request.QueryString("BranchCode") <> "" Then
            sCurrentBranchName = GetDescriptionForCode(NexusProvider.ListType.PMLookup, Request.QueryString("BranchCode").Trim(), "SOURCE")
        ElseIf Session(CNBranchCode) IsNot Nothing AndAlso Session(CNBranchCode) <> "" Then
            sCurrentBranchName = GetDescriptionForCode(NexusProvider.ListType.PMLookup, Session(CNBranchCode).Trim(), "SOURCE")
        Else
            sCurrentBranchName = Convert.ToString(Session("BranchName"))
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("FolderNum")) And Not String.IsNullOrEmpty(Request.QueryString("FolderName")) And sCurrentBranchName.Trim() <> "" Then
            If HidCurrentFolder.Value = "" Then
                HidCurrentFolder.Value = Session("BranchName").ToString() + "|" + Request.QueryString("FolderName").ToString()

                If (Session("PolicyFolderName") IsNot Nothing And Request.QueryString("fromlink").ToString() = "policy") Then
                    HidCurrentFolder.Value = HidCurrentFolder.Value + "|" + Session("PolicyFolderName").ToString()
                ElseIf (Session("ClaimFolderName") IsNot Nothing And Request.QueryString("fromlink").ToString() = "claim") Then
                    HidCurrentFolder.Value = HidCurrentFolder.Value + "|" + Session("ClaimFolderName").ToString()
                ElseIf (Session("GeneralFolderExist") IsNot Nothing And Request.QueryString("fromlink").ToString() = "client") Then
                    HidCurrentFolder.Value = HidCurrentFolder.Value + "|" + "GENERAL"
                End If
            End If
            GetDocumentTree(Server.UrlDecode(HidCurrentFolder.Value))
        End If
        If Request("__EVENTARGUMENT") = "RefreshDocumentList" Then
            'Call GetDocumentTree to get the contents of that folder
            GetDocumentTree(Server.UrlDecode(HidCurrentFolder.Value))
        ElseIf (Not String.IsNullOrEmpty(HidCurrentFolder.Value) And Request("__EVENTARGUMENT") <> "UpdateImport") Then
            'Call GetDocumentTree to get the contents of that folder
            GetDocumentTree(Server.UrlDecode(HidCurrentFolder.Value))
        End If

        If Request("__EVENTARGUMENT") = "UpdateImport" Then
            Page.ClientScript.GetPostBackEventReference(Me, "")
            HidImportFile.Value = CntAsyncFileUpload.PostedFile.FileName
            If String.IsNullOrEmpty(HidImportFile.Value) = False Then
                'call Upload Function
                UploadComplete(HidImportFile.Value)

                'Call GetDocumentTree to get the contents of that folder
                GetDocumentTree(Server.UrlDecode(HidCurrentFolder.Value))
            End If
        End If

        'Display Selected Folder Path 
        If String.IsNullOrEmpty(HidCurrentFolder.Value) Then
            lblSubHeader.Text = GetLocalResourceObject("lbl_DeselectedHeader")
            liUpload.Visible = False
        Else
            liUpload.Visible = True
            lblSubHeader.Text = GetLocalResourceObject("lbl_SubHeader")
            lblSubHeader.Text = Replace(lblSubHeader.Text, "#TransactionNode", Server.UrlDecode(HidCurrentFolder.Value))
        End If
        If Request.Url.ToString().Contains("DMEDocumentManager.aspx") Then
            CntAsyncFileUpload.Visible = False
        End If
    End Sub
    ''' <summary>
    ''' FileUpload button OnClick Event- Will upload new file (Import Document)
    ''' </summary>
    ''' <param name="sFileName"></param>
    ''' <remarks></remarks>
    Protected Sub UploadComplete(ByVal sFileName As String)
        If IsPostBack Then
            Dim RequestedPageURL As String = LCase(Request.Url.Segments(Request.Url.Segments.Length - 1).ToString)
            Dim sPageName = GetLocalResourceObject("sRestrictEventlockFile")
            If CntAsyncFileUpload.HasFile Then
                Dim AddDocumentToDocumasterType As New NexusProvider.AddDocumentToDocumasterType
                Dim oEventDetails As New NexusProvider.EventDetails
                Dim iInsuranceFileKey As Integer = 0
                Dim sTempFolderName As String = Nothing
                Dim sFileFullPath As String = Nothing
                'Hold New unique key for creating temp folder

                sTempFolderName = Guid.NewGuid.ToString
                ' Check if directory exists
                If Not (Directory.Exists(Server.MapPath("~/") + sTempFolderName) AndAlso String.IsNullOrEmpty(sTempFolderName)) Then
                    ' Create the directory.
                    Directory.CreateDirectory(Server.MapPath("~/") + sTempFolderName)
                    'Saving the file temporaril
                    sFileFullPath = Server.MapPath("~/") + sTempFolderName + "\" + Path.GetFileName(CntAsyncFileUpload.FileName)
                    CntAsyncFileUpload.SaveAs(sFileFullPath)
                End If


                If Session(CNParty) IsNot Nothing Then
                    'When user have only party information
                    Dim oParty As NexusProvider.BaseParty = Session.Item(CNParty)
                    With AddDocumentToDocumasterType
                        'Get Session Party Key
                        .v_iPartyKey = oParty.Key
                        .v_bVisibleFromWeb = True
                        .v_sDescription = Path.GetFileNameWithoutExtension(sFileFullPath)
                        .v_sFileName = sFileFullPath
                    End With
                End If

                If Session(CNClaim) IsNot Nothing Then
                    'During Claim Process
                    With AddDocumentToDocumasterType
                        'Get Session OClaim Claim Key
                        .v_iClaimKey = CType(Session(CNClaim), NexusProvider.ClaimOpen).ClaimKey
                        'Get Session OClaim PartyKey Key
                        .v_bVisibleFromWeb = True
                        .v_sDescription = Path.GetFileNameWithoutExtension(sFileFullPath)
                        .v_sFileName = sFileFullPath
                        .v_iInsuranceFolderKey = CType(Session(CNClaimQuote), NexusProvider.Quote).InsuranceFolderKey
                    End With
                ElseIf Session(CNQuote) IsNot Nothing Then
                    'During NB Process
                    With AddDocumentToDocumasterType
                        'Get Session OQuote InsuranceFolderKey Key
                        .v_iInsuranceFolderKey = CType(Session(CNQuote), NexusProvider.Quote).InsuranceFolderKey
                        'Get Session OQuote Party Key
                        .v_iPartyKey = CType(Session(CNQuote), NexusProvider.Quote).PartyKey
                        .v_bVisibleFromWeb = True
                        .v_sDescription = Path.GetFileNameWithoutExtension(sFileFullPath)
                        .v_sFileName = sFileFullPath
                    End With
                    iInsuranceFileKey = CType(Session(CNQuote), NexusProvider.Quote).InsuranceFileKey
                Else
                    'For Any Selected Folder
                    If Request.QueryString("FolderNum") IsNot Nothing And HidFolderNum.Value = "" Then

                        HidFolderNum.Value = Request.QueryString("FolderNum").ToString()
                    End If
                    If Not String.IsNullOrEmpty(HidFolderNum.Value) Then
                        With AddDocumentToDocumasterType
                            .v_bVisibleFromWeb = True
                            .v_sDescription = Path.GetFileNameWithoutExtension(sFileFullPath)
                            .v_sFileName = sFileFullPath
                            .v_iFolderNum = HidFolderNum.Value
                        End With
                    End If
                End If

                'Call AddDocumentToDocumaster SAM Method
                oWebService.AddDocumentToDocumaster(AddDocumentToDocumasterType)

                'Display the File Upload status
                lblFileUploadMessage.Text = GetLocalResourceObject("Msg_FileUpload")

                If LCase(sPageName.Contains(RequestedPageURL)) Then
                    'SAM Will Generate an Event 
                Else

                    'Add a event for New Document Created
                    With oEventDetails
                        .EventDate = Now()
                        .PartyKey = AddDocumentToDocumasterType.v_iPartyKey
                        .InsuranceFileKey = iInsuranceFileKey
                        .InsuranceFolderKey = AddDocumentToDocumasterType.v_iInsuranceFolderKey
                        .ClaimKey = AddDocumentToDocumasterType.v_iClaimKey
                        .RtfText = GetLocalResourceObject("Msg_EventRtfText")
                        .Description = GetLocalResourceObject("Msg_EventDescription")
                        .UserName = Session(CNLoginName)
                        .EventTypeKey = 10
                        .EventLogSubjectKey = 1
                    End With
                    oWebService.AddEvent(oEventDetails)
                End If
            End If
        End If
    End Sub
    ''' <summary>
    ''' This Function is fired when Any Folder has been Selected
    ''' </summary>
    ''' <remarks></remarks>
    Sub GetDocumentTree(ByVal sFolderPath As String)
        'Call GetDMEFolder to get the contents of that folder
        oDMEFolder = oWebService.GetDMEFolder(0, sFolderPath, True)

        If oDMEFolder.DocumentList IsNot Nothing Then
            If oDMEFolder.DocumentList.Count > 0 Then
                grdvDocumentResults.DataSource() = oDMEFolder.DocumentList
                grdvDocumentResults.AllowPaging = True
            Else
                grdvDocumentResults.DataSource() = Nothing
                grdvDocumentResults.AllowPaging = False
            End If
        End If

        'store the data in ViewState to use again for page indexing
        ViewState.Add(CNDocCollection, oDMEFolder.DocumentList)

        grdvDocumentResults.DataBind()
    End Sub
    ''' <summary>
    ''' This is fired on Load of the Grid View
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub grdvDocumentResults_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdvDocumentResults.Load
        'No Need to Show page Number When result not more then one page
        If grdvDocumentResults.PageCount = 1 Then
            grdvDocumentResults.AllowPaging = False
        End If
    End Sub
    ''' <summary>
    ''' This is fired on Page Index Change of the Grid View
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub grdvDocumentResults_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles grdvDocumentResults.PageIndexChanging
        grdvDocumentResults.PageIndex = e.NewPageIndex
        grdvDocumentResults.DataSource = ViewState(CNDocCollection)
        grdvDocumentResults.DataBind()
    End Sub
    ''' <summary>
    ''' This event is fired on Row Data Bound of Grid View
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub grdvDocumentResults_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdvDocumentResults.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then

            e.Row.Attributes.Add("id", CType(e.Row.DataItem, NexusProvider.DocumentList).DocNum)

            If e.Row.FindControl("hypDocDescription") IsNot Nothing Then
                CType(e.Row.FindControl("hypDocDescription"), HyperLink).NavigateUrl = "~/secure/document.aspx?doc_number=" & CType(e.Row.DataItem, NexusProvider.DocumentList).DocNum & "&filename=" & Trim(CType(e.Row.DataItem, NexusProvider.DocumentList).DocDescription) & "&doctype=" & CType(e.Row.DataItem, NexusProvider.DocumentList).DocumentType.ToString
                CType(e.Row.FindControl("hypDocDescription"), HyperLink).Text = CType(e.Row.DataItem, NexusProvider.DocumentList).DocDescription
                If oFileTypes.FileType(UCase(CType(e.Row.DataItem, NexusProvider.DocumentList).DocumentType.ToString)).DocType IsNot Nothing Then
                    CType(e.Row.FindControl("hypDocDescription"), HyperLink).CssClass = oFileTypes.FileType(UCase(CType(e.Row.DataItem, NexusProvider.DocumentList).DocumentType.ToString)).CssClass
                End If
            End If
            If e.Row.FindControl("lblDocumentType") IsNot Nothing Then
                If oFileTypes.FileType(UCase(CType(e.Row.DataItem, NexusProvider.DocumentList).DocumentType.ToString)).DocType IsNot Nothing Then
                    CType(e.Row.FindControl("lblDocumentType"), Label).Text = oFileTypes.FileType(UCase(CType(e.Row.DataItem, NexusProvider.DocumentList).DocumentType.ToString)).Display
                End If
            End If
        ElseIf e.Row.RowType = DataControlRowType.Header Then

        End If
    End Sub
    ''' <summary>
    '''  Add a New Properties “EnableFileUpload” (Boolean) 
    ''' </summary>
    ''' <remarks></remarks>
    Public Property EnableFileUpload() As Boolean
        Get
            Return b_EnableFileUpload
        End Get
        Set(ByVal Value As Boolean)
            b_EnableFileUpload = Value
        End Set
    End Property
    ''' <summary>
    '''  Add a New Properties “CurrentFolder” (String)  
    ''' </summary>
    ''' <remarks></remarks>
    Public Property CurrentFolder() As String
        Get
            Return Server.UrlDecode(HidCurrentFolder.Value)
        End Get
        Set(ByVal Value As String)
            HidCurrentFolder.Value = Server.UrlDecode(Value)
        End Set
    End Property

End Class
