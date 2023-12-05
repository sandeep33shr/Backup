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
Imports Nexus.DataSetFunctions

Partial Class PrivateCar_SummaryOfCover : Inherits System.Web.UI.UserControl

     Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)

        Dim oNexusFrameWork As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
      'When moving from Quote and Policies screen to Premium Display, Portal does not seem to correctly load the
		'XMLDataset for every risk - so force a load here
		Try
			Dim oQuote As NexusProvider.Quote = Session(CNQuote)
			If Session(CNMode) <> Mode.View AndAlso Session(CNMode) <> Mode.Review Then
				If oQuote IsNot Nothing AndAlso oQuote.Risks.Count > 1 Then
					Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
					For iRiskIndex = 0 To oQuote.Risks.Count - 1
						oWebService.GetRisk(oQuote.Risks(iRiskIndex).Key, iRiskIndex, oQuote)
					Next
				End If
			End If
		Catch ex As System.Exception

		End Try
		
        If Not Page.IsPostBack Then
            ' Conditionally attach documents
            DocumentsDisplay()
        End If
		
				
    End Sub

    Sub DocumentsDisplay()

        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim nCount As Integer = 0
        Dim docs As String = ""

        'Other products - Not Specialist Liability
        If oQuote.ProductCode = "NPA" Then
            'If Session(CNMode) = Mode.Add Or Session(CNMode) = Mode.Edit Or Session(CNMode) = Mode.View Then
            If Session(CNMTAType) = MTAType.TEMPORARY Or Session(CNMTAType) = MTAType.PERMANENT Then
                '(oQuote.InsuranceFileTypeCode = "MTAQUOTE  ") Or (oQuote.InsuranceFileTypeCode = "MTAQTETEMP") Or (oQuote.InsuranceFileTypeCode = "MTA TEMP  ") Or (oQuote.InsuranceFileTypeCode = "MTA PERM  ") Then

                If docs = "" Then
                    docs += "PL_MTASchedule,Tax Invoice,Cover Letter Tax Invoice,Credit Note,Debit Note"
                Else
                    docs += ",PL_MTASchedule,Tax Invoice,Cover Letter Tax Invoice,Credit Note, Debit Note"
                    docMgr.Documents = ""
                End If

            ElseIf Session(CNMTAType) = MTAType.REINSTATEMENT Then
                '(oQuote.InsuranceFileTypeCode = "MTAQREINS ") Or (oQuote.InsuranceFileTypeCode = "MTAREINS  ") Then

                If docs = "" Then
                    docs += "PL_REINSchedule"
                Else
                    docs += ",PL_REINSchedule"
                    docMgr.Documents = ""
                End If
			Else
				If docs = "" Then
					docs += "PL_QTSchedule"
				Else
					docs += ",PL_QTSchedule"
					docMgr.Documents = ""
				End If
            End If
            'End If
        End If

        If Not oQuote.ProductCode = "NPA" Then
            'Specialist Liability Product
            For nCount = 0 To oQuote.Risks.Count - 1

                If oQuote.InsuranceFileTypeCode = "QUOTE     " Then
                    If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                        If docs = "" Then
                            docs += "DO_Quotation"
                        Else
                            docs += ",DO_Quotation"
                            docMgr.Documents = ""
                        End If

                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                        If docs = "" Then
                            docs += "PI_Quotation"
                        Else
                            docs += ",PI_Quotation"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                        If docs = "" Then
                            docs += "GL_Quotation"
                        Else
                            docs += ",GL_Quotation"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                        If docs = "" Then
                            docs += "EI_Quotation"
                        Else
                            docs += ",EI_Quotation"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                        If docs = "" Then
                            docs += "EGIT_Quotation"
                        Else
                            docs += ",EGIT_Quotation"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "TRSTLIAB  " Then
                        If docs = "" Then
                            docs += "TL_Quotation"
                        Else
                            docs += ",TL_Quotation"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "EVENTLIAB " Then
                        If docs = "" Then
                            docs += "EV_Quotation"
                        Else
                            docs += ",EV_Quotation"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "MEDMAL    " Then
                        If docs = "" Then
                            docs += "MM_Quotation"
                        Else
                            docs += ",MM_Quotation"
                            docMgr.Documents = ""
                        End If
                    End If
                End If

                If oQuote.InsuranceFileTypeCode = "POLICY    " Then
                    If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                        If docs = "" Then
                            docs += "DO_NBSchedule"
                        Else
                            docs += ",DO_NBSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                        If docs = "" Then
                            docs += "PI_NBSchedule"
                        Else
                            docs += ",PI_NBSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                        If docs = "" Then
                            docs += "GL_NBSchedule"
                        Else
                            docs += ",GL_NBSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                        If docs = "" Then
                            docs += "EI_NBSchedule"
                        Else
                            docs += ",EI_NBSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "TRSTLIAB  " Then
                        If docs = "" Then
                            docs += "TL_NBSchedule"
                        Else
                            docs += ",TL_NBSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                        If docs = "" Then
                            docs += "EGIT_NBSchedule"
                        Else
                            docs += ",EGIT_NBSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "EVENTLIAB " Then
                        If docs = "" Then
                            docs += "EV_NBSchedule"
                        Else
                            docs += ",EV_NBSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "MEDMAL    " Then
                        If docs = "" Then
                            docs += "MM_NBSchedule"
                        Else
                            docs += ",MM_NBSchedule"
                            docMgr.Documents = ""
                        End If
                    End If
                End If
                If (oQuote.InsuranceFileTypeCode = "MTAQUOTE  ") Or (oQuote.InsuranceFileTypeCode = "MTAQTETEMP") Or (oQuote.InsuranceFileTypeCode = "MTAQREINS ") Then

                    If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                        If docs = "" Then
                            docs += "DO_MTASchedule"
                        Else
                            docs += ",DO_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "TRSTLIAB  " Then
                        If docs = "" Then
                            docs += "TL_MTASchedule"
                        Else
                            docs += ",TL_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                        If docs = "" Then
                            docs += "PI_MTASchedule"
                        Else
                            docs += ",PI_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                        If docs = "" Then
                            docs += "GL_MTASchedule"
                        Else
                            docs += ",GL_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                        If docs = "" Then
                            docs += "EI_MTAQSchedule"
                        Else
                            docs += ",EI_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                        If docs = "" Then
                            docs += "EGIT_MTASchedule"
                        Else
                            docs += ",EGIT_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "EVENTLIAB " Then
                        If docs = "" Then
                            docs += "EV_MTASchedule"
                        Else
                            docs += ",EV_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "MEDMAL    " Then
                        If docs = "" Then
                            docs += "MM_MTASchedule"
                        Else
                            docs += ",MM_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    End If
                End If
                If (oQuote.InsuranceFileTypeCode = "MTA PERM  ") Or (oQuote.InsuranceFileTypeCode = "MTA TEMP  ") Or (oQuote.InsuranceFileTypeCode = "MTAREINS  ") Then

                    If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                        If docs = "" Then
                            docs += "DO_MTASchedule"
                        Else
                            docs += ",DO_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                        If docs = "" Then
                            docs += "PI_MTASchedule"
                        Else
                            docs += ",PI_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                        If docs = "" Then
                            docs += "GL_MTASchedule"
                        Else
                            docs += ",GL_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "TRSTLIAB  " Then
                        If docs = "" Then
                            docs += "TL_MTASchedule"
                        Else
                            docs += ",TL_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                        If docs = "" Then
                            docs += "EI_MTASchedule"
                        Else
                            docs += ",EI_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                        If docs = "" Then
                            docs += "EGIT_MTASchedule"
                        Else
                            docs += ",EGIT_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "EVENTLIAB " Then
                        If docs = "" Then
                            docs += "EV_MTASchedule"
                        Else
                            docs += ",EV_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "MEDMAL    " Then
                        If docs = "" Then
                            docs += "MM_MTASchedule"
                        Else
                            docs += ",MM_MTASchedule"
                            docMgr.Documents = ""
                        End If
                    End If

                    If docs = "" Then
                        docs += "Credit Note,PL_REINSchedule"
                    Else
                        docs += ",Credit Note"
                        docMgr.Documents = ""
                    End If

                End If
                If (oQuote.InsuranceFileTypeCode = "MTAQCAN   ") Or (oQuote.InsuranceFileTypeCode = "MTACAN    ") Then
                    If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                        If docs = "" Then
                            docs += "DO_CANSchedule"
                        Else
                            docs += ",DO_CANSchedule"
                            docMgr.Documents = ""
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
                            docs += "TL_CANSchedule"
                        Else
                            docs += ",TL_CANSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                        If docs = "" Then
                            docs += "PI_CANSchedule"
                        Else
                            docs += ",PI_CANSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                        If docs = "" Then
                            docs += "GL_CANSchedule"
                        Else
                            docs += ",GL_CANSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                        If docs = "" Then
                            docs += "EI_CANSchedule"
                        Else
                            docs += ",EI_CANSchedule"
                            docMgr.Documents = ""
                        End If

                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "TRSTLIAB  " Then
                        If docs = "" Then
                            docs += "TL_CANSchedule"
                        Else
                            docs += ",TL_CANSchedule"
                            docMgr.Documents = ""
                        End If

                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                        If docs = "" Then
                            docs += "EGIT_CANSchedule"
                        Else
                            docs += ",EGIT_CANSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "EVENTLIAB " Then
                        If docs = "" Then
                            docs += "EV_CANSchedule"
                        Else
                            docs += ",EV_CANSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "MEDMAL    " Then
                        If docs = "" Then
                            docs += "MM_CANSchedule"
                        Else
                            docs += ",MM_CANSchedule"
                            docMgr.Documents = ""
                        End If
                    End If

                End If
                If oQuote.InsuranceFileTypeCode = "RENEWAL   " Then
                    If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                        If docs = "" Then
                            docs += "DO_RENSchedule"
                        Else
                            docs += ",DO_RENSchedule"
                            docMgr.Documents = ""
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
                            docs += "TL_RENSchedule"
                        Else
                            docs += ",TL_RENSchedule"
                            docMgr.Documents = ""
                        End If

                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                        If docs = "" Then
                            docs += "PI_RENSchedule"
                        Else
                            docs += ",PI_RENSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                        If docs = "" Then
                            docs += "GL_RENSchedule"
                        Else
                            docs += ",GL_RENSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                        If docs = "" Then
                            docs += "EI_RENSchedule"
                        Else
                            docs += ",EI_RENSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "EVENTLIAB " Then
                        If docs = "" Then
                            docs += "EV_RENSchedule"
                        Else
                            docs += ",EV_RENSchedule"
                            docMgr.Documents = ""
                        End If
                    ElseIf oQuote.Risks(nCount).RiskTypeCode = "MEDMAL    " Then
                        If docs = "" Then
                            docs += "MM_RENSchedule"
                        Else
                            docs += ",MM_RENSchedule"
                            docMgr.Documents = ""
                        End If
                        ' ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                        ' If docs = "" Then
                        ' docs += "EGIT_RENSchedule"
                        ' Else
                        ' docs += ",EGIT_Quotation"
                        ' docMgr.Documents = ""
                        ' End If
                    End If
                End If
            Next
        End If

        docMgr.Documents = docs.ToString()

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
End Class