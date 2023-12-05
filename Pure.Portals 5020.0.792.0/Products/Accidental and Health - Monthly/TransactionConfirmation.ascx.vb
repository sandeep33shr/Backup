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
            If oQuote.ProductCode = "AHM" Then
                If Session(CNMode) = Mode.Add Or Session(CNMode) = Mode.Edit Or Session(CNMode) = Mode.View Then
                    If Session(CNMTAType) = MTAType.TEMPORARY Or Session(CNMTAType) = MTAType.PERMANENT Then
                        'If (oQuote.InsuranceFileTypeCode = "MTAQUOTE  ") Or (oQuote.InsuranceFileTypeCode = "MTAQTETEMP") Or (oQuote.InsuranceFileTypeCode = "MTA TEMP  ") Or (oQuote.InsuranceFileTypeCode = "MTA PERM  ") Then

                        If CheckUnderwritingRIColumn("Type") Then
                            docs += "MTA Cover Letter,AHA MTA Schedule,AHA Copy Schedule"
                        Else
                            docs += "MTA Cover Letter,AHA MTA Schedule,AHA Copy Schedule"
                            docMgr.Documents = ""
                        End If
                        'End If
						
						If oQuote.GrossTotal > 1 Then
							docs += ",Debit Note"
						ElseIf oQuote.GrossTotal < 0
							docs += ",Credit Note"
						End If

                    ElseIf Session(CNMTAType) = MTAType.REINSTATEMENT Then
                        ' If (oQuote.InsuranceFileTypeCode = "MTAQREINS ") Or (oQuote.InsuranceFileTypeCode = "MTAREINS  ") Then

                        If CheckUnderwritingRIColumn("Type") Then
                            docs += "AHA Reinstatement"
                        Else
                            docs += "AHA Reinstatement"
                            docMgr.Documents = ""
                        End If
                        'End If
                    ElseIf Session(CNRenewal) IsNot Nothing OrElse Session.Item("CNRenewal") IsNot Nothing Then
                        'If (oQuote.InsuranceFileTypeCode = "RENEWAL") Then

                        If CheckUnderwritingRIColumn("Type") Then
                            docs += "AHA Renewal,Cover Letter Renewal"
                        Else
                            docs += "AHA Renewal,Cover Letter Renewal"
                            docMgr.Documents = ""
                        End If
                        'End If
                    ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
                        'If (oQuote.InsuranceFileTypeCode = "MTACAN    ") Then
                        If CheckUnderwritingRIColumn("Type") Then
                            docs += "AHA Cancellation,Cover Letter Cancellation"
                        Else
                            docs += "AHA Cancellation,Cover Letter Cancellation"
                            docMgr.Documents = ""
                        End If
                        'End If
                    Else
                        If CheckUnderwritingRIColumn("Type") Then
                            docs += "AHA New Business,NB Cover Letter"
                        Else
                            docs += "AHA New Business,NB Cover Letter"
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
		
    End Class
End Namespace