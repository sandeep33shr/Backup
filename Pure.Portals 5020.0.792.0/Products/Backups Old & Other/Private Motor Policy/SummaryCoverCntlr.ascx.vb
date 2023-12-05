Imports Nexus.Constants.Constant
Imports Nexus.Constants.Session
Imports Nexus.Library
Imports CMS.Library
Imports SiriusFS.SAM.Client
Imports Microsoft.VisualBasic
Imports System.Xml
Imports System.Xml.XPath
Imports System.Xml.XmlReader
Imports System.Web.Configuration
Imports System.Web.Configuration.WebConfigurationManager
Imports System.Web.HttpContext
Imports Nexus.Utils
Imports System.Globalization.CultureInfo
Imports System.Reflection


Imports System.Data
Imports System.Data.OleDb
Imports System.Data.SqlClient
Imports System.IO

Imports Nexus.BaseRisk

Imports System.Xml.Linq
Imports Nexus

Imports System.Globalization
Imports System.Collections.Generic


Partial Class Products_MOTOR_SummaryOfCover
    Inherits System.Web.UI.UserControl

    Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
    Dim oNexusFrameWork As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)

    Dim chklstAttachments As New CheckBoxList
    Private _InsuranceFileKey As Integer
    Private _ClaimKey As Integer
    Private _PartyKey As Integer
    Dim oDocumentCollection As NexusProvider.DocumentDefaultsCollection = Nothing

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Ensure tabs are enabled for existing quotations
        If Session(CNMode) <> Mode.View AndAlso Session(CNMode) <> Mode.Review Then
            UpdateNexusQuoteStatus()
        End If

        'Email sending session variable
        If Session("ISMAILSENT") IsNot Nothing Then
            Session("ISMAILSENT") = Nothing
        End If

        'Documents Production
        If Not Page.IsPostBack Then
            DocumentsDisplay()
        End If

        'Ensure that cancellation reason has been selected on stamp duty risk
        If Session(CNMTAType) = MTAType.CANCELLATION Then
            HandleMandatoryOnBind()
        End If

    End Sub

    ''' <summary>
    ''' Ensured that NEXUS QUOTE flag has been updated to ensure tabs can be easily accessed 
    ''' once all tabs have been visited.
    ''' </summary>
    Public Sub UpdateNexusQuoteStatus()
        If Current.Session(CNQuote) IsNot Nothing Then
            Dim oQuote As NexusProvider.Quote = Current.Session(CNQuote)
            Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            For iRisk As Integer = 0 To oQuote.Risks.Count - 1
                If Not oQuote.Risks(iRisk).XMLDataset Is Nothing Then
                    Dim oDoc As New XmlDocument
                    Using srDataset As New System.IO.StringReader(oQuote.Risks(iRisk).XMLDataset)
                        Dim xmlTR As New XmlTextReader(srDataset)

                        oDoc.Load(xmlTR)
                        xmlTR.Close()
                    End Using

                    'Check if it's a quick qoute 
                    Dim oNode As XmlNode = oDoc.SelectSingleNode("/DATA_SET/RISK_OBJECTS/*/*[@NEXUSQS]")
                    If oNode IsNot Nothing Then
                        If oNode.Attributes("NEXUSQS").Value <> "1" Then
                            oNode.Attributes("NEXUSQS").Value = "1"
                            oNode.Attributes("US").Value = "2"
                            Dim swContent As New System.IO.StringWriter
                            Dim xmlwContent As New XmlTextWriter(swContent)

                            oDoc.WriteTo(xmlwContent)
                            oQuote.Risks(iRisk).XMLDataset = swContent.ToString()

                            Current.Session(CNQuote) = oQuote
                            xmlwContent.Close()
                            swContent.Close()
                            'call SAM method SaveRisk to save the risk to DB
                            oWebService.SaveRisk(oQuote, iRisk, Nothing)
                        End If
                    End If
                End If
            Next
        End If
    End Sub

    Private Sub DocumentsDisplay()
        Dim oFileTypes As Config.FileTypes = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork) _
        .Portals.Portal(Portal.GetPortalID()).FileTypes()
        Dim strNewBusiness As New StringBuilder
        Dim strMTADocuments As New StringBuilder
        Dim strRenewalDocuments As New StringBuilder
        Dim strMTCDocuments As New StringBuilder
        Dim strReinstatementDocuments As New StringBuilder

        'Build documents to be attached at New Business Quote
        strNewBusiness.Append("Motor Policy Quote")

        'Build list for MTA Quote
        strMTADocuments.Append("Motor Policy Endorsement Quote")

        'Build list for Cancellation
        strMTCDocuments.Append("Motor Policy Cancellation Quote")

        'Build list for Reinstatement
        strReinstatementDocuments.Append("Motor Policy Reinstatement Quote")

        'Build list for Renewal
        strRenewalDocuments.Append("Motor Policy Renewal Quote")


        'Attach Documents on relevant type of transactions
        If Session(CNMTAType) = MTAType.PERMANENT OrElse Session(CNMTAType) = MTAType.TEMPORARY Then
            DocMgr.Documents = strMTADocuments.ToString
        ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
            DocMgr.Documents = strMTCDocuments.ToString
        ElseIf Session(CNRenewal) IsNot Nothing OrElse Session.Item("CNRenewal") IsNot Nothing Then
            DocMgr.Documents = strRenewalDocuments.ToString
        ElseIf Session(CNMTAType) = MTAType.REINSTATEMENT Then
            DocMgr.Documents = strReinstatementDocuments.ToString
        Else
            DocMgr.Documents = strNewBusiness.ToString
        End If

        'Documents for Email
        Dim lstDocTemplate As New List(Of String)
        lstDocTemplate.Add("test")
        Finddocument(lstDocTemplate)

    End Sub
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

    Protected Sub HandleMandatoryOnBind()
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
        Dim iFailedValidationCount As Integer = 0

        'Loop through list to get the Stam Duty Risk
        For iRiskIndex = 0 To oQuote.Risks.Count - 1
            If oQuote.Risks(iRiskIndex).RiskTypeCode.Trim = "STAMPDUTY" Then

                'Do not allow bind if cancellation reason has not been selected
                If Session(CNMTAType) = MTAType.CANCELLATION Then
                    Try
                        If GetDatafromXML("//STAMPDUTY", "CANC_REASON", oQuote.Risks(iRiskIndex).XMLDataset) = String.Empty Then
                            WarningList.Items.Add(New ListItem("Cancellation reason not selected. Please edit Stamp Duty Risk to select cancellation reason"))
                            iFailedValidationCount += 1
                        End If
                    Catch ex As Exception

                    End Try
                End If
                Exit For
            End If
        Next

        Dim btnBuy = CType(GetMasterPlaceHolder(Page, oNexusConfig.MainContainerName), ContentPlaceHolder).FindControl("btnBuy")

        If Current.Session(CNMode) = Mode.View Then
            divWarning.Visible = False
        Else
            If iFailedValidationCount > 0 Then
                divWarning.Visible = True
                btnBuy.Visible = False
            Else
                divWarning.Visible = False
                btnBuy.Visible = True
            End If
        End If

    End Sub

    Public Function GetDatafromXML(ByVal Xpath As String, ByVal field As String, ByVal strXMLDataSet As String) As String
        Dim dStrValue As String = ""
        If Not String.IsNullOrEmpty(strXMLDataSet) Then
            Dim srDataset As New System.IO.StringReader(strXMLDataSet)
            Dim xmlTR As New XmlTextReader(srDataset)
            Dim Doc As New XmlDocument
            Doc.Load(xmlTR)
            xmlTR.Close()

            Dim oNode As XmlNode = Doc.SelectSingleNode(Xpath)
            If oNode IsNot Nothing Then
                If oNode.Attributes(field) IsNot Nothing Then
                    dStrValue = oNode.Attributes(field).Value
                End If
            End If
        End If
        Return dStrValue
    End Function
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

    Protected Sub Finddocument(lstDocTemplate As List(Of String))

        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        Dim oDocuments As Config.Documents = Nothing
        Dim sDocNameNotFound As String = String.Empty
        'oDocuments = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork) _
        '    .Portals.Portal(Portal.GetPortalID()).Products.Product(oQuote.ProductCode).Documents

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
End Class
