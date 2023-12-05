Imports System.Web.HttpContext
Imports Nexus.Utils
Imports System.Data
Imports Nexus.Constants.Session
Imports Nexus.Constants.Constant
Imports System.Xml.Linq
Imports Nexus


Imports Nexus.Library
Imports CMS.Library
Imports SiriusFS.SAM.Client
Imports Microsoft.VisualBasic
Imports System.Xml
Imports System.Xml.XPath


Imports System.Xml.XmlReader
Imports System.Web.Configuration
Imports System.Web.Configuration.WebConfigurationManager

Imports System.Globalization.CultureInfo
Imports System.Globalization
Imports System.Web.Mail
Imports System.Reflection
Imports System.Collections.Generic
Imports System.IO

Namespace Nexus
    Partial Class TransactionConfirmationCntrl : Inherits System.Web.UI.UserControl
        Dim chklstAttachments As New CheckBoxList
        Private _InsuranceFileKey As Integer
        Private _ClaimKey As Integer
        Private _PartyKey As Integer

        Dim oDocumentCollection As NexusProvider.DocumentDefaultsCollection = Nothing
#Region "Page Events"
        Protected Shadows Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            'If Not Page.IsPostBack Then
            DocumentsDisplay()

            'End If
        End Sub
#End Region
#Region "Documents Production"
        Private Sub DocumentsDisplay()
            Dim oWebService = New NexusProvider.ProviderManager().Provider
            Dim oQuote As NexusProvider.Quote = Session(CNQuote)
            Dim sTransactiontype As String = String.Empty
            Dim oFileTypes As Config.FileTypes = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork) _
            .Portals.Portal(Portal.GetPortalID()).FileTypes()

            Dim strNewBusiness As New StringBuilder
            Dim strMTADocuments As New StringBuilder
            Dim strMTCDocuments As New StringBuilder
            Dim strRenewalDocuments As New StringBuilder
            Dim strReinstatementDocuments As New StringBuilder
            Dim bIsFacPlaced As Boolean = False

            bIsFacPlaced = CheckUnderwritingRIColumn("Type")

            ' Build documents to be attached at New Business 
            strNewBusiness.Append("Motor Policy New Business,Motor Policy Wording")
            If bIsFacPlaced Then
                strNewBusiness.Append(",FAC Slip")
            End If

            ' Build list for MTA 
            strMTADocuments.Append("Motor Policy Endorsement Schedule")
            If bIsFacPlaced Then
                strMTADocuments.Append(",FAC Slip")
            End If

            ' Build list for MTC 
            strMTCDocuments.Append("Motor Policy Cancellation Schedule")
            If bIsFacPlaced Then
                strMTCDocuments.Append(",FAC Slip")
            End If

            ' Build list for Reinstatement
            strReinstatementDocuments.Append("Motor Policy Reinstatement Schedule")
            If bIsFacPlaced Then
                strReinstatementDocuments.Append(",FAC Slip")
            End If

            ' Build list for Renewal
            strRenewalDocuments.Append("Motor Policy Renewal Schedule")
            If bIsFacPlaced Then
                strRenewalDocuments.Append(",FAC Slip")
            End If

            If Session(CNMTAType) = MTAType.PERMANENT OrElse Session(CNMTAType) = MTAType.TEMPORARY Then
                docMgr.Documents = strMTADocuments.ToString
                sTransactiontype = "MTA"
            ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
                docMgr.Documents = strMTCDocuments.ToString
                sTransactiontype = "MTC"
            ElseIf Session(CNRenewal) IsNot Nothing OrElse Session.Item("CNRenewal") IsNot Nothing Then
                docMgr.Documents = strRenewalDocuments.ToString
                sTransactiontype = "REN"
            ElseIf Session(CNMTAType) = MTAType.REINSTATEMENT Then
                docMgr.Documents = strReinstatementDocuments.ToString
                sTransactiontype = "REINS"
            Else
                docMgr.Documents = strNewBusiness.ToString
                sTransactiontype = "NB"
            End If


            If oQuote.GrossTotal >= 0 Then
                docMgr.Documents = docMgr.Documents + ",Debit Note"
            Else
                docMgr.Documents = docMgr.Documents + ",Credit Note"
            End If


            If Session("ISMAILSENT") Is Nothing Then
                Finddocument(docMgr.Documents)
                SendEmail(sTransactiontype)
            End If
        End Sub
