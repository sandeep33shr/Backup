Imports System.Web.Configuration.WebConfigurationManager
Imports System.Xml.Linq
Imports System.IO
Imports Nexus.Utils
Imports Nexus.Library
Imports CMS.Library
Imports Nexus.Constants
Imports System.Data
Imports Nexus
Imports System.Collections.Generic
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared
Imports System.Web.Mail
Imports System.Xml
Imports System.Linq

Partial Class Modal_SendEmail
    Inherits System.Web.UI.Page

    Private _InsuranceFileKey As Integer
    Private _ClaimKey As Integer
    Private _PartyKey As Integer
    Private Const ACEmailDocType As Integer = 8
    Private sFileReportName As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim oParty As NexusProvider.BaseParty
        Dim oEmailDefaults As New EmailDefaults
        Dim strDocumentName As String

        If Not IsPostBack Then
            Dim idocID As Integer 'holds the document id
            Dim oFileTypes As Config.FileTypes = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork) _
            .Portals.Portal(Portal.GetPortalID()).FileTypes() 'so that we can fetch the file type config
            'we must always pass the location of the documents to be attached. If nothing is passed then we will end up with no attachements

            'determine where the email request has come from and populate the attachements appropriately
            Select Case Request.QueryString("loc")
                Case "docm"
                    'files from document manager, we should look in Session(CNCurrentDocumentCollection) for the details
                    'Dim oDocumentCollection As NexusProvider.DocumentDefaultsCollection = CType(Session(CNCurrentDocumentCollection), NexusProvider.DocumentDefaultsCollection)
                    Dim oDocumentCollection As NexusProvider.DocumentDefaultsCollection = CType(Cache.Item(Request.QueryString("key")), NexusProvider.DocumentDefaultsCollection)
                    'we will have ids passed in query string in format docID1docID2 etc
                    'extract the ids by splitting on the string "docID"
                    If oDocumentCollection IsNot Nothing Then

                        For Each docID As String In Regex.Split(Request.QueryString("Docs"), "asp-check docID")

                            If Integer.TryParse(docID, idocID) Then
                                'we have an id passed so add an item to the checkboxlist by matching with the document collection in session
                                'set the attachement container to visisble
                                lblAttachments.Visible = True
                                With oDocumentCollection(Integer.Parse(docID))
                                    Dim iValue As Integer = .Key
                                    Dim sText As String = .DocumentName
                                    strDocumentName = sText

                                    chklstAttachments.Items.Add(New ListItem With {.Value = docID, .Text = sText, .Selected = True})
                                    'Get the CSS class for this file type out of config

                                    If oFileTypes.FileType(oDocumentCollection(Integer.Parse(docID)).FileType) IsNot Nothing Then
                                        chklstAttachments.Items(chklstAttachments.Items.Count - 1).Attributes.Add("class", oFileTypes.FileType(oDocumentCollection(Integer.Parse(docID)).FileType).CssClass)
                                    End If

                                End With
                            End If
                        Next
                    End If


                Case ("sharep")
                    'files are located in sharepoint, we should find the file list in cache using the key from the query string
                    Dim oSPFileList As NexusProvider.SharepointFileList = CType(Cache.Item(Request.QueryString("key")), NexusProvider.SharepointFileList)
                    If oSPFileList IsNot Nothing Then
                        For Each spID As String In Regex.Split(Request.QueryString("Docs"), "spID")
                            If Integer.TryParse(spID, idocID) Then
                                'set the attachement container to visisble
                                lblAttachments.Visible = True
                                With oSPFileList.ItemList.Item(Integer.Parse(idocID))
                                    Dim sValue As String = idocID.ToString
                                    Dim sText As String = .Filename
                                    strDocumentName = sText
                                    chklstAttachments.Items.Add(New ListItem With {.Value = sValue, .Text = sText, .Selected = True})
                                    'Get the CSS class for this file type out of config
                                    If oFileTypes.FileType(oSPFileList.ItemList.Item(Integer.Parse(idocID)).ItemType) IsNot Nothing Then
                                        chklstAttachments.Items(chklstAttachments.Items.Count - 1).Attributes.Add("class", oFileTypes.FileType(oSPFileList.ItemList.Item(Integer.Parse(idocID)).ItemType).CssClass)
                                    End If
                                End With
                            End If
                        Next
                    End If

                Case ("report")
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                    _PartyKey = Request.QueryString("PartyKey")
                    oEmailDefaults = GetEmailDefaults("InsurerPayment")
                    sFileReportName = GenerateReport()
                    Session("Report") = sFileReportName
                    Dim oMsg As MailMessage = New MailMessage()
                    Dim oAttch As MailAttachment = New MailAttachment(sFileReportName)
                    oMsg.Attachments.Add(oAttch)

                    lblAttachments.Visible = True
                    chklstAttachments.Items.Add(New ListItem With {.Value = 1, .Text = "Remittance Advice Report", .Selected = True})
                    'Get the CSS class for this file type out of config

                    chklstAttachments.Items(chklstAttachments.Items.Count - 1).Attributes.Add("class", "upload-pdf")
            End Select

            'populate the message body with template according to where we are in the process
            'note - below logic will need to be redone once we need to handle claims and so on but should work to determine between quote and policy

            'Changes made to pick the correct email template based on the generated document - @Muhammad 10/12/2019
            If Request.QueryString("loc") <> "report" Then
                If CType(Session(CNClaim), NexusProvider.ClaimOpen) IsNot Nothing Then
				'Session(CNMode) = Mode.NewClaim Or Session(CNMode) = Mode.EditClaim Or Session(CNMode) = Mode.PayClaim Or Session(CNMode) = Mode.SalvageClaim Or Session(CNMode) = Mode.TPRecovery
                    'bound policy so use the newpolicy template
                    oEmailDefaults = GetEmailDefaults("newclaim")
                ElseIf Session(CNMode) = Mode.PayClaim Then
                    oEmailDefaults = GetEmailDefaults("ClaimPayment")
                ElseIf Session(CNRenewal) IsNot Nothing Or Session.Item("CNRenewal") IsNot Nothing Then

                    oEmailDefaults = GetEmailDefaults("Renewal")
                ElseIf Session(CNMTAType) IsNot Nothing Then
                    If Session(CNMTAType).ToString = "CANCELLATION" And Session(CNIsTransactionConfirmationVisited) = True Then
                            oEmailDefaults = GetEmailDefaults("Cancelation")
                        ElseIf Session(CNMTAType).ToString = "CANCELLATION" Then
                            oEmailDefaults = GetEmailDefaults("Cancelation")
                        End If
                    ElseIf Session(CNIsTransactionConfirmationVisited) = True Then
                        'bound policy so use the newpolicy template
                        oEmailDefaults = GetEmailDefaults("newpolicy")
                    Else
                        Select Case strDocumentName
                        Case "Cancellation Cover Note.pdf"
                            oEmailDefaults = GetEmailDefaults("NewPolicy")

                        Case "Quote.pdf"
                            oEmailDefaults = GetEmailDefaults("NewQuote")

                        Case "Cancellation.pdf"
                            oEmailDefaults = GetEmailDefaults("Cancelation")

                        Case "New business.pdf"
                            oEmailDefaults = GetEmailDefaults("NewPolicy")

                        Case "Renewal.pdf"
                            oEmailDefaults = GetEmailDefaults("Renewal")

                        Case "MTA.pdf"
                            oEmailDefaults = GetEmailDefaults("NewPolicy")

                        Case "Specialist Liability DNO CAN.pdf"
                            oEmailDefaults = GetEmailDefaults("Cancelation")

                        Case "Specialist Liability DNO MTA.pdf"
                            oEmailDefaults = GetEmailDefaults("NewPolicy")

                        Case "Specialist Liability DNO Quote.pdf"
                            oEmailDefaults = GetEmailDefaults("NewQuote")

                        Case "Specialist Liability DNO REN.pdf"
                            oEmailDefaults = GetEmailDefaults("Renewal")

                        Case "Specialist Liability DNO NB.pdf"
                            oEmailDefaults = GetEmailDefaults("NewPolicy")

                        Case "Specialist Liability PI CAN.pdf"
                            oEmailDefaults = GetEmailDefaults("Cancelation")

                        Case "Specialist Liability PI MTA.pdf"
                            oEmailDefaults = GetEmailDefaults("NewPolicy")
                        Case Else
                            'this Is a New quote, so use the newquote template
                            oEmailDefaults = GetEmailDefaults("newquote")
                    End Select
                End If
            End If

            'If CType(Session(CNClaim), NexusProvider.ClaimOpen) IsNot Nothing Then
            '    oEmailDefaults = GetEmailDefaults("NewClaim")
            'Else
            '    Select Case strDocumentName
            '        Case "Cancellation Cover Note.pdf"
            '            oEmailDefaults = GetEmailDefaults("NewPolicy")
            '
            '        Case "Quote.pdf"
            '            oEmailDefaults = GetEmailDefaults("NewQuote")
            '
            '        Case "Cancellation.pdf"
            '            oEmailDefaults = GetEmailDefaults("Cancelation")
            '
            '        Case "New business.pdf"
            '            oEmailDefaults = GetEmailDefaults("NewPolicy")
            '
            '        Case "Renewal.pdf"
            '            oEmailDefaults = GetEmailDefaults("NewPolicy")
            '
            '        Case "MTA.pdf"
            '            oEmailDefaults = GetEmailDefaults("NewPolicy")
            '
            '        Case "Specialist Liability DNO CAN.pdf"
            '            oEmailDefaults = GetEmailDefaults("Cancelation")
            '
            '        Case "Specialist Liability DNO MTA.pdf"
            '            oEmailDefaults = GetEmailDefaults("NewPolicy")
            '
            '        Case "Specialist Liability DNO Quote.pdf"
            '            oEmailDefaults = GetEmailDefaults("NewQuote")
            '
            '        Case "Specialist Liability DNO REN.pdf"
            '            oEmailDefaults = GetEmailDefaults("NewPolicy")
            '
            '        Case "Specialist Liability DNO NB.pdf"
            '            oEmailDefaults = GetEmailDefaults("NewPolicy")
            '
            '        Case "Specialist Liability PI CAN.pdf"
            '            oEmailDefaults = GetEmailDefaults("Cancelation")
            '
            '        Case "Specialist Liability PI MTA.pdf"
            '            oEmailDefaults = GetEmailDefaults("NewPolicy")
            '
            '    End Select
            'End If

            'If Request.QueryString("loc") <> "report" Then
            '    'If CType(Session(CNClaim), NexusProvider.ClaimOpen) IsNot Nothing Then
            '    If Request.QueryString("ClaimKey") <> 0 Then
            '        'bound policy so use the NewPolicy template
            '        oEmailDefaults = GetEmailDefaults("NewClaim")

            '    ElseIf Request.QueryString("InsuranceFileKey") <> 0 Then
            '        'bound policy so use the NewPolicy template
            '        oEmailDefaults = GetEmailDefaults("NewPolicy")
            '    Else
            '        'this is a new quote, so use the NewQuote template
            '        oEmailDefaults = GetEmailDefaults("NewQuote")
            '    End If
            'End If
            txtMessageBody.Text = oEmailDefaults.MessageBody
            txtEmailTo.Text = oEmailDefaults.EmailTo
            txtEmailSubject.Text = oEmailDefaults.Subject

        End If


        If Request.QueryString("loc") = "docm" Then
            'Get the context (quote / claim / party) from query string values, regardless of whether it's a postback or not
            If Not String.IsNullOrEmpty(Request.QueryString("PartyKey")) Then
                Integer.TryParse(Request.QueryString("PartyKey"), _PartyKey)
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("ClaimKey")) Then
                Integer.TryParse(Request.QueryString("ClaimKey"), _ClaimKey)
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("InsuranceFileKey")) Then
                Integer.TryParse(Request.QueryString("InsuranceFileKey"), _InsuranceFileKey)
            End If
        End If

    End Sub


    Protected Sub Page_PreInit(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreInit
        CMS.Library.Frontend.Functions.SetTheme(Page, AppSettings("ModalPageTemplate"))
    End Sub

    ''' <summary>
    ''' Handles click event to send an email. Creates the XML to pass to the CreateBackgroundJob method
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub btnSendEmail_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSendEmail.Click
        'set up the job to send emails to the requested addresses
        'create an html file on the disk in the temp docs directory, with contents taken from the body textbox
        Dim sFileName As String = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).TempFileLocation & "\" & Guid.NewGuid.ToString & ".html"
        Dim emailBodyFile As New StreamWriter(sFileName)
        'form html formatted string by replacing line breaks with "<br />" and adding basic html tags
        Dim sHtml As String = "<html><body>" & Replace(txtMessageBody.Text.Trim, Chr(13) & Chr(10), "<br />") & "</body></html>"
        emailBodyFile.Write(sHtml)
        emailBodyFile.Close()


        If Request.QueryString("loc") = "report" Then
            Dim EmailDetails As New Hashtable
            Dim oEmailTemplate As NexusProvider.EmailTemplateConfiguration = GetEmailTemplateDetails("InsurerPayment", "CCANNUAL")
            Dim sTemplatePath As String = oEmailTemplate.Path
            Dim sRecipient As String = txtEmailTo.Text
            'SEND EMAIL
            Dim dtEmailDetails As New DataTable
            Dim EmailTemplates As New Nexus.Library.Config.EmailTemplates
            EmailTemplates = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Nexus.Library.Config.NexusFrameWork).Portals.Portal(CMS.Library.Portal.GetPortalID()).EmailTemplates

            'Call SendEmail Method with parameter FileName
            SendEmail(sFileName)

        End If

        If Request.QueryString("loc") <> "report" Then
            Dim xlJob As XElement =
               <BACKGROUND_JOB>
                   <JOB jobtype="DOCUPACK">
                       <PARAMETERS>
                           <PARAMETER name="emailTo" value=<%= txtEmailTo.Text %>/>
                           <PARAMETER name="emailCc" value=<%= txtEmailCC.Text %>/>
                           <PARAMETER name="emailSubject" value=<%= txtEmailSubject.Text %>/>
                           <PARAMETER name="Destination" value="email"/>
                           <PARAMETER name="path" value=<%= sFileName %>/>
                           <PARAMETER name="PartyCnt" value=<%= _PartyKey %>/>
                           <PARAMETER name="ClaimID" value=<%= _ClaimKey %>/>
                           <PARAMETER name="InsuranceFileCnt" value=<%= _InsuranceFileKey %>/>
                           <PARAMETER name="archive" value="true"/>
                       </PARAMETERS>
                       <ITEMS>

                       </ITEMS>
                   </JOB>
               </BACKGROUND_JOB>

            Select Case Request.QueryString("loc")
                Case "docm"
                    'documents from the document manager control, so we need to look in session for the details
                    'Dim oDocumentCollection As NexusProvider.DocumentDefaultsCollection = CType(Session(CNCurrentDocumentCollection), NexusProvider.DocumentDefaultsCollection)
                    Dim oDocumentCollection As NexusProvider.DocumentDefaultsCollection = CType(Cache.Item(Request.QueryString("key")), NexusProvider.DocumentDefaultsCollection)

                    For Each chkAttachment As ListItem In chklstAttachments.Items
                        If chkAttachment.Selected Then
                            Dim xlItem As XElement
                            Dim iDocID As Integer
                            Integer.TryParse(chkAttachment.Value, iDocID)
                            If oDocumentCollection(iDocID).FileLocation IsNot Nothing Then
                                'we've got an actual file so add the location as an item
                                xlItem = <ITEM path=<%= CreateTempExternalFile(oDocumentCollection(iDocID).FileLocation) %>/>
                            Else
                                'add the document code as an item, it will get generated
                                xlItem = <ITEM code=<%= oDocumentCollection(iDocID).documentTemplateCode %>/>
                            End If
                            'if we are specifying a document to generate, or a document which has been generated and editted
                            'we then need to specify a format in which to archive it, either docx or pdf depending on the setting in web.cofig
                            If Not oDocumentCollection(iDocID).IsUpload Then
                                Dim xlParameters As XElement = New XElement("PARAMETERS")
                                'get the file type from config
                                Dim sFileType As String = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).DocumentFormat.ToLower()
                                'we need to pass in the file name, which may change according to file type (e.g. quote.docx may archive as quote.pdf)
                                Dim sOutputFileName As String = oDocumentCollection(iDocID).DocumentName
                                sOutputFileName = Left(sOutputFileName, sOutputFileName.LastIndexOf(".")) & "." & sFileType.ToLower
                                'add output format and file name params
                                Dim xlDocumentFormat As XElement = <PARAMETER name="OutputFormat" value=<%= sFileType.ToUpper %>/>
                                xlParameters.Add(xlDocumentFormat)
                                Dim xlDestinationFilename As XElement = <PARAMETER name="DestinationFilename" value=<%= sOutputFileName %>/>
                                xlParameters.Add(xlDestinationFilename)

                                xlItem.Add(xlParameters)
                            End If

                            xlJob.Element("JOB").Element("ITEMS").Add(xlItem)
                        End If
                    Next
                Case "sharep"
                    Dim oSPFileList As NexusProvider.SharepointFileList = CType(Cache.Item(Request.QueryString("key")), NexusProvider.SharepointFileList)

                    For Each chkAttachment As ListItem In chklstAttachments.Items
                        If chkAttachment.Selected Then
                            'get the document ID from the checkbox, and use this to get the path frmo the item list
                            Dim iDocID As Integer
                            Integer.TryParse(chkAttachment.Value, iDocID)
                            'set up the xml element to add to the job
                            Dim xlItem As XElement

                            xlItem = <ITEM path=<%= CreateTempExternalFile(oSPFileList.ItemList(iDocID).URL) %>/>
                            'if we are specifying a document to generate, or a document which has been generated and editted
                            'we then need to specify a format in which to archive it, either docx or pdf depending on the setting in web.cofig
                            Dim xlParameters As XElement = New XElement("PARAMETERS")
                            Dim xlDocumentFormat As XElement = <PARAMETER name="OutputFormat" value=<%= CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).DocumentFormat.ToUpper() %>/>
                            xlParameters.Add(xlDocumentFormat)

                            xlItem.Add(xlParameters)

                            xlJob.Element("JOB").Element("ITEMS").Add(xlItem)
                        End If
                    Next

            End Select

            Dim strJob As String = xlJob.ToString 'this will be used as input to the SAM call
            Dim sDescription As String = "Email documents"
            Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            'call SAM to queue the docs for Archiving
            Dim iBackgroundJobID As Integer = oWebService.CreateBackgroundJob(sDescription, strJob, Now.Date)
            If Request.QueryString("PostBack") IsNot Nothing Then
                If Request.QueryString("PostBack").ToUpper = "TRUE" Then
                    Dim PostBackStr As String = "self.parent." & Page.ClientScript.GetPostBackEventReference(Me, "RefreshGrid") & ";"
                    'refresh the parent page on postback with event argument RefreshGrid  
                    Page.ClientScript.RegisterStartupScript(GetType(String), "ParentPostBack", PostBackStr, True)
                End If
            End If
            'close the modal page
            Page.ClientScript.RegisterStartupScript(GetType(String), "closeThickBox", "self.parent.tb_remove();", True)
        End If
        ''Close the modal when the page reloads
        'ClientScript.RegisterStartupScript(GetType(String), "closeModal", "self.parent.hide_modal();", True)
    End Sub
    ''' <summary>
    ''' Email and archive document is both process where the same file is used for archiving the document so required to make two versions.
    ''' </summary>
    ''' <param name="sOriginalFilepath"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function CreateTempExternalFile(ByVal sOriginalFilepath As String) As String
        Dim sEmailTemplocation As String = String.Empty

        If sOriginalFilepath <> "" Then
            'set the location using an guid as the folder inside the temp file location from config
            sEmailTemplocation = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).TempFileLocation & "\" & Guid.NewGuid.ToString
            If IO.File.Exists(sOriginalFilepath) Then
                System.IO.Directory.CreateDirectory(sEmailTemplocation)
                sEmailTemplocation = sEmailTemplocation & "\" & Path.GetFileName(sOriginalFilepath)
                IO.File.Copy(sOriginalFilepath, sEmailTemplocation, True)
            End If
        End If
        Return sEmailTemplocation
    End Function
    ''' <summary>
    ''' Gets the defaults for the email message and returns them as an email defaults object
    ''' </summary>
    ''' <param name="sTemplateCode"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetEmailDefaults(ByVal sTemplateCode As String) As EmailDefaults
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim sProductCode As String = String.Empty
        If Not oQuote Is Nothing Then
            sProductCode = oQuote.ProductCode
        Else
            sProductCode = IIf(Session(CNProductCode) Is Nothing, "", Session(CNProductCode))
        End If

        Dim oEmailDefaults As New EmailDefaults 'object to store properties which must be returned
        With oEmailDefaults
            Dim oEmailTemplate As NexusProvider.EmailTemplateConfiguration
            If Request.QueryString("loc") <> "report" Then
                oEmailTemplate = GetEmailTemplateDetails(sTemplateCode.ToUpper(), sProductCode.ToUpper())
            Else
                oEmailTemplate = GetEmailTemplateDetails(sTemplateCode.ToUpper(), sProductCode)
            End If
            Dim lstDocTemplate As New List(Of String)
            Dim oParty As NexusProvider.BaseParty = Session.Item(CNParty)

            Dim oDocumentCollection As NexusProvider.DocumentDefaultsCollection
            Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            Dim sFileLocation As String = String.Empty
            Dim sDocumentTextContents As String = String.Empty
            Dim oDocument As NexusProvider.DocumentDefaults
            Dim sFile As String = ""
            Dim sbTemplate As New StringBuilder
            Dim sMailContact As String = String.Empty

            If Request.QueryString("loc") = "report" Then
                oParty = oWebService.GetParty(_PartyKey)
            End If

            If Session(CNMode) = Mode.NewClaim Or Session(CNMode) = Mode.EditClaim Or Session(CNMode) = Mode.PayClaim Or Session(CNMode) = Mode.SalvageClaim Or Session(CNMode) = Mode.TPRecovery Then
                oQuote = Session(CNClaimQuote)
            Else
                oQuote = Session(CNQuote)
            End If

            If Request.QueryString("loc") <> "report" Then
                If Not oEmailTemplate.EmailTemplateCode Is Nothing Then
                    lstDocTemplate.Add(oEmailTemplate.EmailTemplateCode.Trim)
                End If
                If Not oEmailTemplate.SubjectTemplateCode Is Nothing Then
                    lstDocTemplate.Add(oEmailTemplate.SubjectTemplateCode.Trim)
                End If
                If lstDocTemplate.Count > 0 Then
                    oDocumentCollection = oWebService.GetDocumentDefaults(lstDocTemplate)
                End If

                If Not IsNothing(oQuote) AndAlso Not IsNothing(oQuote.MailContacts) AndAlso oQuote.MailContacts <> String.Empty Then
                    sMailContact = oQuote.MailContacts
                End If
            End If

            If Not String.IsNullOrEmpty(oEmailTemplate.ID) Then
                'create an array by splitting on comma                
                Dim sTemp() As String = oEmailTemplate.Recipient.Split(",")

                'loop through the array, do the merge on each value to replace with the final value
                For iCounter As Integer = 0 To sTemp.Length - 1
                    If sTemp(iCounter).Contains("RiskData") Then
                        'we will have a path specified in the risk, so we need to extract the data from there

                        'strip out everything other than the path
                        sTemp(iCounter) = sTemp(iCounter).Replace("[", "")
                        sTemp(iCounter) = sTemp(iCounter).Replace("]", "")
                        sTemp(iCounter) = sTemp(iCounter).Replace("!", "")
                        sTemp(iCounter) = sTemp(iCounter).Replace("(", "")
                        sTemp(iCounter) = sTemp(iCounter).Replace(")", "")
                        sTemp(iCounter) = sTemp(iCounter).Replace("RiskData", "")
                        sTemp(iCounter) = sTemp(iCounter).Replace("'", "")

                        If sMailContact = String.Empty Then
                            sMailContact = FindInRiskData(sTemp(iCounter))
                        Else
                            sMailContact &= "," & FindInRiskData(sTemp(iCounter))
                        End If
                    Else
                        Select Case sTemp(iCounter)
                            Case "[!LoggedInUserEmail!]"
                                'we need to replace the value with the logged in users email address
                                If Not String.IsNullOrEmpty(CType(Session(CNAgentDetails), NexusProvider.UserDetails).EmailAddress) Then
                                    If sMailContact = String.Empty Then
                                        sMailContact = CType(Session(CNAgentDetails), NexusProvider.UserDetails).EmailAddress
                                    Else
                                        sMailContact &= "," & CType(Session(CNAgentDetails), NexusProvider.UserDetails).EmailAddress
                                    End If
                                End If
                        End Select
                    End If
                Next
                .EmailTo = sMailContact
                If Right(.EmailTo, 1) = "," Then
                    'remove the trailing comma
                    .EmailTo = Left(.EmailTo, Len(.EmailTo) - 1)
                End If

                'Get the message body
                'Email Body 
                .MessageBody = String.Empty
                If Not oEmailTemplate.Path Is Nothing AndAlso Not String.IsNullOrEmpty(oEmailTemplate.Path) Then

                    'open the template from the given path
                    Dim srTmp As New StreamReader(File.OpenRead(Server.MapPath(oEmailTemplate.Path)))
                    sbTemplate = New StringBuilder(srTmp.ReadToEnd())
                    srTmp.Close()
                    If oEmailTemplate.Path.ToLower().EndsWith(".html") Then
                        .MessageBody = ConvertHTMLToText(sbTemplate.ToString)
                    Else
                        .MessageBody = sbTemplate.ToString
                    End If
                Else
                    If Not oEmailTemplate.EmailTemplateCode Is Nothing AndAlso Not String.IsNullOrEmpty(oEmailTemplate.EmailTemplateCode) Then
                        oDocument = oDocumentCollection(0)
                        sFileLocation = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).TempFileLocation _
                                & "\" & Guid.NewGuid.ToString & "\" & oDocument.documentTemplateCode & ".TXT"

                        sFile = oWebService.GenerateDocument(oQuote.PartyKey, oQuote.InsuranceFileKey,
                                oQuote.InsuranceFolderKey, oDocument.documentTemplateCode, NexusProvider.DocumentType.TXT,
                                                             sFileLocation, _ClaimKey, Nothing, Nothing, v_iMode:=ACEmailDocType)

                        If Not String.IsNullOrEmpty(sFile) Then
                            Dim srBodyTmp As New StreamReader(File.OpenRead(sFile))
                            sbTemplate = New StringBuilder(srBodyTmp.ReadToEnd())
                            srBodyTmp.Close()
                            .MessageBody = sbTemplate.ToString
                        End If
                    End If
                End If
                'replace the merge values with real ones

                'do the straight forward replacements
                Dim sInsuredName As String = String.Empty
                Dim sPolicyHeader_CoverStartDate As String = String.Empty
                Dim sPolicyHeader_CoverEndDate As String = String.Empty
                'Addition of missing field needs for email Templates as per Hollard Namibia requirements @ Badimu Kazadi -22-09-2020
                Dim sPolicyNumber As String = String.Empty
                Dim sProductDesc As String = String.Empty
                Dim sCancelReason As String = String.Empty
                Dim sCancelDate As String = String.Empty
                Dim sClaimNumber As String = String.Empty
                Dim sPaymentAmount As String = String.Empty
                Dim sRenewalDate As String = String.Empty
                Dim sExpiryDate As String = String.Empty


                If Session(CNQuote) IsNot Nothing Then
                    'get the insured name from the quote object
                    'sInsuredName = CType(Session(CNQuote), NexusProvider.Quote).InsuredName
                    sPolicyHeader_CoverStartDate = CType(Session(CNQuote), NexusProvider.Quote).CoverStartDate
                    sPolicyHeader_CoverEndDate = CType(Session(CNQuote), NexusProvider.Quote).CoverEndDate
                    sProductDesc = Trim(CType(Session(CNQuote), NexusProvider.Quote).ProductName)
                    sCancelDate = Trim(CType(Session(CNQuote), NexusProvider.Quote).LapseCancelDate.ToString("dd/MM/yyyy"))
                    sCancelReason = GetListValue("Lapsed_Reason", Trim(CType(Session(CNQuote), NexusProvider.Quote).LapseCancelReasonCode), "description")
                    sPolicyNumber = Trim(CType(Session(CNQuote), NexusProvider.Quote).InsuranceFileRef)
                    sExpiryDate = Trim(CType(Session(CNQuote), NexusProvider.Quote).LapseDate.ToString("dd/MM/yyyy"))

                    sRenewalDate = Trim(CType(Session(CNQuote), NexusProvider.Quote).RenewalDate.ToString("dd/MM/yyyy"))

                ElseIf Session(CNClaim) IsNot Nothing Then
                        sClaimNumber = Trim(CType(Session(CNClaim), NexusProvider.ClaimOpen).ClaimNumber)
				ElseIf Session(CNMode) = Mode.PayClaim Then
						sPaymentAmount = Trim(CType(Session(CNClaim), NexusProvider.ClaimPayment).PaymentAmount)
                Else
                        sInsuredName = Session(CNInsurer_Header)
                End If


                Select Case True
                    Case TypeOf oParty Is NexusProvider.CorporateParty
                        With CType(oParty, NexusProvider.CorporateParty)
                            sInsuredName = .CompanyName 'to make the company name as hyper link

                        End With
                    Case TypeOf oParty Is NexusProvider.PersonalParty
                        With CType(oParty, NexusProvider.PersonalParty)
                            sInsuredName = .Title & ". " & .Forename & " " & .Lastname

                        End With
                End Select

                'Code added to check if agency business is used - @Muhammad 10/12/2019
                'If Agency business then the Agents email must be selected
                If oParty IsNot Nothing Then
                    Dim strPartyMainEmail As String = ""
                    If oQuote IsNot Nothing Then
                        If oQuote.Agent IsNot Nothing And oQuote.BusinessTypeCode = "AGENCY" Then
                            Dim oAgent = oWebService.GetParty(oQuote.Agent)
                            For Each oAgentContacts As NexusProvider.Contact In oAgent.Contacts
                                If oAgentContacts.ContactType = NexusProvider.ContactType.MEMAIL Then
                                    If Not String.IsNullOrEmpty(strPartyMainEmail) Then
                                        strPartyMainEmail = strPartyMainEmail + "," + oAgentContacts.Number
                                    Else
                                        strPartyMainEmail = oAgentContacts.Number
                                    End If
                                    Exit For
                                ElseIf oAgentContacts.ContactType = NexusProvider.ContactType.Email AndAlso oAgent.Contacts.FindItemByContactType(NexusProvider.ContactType.MEMAIL) Is Nothing Then
                                    If Not String.IsNullOrEmpty(strPartyMainEmail) Then
                                        strPartyMainEmail = strPartyMainEmail + "," + oAgentContacts.Number
                                    Else
                                        strPartyMainEmail = oAgentContacts.Number
                                    End If
                                End If
                            Next
                        End If
                    End If
                    If String.IsNullOrEmpty(strPartyMainEmail) Then
                        For Each oContact As NexusProvider.Contact In oParty.Contacts
                            If oContact.ContactType = NexusProvider.ContactType.MEMAIL Then
                                If Not String.IsNullOrEmpty(strPartyMainEmail) Then
                                    strPartyMainEmail = strPartyMainEmail + "," + oContact.Number
                                Else
                                    strPartyMainEmail = oContact.Number
                                End If
                                Exit For
                            ElseIf oContact.ContactType = NexusProvider.ContactType.Email AndAlso oParty.Contacts.FindItemByContactType(NexusProvider.ContactType.MEMAIL) Is Nothing Then
                                If Not String.IsNullOrEmpty(strPartyMainEmail) Then
                                    strPartyMainEmail = strPartyMainEmail + "," + oContact.Number
                                Else
                                    strPartyMainEmail = oContact.Number
                                End If
                            End If
                        Next
                    End If
                    .EmailTo = IIf(.EmailTo.Trim.Length > 0, .EmailTo & "," & strPartyMainEmail, strPartyMainEmail)
                End If
                'End of added code


                'Removed and replaced with the above code - @Muhammad 10/12/2019
                'If oParty IsNot Nothing Then
                '    Dim strPartyMainEmail As String = ""
                '    For Each oContact As NexusProvider.Contact In oParty.Contacts
                '        If oContact.ContactType = NexusProvider.ContactType.MEMAIL Then
                '            If Not String.IsNullOrEmpty(strPartyMainEmail) Then
                '                strPartyMainEmail = strPartyMainEmail + "," + oContact.Number
                '            Else
                '                strPartyMainEmail = oContact.Number
                '            End If
                '            Exit For
                '        ElseIf oContact.ContactType = NexusProvider.ContactType.Email AndAlso oParty.Contacts.FindItemByContactType(NexusProvider.ContactType.MEMAIL) Is Nothing Then
                '            If Not String.IsNullOrEmpty(strPartyMainEmail) Then
                '                strPartyMainEmail = strPartyMainEmail + "," + oContact.Number
                '            Else
                '                strPartyMainEmail = oContact.Number
                '            End If
                '        End If
                '    Next
                '    .EmailTo = IIf(.EmailTo.Trim.Length > 0, .EmailTo & "," & strPartyMainEmail, strPartyMainEmail)
                'End If

                'If Session(CNParty) IsNot Nothing Then
                .MessageBody = .MessageBody.Replace("[!InsuredName!]", sInsuredName)
                .MessageBody = .MessageBody.Replace("[!PolicyHeader_CoverStartDate!]", sPolicyHeader_CoverStartDate)
                .MessageBody = .MessageBody.Replace("[!PolicyHeader_CoverEndDate!]", sPolicyHeader_CoverEndDate)
                .MessageBody = .MessageBody.Replace("[!PolicyNumber!]", sPolicyNumber)
                .MessageBody = .MessageBody.Replace("[!ProductName!]", sProductDesc)
                .MessageBody = .MessageBody.Replace("[!CancelDate!]", sCancelDate)
                .MessageBody = .MessageBody.Replace("[!CancelReason!]", sCancelReason)
                .MessageBody = .MessageBody.Replace("[!ClaimNumber!]", sClaimNumber)
                .MessageBody = .MessageBody.Replace("[!PaymentAmount!]", sPaymentAmount)
                .MessageBody = .MessageBody.Replace("[!RenewalDate!]", sRenewalDate)
                .MessageBody = .MessageBody.Replace("[!ExpiryDate!]", sExpiryDate)
                Dim sLoggedInUserFullName As String = String.Empty
                If Session(CNAgentDetails) IsNot Nothing Then
                    'get the logged in user name from session
                    sLoggedInUserFullName = CType(Session(CNAgentDetails), NexusProvider.UserDetails).ResolvedName
                End If
                .MessageBody = .MessageBody.Replace("[!LoggedInUserFullName!]", sLoggedInUserFullName)

                'find instances of riskdata in the string builder and replace by searching the risk using specified xpath query
                'split the string to get each risk data part
                sTemp = .MessageBody.Split("[")
                'Clear the messagebody property then we rebuild it
                .MessageBody = String.Empty
                'loop through the array
                For Each sPart As String In sTemp
                    'take off the start of the merge string ("[!RiskData('")
                    'don't need this? sPart = Right(sPart, Len(sPart) - 12)
                    'extract the query. This will be the bit before the first " ')!]"
                    If Left(sPart, 11) = "!RiskData('" Then
                        'we need to do a query against the risk
                        Dim sQuery As String = Left(sPart, sPart.IndexOf("')!]"))
                        sQuery = Right(sQuery, Len(sQuery) - 11)
                        'put it all back together by adding the merged text, then the rest of the string after "')!]"
                        .MessageBody += FindInRiskData(sQuery) & Right(sPart, Len(sPart) - sPart.IndexOf("')!]") - 4)
                    Else
                        'just put the string back together, there shouldn't be any merge fields left in it
                        .MessageBody += sPart
                    End If
                Next

                ' Get Email Subject
                If Not oEmailTemplate.Subject Is Nothing AndAlso Not String.IsNullOrEmpty(oEmailTemplate.Subject) Then
                    .Subject = Replace(oEmailTemplate.Subject, "[!InsuredName!]", sInsuredName)
                Else
                    If Not oEmailTemplate.SubjectTemplateCode Is Nothing AndAlso Not String.IsNullOrEmpty(oEmailTemplate.SubjectTemplateCode) Then
                        sFile = ""

                        oDocument = oDocumentCollection(1)
                        sFileLocation = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).TempFileLocation _
                                & "\" & Guid.NewGuid.ToString & "\" & oDocument.documentTemplateCode & ".TXT"

                        sFile = oWebService.GenerateDocument(oQuote.PartyKey, oQuote.InsuranceFileKey,
                                oQuote.InsuranceFolderKey, oDocument.documentTemplateCode, NexusProvider.DocumentType.TXT, _
                                                            sFileLocation, _ClaimKey, v_iMode:=ACEmailDocType)
                        If Not String.IsNullOrEmpty(sFile) Then
                            Dim srSubjectTmp As New StreamReader(File.OpenRead(sFile))
                            sbTemplate = New StringBuilder(srSubjectTmp.ReadToEnd())
                            srSubjectTmp.Close()

                            .Subject = sbTemplate.ToString

                            .Subject = Replace(.Subject, "[!InsuredName!]", sInsuredName)
                        End If
                    End If
                End If

            End If

        End With

        Return oEmailDefaults
    End Function

    Private Function FindInRiskData(ByVal sQuery As String) As String
        Dim sReturn As String = String.Empty
        'loop through the risks and try to find a value for the broker email
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        If oQuote IsNot Nothing Then
            If (oQuote.ContactUserKey = 0) Then
                For iCount As Integer = 0 To oQuote.Risks.Count - 1
                    If oQuote.Risks(iCount).XMLDataset IsNot Nothing Then
                        Dim strDataset As New System.IO.StringReader(oQuote.Risks(iCount).XMLDataset)
                        Dim NavString As String = "DATA_SET/RISK_OBJECTS/" & Session(CNDataModelCode) & "_POLICY_BINDER/" & sQuery
                        Dim Navigator As System.Xml.XPath.XPathNavigator
                        Dim trDataset As New System.Xml.XmlTextReader(strDataset)
                        Dim Doc As System.Xml.XPath.XPathDocument = New System.Xml.XPath.XPathDocument(trDataset)
                        Navigator = Doc.CreateNavigator()
                        Dim NodeI As System.Xml.XPath.XPathNodeIterator = Navigator.Select(NavString)
                        While NodeI.MoveNext
                            'if we've got a value then add this to the email string and get out
                            If Not String.IsNullOrEmpty(NodeI.Current.Value) Then
                                sReturn += NodeI.Current.Value
                                Exit For
                            End If
                        End While
                    End If
                Next
            Else
                sReturn = oQuote.EmailAddress
            End If
        End If
        Return sReturn
    End Function


    ''' <summary>
    ''' This function converts HTML code to plain text
    ''' </summary>
    ''' <param name="sHTMLCode"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function ConvertHTMLToText(ByVal sHTMLCode As String) As String
        ' Remove new lines since they are not visible in HTML
        sHTMLCode = sHTMLCode.Replace("\n", " ")

        ' Remove tab spaces
        sHTMLCode = sHTMLCode.Replace("\t", " ")

        ' Remove multiple white spaces from HTML
        sHTMLCode = Regex.Replace(sHTMLCode, "\\s+", "  ")

        ' Remove HEAD tag
        sHTMLCode = Regex.Replace(sHTMLCode, "<head.*?</head>", "" _
          , RegexOptions.IgnoreCase Or RegexOptions.Singleline)

        ' Remove any JavaScript
        sHTMLCode = Regex.Replace(sHTMLCode, "<script.*?</script>", "" _
          , RegexOptions.IgnoreCase Or RegexOptions.Singleline)

        ' Replace special characters like &, <, >, " etc.
        Dim sbHTMLString As StringBuilder = New StringBuilder(sHTMLCode)
        ' Note: There are many more special characters, these are just
        ' most common. You can add new characters in this arrays if needed
        Dim OldWords() As String = {"&nbsp;", "&amp;", "&quot;", "&lt;", _
           "&gt;", "&reg;", "&copy;", "&bull;", "&trade;"}
        Dim NewWords() As String = {" ", "&", """", "<", ">", "Â®", "Â©", "â€¢", "â„¢"}
        For i As Integer = 0 To i < OldWords.Length
            sbHTMLString.Replace(OldWords(i), NewWords(i))
        Next i

        ' Finally, remove all HTML tags and return plain text
        Return System.Text.RegularExpressions.Regex.Replace( _
           sbHTMLString.ToString(), "<[^>]*>", "")
    End Function

    ''' <summary>
    ''' Holds defaults for the email to be sent
    ''' </summary>
    ''' <remarks></remarks>
    Private Class EmailDefaults
        Private _Subject As String
        Private _MessageBody As String
        Private _EmailTo As String

        Public Property Subject() As String
            Get
                Return _Subject
            End Get
            Set(ByVal value As String)
                _Subject = value
            End Set
        End Property

        Public Property MessageBody() As String
            Get
                Return _MessageBody
            End Get
            Set(ByVal value As String)
                _MessageBody = value
            End Set
        End Property

        Public Property EmailTo() As String
            Get
                Return _EmailTo
            End Get
            Set(ByVal value As String)
                _EmailTo = value
            End Set
        End Property
    End Class

    Public Function GenerateReport() As String
        Dim oParametersCollection As New NexusProvider.ParametersCollection
        Dim sPlaceHolderControlID As String = "plcReportForm"
        Dim sUrl As String = String.Empty
        Dim sReportsTypeControlID As String = Nothing
        Dim sSelectedReportsType As String = Nothing
        Dim sCustomValidator As String = "cusReportForm"
        Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
        Dim sFileName As String

        sSelectedReportsType = GetLocalResourceObject("lblReport")

        'Executed Function from Dataset function
        Try
            Dim oParameters As NexusProvider.Parameters
            oParameters = New NexusProvider.Parameters
            oParameters.ParamNameField = "user_id"
            oParameters.ParamValueField = Nothing

            'add the param into the collection
            oParametersCollection.Add(oParameters)
            sFileName = GetReportUrl(sSelectedReportsType, oParametersCollection)

        Catch ex As NexusProvider.NexusException
            'Checking  (bSIRReportPrint.Business.SendToPrint Failed : Failed : Return Value = PMNotFound) Error code , then display a message saying no record found 
            If ex.Errors(0).Code = "1000019" Then
                ex.Errors(0).Code = "88"
            End If
            Throw
        End Try
        Return sFileName
    End Function

    ''' <summary>
    ''' This method retreive the report and returns the Url to open the report
    ''' </summary>
    ''' <param name="sReportName"></param>
    ''' <param name="oParametersCollection"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetReportUrl(ByVal sReportName As String, ByVal oParametersCollection As NexusProvider.ParametersCollection) As String
        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        Dim sDocumentExtractionDirectory As String = Nothing
        Dim sUniqueDirectory As String = Guid.NewGuid.ToString
        Dim url As String = String.Empty
        Dim sFileName As String = String.Empty
        Dim sLocation As String = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).TempFileLocation

        Dim sReportDirName As String = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork) _
              .Portals.Portal(CMS.Library.Portal.GetPortalID()).Reports.Location

        'set the extraction directory using a guid to ensure it is unique
        sDocumentExtractionDirectory = sLocation & "/" & sUniqueDirectory

        'make SAM call with request parameters, sFileName will contain the name of the file we need to display
        sFileName = oWebService.GetReport(sReportName, NexusProvider.DocumentFormatType.PDF,
            oParametersCollection, sDocumentExtractionDirectory)

        Return sFileName
    End Function

    Public Sub SendEmail(Optional ByVal sFileName As String = Nothing)

        Dim sPartyKey = Request.QueryString("PartyKey")

        Dim xlJob As XElement =
           <BACKGROUND_JOB>
               <JOB jobtype="DOCUPACK">
                   <PARAMETERS>
                       <PARAMETER name="emailTo" value=<%= txtEmailTo.Text %>/>
                       <PARAMETER name="emailCc" value=<%= txtEmailCC.Text %>/>
                       <PARAMETER name="emailSubject" value=<%= txtEmailSubject.Text %>/>
                       <PARAMETER name="Destination" value="email"/>
                       <PARAMETER name="path" value=<%= sFileName %>/>
                       <PARAMETER name="PartyCnt" value=<%= sPartyKey %>/>
                       <PARAMETER name="archive" value="true"/>
                       <PARAMETER name="type" value="report"/>
                   </PARAMETERS>
                   <ITEMS>
                   </ITEMS>
               </JOB>
           </BACKGROUND_JOB>

        For Each chkAttachment As ListItem In chklstAttachments.Items
            If chkAttachment.Selected Then
                Dim xlItem As XElement
                Dim iDocID As Integer
                Integer.TryParse(chkAttachment.Value, iDocID)
                If sFileName IsNot Nothing Then
                    'we've got an actual file so add the location as an item
                    xlItem = <ITEM path=<%= Session("Report") %>/>
                End If
                'if we are specifying a document to generate, or a document which has been generated and editted
                'we then need to specify a format in which to archive it, either docx or pdf depending on the setting in web.cofig
                Dim xlParameters As XElement = New XElement("PARAMETERS")
                'get the file type from config
                Dim sFileType As String = CType(GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).DocumentFormat.ToLower()
                'we need to pass in the file name, which may change according to file type (e.g. quote.docx may archive as quote.pdf)
                Dim sOutputFileName As String = Right(Session("Report").ToString(), Len(Session("Report").ToString()) - InStrRev(Session("Report").ToString(), "\"))
                sOutputFileName = Left(sOutputFileName, sOutputFileName.LastIndexOf(".")) & "." & sFileType.ToLower
                'add output format and file name params
                Dim xlDocumentFormat As XElement = <PARAMETER name="OutputFormat" value=<%= sFileType.ToUpper %>/>
                xlParameters.Add(xlDocumentFormat)
                Dim xlDestinationFilename As XElement = <PARAMETER name="DestinationFilename" value=<%= sOutputFileName %>/>
                xlParameters.Add(xlDestinationFilename)

                xlItem.Add(xlParameters)

                xlJob.Element("JOB").Element("ITEMS").Add(xlItem)
            End If
        Next

        Dim strJob As String = xlJob.ToString 'this will be used as input to the SAM call
        Dim sDescription As String = "Email report"
        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        'call SAM to queue the docs for Archiving
        Dim iBackgroundJobID As Integer = oWebService.CreateBackgroundJob(sDescription, strJob, Now.Date)
        If Request.QueryString("PostBack") IsNot Nothing Then
            If Request.QueryString("PostBack").ToUpper = "TRUE" Then
                Dim PostBackStr As String = "self.parent." & Page.ClientScript.GetPostBackEventReference(Me, "RefreshGrid") & ";"
                'refresh the parent page on postback with event argument RefreshGrid  
                Page.ClientScript.RegisterStartupScript(GetType(String), "ParentPostBack", PostBackStr, True)
            End If
        End If
        'close the modal page
        Page.ClientScript.RegisterStartupScript(GetType(String), "closeThickBox", "self.parent.tb_remove();", True)
    End Sub


    Protected Function GetListValue(ByVal sListCode As String, ByVal itemCode As String, ByVal sValue As String) As String
        Dim value As String = String.Empty
        Dim LstXmlElement As XmlElement = Nothing
        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        Dim oList As New NexusProvider.LookupListCollection
        oList = oWebService.GetList(NexusProvider.ListType.PMLookup, sListCode, False, False,,,, LstXmlElement)

        Dim sXML As String = LstXmlElement.OuterXml
        Dim xmlDoc As New System.Xml.XmlDocument
        Dim NodeList As XmlNodeList
        xmlDoc.LoadXml(sXML)

        NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & sListCode)

        If NodeList.Count > 0 Then
            value = (From Node As XmlNode In NodeList Where Node.SelectSingleNode("code").InnerText.Trim() = itemCode Select Node.SelectSingleNode(sValue).InnerText.Trim()).FirstOrDefault()
        End If

        Return value
    End Function
End Class




