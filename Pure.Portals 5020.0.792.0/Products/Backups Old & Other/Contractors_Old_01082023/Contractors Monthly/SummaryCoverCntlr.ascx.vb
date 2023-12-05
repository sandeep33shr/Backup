﻿Imports Nexus.Constants.Constant
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
        'If Not Page.IsPostBack Then

        '    ' Conditionally attach documents
        DocumentsDisplay()

        'End If
    End Sub

    Sub DocumentsDisplay()
        
		Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim nCount As Integer = 0
        Dim docs As String = ""
        For nCount = 0 To oQuote.Risks.Count - 1

            If oQuote.InsuranceFileTypeCode = "QUOTE     " Then
                If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                    'If docs = "" Then
                    docs += "DO_Quotation"
                    'Else
                    'docs += ",DO_Quotation"
                    ' docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                    'If docs = "" Then
                    docs += "PI_Quotation"
                    'Else
                    'docs += ",PI_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                    'If docs = "" Then
                    docs += "GL_Quotation"
                    ' Else
                    'docs += ",GL_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                    'If docs = "" Then
                    docs += "EI_Quotation"
                    'Else
                    'docs += ",EI_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                    'If docs = "" Then
                    docs += "EGIT_Quotation"
                    'Else
                    'docs += ",EGIT_Quotation"
                    'docMgr.Documents = ""
                    'End If
                End If
            End If
            If oQuote.InsuranceFileTypeCode = "POLICY    " Then
                If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                    'If docs = "" Then
                        docs += "DO_NBSchedule"
                    'Else
                        'docs += ",DO_NBSchedule"
                        ' docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                    'If docs = "" Then
                        docs += "PI_NBSchedule"
                    'Else
                        'docs += ",PI_NBSchedule"
                        'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                    'If docs = "" Then
                        docs += "GL_NBSchedule"
                    'Else
                        'docs += ",GL_NBSchedule"
                        'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                    'If docs = "" Then
                        docs += "EI_NBSchedule"
                    'Else
                        'docs += ",EI_NBSchedule"
                        'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                    'If docs = "" Then
                        docs += "EGIT_NBSchedule"
                    'Else
                        'docs += ",EGIT_NBSchedule"
                        'docMgr.Documents = ""
                    'End If
                End If
            End If
            If (oQuote.InsuranceFileTypeCode = "MTAQUOTE  ") Or (oQuote.InsuranceFileTypeCode = "MTAQTETEMP") Or (oQuote.InsuranceFileTypeCode = "MTAQREINS ") Then
                If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                    'If docs = "" Then
                    docs += "DO_MTASchedule"
                    'Else
                    'docs += ",DO_Quotation"
                    ' docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                    'If docs = "" Then
                    docs += "PI_MTASchedule"
                    'Else
                    'docs += ",PI_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                    'If docs = "" Then
                    docs += "GL_MTASchedule"
                    ' Else
                    'docs += ",GL_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                    'If docs = "" Then
                    docs += "EI_MTAQSchedule"
                    'Else
                    'docs += ",EI_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                    'If docs = "" Then
                    docs += "EGIT_MTASchedule"
                    'Else
                    'docs += ",EGIT_Quotation"
                    'docMgr.Documents = ""
                    'End If
                End If
            End If
            If (oQuote.InsuranceFileTypeCode = "MTA PERM  ") Or (oQuote.InsuranceFileTypeCode = "MTA TEMP  ") Or (oQuote.InsuranceFileTypeCode = "MTAREINS  ") Then
                If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                    'If docs = "" Then
                    docs += "DO_MTASchedule"
                    'Else
                    'docs += ",DO_Quotation"
                    ' docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                    'If docs = "" Then
                    docs += "PI_MTASchedule"
                    'Else
                    'docs += ",PI_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                    'If docs = "" Then
                    docs += "GL_MTASchedule"
                    ' Else
                    'docs += ",GL_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                    'If docs = "" Then
                    docs += "EI_MTASchedule"
                    'Else
                    'docs += ",EI_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                    'If docs = "" Then
                    docs += "EGIT_MTASchedule"
                    'Else
                    'docs += ",EGIT_Quotation"
                    'docMgr.Documents = ""
                    'End If
                End If
            End If
            If (oQuote.InsuranceFileTypeCode = "MTAQCAN   ") Or (oQuote.InsuranceFileTypeCode = "MTACAN    ") Then
                If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                    'If docs = "" Then
                    docs += "DO_CANSchedule"
                    'Else
                    'docs += ",DO_Quotation"
                    ' docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                    'If docs = "" Then
                    docs += "PI_CANSchedule"
                    'Else
                    'docs += ",PI_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                    'If docs = "" Then
                    docs += "GL_CANSchedule"
                    ' Else
                    'docs += ",GL_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                    'If docs = "" Then
                    docs += "EI_CANSchedule"
                    'Else
                    'docs += ",EI_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                    'If docs = "" Then
                    docs += "EGIT_CANSchedule"
                    'Else
                    'docs += ",EGIT_Quotation"
                    'docMgr.Documents = ""
                    'End If
                End If
            End If
            If oQuote.InsuranceFileTypeCode = "RENEWAL   " Then
                If oQuote.Risks(nCount).RiskTypeCode = "DNOLIAB   " Then
                    'If docs = "" Then
                    docs += "DO_RENSchedule"
                    'Else
                    'docs += ",DO_Quotation"
                    ' docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "NCPIND    " Then
                    'If docs = "" Then
                    docs += "PI_RENSchedule"
                    'Else
                    'docs += ",PI_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "GENLIAB   " Then
                    'If docs = "" Then
                    docs += "GL_RENSchedule"
                    ' Else
                    'docs += ",GL_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVSTSS   " Then
                    'If docs = "" Then
                    docs += "EI_RENSchedule"
                    'Else
                    'docs += ",EI_Quotation"
                    'docMgr.Documents = ""
                    'End If
                ElseIf oQuote.Risks(nCount).RiskTypeCode = "ENVGIT    " Then
                    'If docs = "" Then
                    docs += "EGIT_RENSchedule"
                    'Else
                    'docs += ",EGIT_Quotation"
                    'docMgr.Documents = ""
                    'End If
                End If
            End If
            docMgr.Documents = docs.ToString()
			Next

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