#End Region

#Region "Send Email"
        Function CheckUnderwritingRIColumn(ByVal xCheckColumn As String) As Boolean
            Try
                Dim oWebService = New NexusProvider.ProviderManager().Provider
                Dim oQuote As NexusProvider.Quote = Session(CNQuote)


                Dim IsFACPlaced As Boolean = False

                Dim RiskCount As Integer = oQuote.Risks.Count()


                For index = 0 To oQuote.Risks.Count() - 1

                    Dim oRIXMLData As String = oWebService.GetReinsurance2007(oQuote.Risks(index).Key, 0)
                    Dim oXMLDoc As New XmlDocument
                    oXMLDoc.LoadXml(oRIXMLData)


                    Dim table As New Data.DataTable
                    Dim dataset As New Data.DataSet

                    dataset.ReadXml(New XmlNodeReader(oXMLDoc))

                    If dataset.Tables.Count > 0 Then

                        table = dataset.Tables(1).Copy() 'ArrangementRow

                        Dim columnIndex As Integer = -1
                        Dim CheckColumnName As String = xCheckColumn
                        Dim Value As String


                        For i As Integer = 0 To table.Columns.Count - 1
                            If table.Columns(i).ColumnName = CheckColumnName Then
                                columnIndex = i
                                For x = 0 To table.Rows.Count
                                    Try
                                        Value = table.Rows(x).ItemArray(columnIndex)

                                        If Value = "F" Or Value = "FX" Then
                                            IsFACPlaced = True
                                            Exit For
                                        End If
                                    Catch
                                        Exit For
                                    End Try
                                Next

                                If IsFACPlaced = True Then
                                    Exit For
                                End If
                            End If
                        Next
                    End If


                Next
                CheckUnderwritingRIColumn = IsFACPlaced
            Catch
                CheckUnderwritingRIColumn = False
                Exit Function
            End Try
        End Function
        Protected Sub SendEmail(Stranstype As String)
            Session("ISMAILSENT") = 1
            Dim oParty As NexusProvider.BaseParty = Nothing
            Dim sSubject As String = String.Empty
            Dim sMessage As String = String.Empty
            Dim sCCemail As String = String.Empty
            Dim sbCCemail As String = String.Empty
            Dim sDefaultSenderEmail = "Pure_access@oldmutual.co.zw"
            Dim sSenderEmail As String = String.Empty
            Dim sSenderName As String = "OMICO"
            Dim sRecipientEmail As String = ""
            Dim sAgentemail As String = ""
            Dim sClientemail As String = ""
            Dim sInsuredName As String = String.Empty
            Dim bEmailSent As Boolean = False
            Dim oQuote As NexusProvider.Quote = Session(CNQuote)


            'Get logged in user Name
            If Session(CNAgentDetails) IsNot Nothing Then
                Dim oUserDetails As NexusProvider.UserDetails = CType(Session(CNAgentDetails), NexusProvider.UserDetails)
                sSenderName = oUserDetails.PureUsername
                'get the logged in user name from session
                If oUserDetails.EmailAddress.ToString <> "" Then
                    sSenderEmail = CType(Session(CNAgentDetails), NexusProvider.UserDetails).EmailAddress.ToString
                Else
                    sSenderEmail = sDefaultSenderEmail
                End If
                sbCCemail = ""
            End If

            'IF agency Bussines get agents email address
            If (oQuote.Agent > 0) Then
                Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                oParty = oWebService.GetParty(oQuote.Agent)

                With CType(oParty, NexusProvider.OtherParty)
                    Dim oContact As NexusProvider.Contact = .Contacts(NexusProvider.ContactType.MEMAIL)
                    ' sInsuredName = .Name
                    If oContact IsNot Nothing Then
                        If sAgentemail = String.Empty Then
                            sAgentemail = oContact.Number
                        Else
                            sAgentemail &= "," & oContact.Number
                        End If
                    End If
                End With
                oWebService = Nothing
            End If
            'Get Insured's Name and Email address  
            oParty = Session.Item(CNParty)

            Select Case True
                Case TypeOf oParty Is NexusProvider.CorporateParty
                    With CType(oParty, NexusProvider.CorporateParty)
                        sInsuredName = .CompanyName
                        Dim oContact As NexusProvider.Contact = .Contacts(NexusProvider.ContactType.Email)
                        If oContact IsNot Nothing Then
                            If sClientemail = String.Empty Then
                                sClientemail = oContact.Number
                            Else
                                sClientemail &= "," & oContact.Number
                            End If
                        End If
                    End With
                Case TypeOf oParty Is NexusProvider.PersonalParty
                    With CType(oParty, NexusProvider.PersonalParty)
                        sInsuredName = .Title & " " & .Forename & " " & .Lastname
                        Dim oContact As NexusProvider.Contact = .Contacts(NexusProvider.ContactType.MEMAIL)
                        If oContact IsNot Nothing Then
                            If sClientemail = String.Empty Then
                                sClientemail = oContact.Number
                            Else
                                sClientemail &= "," & oContact.Number
                            End If
                        End If
                    End With
            End Select

            If (oQuote.Agent > 0) Then
                sRecipientEmail = sAgentemail

                'Build e-mail subject and Body As per transaction type    
                Select Case Stranstype
                    Case "NB"
                        sMessage = "Dear Sir/Madam " & vbCrLf & vbCrLf
                        sMessage = sMessage & "Ref: " & sInsuredName & vbCrLf & vbCrLf
                        sMessage = sMessage & "Please find attached policy schedule & wording in respect of the above-named insured for your consideration. If you require any further information, feel free to contact us."
                        sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                        sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
                        'sSubject = "Policy Issued" & oQuote.InsuranceFileRef & " for " & sInsuredName
                        sSubject = "NEW BUSINESS"
                    Case "MTA"
                        sMessage = "Dear Sir/Madam " & vbCrLf & vbCrLf
                        sMessage = sMessage & "Ref: " & sInsuredName & vbCrLf & vbCrLf
                        sMessage = sMessage & "Please find attached endorsement in respect of the above-named insured for your consideration. If you require any further information, feel free to contact us."
                        sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                        sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
                        sSubject = "ENDORSEMENT" '& oQuote.InsuranceFileRef & " for " & sInsuredName

                    Case "MTC"
                        sMessage = "Dear Sir/Madam " & vbCrLf & vbCrLf
                        sMessage = sMessage & "Ref: " & sInsuredName & vbCrLf & vbCrLf
                        sMessage = sMessage & "Please note that policy " + oQuote.InsuranceFileRef + " in respect of the above-named insured has been cancelled, find attached endorsement for your consideration.If you require any further information, feel free to contact us."
                        sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                        sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
                        sSubject = "CANCELLATION" ' & oQuote.InsuranceFileRef & " for " & sInsuredName

                    Case "REINS"
                        sMessage = "Dear Sir/Madam " & vbCrLf & vbCrLf
                        sMessage = sMessage & "Ref: " & sInsuredName & vbCrLf & vbCrLf
                        sMessage = sMessage & "Please note that policy " + oQuote.InsuranceFileRef + " in respect of the above-named insured has been reinstated, find attached endorsement for your consideration.If you require any further information, feel free to contact us."
                        sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                        sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
                        sSubject = "REINSTATEMENT" '& oQuote.InsuranceFileRef & " for " & sInsuredName

                    Case "REN"
                        sMessage = "Dear Sir/Madam " & vbCrLf & vbCrLf
                        sMessage = sMessage & "Ref: " & sInsuredName & vbCrLf & vbCrLf
                        sMessage = sMessage & "Please note that policy " + oQuote.InsuranceFileRef + " in respect of the above-named insured has been renewed for the period " + oQuote.CoverStartDate + " to " + oQuote.CoverEndDate + ", find attached renewal schedule for your consideration.If you require any further information, feel free to contact us."
                        sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                        sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
                        sSubject = "Renewal" '& oQuote.InsuranceFileRef & " for " & sInsuredName

                End Select
            Else
                sRecipientEmail = sClientemail

                Select Case Stranstype
                    Case "NB"
                        sMessage = "Dear Sir/Madam " & vbCrLf & vbCrLf
                        sMessage = sMessage & "Ref: " & sInsuredName & " of " & oQuote.InsuranceFileRef & vbCrLf & vbCrLf
                        sMessage = sMessage & "Please find attached policy schedule & wording for your consideration.If you require any further information, feel free to contact us."
                        sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                        sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
                        'sSubject = "Policy Issued" & oQuote.InsuranceFileRef & " for " & sInsuredName
                        sSubject = "NEW BUSINESS"
                    Case "MTA"
                        sMessage = "Dear Sir/Madam " & vbCrLf & vbCrLf
                        sMessage = sMessage & "Ref: " & sInsuredName & " of " & oQuote.InsuranceFileRef & vbCrLf & vbCrLf
                        sMessage = sMessage & "Please find attached endorsement for your consideration.If you require any further information, feel free to contact us."
                        sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                        sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
                        sSubject = "ENDORSEMENT" '& oQuote.InsuranceFileRef & " for " & sInsuredName

                    Case "MTC"
                        sMessage = "Dear Sir/Madam " & vbCrLf & vbCrLf
                        sMessage = sMessage & "Ref: " & sInsuredName & " of " & oQuote.InsuranceFileRef & vbCrLf & vbCrLf
                        sMessage = sMessage & "Please note that the above-mentioned policy has been cancelled, find attached endorsement for your consideration.If you require any further information, feel free to contact us."
                        sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                        sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
                        sSubject = "CANCELLATION" ' & oQuote.InsuranceFileRef & " for " & sInsuredName

                    Case "REINS"
                        sMessage = "Dear Sir/Madam " & vbCrLf & vbCrLf
                        sMessage = sMessage & "Ref: " & sInsuredName & " of " & oQuote.InsuranceFileRef & vbCrLf & vbCrLf
                        sMessage = sMessage & "Please note that the above-mentioned policy has been reinstated, find attached endorsement for your consideration.If you require any further information, feel free to contact us."
                        sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                        sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
                        sSubject = "REINSTATEMENT" '& oQuote.InsuranceFileRef & " for " & sInsuredName

                    Case "REN"
                        sMessage = "Dear Sir/Madam " & vbCrLf & vbCrLf
                        sMessage = sMessage & "Ref: " & sInsuredName & " of " & oQuote.InsuranceFileRef & vbCrLf & vbCrLf
                        sMessage = sMessage & "Please note that the above-mentioned policy has been renewed for the period  " + oQuote.CoverStartDate + " to " + oQuote.CoverEndDate + ", find attached renewal schedule for your consideration.If you require any further information, feel free to contact us."
                        sMessage = sMessage & vbCrLf & vbCrLf & "Regards"
                        sMessage = sMessage & vbCrLf & vbCrLf & sSenderName
                        sSubject = "Renewal" '& oQuote.InsuranceFileRef & " for " & sInsuredName
                End Select

            End If


            'set up the job to send emails to the requested addresses
            'create an html file on the disk in the temp docs directory, with contents taken from the body textbox
            Dim sFileName As String = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).TempFileLocation & "\" & Guid.NewGuid.ToString & ".html"
            Dim emailBodyFile As New System.IO.StreamWriter(sFileName)

            'form html formatted string by replacing line breaks with "<br />" and adding basic html tags
            Dim sHtml As String = "<html><body>" & Replace(Convert.ToString(sMessage), Chr(13) & Chr(10), "<br />") & "</body></html>"
            emailBodyFile.Write(sHtml)
            emailBodyFile.Close()

            'For setting CC
            'If String.IsNullOrEmpty(sRecipientEmail) Then
            '    sSubject = sSubject + "email not send to sRecipientEmail"
            '    sRecipientEmail = CType(Session(CNAgentDetails), NexusProvider.UserDetails).EmailAddress
            'Else
            '    sCCemail = CType(Session(CNAgentDetails), NexusProvider.UserDetails).EmailAddress

            'End If


            CreateBackgroundJob(sRecipientEmail, sCCemail, sSubject, sFileName, oParty.Key, oQuote.InsuranceFileKey)
            oQuote = Nothing

        End Sub
        Function CreateBackgroundJob(sRecipientEmail As String, sCCemail As String, sSubject As String, sFileName As String, nPartyCnt As String, nInsuranceFileCnt As String) As Integer
            Dim xlJob As System.Xml.Linq.XElement =
            <BACKGROUND_JOB>
                <JOB jobtype="DOCUPACK">
                    <PARAMETERS>
                        <PARAMETER name="emailTo" value=<%= sRecipientEmail %>/>
                        <PARAMETER name="emailCc" value=<%= sCCemail %>/>
                        <PARAMETER name="emailSubject" value=<%= sSubject %>/>
                        <PARAMETER name="Destination" value="email"/>
                        <PARAMETER name="path" value=<%= sFileName %>/>
                        <PARAMETER name="PartyCnt" value=<%= nPartyCnt %>/>
                        <PARAMETER name="InsuranceFileCnt" value=<%= nInsuranceFileCnt %>/>
                    </PARAMETERS>
                    <ITEMS>
                    </ITEMS>
                </JOB>
            </BACKGROUND_JOB>

            'documents from the document manager control, so we need to look in session for the details
            'Dim oDocumentCollection As NexusProvider.DocumentDefaultsCollection = CType(Session(CNCurrentDocumentCollection), NexusProvider.DocumentDefaultsCollection)
            '  Dim oDocumentCollection As NexusProvider.DocumentDefaultsCollection = CType(Cache.Item(Request.QueryString("key")), NexusProvider.DocumentDefaultsCollection)

            For Each chkAttachment As ListItem In chklstAttachments.Items
                If chkAttachment.Selected Then
                    Dim xlItem As XElement
                    Dim iDocID As Integer
                    Integer.TryParse(chkAttachment.Value, iDocID)
                    Dim sOutputFormat As String = String.Empty
                    If Not String.IsNullOrEmpty(oDocumentCollection(iDocID).FileLocation) Then
                        'get the file extension so that we can use this as the OutputFormat in the xml
                        Dim sFileLocation As String = oDocumentCollection(iDocID).FileLocation
                        sOutputFormat = Right(sFileLocation, Len(sFileLocation) - sFileLocation.LastIndexOf(".") - 1).ToUpper
                    End If
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
                        Dim sFileType As String = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).DocumentFormat.ToLower()
                        'we need to pass in the file name, which may change according to file type (e.g. quote.docx may archive as quote.pdf)
                        Dim sOutputFileName As String = oDocumentCollection(iDocID).documentTemplateDescription & "." & sFileType.ToLower
                        '  sOutputFileName = Left(sOutputFileName, sOutputFileName.LastIndexOf(".")) & "." & sFileType.ToLower
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


            Dim strJob As String = xlJob.ToString 'this will be used as input to the WFC Service call
            Dim sDescription As String = "Email documents"
            Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider

            'call WCF Service to queue the docs for Archiving
            Dim iBackgroundJobID As Integer = oWebService.CreateBackgroundJob(sDescription, strJob, Now.Date)
            oWebService = Nothing
            Return iBackgroundJobID
        End Function
        Protected Sub Finddocument(lstDocName As String)

            Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider

            Dim sDocNameNotFound As String = String.Empty

            Dim lstDocTemplate As New List(Of String)
            Dim oQuote As NexusProvider.Quote = Session(CNQuote)
            Dim sFileLocation As String

            Dim oDocumentType As NexusProvider.DocumentType = NexusProvider.DocumentType.PDF
            'set the document type for the call to GenerateDocument, use the file extensions that we added when setting up the document


            Dim oDocuments As Config.Documents = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork) _
                .Portals.Portal(Portal.GetPortalID()).Products.Product(oQuote.ProductCode).Documents

            For Each sDocName As String In Split(lstDocName, ",")
                If oDocuments.DocTemplate(sDocName) IsNot Nothing Then
                    'add the document template to the list of templates
                    lstDocTemplate.Add(oDocuments.DocTemplate(sDocName).Code.ToString)

                End If
            Next
            If (Session(CNCurrentDocumentCollection) IsNot Nothing) Then
                oDocumentCollection = CType(Session(CNCurrentDocumentCollection), NexusProvider.DocumentDefaultsCollection)
            Else
                oDocumentCollection = oWebService.GetDocumentDefaults(lstDocTemplate)
            End If
            'we will have ids passed in query string in format docID1docID2 etc
            'extract the ids by splitting on the string "docID"
            If oDocumentCollection IsNot Nothing Then
                ' If oDocumentCollection.Count <> lstDocTemplate.Count Then
                Dim bDocCodeFound As Boolean
                For Each sItem As String In lstDocTemplate
                    bDocCodeFound = False
                    For i As Integer = 0 To oDocumentCollection.Count - 1
                        If oDocumentCollection(i).documentTemplateCode = sItem Then
                            bDocCodeFound = True
                            Dim docID As Integer = oDocumentCollection(i).documentTemplateID
                            With oDocumentCollection(Integer.Parse(i))
                                Dim iValue As Integer = .Key
                                Dim sText As String = .documentTemplateDescription
                                chklstAttachments.Items.Add(New ListItem With {.Value = i, .Text = sText, .Selected = True})
                            End With
                            Exit For
                        Else
                            sDocNameNotFound = sDocNameNotFound + sItem
                        End If
                    Next

                Next
            End If
            oWebService = Nothing
            '  End If
        End Sub
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
            Dim OldWords() As String = {"&nbsp;", "&amp;", "&quot;", "&lt;",
           "&gt;", "&reg;", "&copy;", "&bull;", "&trade;"}
            Dim NewWords() As String = {" ", "&", """", "<", ">", "®", "©", "•", "™"}
            For i As Integer = 0 To i < OldWords.Length
                sbHTMLString.Replace(OldWords(i), NewWords(i))
            Next i

            ' Finally, remove all HTML tags and return plain text
            Return System.Text.RegularExpressions.Regex.Replace(
           sbHTMLString.ToString(), "<[^>]*>", "")
        End Function
        Private Function CreateTempExternalFile(ByVal sOriginalFilepath As String) As String
            Dim sEmailTemplocation As String = String.Empty
            If sOriginalFilepath <> "" Then
                'set the location using an guid as the folder inside the temp file location from config
                sEmailTemplocation = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(Portal.GetPortalID()).TempFileLocation & "\" & Guid.NewGuid.ToString
                If IO.File.Exists(sOriginalFilepath) Then
                    System.IO.Directory.CreateDirectory(sEmailTemplocation)
                    sEmailTemplocation = sEmailTemplocation & "\" & Path.GetFileName(sOriginalFilepath)
                    IO.File.Copy(sOriginalFilepath, sEmailTemplocation, True)
                End If
            End If
            Return sEmailTemplocation
        End Function
#End Region
    End Class

End Namespace