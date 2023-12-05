Imports System.Web.HttpContext
Imports Nexus.Utils
Imports System.Data
Imports Nexus.Constants.Session
Imports Nexus.Constants.Constant
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

Imports System.Reflection

Namespace Nexus
    Partial Class TransactionConfirmationCntrl : Inherits System.Web.UI.UserControl
        Protected Shadows Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            'If Not Page.IsPostBack Then
                DocumentsDisplay()
            'End If
        End Sub

        Private Sub DocumentsDisplay()
		 Dim oQuote As NexusProvider.Quote = Session(CNQuote)
           ' Dim risk As NexusProvider.Risk = Session(CNRisks)
            Dim nCount As Integer = 0
            Dim docs As String = ""

            Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
            'Dim oPolicyQuote As NexusProvider.Quote = Session(CN

            'If Session(CNMode) = Mode.NewClaim Or Session.Item(CNMode) = Mode.NewClaim Then
            '    docMgr.Documents = "Treaty RI Notification,Large Loss Notification Treaty,Payment Confirmation Letter,Acknowledgement of Debt,TP Letter of Demand"
            'End If


            'Other products - Not Specialist Liability
            If oQuote.ProductCode = "PKM" Then
                If Session(CNMode) = Mode.Add Or Session(CNMode) = Mode.Edit Or Session(CNMode) = Mode.View Then
                    If Session(CNMTAType) = MTAType.TEMPORARY Or Session(CNMTAType) = MTAType.PERMANENT Then
                        If (oQuote.InsuranceFileTypeCode = "MTAQUOTE  ") Or (oQuote.InsuranceFileTypeCode = "MTAQTETEMP") Or (oQuote.InsuranceFileTypeCode = "MTA TEMP  ") Or (oQuote.InsuranceFileTypeCode = "MTA PERM  ") Then

                            If docs = "" Then
                                docs += "Home Loan MTA,MTA Cover Letter"
                            Else
                                docs += ",Home Loan MTA,MTA Cover Letter"
                                docMgr.Documents = ""
                            End If
                        End If
						
                    ElseIf Session(CNMTAType) = MTAType.REINSTATEMENT Then
                        If (oQuote.InsuranceFileTypeCode = "MTAQREINS ") Or (oQuote.InsuranceFileTypeCode = "MTAREINS  ") Then

                            If docs = "" Then
                                docs += "Home Loan Reinstatement"
                            Else
                                docs += ",Home Loan Reinstatement"
                                docMgr.Documents = ""
                            End If
                        End If
                    ElseIf Session(CNRenewal) IsNot Nothing OrElse Session.Item("CNRenewal") IsNot Nothing Then
                            If docs = "" Then
                                docs += "Home Loan Renewal,Cover Letter Renewal"
                            Else
                                docs += ",Home Loan Renewal,Cover Letter Renewal"
                                docMgr.Documents = ""
                            End If
                    ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
                        'If (oQuote.InsuranceFileTypeCode = "MTACAN    ") Then
                        If docs = "" Then
                            docs += "Home Loan Cancellation,Cover Letter Cancellation"
                        Else
                            docs += ",Home Loan Cancellation,Cover Letter Cancellation"
                            docMgr.Documents = ""
                        End If
                        'End If
                    Else
                        If docs = "" Then
                            docs += "Home Loan New Business,NB Cover Letter"
                        Else
                            docs += ",Home Loan New Business,NB Cover Letter"
                            docMgr.Documents = ""
                        End If
                    End If
                End If
            End If

            docMgr.Documents = docs.ToString()
        'Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
        'Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        'Dim oNexusFrameWork As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)

        ''-----------------------Load the control-----------------------
        'Dim myUC As UserControl = CType(CType(GetMasterPlaceHolder(Page, oNexusConfig.MainContainerName), ContentPlaceHolder).FindControl("docMgr"), UserControl) 

        ''-----------------------Set the Usercontrol Type-----------------------
        'Dim ucType As Type = myUC.GetType()

        'Dim strNewBusinessDocuments As New StringBuilder
        'Dim strMTADocuments As New StringBuilder
        'Dim strMTACancellation As New StringBuilder

        ''-----------------------Build list for New Business Bind Documents-----------------------
        'strNewBusinessDocuments.Append("Schedule")
        'strNewBusinessDocuments.Append(",RIslip1")

        ''-----------------------Build list for MTA Bind Documents-----------------------
        'strMTADocuments.Append("MTA Schedule")
        'strMTADocuments.Append(",RIslip1")

        ''-----------------------Build list for MTA Cancellation Documents-----------------------
        ''strMTACancellation.Append("MTA Cancellation,") 'Uncomment and check doc name (in web.config) when MTA Cancellation doc is added
        'strMTACancellation.Append("RIslip1")

        ''-----------------------Get access to the property-----------------------
        'Dim ucPageHeadingProperty As PropertyInfo = ucType.GetProperty("Documents")


        '-----------------------Checks the current transaction type and adds relevent document lists-----------------------
                ' If Session(CNMTAType) = MTAType.PERMANENT Or Session(CNMTAType) = MTAType.TEMPORARY Then
                    ' ' ucPageHeadingProperty.SetValue(myUC, strMTADocuments.ToString, Nothing)
					' docMgr.Documents = "Endorsement"
                ' ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
                    ' 'ucPageHeadingProperty.SetValue(myUC, strMTACancellation.ToString, Nothing)
					' docMgr.Documents = "Cancellation"
				' ElseIf Session(CNRenewal) IsNot Nothing Or Session.Item("CNRenewal") IsNot Nothing Then
					' docMgr.Documents = "Renewal"
				' ElseIf Session(CNMTAType) = MTAType.REINSTATEMENT Then
                    ' 'ucPageHeadingProperty.SetValue(myUC, strMTACancellation.ToString, Nothing)
					' docMgr.Documents = "Reinstatement"	
                ' Else
                    ' docMgr.Documents = "Schedule"
                    ' 'ucPageHeadingProperty.SetValue(myUC, strNewBusinessDocuments.ToString, Nothing)
                ' End If
        End Sub
    End Class
End Namespace