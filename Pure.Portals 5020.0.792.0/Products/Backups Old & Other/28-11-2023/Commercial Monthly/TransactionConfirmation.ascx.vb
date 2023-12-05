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

            If oQuote.ProductCode = "CMM" Then
                If Session(CNMode) = Mode.Add Or Session(CNMode) = Mode.Edit Or Session(CNMode) = Mode.View Then
                    If Session(CNMTAType) = MTAType.TEMPORARY Or Session(CNMTAType) = MTAType.PERMANENT Then
                        If CheckUnderwritingRIColumn("Type") Then
                            docs += "MM MTA Schedule,MTA Cover Letter,MM Copy Schedule"
                        Else
                            docs += "MM MTA Schedule,MTA Cover Letter,MM Copy Schedule"
                            docMgr.Documents = ""
                        End If

                    ElseIf Session(CNMTAType) = MTAType.REINSTATEMENT Then
                        If CheckUnderwritingRIColumn("Type") Then
                            docs += "MM Reinstatement"
                        Else
                            docs += "MM Reinstatement"
                            docMgr.Documents = ""
                        End If
                        
                    ElseIf Session(CNRenewal) IsNot Nothing OrElse Session.Item("CNRenewal") IsNot Nothing Then
                        If CheckUnderwritingRIColumn("Type") Then
                            docs += "MM Monthly Renewal,Cover Letter Renewal"
                        Else
                            docs += "MM Monthly Renewal,Cover Letter Renewal"
                            docMgr.Documents = ""
                        End If
						
                    ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
                        If CheckUnderwritingRIColumn("Type") Then
                            docs += "MM Cancellation,Cover Letter Cancellation"
                        Else
                            docs += "MM Cancellation,Cover Letter Cancellation"
                            docMgr.Documents = ""
                        End If
						
                    Else
                        If CheckUnderwritingRIColumn("Type") Then
                            docs += "MM New Business,NB Cover Letter"
                        Else
                            docs += "MM New Business,NB Cover Letter"
                            docMgr.Documents = ""
                        End If
                    End If
                End If
            End If
            docMgr.Documents = docs.ToString()
			
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