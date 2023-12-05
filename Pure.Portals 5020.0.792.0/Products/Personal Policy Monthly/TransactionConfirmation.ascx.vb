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
            If oQuote.ProductCode = "NPM" Then
                If Session(CNMode) = Mode.Add Or Session(CNMode) = Mode.Edit Or Session(CNMode) = Mode.View Then
                    If Session(CNMTAType) = MTAType.TEMPORARY Or Session(CNMTAType) = MTAType.PERMANENT Then
                        'If (oQuote.InsuranceFileTypeCode = "MTAQUOTE  ") Or (oQuote.InsuranceFileTypeCode = "MTAQTETEMP") Or (oQuote.InsuranceFileTypeCode = "MTA TEMP  ") Or (oQuote.InsuranceFileTypeCode = "MTA PERM  ") Then

                        If CheckUnderwritingRIColumn("Type") Then
                                docs += "PL_MTASchedule,MTA Cover Letter"
                            Else
                                docs += "PL_MTASchedule,MTA Cover Letter"
                                docMgr.Documents = ""
                            End If
                        'End If
						
						' If oQuote.GrossTotal > 1 Then
							' docs += ",Debit Note"
					' ElseIf oQuote.GrossTotal < 0
							' docs += ",Credit Note"
					' End If

                    ElseIf Session(CNMTAType) = MTAType.REINSTATEMENT Then
                        'If (oQuote.InsuranceFileTypeCode = "MTAQREINS ") Or (oQuote.InsuranceFileTypeCode = "MTAREINS  ") Then

                        If CheckUnderwritingRIColumn("Type") Then
                                docs += "PL_REINSchedule"
                            Else
                                docs += "PL_REINSchedule"
                                docMgr.Documents = ""
                            End If
                        ' End If
                    ElseIf Session(CNRenewal) IsNot Nothing OrElse Session.Item("CNRenewal") IsNot Nothing Then
                        'If (oQuote.InsuranceFileTypeCode = "RENEWAL") Then

                        If CheckUnderwritingRIColumn("Type") Then
                                docs += "Cover Letter Renewal,PL_RNSchedule"
                            Else
                                docs += "Cover Letter Renewal,PL_RNSchedule"
                                docMgr.Documents = ""
                            End If
                        ' End If
                    ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
                        'If (oQuote.InsuranceFileTypeCode = "MTACAN    ") Then
                        If CheckUnderwritingRIColumn("Type") Then
                                docs += "PL_CNSchedule,Cover Letter Cancellation"
                            Else
                                docs += "PL_CNSchedule,Cover Letter Cancellation"
                                docMgr.Documents = ""
                            End If
                        'End If
                    Else
                        If CheckUnderwritingRIColumn("Type") Then
                            docs += "PL_NBSchedule,NB Cover Letter"
                        Else
                            docs += "PL_NBSchedule,NB Cover Letter"
                            docMgr.Documents = ""
                        End If
                    End If
                End If
            End If

            'Specialist Liability Product
            If oQuote.ProductCode IsNot "NPM" Then
                For nCount = 0 To oQuote.Risks.Count - 1
                    If Session(CNMTAType) = MTAType.PERMANENT Or Session(CNMTAType) = MTAType.TEMPORARY Then
                        If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                            If docs = "" Then
                                docs = "DO_MTASchedule"
                            Else
                                docs += ",DO_MTASchedule"
                            End If

                            'ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPAPA     " Then
                            '	If docs = "" Then
                            '		docs += "Tax Invoice,Cover Letter Tax Invoice"
                            '	Else
                            '		docs += ",Tax Invoice,Cover Letter Tax Invoice"
                            '		docMgr.Documents = ""
                            '	End If

                            'ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPADOM    " Then
                            '	If docs = "" Then
                            '		docs += "Tax Invoice,Cover Letter Tax Invoice"
                            '	Else
                            '		docs += ",Tax Invoice,Cover Letter Tax Invoice"
                            '		docMgr.Documents = ""
                            '	End If

                            'ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPAMOTOR  " Then
                            '	If docs = "" Then
                            '		docs += "Tax Invoice,Cover Letter Tax Invoice"
                            '	Else
                            '		docs += ",Tax Invoice,Cover Letter Tax Invoice"
                            '		docMgr.Documents = ""
                            '	End If

                            'ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPAPCE    " Then
                            '	If docs = "" Then
                            '		docs += "Tax Invoice,Cover Letter Tax Invoice"
                            '	Else
                            '		docs += ",Tax Invoice,Cover Letter Tax Invoice"
                            '		docMgr.Documents = ""
                            '	End If

                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "TRSTLIAB  " Then
                            If docs = "" Then
                                docs += "TL_MTASchedule"
                            Else
                                docs += ",TL_MTASchedule"
                                docMgr.Documents = ""
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                            If docs = "" Then
                                docs = "PI_MTASchedule"
                            Else
                                docs += ",PI_MTASchedule"
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                            If docs = "" Then
                                docs = "GL_MTASchedule"
                            Else
                                docs += ",GL_MTASchedule"
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "EVENTLIAB " Then
                            If docs = "" Then
                                docs += "EV_MTASchedule"
                            Else
                                docs += ",EV_MTASchedule"
                                docMgr.Documents = ""
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "MEDMAL  " Then
                            If docs = "" Then
                                docs += "MM_MTASchedule"
                            Else
                                docs += ",MM_MTASchedule"
                                docMgr.Documents = ""
                            End If
                        End If
                        'Next
                    ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
                        'For nCount = 0 To oQuote.Risks.Count - 1
                        If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                            If docs = "" Then
                                docs = "DO_CANSchedule"
                            Else
                                docs += ",DO_CANSchedule"
                            End If

                            ' ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPAPA     " Then
                            ' If docs = "" Then
                            ' docs += "Cover Letter Cancellation"
                            ' Else
                            ' docs += ",Cover Letter Cancellation"
                            ' docMgr.Documents = ""
                            ' End If

                            ' ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPADOM    " Then
                            ' If docs = "" Then
                            ' docs += "Cover Letter Cancellation"
                            ' Else
                            ' docs += ",Cover Letter Cancellation"
                            ' docMgr.Documents = ""
                            ' End If

                            ' ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPAMOTOR  " Then
                            ' If docs = "" Then
                            ' docs += "Cover Letter Cancellation"
                            ' Else
                            ' docs += ",Cover Letter Cancellation"
                            ' docMgr.Documents = ""
                            ' End If

                            ' ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPAPCE    " Then
                            ' If docs = "" Then
                            ' docs += "Cover Letter Cancellation"
                            ' Else
                            ' docs += ",Cover Letter Cancellation"
                            ' docMgr.Documents = ""
                            ' End If

                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "TRSTLIAB  " Then
                            If docs = "" Then
                                docs = "TL_CANSchedule"
                            Else
                                docs += ",TL_CANSchedule"
                            End If

                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                            If docs = "" Then
                                docs = "PI_CANSchedule"
                            Else
                                docs += ",PI_CANSchedule"
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                            If docs = "" Then
                                docs = "GL_CANSchedule"
                            Else
                                docs += ",GL_CANSchedule"
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "EVENTLIAB " Then
                            If docs = "" Then
                                docs += "EV_CANSchedule"
                            Else
                                docs += ",EV_CANSchedule"
                                docMgr.Documents = ""
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "MEDMAL  " Then
                            If docs = "" Then
                                docs += "MM_CANSchedule"
                            Else
                                docs += ",MM_CANSchedule"
                                docMgr.Documents = ""
                            End If
                        End If

                        ' Next
                    ElseIf Session(CNRenewal) IsNot Nothing Or Session.Item("CNRenewal") IsNot Nothing Then
                        'For nCount = 0 To oQuote.Risks.Count - 1
                        If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                            If docs = "" Then
                                docs = "DO_RENSchedule"
                            Else
                                docs += ",DO_RENSchedule"
                            End If

                            ' ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPAPA     " Then
                            ' If docs = "" Then
                            ' docs += "Cover Letter Renewal"
                            ' Else
                            ' docs += ",Cover Letter Renewal"
                            ' docMgr.Documents = ""
                            ' End If

                            ' ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPADOM    " Then
                            ' If docs = "" Then
                            ' docs += "Cover Letter Renewal"
                            ' Else
                            ' docs += ",Cover Letter Renewal"
                            ' docMgr.Documents = ""
                            ' End If

                            ' ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPAMOTOR  " Then
                            ' If docs = "" Then
                            ' docs += "Cover Letter Renewal"
                            ' Else
                            ' docs += ",Cover Letter Renewal"
                            ' docMgr.Documents = ""
                            ' End If

                            ' ElseIf oQuote.Risks(nCount).RiskTypeCode = "NPAPCE    " Then
                            ' If docs = "" Then
                            ' docs += "Cover Letter Renewal"
                            ' Else
                            ' docs += ",Cover Letter Renewal"
                            ' docMgr.Documents = ""
                            ' End If

                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "TRSTLIAB  " Then
                            If docs = "" Then
                                docs = "TL_RENSchedule"
                            Else
                                docs += ",TL_RENSchedule"
                            End If

                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                            If docs = "" Then
                                docs = "PI_RENSchedule"
                            Else
                                docs += ",PI_RENSchedule"
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                            If docs = "" Then
                                docs = "GL_RENSchedule"
                            Else
                                docs += ",GL_RENSchedule"
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "MEDMAL  " Then
                            If docs = "" Then
                                docs += "MM_RENSchedule"
                            Else
                                docs += ",MM_RENSchedule"
                                docMgr.Documents = ""
                            End If
                        End If
                        ' Next
                    Else
                        'For nCount = 0 To oQuote.Risks.Count - 1
                        If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                            If docs = "" Then
                                docs = "DO_NBSchedule"
                            Else
                                docs += ",DO_NBSchedule"
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                            If docs = "" Then
                                docs = "PI_NBSchedule"
                            Else
                                docs += ",PI_NBSchedule"
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                            If docs = "" Then
                                docs = "GL_NBSchedule"
                            Else
                                docs += ",GL_NBSchedule"
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "TRSTLIAB  " Then
                            If docs = "" Then
                                docs = "TL_NBSchedule"
                            Else
                                docs += ",TL_NBSchedule"
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "EVENTLIAB " Then
                            If docs = "" Then
                                docs = "EV_NBSchedule"
                            Else
                                docs += ",EV_NBSchedule"
                            End If
                        ElseIf oQuote.Risks(nCount).RiskTypeCode = "MEDMAL  " Then
                            If docs = "" Then
                                docs = "MM_NBSchedule"
                            Else
                                docs += ",MM_NBSchedule"
                            End If
                        End If
                        'NextCover Letter Cancellation
                    End If

                Next
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