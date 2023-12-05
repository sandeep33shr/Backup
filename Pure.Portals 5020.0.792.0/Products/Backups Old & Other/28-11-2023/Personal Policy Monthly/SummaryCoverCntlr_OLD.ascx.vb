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
		
		'Validate risk data again - check for mandatory on issuance (risk linking)
		HandleMandatoryBind()		
    End Sub

    Sub DocumentsDisplay()

        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim nCount As Integer = 0
        Dim docs As String = ""

        'Other products - Not Specialist Liability
        If oQuote.ProductCode = "NPM" Then
            If Not Session(CNMode) = Mode.View Then
                'If Session(CNMode) = Mode.Add Or Session(CNMode) = Mode.Edit Or Session(CNMode) = Mode.View Then
                If Session(CNMTAType) = MTAType.TEMPORARY Or Session(CNMTAType) = MTAType.PERMANENT Then
                    '(oQuote.InsuranceFileTypeCode = "MTAQUOTE  ") Or (oQuote.InsuranceFileTypeCode = "MTAQTETEMP") Or (oQuote.InsuranceFileTypeCode = "MTA TEMP  ") Or (oQuote.InsuranceFileTypeCode = "MTA PERM  ") Then

                    If docs = "" Then
                        docs += "PL_MTASchedule,MTA Cover Letter"
                    Else
                        docs += ",PL_MTASchedule,MTA Cover Letter"
                        docMgr.Documents = ""
                    End If
					
					' If oQuote.GrossTotal > 1 Then
							' docs += ",Debit Note"
					' ElseIf oQuote.GrossTotal < 0
							' docs += ",Credit Note"
					' End If

                ElseIf Session(CNMTAType) = MTAType.REINSTATEMENT Then
                    '(oQuote.InsuranceFileTypeCode = "MTAQREINS ") Or (oQuote.InsuranceFileTypeCode = "MTAREINS  ") Then

                    If docs = "" Then
                        docs += "PL_REINSchedule"
                    Else
                        docs += ",PL_REINSchedule"
                        docMgr.Documents = ""
                    End If
                ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
                    If docs = "" Then
                        docs += "PL_CNSchedule,Cover Letter Cancellation"
                    Else
                        docs += ",PL_CNSchedule,Cover Letter Cancellation"
                        docMgr.Documents = ""
                    End If
                ElseIf Session(CNRenewal) IsNot Nothing OrElse Session.Item("CNRenewal") IsNot Nothing Then
                    'If (oQuote.InsuranceFileTypeCode = "RENEWAL") Then

                    If docs = "" Then
                        docs += "Cover Letter Renewal,PL_RNSchedule"
                    Else
                        docs += ",Cover Letter Renewal,PL_RNSchedule"
                        docMgr.Documents = ""
                    End If
                Else
                    If docs = "" Then
                        docs += "PL_QTSchedule,QT Cover Letter"
                    Else
                        docs += ",PL_QTSchedule,QT Cover Letter"
                        docMgr.Documents = ""
                    End If
                End If
            End If
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

                    ' If docs = "" Then
                        ' docs += "Credit Note,PL_REINSchedule"
                    ' Else
                        ' docs += ",Credit Note"
                        ' docMgr.Documents = ""
                    ' End If

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

    Protected Sub HandleMandatoryBind()
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
        Dim isContentFlag As Integer = 0
        Dim isBuildingFlag As Integer = 0
        Dim riskCode As String = String.Empty
        Dim iFailedValidationCount As Integer = 0
        Dim VehicleCode As Integer = 0
        Dim isUnsupported As Integer = 0
        Dim state As Boolean = False
        Dim isDomesticRisk As Boolean = False
		Dim riskState As String = String.Empty

        'Add header string
        WarningList.Items.Add(New ListItem("MANDATORY ON ISSUANCE: To purchase this policy, either Buildings or Contents cover under the Domestic Risk must be added"))


        For i As Integer = 0 To oQuote.Risks.Count - 1
            If Not oQuote.Risks(i).XMLDataset Is Nothing Then
                riskCode = Trim(oQuote.Risks(i).RiskTypeCode)
				riskState = Trim(oQuote.Risks(i).StatusCode)

                'Check if it is not Motor or Domestic before setting a flag 
                If Not (riskCode = "NPADOM" Or riskCode = "NPAMOTOR") Or (riskCode = "SDNASRIA") Then

                    'set the flag to false if there is no Domestic risk for the policy
                    If Not isDomesticRisk Then
                        state = False
                    End If

                ElseIf (riskCode = "NPADOM" And riskState <> "DELETED") Then
                    state = True
                    isDomesticRisk = True
                ElseIf (riskCode = "NPAMOTOR") Then
                    state = True

                End If

                If (riskCode = "NPADOM" And riskState <> "DELETED") Then
                    Integer.TryParse(GetDatafromXML("//GENERAL", "IS_CONTENTS", oQuote.Risks(i).XMLDataset), isContentFlag)
                    Integer.TryParse(GetDatafromXML("//GENERAL", "IS_BUILDINGS", oQuote.Risks(i).XMLDataset), isBuildingFlag)

                End If

                If riskCode = "NPAMOTOR" Then
                    Integer.TryParse(GetDatafromXML("//MOTOR", "VEHTYPECODE", oQuote.Risks(i).XMLDataset), VehicleCode)
                    Integer.TryParse(GetDatafromXML("//MOTOR", "UNSUPPORTED", oQuote.Risks(i).XMLDataset), isUnsupported)

                End If

                'This section condition is to check for the motor risk is selected and what cover it is 
                'Or if it is Domestic 
                If state = True Then
                    If ((VehicleCode = 106 And isUnsupported = 1) Or (isBuildingFlag = 1 Or isContentFlag = 1) Or (VehicleCode = 5)) Then
                        iFailedValidationCount = 0

                    Else
                        iFailedValidationCount += 1
                    End If
                Else
                    iFailedValidationCount += 1
                End If


            End If
        Next


        If Current.Session(CNMode) = Mode.View Then
            divWarning.Visible = False
            CType(CType(GetMasterPlaceHolder(Page, oNexusConfig.MainContainerName), ContentPlaceHolder).FindControl("btnBuy"), LinkButton).Visible = False
        Else
            If iFailedValidationCount > 0 Then
                divWarning.Visible = True
                CType(CType(GetMasterPlaceHolder(Page, oNexusConfig.MainContainerName), ContentPlaceHolder).FindControl("btnBuy"), LinkButton).Visible = False
                If Session(CNMTAType) = MTAType.CANCELLATION Then
                    Try
                        Dim multiRiskControl As UserControl = CType(CType(GetMasterPlaceHolder(Page, oNexusConfig.MainContainerName), ContentPlaceHolder).FindControl("MultiRisk1"), UserControl)
                        Dim btnQuoteAll As Button = CType(multiRiskControl.FindControl("btnQuoteAll"), Button)
                        btnQuoteAll.Enabled = False
                    Catch ex As System.Exception
                    End Try
                End If
            Else
                divWarning.Visible = False
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
End Class