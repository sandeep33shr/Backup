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

Partial Class MultiMark_SummaryOfCover : Inherits System.Web.UI.UserControl

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
		'HandleMandatoryBind()	

		UpdateNariaRefreshFlag()		
    End Sub

    Sub DocumentsDisplay()

        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim nCount As Integer = 0
        Dim docs As String = ""

        'Other products - Not Specialist Liability
        If oQuote.ProductCode = "CMA" Then           
			'If Session(CNMTAType) = MTAType.TEMPORARY Or Session(CNMTAType) = MTAType.PERMANENT Then
			If (oQuote.InsuranceFileTypeCode = "MTAQUOTE  ") OR (oQuote.InsuranceFileTypeCode = "MTAQTETEMP") OR (oQuote.InsuranceFileTypeCode = "MTA TEMP  ") OR (oQuote.InsuranceFileTypeCode = "MTA PERM  ") Then
				If Session(CNMode) = Mode.Add Or Session(CNMode) = Mode.Edit Then
					If CheckUnderwritingRIColumn("Type") Then
						docs += "MM MTA Quote Schedule,MTA Cover Letter"
					Else
						docs += "MM MTA Quote Schedule,MTA Cover Letter"
					End If
				ElseIf Session(CNMode) = Mode.View Then
					If CheckUnderwritingRIColumn("Type") Then
						docs += "MM MTA Schedule,MTA Cover Letter"
					Else
						docs += "MM MTA Schedule,MTA Cover Letter"
					End If
				End If
				
				If oQuote.GrossTotal > 0 Then
					docs += ",Debit Note"
				Else
					docs += ",Credit Note"
				End If
				
			'ElseIf Session(CNMTAType) = MTAType.REINSTATEMENT OR 
			ElseIf (oQuote.InsuranceFileTypeCode = "MTAQREINS ") OR (oQuote.InsuranceFileTypeCode = "MTAREINS  ") Then
				If Session(CNMode) = Mode.Add Or Session(CNMode) = Mode.Edit Then
					If CheckUnderwritingRIColumn("Type") Then
						docs += "MM Reinstatement Quote"
					Else
						docs += "MM Reinstatement Quote"
					End If
				ElseIf Session(CNMode) = Mode.View Then
					If CheckUnderwritingRIColumn("Type") Then
						docs += "MM Reinstatement"
					Else
						docs += "MM Reinstatement"
					End If
				End If
				
			'ElseIf Session(CNRenewal) IsNot Nothing OrElse Session.Item("CNRenewal") IsNot Nothing Then
			ElseIf (oQuote.InsuranceFileTypeCode = "RENEWAL   ") Then
				If Session(CNMode) = Mode.Add Or Session(CNMode) = Mode.Edit Then
					If CheckUnderwritingRIColumn("Type") Then
						docs += "MM Renewal Invite,Cover Letter Renewal"
					Else
						docs += "MM Renewal Invite,Cover Letter Renewal"
					End If
				ElseIf Session(CNMode) = Mode.View Then
					If CheckUnderwritingRIColumn("Type") Then
						docs += "MM Renewal,Cover Letter Renewal"
					Else
						docs += "MM Renewal,Cover Letter Renewal"
					End If
				End If
				
			'ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
			ElseIf (oQuote.InsuranceFileTypeCode = "MTAQCAN   ") OR (oQuote.InsuranceFileTypeCode = "MTACAN    ") Then
				If CheckUnderwritingRIColumn("Type") Then
					docs += "MM Cancellation,Cover Letter Cancellation"
				Else
					docs += "MM Cancellation,Cover Letter Cancellation"
				End If
				
			Else
				If Session(CNMode) = Mode.View Then
					If oQuote.Regarding.Trim() = "Renewals" Or
					   oQuote.IsPolicyInRenewal Or
					  (oQuote.InsuranceFileTypeCode.Trim() = "POLICY" And oQuote.InsuranceFileVersion > 1 And oQuote.RenewalCount > 0) Then
						docs += "MM Renewal,Cover Letter Renewal"
					Else
						docs += "MM New Business,NB Cover Letter"
					End If
				Else
					docs += "MM Quotation,QT Cover Letter"
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
		Dim isNotMotorOrDomestic As Integer = 0
        Dim DomesticCount As Integer = 0
		
        'Add header string
        WarningList.Items.Add(New ListItem("MANDATORY ON ISSUANCE: To purchase this policy, either Buildings or Contents cover under the Domestic Risk must be added"))


        For i As Integer = 0 To oQuote.Risks.Count - 1
            If Not oQuote.Risks(i).XMLDataset Is Nothing Then
                riskCode = Trim(oQuote.Risks(i).RiskTypeCode)
				riskState = Trim(oQuote.Risks(i).StatusCode)
				
                'Check if it is not Motor or Domestic before setting a flag 
                If Not ((riskCode = "NPADOM" Or riskCode = "NPAMOTOR") Or (riskCode = "SDNASRIA")) And (riskState <> "DELETED") Then

                    'Count Risks that are not Motor/SDNASRIA/Domestic
					If riskCode <> "SDNASRIA" Then
                        isNotMotorOrDomestic += 1
                    End If
                    'set the flag to false if there is no Domestic risk for the policy
                    If Not isDomesticRisk Then
                        state = False
                    End If


                ElseIf ((riskCode = "NPADOM" And riskState <> "DELETED")) Then
                    state = True
                    isDomesticRisk = True
                ElseIf (riskCode = "NPAMOTOR" And riskState <> "DELETED") Then
                    state = True

                End If

                If (riskCode = "NPADOM" And riskState <> "DELETED") Then
                    Integer.TryParse(GetDatafromXML("//GENERAL", "IS_CONTENTS", oQuote.Risks(i).XMLDataset), isContentFlag)
                    Integer.TryParse(GetDatafromXML("//GENERAL", "IS_BUILDINGS", oQuote.Risks(i).XMLDataset), isBuildingFlag)
					DomesticCount += 1
                End If

                If (riskCode = "NPAMOTOR" And riskState <> "DELETED") Then
                    Integer.TryParse(GetDatafromXML("//MOTOR", "VEHTYPECODE", oQuote.Risks(i).XMLDataset), VehicleCode)
                    Integer.TryParse(GetDatafromXML("//MOTOR", "UNSUPPORTED", oQuote.Risks(i).XMLDataset), isUnsupported)
					
					If (VehicleCode <> 106 And VehicleCode <> 5) Or (VehicleCode = 106 And isUnsupported = 0) Then
                        isNotMotorOrDomestic += 1
                    End If
                End If

                'This section condition is to check for the motor risk is selected and what cover it is 
                'Or if it is Domestic 
                If state = True Then
                    'If ((VehicleCode = 106 And isUnsupported = 1) Or (isBuildingFlag = 1 Or isContentFlag = 1) Or (VehicleCode = 5)) Then
					If (((VehicleCode = 106 And isUnsupported = 1) Or (VehicleCode = 5)) And isNotMotorOrDomestic = 0) Or (DomesticCount > 0) Then
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
	
	Private Sub UpdateNariaRefreshFlag()
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim iRiskNo As Integer
        For iRiskNo = 0 To oQuote.Risks.Count() - 1
            If oQuote.Risks(iRiskNo).StatusCode <> "Quoted" Then
                Session("Refresh") = "1"
            End If
        Next
    End Sub
End Class