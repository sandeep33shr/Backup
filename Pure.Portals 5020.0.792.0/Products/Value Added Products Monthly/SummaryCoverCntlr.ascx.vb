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
		
		UpdateNariaRefreshFlag()
    End Sub

    Sub DocumentsDisplay()

        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim nCount As Integer = 0
        Dim docs As String = ""

        'Other products - Not Specialist Liability
        If oQuote.ProductCode = "PVM" Then
            'If Session(CNMode) = Mode.Add Or Session(CNMode) = Mode.Edit Or Session(CNMode) = Mode.View Then
            'If Session(CNMTAType) = MTAType.TEMPORARY Or Session(CNMTAType) = MTAType.PERMANENT Then
            If (oQuote.InsuranceFileTypeCode = "MTAQUOTE  ") OR (oQuote.InsuranceFileTypeCode = "MTAQTETEMP") OR (oQuote.InsuranceFileTypeCode = "MTA TEMP  ") OR (oQuote.InsuranceFileTypeCode = "MTA PERM  ") Then
                If docs = "" Then
                    docs += "VAPS_MTA,MTA Cover Letter"
                Else
                    docs += ",VAPS_MTA,MTA Cover Letter"
                    docMgr.Documents = ""
                End If
            'ElseIf Session(CNRenewal) IsNot Nothing OrElse Session.Item("CNRenewal") IsNot Nothing Then
            ElseIf (oQuote.InsuranceFileTypeCode = "RENEWAL   ") Then
                If docs = "" Then
                    docs += "VAPS_RN,Cover Letter Renewal"
                Else
                    docs += ",VAPS_RN,Cover Letter Renewal"
                    docMgr.Documents = ""
                End If
            'ElseIf Session(CNMTAType) = MTAType.REINSTATEMENT Then
            ElseIf (oQuote.InsuranceFileTypeCode = "MTAQREINS ") OR (oQuote.InsuranceFileTypeCode = "MTAREINS  ") Then
                If docs = "" Then
                    docs += "VAPS Reinstatement"
                Else
                    docs += "VAPS Reinstatement"
                    docMgr.Documents = ""
                End If
			'ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
            ElseIf (oQuote.InsuranceFileTypeCode = "MTAQCAN   ") OR (oQuote.InsuranceFileTypeCode = "MTACAN    ") Then
                If docs = "" Then
                    docs += "Cover Letter Cancellation,VAPS Cancellation"
                Else
                    docs += ",Cover Letter Cancellation,VAPS Cancellation"
                    docMgr.Documents = ""
                End If
            Else
				If Session(CNMode) = Mode.View Then
					If oQuote.Regarding.Trim() = "Renewals" Or
					   oQuote.IsPolicyInRenewal Or
					   (oQuote.InsuranceFileTypeCode.Trim() = "POLICY" And oQuote.InsuranceFileVersion > 1 And oQuote.RenewalCount > 0) Then
						docs += "VAPS_RN,Cover Letter Renewal"
					Else
						docs += ",VAPSNB,NB Cover Letter"
						docMgr.Documents = ""
					End If
				Else
					If docs = "" Then
						docs += "VAPSQuote,QT Cover Letter"
					Else
						docs += ",VAPSQuote,QT Cover Letter"
						docMgr.Documents = ""
					End If
				End If	
            End If
            
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