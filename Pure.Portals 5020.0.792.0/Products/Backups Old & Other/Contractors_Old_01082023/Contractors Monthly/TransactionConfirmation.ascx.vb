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

            For nCount = 0 To oQuote.Risks.Count - 1
                If Session(CNMTAType) = MTAType.PERMANENT Or Session(CNMTAType) = MTAType.TEMPORARY Then
                    'For nCount = 0 To oQuote.Risks.Count - 1
                    If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                        If docs = "" Then
                            docs = "DO_MTASchedule"
                        Else
                            docs += ",DO_MTASchedule"
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
                    End If
                    'Next
                End If
            Next
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