Imports System.Web.Configuration.WebConfigurationManager
Imports Nexus
Imports Nexus.Constants
Imports Nexus.Constants.Session
Imports CMS.Library
Imports Nexus.Library
Imports System.IO
Imports System.Net
Imports System.Linq
Imports SPM
Imports System.Xml

Namespace Nexus

    Partial Class Framework_Complete
        Inherits CMS.Library.Frontend.clsCMSPage

#Region " Page Events "

        Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init

            ' Load the claimcomplete control on page init otherwise view state for Document manager will not get maintained
            Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
            Dim oPortal As Nexus.Library.Config.Portal = oNexusConfig.Portals.Portal(Portal.GetPortalID())
            Dim WebControlPath As String
            Dim sFolder As String = "~/Claims/ClientPages/" & oPortal.Claims.ScreenLocation
            WebControlPath = sFolder & "/claimcomplete.ascx"
            If (System.IO.File.Exists(Request.MapPath(WebControlPath))) Then
                Dim tempControl As Control = LoadControl(WebControlPath)
                TransactionConfirmation.Controls.Clear()
                TransactionConfirmation.Controls.Add(tempControl)
            End If

        End Sub
        ''' <summary>
        ''' This event is fired on page load
        ''' </summary>
        ''' <param name="sender"></param>
        ''' <param name="e"></param>
        ''' <remarks></remarks>
        Protected Shadows Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            'Check the link of case with claim
            Dim oOpenClaim As NexusProvider.ClaimOpen = Session(CNClaim)
            DocumentsDisplay()

            'Section added to cater for SPM Integration 
            Dim srDataset As New System.IO.StringReader(Session(CNDataSet))
            Dim xmlTR As New XmlTextReader(srDataset)
            Dim xmlDoc As New XmlDocument
            Dim claimPeril As NexusProvider.PerilSummary = New NexusProvider.PerilSummary
            Dim BasePerilKey As Int32
            Dim xmlTagName As String = String.Empty
            Dim token As String = String.Empty
            Dim isSPM As Boolean
            xmlDoc.Load(xmlTR)
            xmlTR.Close()


            Dim oNodelist As XmlNodeList

            For Each item As NexusProvider.PerilSummary In oOpenClaim.ClaimPeril
                BasePerilKey = item.BaseClaimPerilKey
                xmlTagName = GetListValue("UDL_PURECLM", item.TypeCode, "claim_object")
            Next

            oNodelist = xmlDoc.GetElementsByTagName(xmlTagName)

            If oNodelist.Count > 0 Then
                For Each Node As XmlNode In oNodelist
                    If Node IsNot Nothing Then
                        If Node.Attributes("IS_SPM") IsNot Nothing Then
                            isSPM = CBool(Node.Attributes("IS_SPM").Value)
                        End If
                    End If


                Next


            End If

            'isSPM = CBool((From Node As XmlNode In oNodelist Select Node.Attributes("IS_SPM").InnerText).FirstOrDefault())
            If isSPM = True Then
                token = RequestToken("June Nikles")
                If Trim(oOpenClaim.RiskType) = "NPAMOTOR" Then
                    CreateMotorClaim(xmlTagName)
                Else
                    CreateNonMotorClaim()
                End If

            End If

            For Each item As NexusProvider.PerilSummary In oOpenClaim.ClaimPeril
                BasePerilKey = item.BaseClaimPerilKey
            Next
            '---------------------------------------------

            If Session(CNMode) <> Mode.ViewClaim Then
                If oOpenClaim IsNot Nothing AndAlso oOpenClaim.BaseCaseKey > 0 Then
                    btnReturnToCase.Visible = True
                    If Session(CNCaseKey) IsNot Nothing Then
                        btnReturnToCase.PostBackUrl = "~/Claims/ClaimCase.aspx?CaseKey=" & Session(CNCaseKey).ToString()
                    Else
                        btnReturnToCase.PostBackUrl = "~/Claims/ClaimCase.aspx?BaseCaseKey=" & oOpenClaim.BaseCaseKey
                    End If
                End If
            End If

            If Session.Item(CNClaimNumber) IsNot Nothing Then
                hypClaimNumber.Text = Trim(Session.Item(CNClaimNumber))
                hypClaimNumber.PostBackUrl = "~/Claims/FindClaim.aspx?Claimno=" & Trim(Session.Item(CNClaimNumber))

                'Section added to check if SPM Codeplex is needed or not
                If isSPM = True Then
                    hypCodeplex.Text = Trim(Session.Item(CNClaimNumber))
                    hypCodeplex.PostBackUrl = "https://codeplex.driveable.com.na/SPMUAT/Login.aspx?sMode=edit&sClaimNo=" & Trim(Session.Item(CNClaimNumber)) & "_" & BasePerilKey & "&sSessionToken=" & token & "&sUser =" & Trim("June Nikles")
                End If
                If Session.Item(CNMode) = Mode.NewClaim Then
                    ltrlThankyouRegister.Visible = True

                    'Statement added for Codeplex
                    If isSPM = True Then
                        ltrlCodeplexNew.Visible = True
                    End If

                ElseIf Session.Item(CNMode) = Mode.EditClaim Then
                        If Session(CNClaimStatus) IsNot Nothing Then
                            'If claim is "CLOSED"
                            If Session(CNClaimStatus).ToString.Trim.ToUpper = "CLOSED" Then
                                ltrlCloseClaim.Visible = True
                                Session(CNClaimStatus) = Nothing
                            Else
                                ltrlThankyouUpdate.Visible = True
                                ltrlCodeplexEdit.Visible = True
                            End If
                        Else
                            ltrlThankyouUpdate.Visible = True
                            ltrlCodeplexEdit.Visible = True
                        End If
                    ElseIf Session.Item(CNMode) = Mode.PayClaim Or Session.Item(CNMode) = Mode.SalvageClaim Or Session.Item(CNMode) = Mode.TPRecovery Then
                        'If claim is "Authorize Payment"
                        If Session(CNStatus) IsNot Nothing And Session(CNAuthorizeStatus) = "Authorize Payment" Then
                            ltrlAuthorizeClaimPayment.Visible = True
                        Else
                            ltrlThankyouUpdate.Visible = True
                        End If
                    End If
                End If
                'Updation of Progress Bar status
                ucProgressBar.OverviewStyle = "complete"
            ucProgressBar.ReinsuranceStyle = "complete"
            ucProgressBar.PerilsStyle = "complete"
            ucProgressBar.SummaryStyle = "complete"
            ucProgressBar.CompleteStyle = "in-progress"

        End Sub

        Private Sub DocumentsDisplay()
            Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
            Dim oClaimQuote As NexusProvider.Quote = Session(CNClaimQuote)

            If Session(CNMode) = Mode.NewClaim Or Session.Item(CNMode) = Mode.NewClaim Then
                docMgr.Documents = "Treaty RI Notification,Payment Confirmation Letter,Acknowledgement of Debt,TP Letter of Demand"
            End If
            If Session(CNMode) = Mode.EditClaim Or Session.Item(CNMode) = Mode.EditClaim Then
                docMgr.Documents = "Treaty RI Notification,Payment Confirmation Letter,Acknowledgement of Debt,TP Letter of Demand"
            End If
            If Session(CNMode) = Mode.ViewClaim Or Session.Item(CNMode) = Mode.ViewClaim Then
                docMgr.Documents = "Treaty RI Notification,Payment Confirmation Letter,Acknowledgement of Debt,TP Letter of Demand"
            End If
        End Sub

        'This method is used to get the token from SPM GetSessionToken web method 
        Private Function RequestToken(ByVal username As String) As String
            Dim Token As String = String.Empty
            Dim SoapStr As String = String.Empty
            Dim soapAction As String = "http://tempuri.org/IWCFService/PASGetSessionToken"
            Dim TagElement As String = "sSessionToken"

            SoapStr = "<?xml version=""1.0"" encoding=""utf-8""?>"
            SoapStr = SoapStr & "<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:tem=""http://tempuri.org/"">"
            SoapStr = SoapStr & "<soapenv:Header/>"
            SoapStr = SoapStr & "<soapenv:Body>"
            SoapStr = SoapStr & "<tem:SPMPASSessionTokenRequest>"
            SoapStr = SoapStr & "<tem:sPASystem>HNAMPURE</tem:sPASystem>"
            SoapStr = SoapStr & "<tem:sPassword>HNAM@PURE</tem:sPassword>"
            SoapStr = SoapStr & "<tem:sUserId></tem:sUserId>"
            SoapStr = SoapStr & "</tem:SPMPASSessionTokenRequest>"
            SoapStr = SoapStr & "</soapenv:Body>"
            SoapStr = SoapStr & "</soapenv:Envelope>"

            Token = PostWebservice(soapAction, SoapStr, TagElement)

            Return Token
        End Function

        'This is the function used to call SPM Webservices in order to create a new claim on the SPM system
        Private Function CreateMotorClaim(ByVal tagName As String) As String
            Dim claimNumber As String = String.Empty
            Dim SoapStr As String = String.Empty
            Dim soapAction As String = "http://tempuri.org/IWCFService/PASAddClaim"
            Dim TagElement As String = "iClaimID"
            Dim oOpenClaim As NexusProvider.ClaimOpen = Session(CNClaim)
            Dim oClaimQuote As NexusProvider.Quote = CType(Session(CNClaimQuote), NexusProvider.Quote)
            Dim srDataset As New System.IO.StringReader(Session(CNDataSet))
            Dim xmlTR As New XmlTextReader(srDataset)
            Dim xmlDoc As New XmlDocument
            Dim PerilID As String = String.Empty
            Dim SPM_CoverType As String = String.Empty
            Dim CoverType As String = String.Empty
            Dim BasePerilKey As Int32
            Dim PerilCode As String = String.Empty
            Dim SumInsured As Decimal = 0.0
            Dim ReserveAmount As Decimal = 0.0
            Dim oNodelist As XmlNodeList = xmlDoc.GetElementsByTagName(tagName)



            xmlDoc.Load(xmlTR)
            xmlTR.Close()


            For Each item As NexusProvider.PerilSummary In oOpenClaim.ClaimPeril
                BasePerilKey = item.BaseClaimPerilKey
                PerilCode = item.TypeCode
                SumInsured = item.SumInsured
                ReserveAmount = (From u In item.Reserve Where u.TypeCode = "Indemnity" Select u.InitialReserve).FirstOrDefault()
            Next

            PerilID = GetListValue("UDL_PURESPM", PerilCode, "claimtypeid")
            SPM_CoverType = GetListValue("UDL_PURESPM", PerilCode, "spm_description")

            If oNodelist.Count > 0 Then
                Dim isAlcoholTest As String = String.Empty
                Dim DriverName As String = String.Empty
                Dim Make As String = String.Empty
                Dim Model As String = String.Empty
                Dim YearMan As String = String.Empty
                Dim Vin_NO As String = String.Empty
                Dim REG_NO As String = String.Empty
                Dim BrokerName As String = String.Empty

                If Trim(oClaimQuote.AgentCode) IsNot Nothing Then

                    BrokerName = Trim(oClaimQuote.AgentDesc)
                Else
                    BrokerName = Trim(oClaimQuote.InsuredName)

                End If


                For Each Node As XmlNode In oNodelist
                    If Node IsNot Nothing Then

                        If Node.Attributes("ALCOHOL") IsNot Nothing Then
                            Dim ratelistValue As String = String.Empty
                            ratelistValue = GetListItemDescfromCode("UserDefined", "YESNONA", Node.Attributes("ALCOHOL").Value)

                            If ratelistValue = "Yes" Then
                                isAlcoholTest = "Y"
                            Else
                                isAlcoholTest = "N"
                            End If


                        End If

                        If Node.Attributes("MAIN_DRIVER") IsNot Nothing Then
                            DriverName = Node.Attributes("MAIN_DRIVER").Value
                        End If

                        If Node.Attributes("MAKEMODEL") IsNot Nothing Then
                            Model = Node.Attributes("MAKEMODEL").Value
                        End If

                        If Node.Attributes("MAKE") IsNot Nothing Then
                            Make = Node.Attributes("MAKE").Value
                        Else
                            Make = Model
                        End If

                        If Node.Attributes("MAN_YEAR") IsNot Nothing Then
                            YearMan = Node.Attributes("MAN_YEAR").Value
                        End If

                        If Node.Attributes("VIN_NO") IsNot Nothing Then
                            Vin_NO = Node.Attributes("VIN_NO").Value
                        End If

                        If Node.Attributes("REG_NO") IsNot Nothing Then
                            REG_NO = Node.Attributes("REG_NO").Value
                        End If

                        If Node.Attributes("COVERTYPE") IsNot Nothing Then
                            CoverType = GetListItemDescfromCode("UserDefined", "MVCOVER", Node.Attributes("COVERTYPE").Value)
                        End If

                    End If



                Next
                'CoverType = GetListItemDescfromCode("UserDefined", "MVCOVER", ((From Node As XmlNode In oNodelist Select Node.Attributes("COVERTYPE").InnerText.Trim()).FirstOrDefault()))

                SoapStr = "<?xml version=""1.0"" encoding=""utf-8""?>"
                SoapStr = SoapStr & "<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:tem=""http://tempuri.org/"">"
                SoapStr = SoapStr & "<soapenv:Header/>"
                SoapStr = SoapStr & "<soapenv:Body>"
                SoapStr = SoapStr & "<tem:SPMPASAddClaimRequest>"
                SoapStr = SoapStr & "<tem:Password>HNAM@PURE</tem:Password>"
                SoapStr = SoapStr & "<tem:iClaimTypeID>" & SPM_CoverType & "</tem:iClaimTypeID>"
                SoapStr = SoapStr & "<tem:sClaimNo>" & Trim(oOpenClaim.ClaimNumber) & "</tem:sClaimNo>"
                SoapStr = SoapStr & "<tem:sPASystem>HNAMPURE</tem:sPASystem>"
                SoapStr = SoapStr & "<tem:sXmlClaim><![CDATA["
                SoapStr = SoapStr & "<xml>"
                SoapStr = SoapStr & "<Claim>"
                SoapStr = SoapStr & "<ClaimSpecialist>" & GetListValue("handler", Trim(oOpenClaim.HandlerCode), "description") & "</ClaimSpecialist>"
                SoapStr = SoapStr & "<PolicyNumber>" & Trim(oClaimQuote.InsuranceFileRef) & "</PolicyNumber>"
                SoapStr = SoapStr & "<PerilTypeID>" & BasePerilKey & "</PerilTypeID>"
                SoapStr = SoapStr & "<PerilID>" & PerilID & "</PerilID>"
                SoapStr = SoapStr & "<PureReserveTypeID>2</PureReserveTypeID>"
                SoapStr = SoapStr & "<Cover>" & CoverType & "</Cover>"
                SoapStr = SoapStr & "<IntClaimRefNo>" & Trim(oOpenClaim.ClaimNumber) & "</IntClaimRefNo>"
                SoapStr = SoapStr & "<InsuredName>" & Trim(oClaimQuote.InsuredName) & "</InsuredName>"
                SoapStr = SoapStr & "<InsHomeTel>" & Trim(oOpenClaim.ClientTelNo) & "</InsHomeTel>"
                SoapStr = SoapStr & "<InsWorkTel>" & Trim(oOpenClaim.ClientMobileNo) & "</InsWorkTel>"
                SoapStr = SoapStr & "<IncidentDT>" & Trim(oOpenClaim.LossToDate) & "</IncidentDT>"
                SoapStr = SoapStr & "<DateCaptured>" & Trim(oOpenClaim.ReportedDate) & "</DateCaptured>"
                SoapStr = SoapStr & "<BrokerName>" & BrokerName & "</BrokerName>"
                SoapStr = SoapStr & "<BrokerConsultant></BrokerConsultant>"
                SoapStr = SoapStr & "<BrokerCode>" & Trim(oClaimQuote.AgentCode) & "</BrokerCode>"
                SoapStr = SoapStr & "<RiskNumber>" & Trim(oOpenClaim.RiskKey) & "</RiskNumber>"
                SoapStr = SoapStr & "<Value>" & SumInsured & "</Value>"
                SoapStr = SoapStr & "<Estimate>" & ReserveAmount & "</Estimate>"
                SoapStr = SoapStr & "<PureReserveTypeID>2</PureReserveTypeID>"
                SoapStr = SoapStr & "<Excess></Excess>"
                SoapStr = SoapStr & "<DriverName>" & DriverName & "</DriverName>"
                SoapStr = SoapStr & "<AccidentDescription>" & Trim(oOpenClaim.Description) & "</AccidentDescription>"
                SoapStr = SoapStr & "<VehicleLocation>" & Trim(oOpenClaim.Location) & "</VehicleLocation>"
                SoapStr = SoapStr & "<Make>" & Make & "</Make>"
                SoapStr = SoapStr & "<Model>" & Model & "</Model>"
                SoapStr = SoapStr & "<YearOfManufacture>" & YearMan & "</YearOfManufacture>"
                SoapStr = SoapStr & "<VinNo>" & Vin_NO & "</VinNo>"
                SoapStr = SoapStr & "<VehicleRegNo>" & REG_NO & "</VehicleRegNo>"
                SoapStr = SoapStr & "<IsAlcoholTested>" & isAlcoholTest & "</IsAlcoholTested>"
                SoapStr = SoapStr & "<IsPotentialSalvage></IsPotentialSalvage>"
                SoapStr = SoapStr & "<Extensions></Extensions>"
                SoapStr = SoapStr & "<AdditionalInformation></AdditionalInformation>"
                SoapStr = SoapStr & "<ContactPerson></ContactPerson>"
                SoapStr = SoapStr & "<SpecialInstruction>" & Trim(oOpenClaim.PrimaryCause) & "</SpecialInstruction>"
                SoapStr = SoapStr & "<IncidentLocation>" & Trim(oOpenClaim.Location) & "</IncidentLocation>"
                SoapStr = SoapStr & "</Claim>"
                SoapStr = SoapStr & "</xml>"
                SoapStr = SoapStr & "]]></tem:sXmlClaim>"
                SoapStr = SoapStr & "</tem:SPMPASAddClaimRequest>"
                SoapStr = SoapStr & "</soapenv:Body>"
                SoapStr = SoapStr & "</soapenv:Envelope>"

            End If

            claimNumber = PostWebservice(soapAction, SoapStr, TagElement)

            Return claimNumber
        End Function

        Private Function CreateNonMotorClaim() As String
            Dim claimNumber As String = ""
            Dim SoapStr As String = ""
            Dim soapAction As String = "http://tempuri.org/IWCFService/PASAddClaim"
            Dim TagElement As String = "iClaimID"
            Dim oOpenClaim As NexusProvider.ClaimOpen = Session(CNClaim)
            Dim oClaimQuote As NexusProvider.Quote = Session(CNClaimQuote)
            Dim SPM_CoverType As String = String.Empty
            Dim CoverType As String = String.Empty
            Dim BasePerilKey As Int32

            Dim PerilCode As String = ""
            Dim PerilID As Int32
            Dim SumInsured As Decimal = 0.0
            Dim ReserveAmount As Decimal = 0.0

            Dim BrokerName As String = String.Empty

            If Trim(oClaimQuote.AgentCode) IsNot Nothing Then

                BrokerName = oClaimQuote.AgentDesc.Trim()
            Else
                BrokerName = oClaimQuote.InsuredName.Trim()

            End If

            For Each item As NexusProvider.PerilSummary In oOpenClaim.ClaimPeril
                BasePerilKey = item.BaseClaimPerilKey
                PerilCode = item.TypeCode
                SumInsured = item.SumInsured
                ReserveAmount = (From u In item.Reserve Where u.TypeCode = "Indemnity" Select u.InitialReserve).FirstOrDefault()
            Next

            PerilID = GetListValue("UDL_PURESPM", PerilCode, "claimtypeid")
            CoverType = GetListValue("UDL_PURESPM", PerilCode, "description")
            SPM_CoverType = GetListValue("UDL_PURESPM", PerilCode, "spm_description")

            SoapStr = "<?xml version=""1.0"" encoding=""utf-8""?>"
            SoapStr = SoapStr & "<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:tem=""http://tempuri.org/"">"
            SoapStr = SoapStr & "<soapenv:Header/>"
            SoapStr = SoapStr & "<soapenv:Body>"
            SoapStr = SoapStr & "<tem:SPMPASAddClaimRequest>"
            SoapStr = SoapStr & "<tem:Password>HNAM@PURE</tem:Password>"
            SoapStr = SoapStr & "<tem:iClaimTypeID>" & SPM_CoverType & "</tem:iClaimTypeID>"
            SoapStr = SoapStr & "<tem:sClaimNo>" & Trim(oOpenClaim.ClaimNumber) & "</tem:sClaimNo>"
            SoapStr = SoapStr & "<tem:sPASystem>HNAMPURE</tem:sPASystem>"
            SoapStr = SoapStr & "<tem:sXmlClaim><![CDATA["
            SoapStr = SoapStr & "<xml>"
            SoapStr = SoapStr & "<Claim>"
            SoapStr = SoapStr & "<ClaimSpecialist>" & GetListValue("handler", Trim(oOpenClaim.HandlerCode), "description") & "</ClaimSpecialist>"
            SoapStr = SoapStr & "<PolicyNumber>" & Trim(oClaimQuote.InsuranceFileRef) & "</PolicyNumber>"
            SoapStr = SoapStr & "<PerilTypeID>" & BasePerilKey & "</PerilTypeID>"
            SoapStr = SoapStr & "<PerilID>" & PerilID & "</PerilID>"
            SoapStr = SoapStr & "<PureReserveTypeID>2</PureReserveTypeID>"
            SoapStr = SoapStr & "<Cover>" & CoverType & "</Cover>"
            SoapStr = SoapStr & "<IntClaimRefNo>" & Trim(oOpenClaim.ClaimNumber) & "</IntClaimRefNo>"
            SoapStr = SoapStr & "<InsuredName>" & Trim(oClaimQuote.InsuredName) & "</InsuredName>"
            SoapStr = SoapStr & "<InsHomeTel>" & Trim(oOpenClaim.ClientTelNo) & "</InsHomeTel>"
            SoapStr = SoapStr & "<InsWorkTel>" & Trim(oOpenClaim.ClientMobileNo) & "</InsWorkTel>"
            SoapStr = SoapStr & "<IncidentDT>" & Trim(oOpenClaim.LossToDate) & "</IncidentDT>"
            SoapStr = SoapStr & "<DateCaptured>" & Trim(oOpenClaim.ReportedDate) & "</DateCaptured>"
            SoapStr = SoapStr & "<BrokerName>" & BrokerName & "</BrokerName>"
            SoapStr = SoapStr & "<BrokerConsultant></BrokerConsultant>"
            SoapStr = SoapStr & "<BrokerCode>" & Trim(oClaimQuote.AgentCode) & "</BrokerCode>"
            SoapStr = SoapStr & "<RiskNumber>" & Trim(oOpenClaim.RiskKey) & "</RiskNumber>"
            SoapStr = SoapStr & "<Value>" & SumInsured & "</Value>"
            SoapStr = SoapStr & "<Estimate>" & ReserveAmount & "</Estimate>"
            SoapStr = SoapStr & "<Excess></Excess>"
            SoapStr = SoapStr & "<ContactPerson></ContactPerson>"
            SoapStr = SoapStr & "<SpecialInstruction>" & Trim(oOpenClaim.Description) & "</SpecialInstruction>"
            SoapStr = SoapStr & "<IncidentLocation>" & Trim(oOpenClaim.Location) & "</IncidentLocation>"
            SoapStr = SoapStr & "</Claim>"
            SoapStr = SoapStr & "</xml>"
            SoapStr = SoapStr & "]]></tem:sXmlClaim>"
            SoapStr = SoapStr & "</tem:SPMPASAddClaimRequest>"
            SoapStr = SoapStr & "</soapenv:Body>"
            SoapStr = SoapStr & "</soapenv:Envelope>"

            claimNumber = PostWebservice(soapAction, SoapStr, TagElement)

            Return claimNumber
        End Function

        'This is the function used to call SPM Webservices in order to get information from their endpoint
        Private Function PostWebservice(ByVal soapAction As String, ByVal xmlBody As String, ByVal tagElement As String) As String

            Dim Request As HttpWebRequest
            Dim DataStream As Stream
            Dim Response As WebResponse
            Dim Reader As StreamReader
            Dim uTF8Encoding As New UTF8Encoding()
            Dim xmlDoc As New XmlDocument()
            Dim SoapByte As Byte()
            Dim value As String = String.Empty
            Dim requestUriString As String = "https://codeplex.driveable.com.na/SPMIntegrationUAT/WCFService.svc"

            Try
                SoapByte = uTF8Encoding.GetBytes(xmlBody)
                Request = CType(WebRequest.Create(requestUriString), HttpWebRequest)
                Request.Headers.Add("SOAPAction", soapAction)
                Request.ContentType = "text/xml; charset=utf-8"
                Request.ContentLength = SoapByte.Length
                Request.Method = "POST"

                Using requestStream As Stream = Request.GetRequestStream()
                    requestStream.Write(SoapByte, 0, SoapByte.Length)
                End Using

                Response = Request.GetResponse()
                DataStream = Response.GetResponseStream()
                Reader = New StreamReader(DataStream)
                Dim SD2Request As String = Reader.ReadToEnd()
                xmlDoc.LoadXml(SD2Request)
                Dim nodelist As XmlNodeList = xmlDoc.GetElementsByTagName(tagElement)

                If nodelist.Count > 0 Then
                    For Each item As XmlNode In nodelist
                        value = item.InnerText
                    Next
                End If

            Catch ex As WebException
                MsgBox(ex.ToString())
            End Try

            Return value
        End Function

        Protected Function GetListItemDescfromCode(ByVal sListType As String, ByVal sListCode As String, ByVal iItemId As String) As String
            Dim sItemDesc As String = String.Empty

            Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            Dim oList As New NexusProvider.LookupListCollection

            ' SAM call to retrieve the list of items from user defined list
            If sListType = "UserDefined" Then
                oList = oWebService.GetList(NexusProvider.ListType.UserDefined, sListCode, False, False)
            Else
                oList = oWebService.GetList(NexusProvider.ListType.PMLookup, sListCode, False, False)
            End If

            ' Get Description for Code
            For iListCount As Integer = 0 To oList.Count - 1
                If oList(iListCount).Key = iItemId Then
                    sItemDesc = oList(iListCount).Description
                    Exit For
                End If
            Next
            Return sItemDesc
        End Function


        Protected Function GetListValue(ByVal sListCode As String, ByVal itemCode As String, ByVal sValue As String) As String
            Dim value As String = String.Empty
            Dim LstXmlElement As XmlElement = Nothing
            Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            Dim oList As New NexusProvider.LookupListCollection
            oList = oWebService.GetList(NexusProvider.ListType.PMLookup, sListCode, False, False, , , , LstXmlElement)

            Dim sXML As String = LstXmlElement.OuterXml
            Dim xmlDoc As New System.Xml.XmlDocument
            Dim NodeList As XmlNodeList
            xmlDoc.LoadXml(sXML)

            NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & sListCode)

            If NodeList.Count > 0 Then
                value = (From Node As XmlNode In NodeList Where Node.SelectSingleNode("code").InnerText.Trim() = itemCode Select Node.SelectSingleNode(sValue).InnerText.Trim()).FirstOrDefault()
            End If

            Return value
        End Function

#End Region

    End Class

End Namespace
