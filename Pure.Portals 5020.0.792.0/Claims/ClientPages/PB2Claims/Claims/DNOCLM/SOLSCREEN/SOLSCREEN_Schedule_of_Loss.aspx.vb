Imports CMS.Library
Imports System.Web.Configuration.WebConfigurationManager
Imports Nexus.Library
Imports System.Web.Configuration
Imports Nexus.Utils
Imports System.Web.HttpContext
Imports Nexus.Constants.Session
Imports Nexus.Constants.Constant
Imports System.Xml.XPath
Imports System.Xml
Imports System.Data.SqlClient

Namespace Nexus
    Partial Class PB2_SOLSCREEN_Schedule_of_Loss : Inherits BaseClaim
        Protected iMode As Integer
        Private coverNoteBookKey As Integer = 0
        Dim oWebService As NexusProvider.ProviderBase = Nothing

		Enum LifecycleEvent
            PostDataSetWrite
            PreDataSetWrite
            Page_Load
            Page_LoadComplete
            btnFinish_Click
            btnNext_Click
            Render
            Page_Init
        End Enum
        
		Protected eLifecycleEvent As LifecycleEvent
		
        Public Overrides Sub PostDataSetWrite()
			eLifecycleEvent = LifecycleEvent.PostDataSetWrite
			CallRuleScripts()
        End Sub

        Public Overrides Sub PreDataSetWrite()
			eLifecycleEvent = LifecycleEvent.PreDataSetWrite
			CallRuleScripts()
        End Sub

		Protected Shadows Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
			eLifecycleEvent = LifecycleEvent.Page_Init
			CallRuleScripts()
        End Sub
        
		
		Protected Shadows Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            Me.Page.ClientScript.RegisterStartupScript(Me.GetType, "DoLogicStartup", "onload = function () {BuildComponents(); DoLogic(true);};", True)
			eLifecycleEvent = LifecycleEvent.Page_Load
			CallRuleScripts()
        End Sub
		
		Protected Shadows Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
            ' Output the XMLDataSet
            XMLDataSet.Text = Session(CNDataSet).Replace("'", "\'").Replace(vbCr, "").Replace(vbLf, "")

            ' Remove DTD Details - Comment in when Ali has made his mods
            XMLDataSet.Text = XMLDataSet.Text.Substring(0, XMLDataSet.Text.IndexOf("<!DOCTYPE DATA_SET")) & XMLDataSet.Text.Substring(XMLDataSet.Text.IndexOf("<DATA_SET"))

			' Output the IO Number
			Dim oOI As Collections.Stack
			oOI = Session.Item(CNOI)
			If Not oOI is Nothing Then
				If oOI.Count > 0 Then
					ThisOI.Text = oOI.Peek
				End If
			End If
			eLifecycleEvent = LifecycleEvent.Page_LoadComplete
			CallRuleScripts()
		End Sub

        Protected Sub btnNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
			eLifecycleEvent = LifecycleEvent.btnNext_Click
			CallRuleScripts()
        End Sub
		
        Protected Overrides Sub Render(ByVal writer As HtmlTextWriter)
            MyBase.Render(writer)
			eLifecycleEvent = LifecycleEvent.Render
			CallRuleScripts()
        End Sub

		Protected Sub onValidate_SCHEDULE_LOSS__ITEM_NUMBER()
        
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_SCHEDULE_LOSS__ITEM_NUMBER()
End Sub

		    
        Protected Sub btnNextTop_Click(sender As Object, e As EventArgs) Handles btnNextTop.Click, btnNext.Click
             If (CType(Session.Item(CNMode), Mode) = Mode.PayClaim) Then 'And GetValue("RESERVES", "PROCESSED_THIS_PAYMENT") <> "1" 
                        ProcessPayment()
                        Session(CNEnablePayClaim) = True
        
        
        
             End If
        	 'Added for updating reserves for claim reinsurance
        	 If Session(CNMode) = Mode.NewClaim Or Session(CNMode) = Mode.EditClaim Then
                        UpdateReserveData()
             End If
        
                    'Dim dThisReceipt As Double
                    'Double.TryParse(RESERVES__Total_This_Receipt.Text, dThisReceipt)
                    'If ((CType(Session.Item(CNMode), Mode) = Mode.SalvageClaim) OrElse (CType(Session.Item(CNMode), Mode) = Mode.TPRecovery)) AndAlso (dThisReceipt > 0) Then
                    '    UpdateClaimXML("DNOLBCLAIM", "PROCESS_RECEIPT_FLAG", "1", True)
                    '    UpdateClaimXML("DNOLBCLAIM", "RECEIPT_PAYEE_TYPE", RESERVES__Receipt_Payee_Type.Value, True)
                    '    UpdateClaimXML("DNOLBCLAIM", "RECEIPT_PARTY_NAME", RESERVES__Receipt_Party_Name.PartyKey, True)
                    '    RunDefaultRule()
                    '    GetClaimDetails(CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimKey, Nothing)
        
                    '    'Get get flags updated in back office rules
                    '    RESERVES__Paid_Payment_Processed_Flag.Text = GetValue("DNOLBCLAIM", "RECEIPT_PROCESSED")
                    '    RESERVES__Process_Payment_Flag.Text = GetValue("DNOLBCLAIM", "PROCESS_RECEIPT_FLAG")
                    '    SetScriptReceipt()
                    'End If
        End Sub
        
        Dim cPaymentCollection As New System.Collections.Generic.Dictionary(Of Integer, Hashtable)
        Private Sub ProcessPayment()
                     If (Not String.IsNullOrEmpty(Session(CNDataSet)) AndAlso CType(Session.Item(CNMode), Mode) = Mode.PayClaim) Then
                        Dim srDataset As New System.IO.StringReader(Session(CNDataSet))
                        Dim xmlTR As New XmlTextReader(srDataset)
                        Dim xmlDoc As New XmlDocument
                        Dim bIsPaymentProcessed As Boolean = False
                        Dim sPaymentOI As String = String.Empty
                        xmlDoc.Load(xmlTR)
                        xmlTR.Close()
                        Dim oNodelist As XmlNodeList = xmlDoc.SelectNodes("//DNOLBCLAIM/SCHEDULE_LOSS")
                        For Each oNode As XmlNode In oNodelist
                            If oNode IsNot Nothing Then
        
                                Dim dThisPayment As Double
                                Dim sPayeeTypeCode As String = String.Empty
                                Dim sIsExGratia As String = String.Empty
                                Dim sPayeeType As String = String.Empty
                                'Dim sStatusCode As String = String.Empty
                                Dim sMediaTypeCode As String = String.Empty
                                'Dim sBankAccountNo As String = String.Empty
                                'Dim sBranchCode As String = String.Empty
                                'Dim sBankName As String = String.Empty
                                'Dim sPaymentDate As String = String.Empty
                                Dim sPayeeName As String = String.Empty
                                Dim sMediaType As String = String.Empty
                                'Dim sAccountType As String = String.Empty
                                'Dim sBic As String = String.Empty
                                'Dim sIban As String = String.Empty
                                'Dim sComment As String = String.Empty
                                'Dim sOurRef As String = String.Empty
                                'Dim sTheirRef As String = String.Empty
                                Dim sMediaRef As String = String.Empty
                                ' Dim sAddressLine1 As String = String.Empty
                                'Dim sAddressLine2 As String = String.Empty
                                ' Dim sAddressLine3 As String = String.Empty
                                'Dim sAddressLine4 As String = String.Empty
                                'Dim sCountryCode As String = String.Empty
                                'Dim sPostCode As String = String.Empty
                                'Dim sPartyKey As String = String.Empty
                                Dim htPaymentDetails As New Hashtable
        
        
                                If oNode.Attributes("PAYMENT_AMOUNT") IsNot Nothing Then
                                    Double.TryParse(oNode.Attributes("PAYMENT_AMOUNT").Value, dThisPayment)
                                End If
                                ' If oNode.Attributes("STATUSCODE") IsNot Nothing Then
                                ' sStatusCode = oNode.Attributes("STATUSCODE").Value
                                ' End If
                                htPaymentDetails.Clear()
        
                                If (dThisPayment > 0) Then ' AndAlso (sStatusCode = "NP" OrElse sStatusCode = "AUTH")) Then
                                    If oNode.Attributes("OI") IsNot Nothing Then
                                        sPaymentOI = oNode.Attributes("OI").Value
                                    End If
                                    'GetListItemCodefromID(ByVal sListType As String, ByVal sListCode As String, ByVal iItemId As String)
                                    If oNode.Attributes("PAYEE_TYPE") IsNot Nothing Then
                                        sPayeeTypeCode = GetListItemCodefromID("PMLookUp", "UDL_COM_PAYEE_TYPE", oNode.Attributes("PAYEE_TYPE").Value)
                                    End If
                                    ' If oNode.Attributes("PARTY_KEY") IsNot Nothing Then
                                    ' sPartyKey = oNode.Attributes("PARTY_KEY").Value
                                    ' End If
                                    If oNode.Attributes("IS_EXGRATIA") IsNot Nothing Then
                                        sIsExGratia = oNode.Attributes("IS_EXGRATIA").Value
                                    End If
                                    If oNode.Attributes("PAYEE_TYPE") IsNot Nothing Then
                                        Select Case sPayeeTypeCode
                                            Case "CLMPAYABLE"
                                                sPayeeType = "Claim Payable"
                                            Case "PARTY"
                                                sPayeeType = "Other Party"
                                            Case "CLIENT"
                                                sPayeeType = "Client"
                                        End Select
                                        'sPayeeType = oNode.Attributes("PAYEE_TYPE").Value
                                    End If
                                    If oNode.Attributes("PAYMENT_TYPE") IsNot Nothing Then
                                        sMediaTypeCode = GetListItemCodefromID("PMLookUp", "MediaType", oNode.Attributes("PAYMENT_TYPE").Value)
                                    End If
                                    ' If oNode.Attributes("BANK_ACCOUNT_NO") IsNot Nothing Then
                                    ' sBankAccountNo = oNode.Attributes("BANK_ACCOUNT_NO").Value
                                    ' End If
                                    ' If oNode.Attributes("BRANCH_CODE") IsNot Nothing Then
                                    ' sBranchCode = oNode.Attributes("BRANCH_CODE").Value
                                    ' End If
                                    ' If oNode.Attributes("BANK_NAME") IsNot Nothing Then
                                    ' sBankName = oNode.Attributes("BANK_NAME").Value
                                    ' End If
                                    ' If oNode.Attributes("PAYMENT_DATE") IsNot Nothing Then
                                    ' sPaymentDate = oNode.Attributes("PAYMENT_DATE").Value
                                    ' End If
                                    If oNode.Attributes("PAYEE_TYPE") IsNot Nothing Then
                                        Select Case sPayeeTypeCode
                                            Case "CLMPAYABLE"
                                                sPayeeName = "-1"
                                            Case "PARTY"
                                                sPayeeName = oNode.Attributes("PARTY_NAME").Value
                                            Case "CLIENT"
                                                sPayeeName = oNode.Attributes("CLIENT").Value
                                        End Select
        
                                    End If
                                    If oNode.Attributes("PAYMENT_TYPE") IsNot Nothing Then
                                        sMediaType = GetListItemDescfromCode("PMLookUp", "MediaType", oNode.Attributes("PAYMENT_TYPE").Value)
                                    End If
                                    ' If oNode.Attributes("ACCOUNT_TYPE") IsNot Nothing Then
                                    ' sAccountType = oNode.Attributes("ACCOUNT_TYPE").Value
                                    ' End If
                                    ' If oNode.Attributes("COMMENTS") IsNot Nothing Then
                                    ' sComment = oNode.Attributes("COMMENTS").Value
                                    ' End If
                                    ' If oNode.Attributes("BIC") IsNot Nothing Then
                                    ' sBic = oNode.Attributes("BIC").Value
                                    ' End If
                                    ' If oNode.Attributes("IBAN") IsNot Nothing Then
                                    ' sIban = oNode.Attributes("IBAN").Value
                                    ' End If
                                    ' If oNode.Attributes("OUR_REF") IsNot Nothing Then
                                    ' sOurRef = oNode.Attributes("OUR_REF").Value
                                    ' End If
                                    ' If oNode.Attributes("THEIR_REF") IsNot Nothing Then
                                    ' sTheirRef = oNode.Attributes("THEIR_REF").Value
                                    ' End If
                                    If oNode.Attributes("MEDIA_REF") IsNot Nothing Then
                                        sMediaRef = oNode.Attributes("MEDIA_REF").Value
                                    End If
        
                                    ' Dim oAddressNodelist As XmlNode = xmlDoc.SelectSingleNode("//RESERVES/PAYMENT[@OI='" & sPaymentOI & "']/ADDRESS_CNT")
                                    ' If oAddressNodelist IsNot Nothing Then
                                    ' If oAddressNodelist.Attributes("ADDRESS_LINE1") IsNot Nothing Then
                                    ' sAddressLine1 = oAddressNodelist.Attributes("ADDRESS_LINE1").Value
                                    ' End If
                                    ' If oAddressNodelist.Attributes("ADDRESS_LINE2") IsNot Nothing Then
                                    ' sAddressLine2 = oAddressNodelist.Attributes("ADDRESS_LINE2").Value
                                    ' End If
                                    ' If oAddressNodelist.Attributes("ADDRESS_LINE3") IsNot Nothing Then
                                    ' sAddressLine3 = oAddressNodelist.Attributes("ADDRESS_LINE3").Value
                                    ' End If
                                    ' If oAddressNodelist.Attributes("ADDRESS_LINE4") IsNot Nothing Then
                                    ' sAddressLine4 = oAddressNodelist.Attributes("ADDRESS_LINE4").Value
                                    ' End If
                                    ' If oAddressNodelist.Attributes("COUNTRYCODE") IsNot Nothing Then
                                    ' sCountryCode = oAddressNodelist.Attributes("COUNTRYCODE").Value
        
                                    ' End If
                                    ' If oAddressNodelist.Attributes("POSTCODE") IsNot Nothing Then
                                    ' sPostCode = oAddressNodelist.Attributes("POSTCODE").Value
                                    ' End If
                                    ' End If
        
                                    htPaymentDetails.Add("PAYEE_TYPECODE", sPayeeTypeCode)
                                    'htPaymentDetails.Add("PARTY_KEY", sPartyKey)
                                    htPaymentDetails.Add("IS_EX_GRATIA", sIsExGratia)
                                    htPaymentDetails.Add("PAYEE_TYPE", sPayeeType)
                                    ' htPaymentDetails.Add("STATUSCODE", sStatusCode)
                                    htPaymentDetails.Add("MEDIA_TYPECODE", sMediaTypeCode)
                                    ' htPaymentDetails.Add("BANK_ACCOUNT_NO", sBankAccountNo)
                                    ' htPaymentDetails.Add("BRANCH_CODE", sBranchCode)
                                    ' htPaymentDetails.Add("BANK_NAME", sBankName)
                                    'htPaymentDetails.Add("PAYMENT_DATE", sPaymentDate)
                                    htPaymentDetails.Add("PAYEE_NAME", sPayeeName)
                                    htPaymentDetails.Add("MEDIA_TYPE", sMediaType)
                                    ' htPaymentDetails.Add("ACCOUNT_TYPE", sAccountType)
                                    ' htPaymentDetails.Add("COMMENTS", sComment)
                                    ' htPaymentDetails.Add("BIC", sBic)
                                    ' htPaymentDetails.Add("IBAN", sIban)
                                    ' htPaymentDetails.Add("OUR_REF", sOurRef)
                                    ' htPaymentDetails.Add("THEIR_REF", sTheirRef)
                                    htPaymentDetails.Add("MEDIA_REF", sMediaRef)
                                    ' htPaymentDetails.Add("ADDRESS_LINE1", sAddressLine1)
                                    ' htPaymentDetails.Add("ADDRESS_LINE2", sAddressLine2)
                                    ' htPaymentDetails.Add("ADDRESS_LINE3", sAddressLine3)
                                    ' htPaymentDetails.Add("ADDRESS_LINE4", sAddressLine4)
                                    ' htPaymentDetails.Add("COUNTRYCODE", sCountryCode)
                                    ' htPaymentDetails.Add("POSTCODE", sPostCode)
        
                                     Dim oPaymentNodelist As XmlNodeList = xmlDoc.SelectNodes("//DNOLBCLAIM/SCHEDULE_LOSS")
                                    For Each oPaymentNode As XmlNode In oPaymentNodelist
                                        Dim sPerilTypeCode As String = String.Empty
                                        Dim sReserveTypeCode As String = String.Empty
                                        Dim sPaymentAmount As String = String.Empty
                                        If oPaymentNode IsNot Nothing Then
                                            If oPaymentNode.Attributes("PERIL") IsNot Nothing Then
                                                sPerilTypeCode = GetListItemCodefromID("PMLookUp", "UDL_DNO_PERIL_TYPE", oPaymentNode.Attributes("PERIL").Value)
                                            End If
                                            If oPaymentNode.Attributes("DESCRIPTION") IsNot Nothing Then
                                                sReserveTypeCode = GetListItemCodefromID("PMLookUp", "UDL_CLA_RESERVE", oPaymentNode.Attributes("DESCRIPTION").Value)
                                            End If
                                            If oPaymentNode.Attributes("PAYMENT_AMOUNT") IsNot Nothing Then
                                                sPaymentAmount = oPaymentNode.Attributes("PAYMENT_AMOUNT").Value
                                            End If
        
                                            If (AddPayment(sPerilTypeCode, "INDEMNITY", sPaymentAmount, htPaymentDetails)) Then
                                                bIsPaymentProcessed = True
                                            End If
                                        End If
                                    Next
        
                                    If (bIsPaymentProcessed And cPaymentCollection IsNot Nothing) Then
                                        For Each oPaymentItem In cPaymentCollection
                                            SavePaymentData(oPaymentItem.Key, oPaymentItem.Value)
                                        Next
        
                                        'UpdateClaimXML("RESERVES/PAYMENT", "STATUSCODE", "PAID", True, sPaymentOI)
                                        'UpdateClaimXML("RESERVES/PAYMENT", "STATUS", "4", True, sPaymentOI)
                                        'UpdateClaimXML("RESERVES/PAYMENT", "PAID_PAYMENT_PROCESSED_FLAG", "1", True, sPaymentOI)
                                        oNodelist = xmlDoc.SelectNodes("//DNOLBCLAIM/SCHEDULE_LOSS")
                                        Dim sReseveOI As String = String.Empty
                                        Dim sTotalPaidAmount As String = String.Empty
                                        Dim sThisPaymentAmount As String = String.Empty
                                        Dim sOutstandingAmount As String = String.Empty
                                        Dim sNetTotalOutstandingAmount As String = String.Empty
                                        Dim sNetTotalPaymentAmount As String = String.Empty
                                        Dim sLossId As String = String.Empty
                                        For Each oPaymentNode As XmlNode In oNodelist
                                            If oPaymentNode.Attributes("OI") IsNot Nothing Then
                                                sReseveOI = oPaymentNode.Attributes("OI").Value
                                            End If
        
                                            If oPaymentNode.Attributes("PAYMENT_AMOUNT") IsNot Nothing Then
                                                sTotalPaidAmount = oPaymentNode.Attributes("PAYMENT_AMOUNT").Value
                                            End If
        
                                            ' If oPaymentNode.Attributes("LOSS_ID") IsNot Nothing Then
                                            ' sLossId = oPaymentNode.Attributes("LOSS_ID").Value
                                            ' sThisPaymentAmount = GetValue("RESERVES/PAYMENT[@ID='" & RESERVES__PROCESS_PAYMENT_ID.Text & "']/PAYBRKDWN[@LOSS_ID='" & sLossId & "']", "AMOUNT")
                                            ' End If
        
                                            If oPaymentNode.Attributes("THIS_PAYMENT") IsNot Nothing Then
                                                sOutstandingAmount = oPaymentNode.Attributes("THIS_PAYMENT").Value
                                            End If
        
                                            sNetTotalPaymentAmount = CDbl(sTotalPaidAmount) '+ SafeDouble(sThisPaymentAmount)
                                            sNetTotalOutstandingAmount = CDbl(sOutstandingAmount) '- CDbl(sThisPaymentAmount)
                                            'UpdateClaimXML("RESERVES/LSRSV", "PAYMENT_AMOUNT", "0.00", True, sReseveOI)
                                            UpdateClaimXML("DNOLBCLAIM/SCHEDULE_LOSS", "THIS_PAYMENT", sNetTotalOutstandingAmount, True, sReseveOI)
                                            UpdateClaimXML("DNOLBCLAIM/SCHEDULE_LOSS", "PAYMENT_AMOUNT", sNetTotalPaymentAmount, True, sReseveOI)
                                        Next
                                        'UpdateClaimXML("RESERVES/PAYMENT[@ID='" & RESERVES__PROCESS_PAYMENT_ID.Text & "']", "PAID_PAYMENT_PROCESSED_FLAG", "1", True)
                                        'RESERVES__PROCESS_PAYMENT_ID.Text = ""
                                        'UpdateClaimXML("RESERVES", "PROCESS_PAYMENT_FLAG", "", True)
                                        'UpdateClaimXML("RESERVES", "PROCESS_PAYMENT", "1", True)
                                        'UpdateClaimXML("RESERVES", "PROCESSED_THIS_PAYMENT", "1", True)
                                        RunDefaultRule()
                                        bIsPaymentProcessed = False
                                    End If
                                End If
                            End If
                        Next
                    End If
        	End Sub
        
        Dim nPayment As Integer = 0
        
        Function AddPayment(sPerilTypeCode As String, sReserveTypeCode As String, sPaymentAmount As String, htPaymentDetails As Hashtable) As Boolean
            Dim nPeril As Integer
            Dim nPaymentIndex As Integer
            Dim sFormatString As String = String.Empty
            Dim bAddPayment As Boolean = False
            Dim bResetValues As Boolean = False
            Dim bFirstElement As Boolean = False
            Dim nClaimKey As Integer
            Dim bReceiptExcludeTax As Boolean = False
            Dim oClaimOpen As NexusProvider.ClaimOpen = New NexusProvider.ClaimOpen
            Dim oQuote As NexusProvider.Quote = New NexusProvider.Quote
            Dim oWebservice As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            Dim oTaxGroupCollection As NexusProvider.TaxGroupCollection = Nothing
            Dim oClaimPayment As NexusProvider.PerilSummary = Nothing
            Dim oOptionSettings As NexusProvider.OptionTypeSetting
            Dim oCurrency As New NexusProvider.Currency
        
            Try
                oClaimOpen = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen)
                sFormatString = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork).Portals.Portal(CMS.Library.Portal.GetPortalID()).FormatStrings.FormatString("Currency").DataFormatString
        
                For nCount As Integer = 0 To oClaimOpen.ClaimPeril.Count
                    If oClaimOpen.ClaimPeril(nCount).TypeCode = sPerilTypeCode Then
                        nPeril = nCount
                        For nInnerCount As Integer = 0 To oClaimOpen.ClaimPeril(nCount).Reserve.Count - 1
                            If oClaimOpen.ClaimPeril(nCount).Reserve(nInnerCount).TypeCode = sReserveTypeCode Then
                                nPaymentIndex = nInnerCount
                                Exit For
                            End If
                        Next
                        Exit For
                    End If
                Next
        
                Session(CNClaimPerilIndex) = nPeril
                oQuote = Session(CNClaimQuote)
        
                If oClaimOpen IsNot Nothing Then
                    For iInnerCount As Integer = 0 To oClaimOpen.ClaimPeril(nPeril).Payment.ClaimPaymentItem.Count - 1
                        CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(nPeril).Payment.ClaimPaymentItem(nPaymentIndex).TaxGroupCode = ""
                        CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(nPeril).Payment.ClaimPaymentItem(nPaymentIndex).TaxAmount = 0
                        CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(nPeril).Payment.ClaimPaymentItem(nPaymentIndex).PaymentAmount = 0
                    Next
        
                    For iInnerCount As Integer = 0 To oClaimOpen.ClaimPeril(nPeril).ClaimReserve.Count - 1
                        CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(nPeril).ClaimReserve(nPaymentIndex).ThisPaymentTax = 0
                        CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(nPeril).ClaimReserve(nPaymentIndex).ThisPaymentINCLTax = 0
                    Next
                End If
        
                If nPayment = 0 Then
                    For nPerilCount As Integer = 0 To oClaimOpen.ClaimPeril.Count - 1
                        If oClaimOpen.ClaimPeril(nPerilCount).ClaimReserve IsNot Nothing AndAlso oClaimOpen.ClaimPeril(nPerilCount).ClaimReserve.Count > 0 Then
                            For iCount As Integer = 0 To oClaimOpen.ClaimPeril(nPerilCount).ClaimReserve.Count - 1
                                oClaimOpen.ClaimPeril(nPerilCount).ClaimReserve.Remove(0)
                            Next
                        End If
                    Next
                    If Not PopulateReserveItem(nPeril) Then
                        Return bAddPayment
                    End If
                End If
                nPayment = nPayment + 1
        
                If oClaimOpen.ClaimPeril(nPeril).ClaimReserve(nPaymentIndex).IsExcess = True AndAlso
                                                    oClaimOpen.ClaimPeril(nPeril).ClaimReserve(nPaymentIndex).ThisPaymentINCLTax = 0 Then
                    For nCount As Integer = 0 To oClaimOpen.ClaimPeril(nPeril).ClaimReserve.Count - 1
                        If oClaimOpen.ClaimPeril(nPeril).ClaimReserve(nCount).IsExcess = False _
                                                            AndAlso oClaimOpen.ClaimPeril(nPeril).ClaimReserve(nCount).PayQueue > 0 Then
                            bResetValues = True
                            Exit For
                        End If
                    Next
                Else
                    For nCount As Integer = 0 To oClaimOpen.ClaimPeril(nPeril).ClaimReserve.Count - 1
                        If oClaimOpen.ClaimPeril(nPeril).ClaimReserve(nCount).PayQueue > 0 Then
                            bFirstElement = True
                            Exit For
                        End If
                    Next
                End If
        
                If bResetValues = True Then
                    oClaimOpen.ClaimPeril(nPeril).Payment.ClaimPaymentItem.Clear()
                    oClaimOpen.ClaimPeril(nPeril).ClaimReserve.Clear()
                    If Not PopulateReserveItem(nPeril) Then
                        Return bAddPayment
                    End If
                End If
        
                oClaimPayment = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(nPeril)
                oOptionSettings = oWebservice.GetOptionSetting(NexusProvider.OptionType.SystemOption, 5067)
        
                If oOptionSettings.OptionValue = "1" Then
                    bReceiptExcludeTax = True
                End If
        
                nClaimKey = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).BaseClaimKey
                oCurrency.AccountCode = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClientShortName
                oCurrency.TransactionCurrencyCode = oQuote.CurrencyCode
                oCurrency.Mode = "ALL"
                oCurrency = oWebservice.GetCurrencyExchangeRates(oCurrency, Session(CNBranchCode), nClaimKey)
        
                With oClaimOpen.ClaimPeril(nPeril)
                    .ClaimReserve(nPaymentIndex).TotalReserve = .ClaimReserve(nPaymentIndex).TotalReserve
                    .ClaimReserve(nPaymentIndex).ThisPaymentTax = 0
                    .ClaimReserve(nPaymentIndex).ThisPaymentINCLTax = CDec(sPaymentAmount)
                    .ClaimReserve(nPaymentIndex).CostToClaim = CDec(sPaymentAmount)
                    .ClaimReserve(nPaymentIndex).CurrencyCode = oQuote.CurrencyCode
                    .ClaimReserve(nPaymentIndex).CurrencyRate = oCurrency.TransactionCurrencyRate
                    oClaimOpen.ClaimPeril(nPeril).Payment.ClaimPaymentItem(nPaymentIndex).ReverseExcess = False
                    .ClaimReserve(nPaymentIndex).CurrentReserve = String.Format(sFormatString, .ClaimReserve(nPaymentIndex).OldReserve - CDec(sPaymentAmount))
                    oClaimOpen.ClaimPeril(nPeril).Payment.CurrencyCode = oQuote.CurrencyCode
                    oClaimOpen.ClaimPeril(nPeril).Payment.CurrencyRate = oCurrency.TransactionCurrencyRate
                    oClaimOpen.ClaimPeril(nPeril).Payment.PaymentAmount = CDec(sPaymentAmount)
                    'oClaimOpen.ClaimPeril(iPeril).Payment.RiskType = txtRiskType.Text
                    oClaimOpen.ClaimPeril(nPeril).Payment.ReserveType = sReserveTypeCode
                    oClaimOpen.ClaimPeril(nPeril).Payment.TaxAmount = 0
                    oClaimOpen.ClaimPeril(nPeril).Payment.ClaimPaymentItem(nPaymentIndex).LossPaymentAmount = Math.Round(CDec(sPaymentAmount), 2)
                    oClaimOpen.ClaimPeril(nPeril).Payment.ClaimPaymentItem(nPaymentIndex).PaymentAmount = Math.Round(CDec(sPaymentAmount), 2)
                    oClaimOpen.ClaimPeril(nPeril).Payment.ClaimPaymentItem(nPaymentIndex).CurrencyCode = oQuote.CurrencyCode
                    oClaimOpen.ClaimPeril(nPeril).Payment.ClaimPaymentItem(nPaymentIndex).CurrencyRate = oCurrency.TransactionCurrencyRate
                    Dim oClaimPaymentTaxItems As New NexusProvider.ClaimPaymentTaxItem
                    oClaimOpen.ClaimPeril(nPeril).Reserve(nPaymentIndex).RevisedReserve = 0
                    If .ClaimReserve(nPaymentIndex).CurrentReserve < 0 Then
                        oClaimOpen.ClaimPeril(nPeril).Reserve(nPaymentIndex).RevisedReserve = .ClaimReserve(nPaymentIndex).CurrentReserve * -1
                    End If
        
                    'Assigning of the PayQueue
                    bFirstElement = True
                    For nCount As Integer = 0 To .ClaimReserve.Count - 1
                        If .ClaimReserve(nCount).PayQueue > 0 Then
                            bFirstElement = False
                            Exit For
                        End If
                    Next
                    If bFirstElement Then
                        .ClaimReserve(nPaymentIndex).PayQueue = 1
                        oClaimOpen.ClaimPeril(nPeril).Payment.ClaimPaymentItem(nPaymentIndex).PayQueue = 1
                    End If
        
                    Dim dBalanceAmount As Double = 0
                    dBalanceAmount = .ClaimReserve(nPaymentIndex).OldReserve - Math.Round(CDec(sPaymentAmount), 2)
                    .ClaimReserve(nPaymentIndex).CurrentReserve = CDbl(dBalanceAmount)
                    If (dBalanceAmount > 0) Then
                        If .ClaimReserve(nPaymentIndex).CurrentReserve <> String.Format(sFormatString, CDec(dBalanceAmount)) Then
                            UpdateReserve(oClaimOpen, nPeril, nPaymentIndex, dBalanceAmount)
                        End If
                    End If
                End With
                Session(CNClaim) = oClaimOpen
                If Not cPaymentCollection.ContainsKey(nPeril) Then
                       cPaymentCollection.Add(nPeril, htPaymentDetails)
                End If
              
                bAddPayment = True       
            Catch ex As Exception
                Return bAddPayment
            Finally
                oClaimOpen = Nothing
                oClaimOpen = Nothing
                oQuote = Nothing
                oWebservice = Nothing
                oTaxGroupCollection = Nothing
                oClaimPayment = Nothing
                oOptionSettings = Nothing
                oCurrency = Nothing
            End Try
            Return bAddPayment
        End Function
        
        
        Sub UpdateReserve(ByRef oClaim As NexusProvider.ClaimOpen, nPeril As Integer, nPaymentIndex As Integer, sBalanceAmount As String)
            Dim oModeClaim As Mode = CType(Session.Item(CNMode), Mode)
            Dim sAmount As String = sBalanceAmount
            Dim dTaxAmount As Decimal = 0D
            Dim sOption As String
        
            Try
                Session(CNLockPaymentGrid) = True
                oClaim.ClaimPeril(nPeril).PerilEdited = True
                sOption = oWebService.GetProductRiskOptionValue(NexusProvider.ProductConfigActionType.ProductRiskMaintenance, NexusProvider.ProductRiskOptions.IsGrossClaimPaymentAmount, NexusProvider.RiskTypeOptions.None, Session(CNProductCode), Nothing)
                If oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).BaseReserveKey <> 0 Then
                    If String.IsNullOrEmpty(sAmount) = False Then
                        Dim dAmountToBePaid As Decimal
                        If oClaim.ClaimPeril(nPeril).ClaimReserve IsNot Nothing AndAlso oClaim.ClaimPeril(nPeril).ClaimReserve.Count > 0 Then
                            If sOption = "1" Then
                                Decimal.TryParse(oClaim.ClaimPeril(nPeril).ClaimReserve(nPaymentIndex).ThisPaymentINCLTax, dAmountToBePaid)
                            Else
                                Decimal.TryParse(oClaim.ClaimPeril(nPeril).ClaimReserve(nPaymentIndex).ThisPaymentINCLTax - oClaim.ClaimPeril(nPeril).ClaimReserve(nPaymentIndex).ThisPaymentTax, dAmountToBePaid)
                            End If
                        End If
                        oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).CurrentReserve += CDbl(sAmount) - (oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).InitialReserve + oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).RevisedReserve - oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).PaidAmount - dAmountToBePaid)
                        If sOption = "1" Then
                            oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).RevisedReserve += CDbl(sAmount) - (oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).InitialReserve + oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).RevisedReserve - oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).PaidAmount - dAmountToBePaid)
                        Else
                            oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).RevisedReserve += CDbl(sAmount) - (oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).InitialReserve + oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).RevisedReserve - oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).PaidAmount - (dAmountToBePaid - dTaxAmount))
                        End If
        
        
                        If CDbl(sAmount) < 0 Then
                            oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).RevisedReserve = sAmount * -1
                        End If
                        'Flag to check which reserve has been updated it need to be updated in DB
        
                        oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).ReserveEdited = True
                    Else
                        'Flag to check which reserve has been updated it need to be updated in DB
                        oClaim.ClaimPeril(nPeril).Reserve(nPaymentIndex).ReserveEdited = False
                    End If
                End If
                Session.Item(CNClaim) = oClaim
            Catch ex As Exception
            Finally
                oModeClaim = Nothing
            End Try
        End Sub
        
        Function PopulateReserveItem(iPeril As Integer) As Boolean
            Dim oClaimOpen As NexusProvider.ClaimOpen = Nothing
            Dim oClaimPayment As New NexusProvider.ClaimPayment
            Dim oQuote As NexusProvider.Quote = CType(Session(CNClaimQuote), NexusProvider.Quote)
            Dim bIsPaymentPopulated As Boolean = False
            Try
                oClaimOpen = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen)
                For Each oCPeril As NexusProvider.PerilSummary In oClaimOpen.ClaimPeril
                    For Each oReserveItem As NexusProvider.Reserve In oCPeril.Reserve
                        If oReserveItem.BaseReserveKey <> 0 Then
                            Dim oClaimPaymentItem As New NexusProvider.ClaimPaymentItemType
                            Dim oClaimReserve As New NexusProvider.ClaimPerilReservePaymentType
                            oClaimPayment.BaseReserveKey = oReserveItem.BaseReserveKey
                            oClaimPaymentItem.BaseReserveKey = oReserveItem.BaseReserveKey
        
                            With oClaimReserve
                                .TypeCode = oReserveItem.TypeCode
                                .BaseReserveKey = oReserveItem.BaseReserveKey
        
                                'Total Tax Paid and Amount Paid
                                If oClaimOpen.ClaimPeril(iPeril).ClaimPayment IsNot Nothing Then
                                    Dim dPaymentBaseReserveKey As Integer = 0
                                    For iCount As Integer = 0 To oClaimOpen.ClaimPeril(iPeril).ClaimPayment.Count - 1
                                        For kCount As Integer = 0 To oClaimOpen.ClaimPeril(iPeril).ClaimPayment(iCount).PaymentItems.Count - 1
                                            If oClaimOpen.ClaimPeril(iPeril).ClaimPayment(iCount).PaymentItems IsNot Nothing _
                                                                    AndAlso oClaimOpen.ClaimPeril(iPeril).ClaimPayment(iCount).PaymentItems.Count > 0 Then
                                                dPaymentBaseReserveKey = oClaimOpen.ClaimPeril(iPeril).ClaimPayment(iCount).PaymentItems(kCount).BaseReserveKey
                                            End If
        
                                            If dPaymentBaseReserveKey = oReserveItem.BaseReserveKey Then
                                                If dPaymentBaseReserveKey = oClaimOpen.ClaimPeril(iPeril).ClaimPayment(iCount).PaymentItems(kCount).BaseReserveKey Then
                                                    .PaidToDateTax += oClaimOpen.ClaimPeril(iPeril).ClaimPayment(iCount).PaymentItems(kCount).LossTaxAmount
                                                    .PaidToDate += oClaimOpen.ClaimPeril(iPeril).ClaimPayment(iCount).PaymentItems(kCount).LossAmount
        
                                                    ''Only View Mode will retrive Latest Payment details
                                                    If oClaimOpen.ClaimVersionDescription <> "Maintained Claim" Then
                                                        If Session(CNMode) = Mode.ViewClaim OrElse CType(Session(CNMode), Mode) = Mode.ViewClaimPayment OrElse CType(Session(CNMode), Mode) = Mode.Authorise OrElse CType(Session(CNMode), Mode) = Mode.DeclinePayment OrElse CType(Session(CNMode), Mode) = Mode.Recommend Then
                                                            .ThisPaymentTax = oClaimOpen.ClaimPeril(iPeril).ClaimPayment(iCount).PaymentItems(kCount).LossTaxAmount
                                                            .ThisPaymentINCLTax = oClaimOpen.ClaimPeril(iPeril).ClaimPayment(iCount).PaymentItems(kCount).LossAmount + .ThisPaymentTax
                                                            .CostToClaim = .ThisPaymentINCLTax - .ThisPaymentTax
                                                        End If
        
                                                        If (Session(CNMode) = Mode.ViewClaim OrElse CType(Session(CNMode), Mode) = Mode.ViewClaimPayment) Then
                                                            .ThisRevision = oClaimOpen.ClaimPeril(iPeril).ClaimPayment(iCount).PaymentItems(kCount).ThisRevision
                                                        End If
                                                    End If
                                                End If
                                            End If
                                        Next
        
                                    Next
                                End If
                                .PaidToDate = oReserveItem.PaidAmount
                                .TotalReserve = oReserveItem.InitialReserve + oReserveItem.RevisedReserve
                                .IsExcess = oReserveItem.IsExcess
                                .IsIndemnity = oReserveItem.IsIndemnity
                                .IsExpense = oReserveItem.IsExpense
        
                                'Calculation of Current Reserve and other values
                                If oReserveItem.IsExcess Then
                                    .CurrentReserve = (oReserveItem.InitialReserve + oReserveItem.RevisedReserve) + (- .PaidToDate)
                                Else
                                    .CurrentReserve = .TotalReserve - .PaidToDate
                                End If
                                If .OldReserve <= 0.0 Then
                                    .OldReserve = .CurrentReserve
                                End If
        
                                If Session.Item(CNReserveDescriptions) IsNot Nothing Then
                                    Dim oReserveDescriptions As Hashtable = Session.Item(CNReserveDescriptions)
                                    Dim HData As DictionaryEntry
                                    For Each HData In oReserveDescriptions
                                        If HData.Key.ToString.Trim.ToUpper = oReserveItem.TypeCode.Trim.ToUpper Then
                                            .Description = HData.Value
                                        End If
                                    Next
                                End If
                            End With
                            'All claim reserve will be added
                            If oCPeril.ClaimReserve IsNot Nothing Then
                                oCPeril.ClaimReserve.Add(oClaimReserve)
                            End If
                            'Only selected peril will have payment item
                            If oClaimOpen.ClaimPeril(iPeril).ClaimPerilKey = oCPeril.ClaimPerilKey Then
                                oClaimPayment.ClaimPaymentItem.Add(oClaimPaymentItem)
                            End If
                        End If
                    Next
                Next
        
                'Updating values into oClaimPayment object
                oClaimPayment.LossCurrencyCode = oClaimOpen.CurrencyISOCode  'Issue126
                oClaimPayment.RiskType = oQuote.Risks(0).Description
                oClaimPayment.BaseClaimKey = oClaimOpen.BaseClaimKey
                oClaimPayment.BaseClaimPerilKey = oClaimOpen.ClaimPeril(iPeril).BaseClaimPerilKey
                oClaimPayment.ClientKey = oClaimOpen.Client.PartyKey
                oClaimOpen.ClaimPeril(iPeril).Payment = oClaimPayment
                Session(CNClaim) = oClaimOpen
                bIsPaymentPopulated = True
            Catch ex As Exception
                Return bIsPaymentPopulated
            Finally
                oClaimOpen = Nothing
                oClaimPayment = Nothing
                oQuote = Nothing
            End Try
            Return bIsPaymentPopulated
        End Function
        
        Function SavePaymentData(nPerilIndex As Integer, htPaymentDetails As Hashtable) As Boolean
            Dim nPeril As Integer = nPerilIndex
            Dim bIsPaymentSaved As Boolean = False
            Dim oWebservice As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
            Dim oPortal As Nexus.Library.Config.Portal = oNexusConfig.Portals.Portal(CMS.Library.Portal.GetPortalID())
            Dim oQuote As NexusProvider.Quote = CType(Session(CNClaimQuote), NexusProvider.Quote)
            Dim oClaimOpen As NexusProvider.ClaimOpen = CType(Session(CNClaim), NexusProvider.ClaimOpen)
            Dim oAddress As NexusProvider.Address = Nothing
            Dim oPayClaimResponse As NexusProvider.PayClaimResponse = Nothing
        
            Try
                If Session(CNMode) = Mode.PayClaim Then
                    oClaimOpen.ClaimPeril(nPeril).Payment.BaseClaimKey = oClaimOpen.BaseClaimKey
                    oClaimOpen.ClaimPeril(nPeril).Payment.BaseClaimPerilKey = oClaimOpen.ClaimPeril(nPeril).BaseClaimPerilKey
                    oClaimOpen.ClaimPeril(nPeril).Payment.PartyPaidName = Trim(htPaymentDetails("PAYEE_NAME"))
                    oClaimOpen.ClaimPeril(nPeril).Payment.UltimatePayee = Trim(htPaymentDetails("PAYEE_NAME"))
                    oClaimOpen.ClaimPeril(nPeril).Payment.IsExGratia = htPaymentDetails("IS_EXGRATIA")
                    ' If Not String.IsNullOrEmpty(htPaymentDetails("OUR_REF")) Then
                        ' oClaimOpen.ClaimPeril(nPeril).Payment.OurRef = Trim(htPaymentDetails("OUR_REF"))
                    ' End If
        
                    With oClaimOpen.ClaimPeril(nPeril).Payment.Payee
                        'Dim iPartyBankKey As Integer
                        'Integer.TryParse(ddlAccountType.SelectedValue, iPartyBankKey)
                        '.PartyBankKey = iPartyBankKey
                        '.PartyBankKey = PAYMENT_DETAILS__Account_Type.Value
                        ' If (Not String.IsNullOrEmpty(htPaymentDetails("ACCOUNT_TYPE"))) Then
                          ' .PartyBankKey = htPaymentDetails("ACCOUNT_TYPE")
                        ' End If
                        .MediaReference = htPaymentDetails("MEDIA_REF")
                        .MediaTypeCode = htPaymentDetails("MEDIA_TYPECODE")
                        .Name = Trim(htPaymentDetails("PAYEE_NAME"))
                       ' .TheirReference = Trim(htPaymentDetails("THEIR_REF"))
                        '.Comments = htPaymentDetails("COMMENTS")
                        '.BankCode = Trim(htPaymentDetails("BRANCH_CODE"))
                        '.BankName = Trim(htPaymentDetails("BANK_NAME"))
                       ' .BankNumber = Trim(htPaymentDetails("BANK_ACCOUNT_NO"))
                        '.BIC = Trim(htPaymentDetails("BIC"))
                        '.IBAN = Trim(htPaymentDetails("IBAN"))
        
                        '.Address.Address1 = htPaymentDetails("ADDRESS_LINE1")
                       ' .Address.Address2 = htPaymentDetails("ADDRESS_LINE2")
                        '.Address.Address3 = htPaymentDetails("ADDRESS_LINE3")
                        '.Address.Address4 = htPaymentDetails("ADDRESS_LINE4")
                       ' .Address.AddressType = NexusProvider.AddressType.CorrespondenceAddress
                       ' .Address.CountryCode = htPaymentDetails("COUNTRYCODE")
                       ' .Address.CountryDescription = ""
                       ' .Address.PostCode = htPaymentDetails("POSTCODE")
                    End With
        
                End If
        
                        Select Case htPaymentDetails("PAYEE_TYPECODE")
                            ' Case "AGENT"
                                ' oClaimOpen.ClaimPeril(nPeril).Payment.PaymentPartyType = NexusProvider.ClaimPaymentPartyTypeType.AGENT
                                ' oClaimOpen.ClaimPeril(nPeril).Payment.PartyPaidCode = oQuote.AgentCode
                            Case "CLIENT"
                                oClaimOpen.ClaimPeril(nPeril).Payment.PaymentPartyType = NexusProvider.ClaimPaymentPartyTypeType.CLIENT
                                oClaimOpen.ClaimPeril(nPeril).Payment.PartyPaidCode = oClaimOpen.ClientShortName
                            Case "PARTY"
                                oClaimOpen.ClaimPeril(nPeril).Payment.PaymentPartyType = NexusProvider.ClaimPaymentPartyTypeType.PARTY
                                oClaimOpen.ClaimPeril(nPeril).Payment.PartyPaidCode = oClaimOpen.ClaimPeril(nPeril).Payment.PartyPaidCode
                                oClaimOpen.ClaimPeril(nPeril).Payment.PartyKey = htPaymentDetails("PARTY_KEY")
                            ' Case "INSURED"
                                ' oClaimOpen.ClaimPeril(nPeril).Payment.PaymentPartyType = NexusProvider.ClaimPaymentPartyTypeType.CLIENT
                                ' oClaimOpen.ClaimPeril(nPeril).Payment.PartyPaidCode = oClaimOpen.ClaimPeril(nPeril).Payment.PartyPaidCode
                            Case "CLMPAYABLE"
                                oClaimOpen.ClaimPeril(nPeril).Payment.PaymentPartyType = NexusProvider.ClaimPaymentPartyTypeType.CLMPAYABLE
                                oClaimOpen.ClaimPeril(nPeril).Payment.PartyPaidCode = "CLMPAYABLE"
                        End Select
        
                Session(CNClaim) = oClaimOpen
                If Session(CNMode) = Mode.PayClaim Then
                    Dim oPayment As NexusProvider.ClaimPayment = CType(Session(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(Session(CNClaimPerilIndex)).Payment
                    Dim oInitialClaim As NexusProvider.ClaimOpen = CType(Session(CNClaim), NexusProvider.ClaimOpen)
                    Dim bTimeStamp As Byte() = CType(Session(CNClaimTimeStamp), Byte())
        
                    Try
                        If Session(CNPayClaimError) Is Nothing Then
                            UpdatePaymentData(nPeril)
                        End If
                    Catch ex As NexusProvider.NexusException
                        If ex.Errors(0).Code = "1000151" Then
                            oPayClaimResponse = New NexusProvider.PayClaimResponse
                            Dim oWarning As New NexusProvider.Warnings
                            oPayClaimResponse.Warnings = New NexusProvider.WarningCollection
                            oWarning.Code = ex.Errors(0).Code
                            oWarning.Description = ex.Errors(0).Description
                            oPayClaimResponse.Warnings.Add(oWarning)
                            Session(CNPayClaimError) = oPayClaimResponse
                            Session(CNEnablePayClaim) = True
                        End If
                        If ex.Errors(0).Code = "1000152" Then
                            oPayClaimResponse = New NexusProvider.PayClaimResponse
                            Dim oWarning As New NexusProvider.Warnings
                            oPayClaimResponse.Warnings = New NexusProvider.WarningCollection
                            oWarning.Code = ex.Errors(0).Code
                            oWarning.Description = ex.Errors(0).Description
                            oPayClaimResponse.Warnings.Add(oWarning)
                            Session(CNPayClaimError) = oPayClaimResponse
                            Session(CNEnablePayClaim) = True
                        End If
                    End Try
        
                    Dim sOption As String
                    sOption = oWebservice.GetProductRiskOptionValue(NexusProvider.ProductConfigActionType.ProductRiskMaintenance, NexusProvider.ProductRiskOptions.IsGrossClaimPaymentAmount, NexusProvider.RiskTypeOptions.None, Session(CNProductCode), Nothing)
                    If String.IsNullOrEmpty(sOption) Then
                        sOption = "0"
                    End If
                    Dim dPaidAmount As Decimal
                    For i As Integer = 0 To oClaimOpen.ClaimPeril(nPeril).ClaimReserve.Count - 1
                        If sOption = "1" Then
                            dPaidAmount = dPaidAmount + oClaimOpen.ClaimPeril(nPeril).ClaimReserve(i).ThisPaymentINCLTax - oClaimOpen.ClaimPeril(nPeril).ClaimReserve(i).ThisPaymentTax
                        Else
                            dPaidAmount = dPaidAmount + oClaimOpen.ClaimPeril(nPeril).ClaimReserve(i).ThisPaymentINCLTax
                        End If
                    Next
                    oClaimOpen.ClaimPeril(nPeril).TotalPaidAmount = oClaimOpen.ClaimPeril(nPeril).PaidAmount + dPaidAmount
        
                ElseIf Session(CNMode) = Mode.SalvageClaim Or Session(CNMode) = Mode.TPRecovery Then
                    Session(CNEnablePayClaim) = True
                End If
        
                Session(CNClaim) = oClaimOpen
                bIsPaymentSaved = True
            Catch ex As Exception
                Return bIsPaymentSaved
            Finally
                oWebservice = Nothing
                oNexusConfig = Nothing
                oPortal = Nothing
                oQuote = Nothing
                oClaimOpen = Nothing
                oAddress = Nothing
                oPayClaimResponse = Nothing
            End Try
            Return bIsPaymentSaved
        End Function
        
        Sub UpdatePaymentData(iPeril As Integer)
            Dim oClaim As NexusProvider.ClaimOpen = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen)
            Dim oModeClaim As Mode = CType(Session.Item(CNMode), Mode)
            Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
            Dim oPortal As Nexus.Library.Config.Portal = oNexusConfig.Portals.Portal(CMS.Library.Portal.GetPortalID())
        
            oClaim.ClaimPeril(iPeril).Payment.IsExGratia = False
            oClaim.ClaimPeril(iPeril).PerilEdited = True
            Session.Item(CNClaim) = oClaim
        
            'if peril screen is not configured then need to validate the reserve with coreperilscreen code
            Dim oPayment As NexusProvider.ClaimPayment = CType(Session(CNClaim), NexusProvider.ClaimOpen).ClaimPeril(iPeril).Payment
            Dim oWebservice As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            Dim oClaimResponse As NexusProvider.ClaimResponse = Nothing
            Dim oQuote As NexusProvider.Quote = Session(CNClaimQuote)
            Dim sBranchCode As String = oQuote.BranchCode
            Dim nProcessType As Integer = 4
            oPayment.ClaimKey = oClaim.ClaimKey
        
            If Session(CNMode) = Mode.PayClaim Then
                Dim m_sIsPaymentsReadOnly As String = oWebservice.GetProductRiskOptionValue(NexusProvider.ProductConfigActionType.ProductRiskMaintenance, NexusProvider.ProductRiskOptions.IsPaymentsReadOnly, NexusProvider.RiskTypeOptions.None, Current.Session(CNProductCode), Nothing)
                If m_sIsPaymentsReadOnly = "1" Then
                    GetClaimDetails(CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimKey, Nothing)
                    SetScriptPayment()
                    Dim oClaimOpen As NexusProvider.ClaimOpen = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen)
                    oClaimOpen.ClaimPeril(iPeril).Payment = oPayment
                    Session.Item(CNClaim) = oClaimOpen
                    nProcessType = 5
                End If
                oClaimResponse = UpdateClaimReservesOrPaymentsCall(oClaim, oPayment, Session.Item(CNClaimTimeStamp), nProcessType, sBranchCode)
                If oClaimResponse Is Nothing Then
                    Exit Sub
                End If
            End If
            Session(CNPayClaim) = oClaimResponse
        End Sub
        
        'For updateing reserves For claim reinsurance 
        Sub UpdateReserveData()
                    Dim oClaim As NexusProvider.ClaimOpen = CType(Session.Item(CNClaim), NexusProvider.ClaimOpen)
                    Dim oModeClaim As Mode = CType(Session.Item(CNMode), Mode)
                    Dim oNexusConfig As Config.NexusFrameWork = CType(ConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
                    Dim oPortal As Nexus.Library.Config.Portal = oNexusConfig.Portals.Portal(CMS.Library.Portal.GetPortalID())
        
                    Session.Item(CNClaim) = oClaim
        
                    'if peril screen is not configured then need to validate the reserve with coreperilscreen code
                    Dim oWebservice As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                    Dim oClaimResponse As NexusProvider.ClaimResponse = Nothing
                    Dim oQuote As NexusProvider.Quote = Session(CNClaimQuote)
                    Dim sBranchCode As String = oQuote.BranchCode
                    Dim nProcessType As Integer = 1
                    'oPayment.ClaimKey = oClaim.ClaimKey
        
                    If Session(CNMode) = Mode.NewClaim Then
                        nProcessType = 1
                        oClaimResponse = UpdateClaimReservesOrPaymentsCall(oClaim, Nothing, Session.Item(CNClaimTimeStamp), nProcessType, sBranchCode)
                        If oClaimResponse Is Nothing Then
                            Exit Sub
                        End If
                    ElseIf Session(CNMode) = Mode.EditClaim Then
                        nProcessType = 2
                        oClaimResponse = UpdateClaimReservesOrPaymentsCall(oClaim, Nothing, Session.Item(CNClaimTimeStamp), nProcessType, sBranchCode)
                        If oClaimResponse Is Nothing Then
                            Exit Sub
                        End If
                    End If
                    Session(CNPayClaim) = oClaimResponse
                End Sub
        
        Public Sub UpdateClaimXML(ByVal sObjectName As String, ByVal sFieldName As String, ByVal sFieldValue As String, Optional ByVal bIsDelete As Boolean = False, Optional ByVal sOINumber As String = "")
            Dim oDataSet As New SiriusFS.SAM.Client.DataSetControl.Application
            Dim sDatasetXml As String = String.Empty
            Dim oNode As XmlNode
            'get the dataset definition
            'Dim oQuote As NexusProvider.Quote = System.Web.HttpContext.Current.Session(CNQuote)
            sDatasetXml = Current.Session(CNDataSet)
            Dim sDataSetDefinition As String = Nexus.DataSetFunctions.ClaimGetDataSetDefinition()
            'load dataset into SAM client
            oDataSet.LoadFromXML(sDataSetDefinition, sDatasetXml)
        
            Dim srXMLDataset As String = Current.Session(CNDataSet)
            Dim oDoc As New XmlDocument
            oDoc.LoadXml(srXMLDataset)
        
            If Not String.IsNullOrEmpty(sOINumber) Then
                oNode = oDoc.SelectSingleNode("//" & Session.Item(CNDataModelCode) & "_POLICY_BINDER/" & sObjectName & "[@OI='" & sOINumber & "']")
            Else
                oNode = oDoc.SelectSingleNode("//" & Session.Item(CNDataModelCode) & "_POLICY_BINDER/" & sObjectName)
            End If
        
            Dim swContent As New System.IO.StringWriter
            Dim xmlwContent As New XmlTextWriter(swContent)
            oDataSet.SetPropertyValue(sObjectName, sFieldName, oNode.Attributes("OI").Value, sFieldValue, False)
        
            If oNode.Attributes("US").Value <> "1" Then
                ' oDataSet.SetPropertyValue(sObjectName, "US", oNode.Attributes("OI").Value, "2", True)
            End If
        
            oDoc.WriteTo(xmlwContent)
            sDatasetXml = swContent.ToString()
            oDataSet.ReturnAsXML(sDatasetXml)
            Current.Session(CNDataSet) = sDatasetXml
            xmlwContent.Close()
            swContent.Close()
        End Sub
        
        Protected Sub RunDefaultRule()
            Const kTRANSACTIONTYPE_OpenClaim As String = "C_CO"
            Const kTRANSACTIONTYPE_MaintainClaim As String = "C_CR"
            Const kTRANSACTIONTYPE_PayClaim As String = "C_CP"
            'run default rules edit to populate the category and Special fields on the screen on the basis of version selected as per "Date Of Incident"
            Dim sXMLDataset As String = DirectCast(Session(CNDataSet), System.Object)
            Dim oClaimQuote As NexusProvider.Quote = Session(CNClaimQuote)
            Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            Dim v_bSkipSaveToDB As Boolean = False
            Dim sScreenCode As String = "GNRCL"
            Dim sTransactionType As String = ""
        
            If CType(Session.Item(CNMode), Mode) = Mode.NewClaim Then
                sTransactionType = kTRANSACTIONTYPE_OpenClaim
            ElseIf CType(Session.Item(CNMode), Mode) = Mode.EditClaim Then
                sTransactionType = kTRANSACTIONTYPE_MaintainClaim
            ElseIf CType(Session.Item(CNMode), Mode) = Mode.PayClaim Then
                sTransactionType = kTRANSACTIONTYPE_PayClaim
            End If
            Session(CNDataSet) = oWebService.RunDefaultRulesEdit(sScreenCode, sXMLDataset, Nothing, oClaimQuote.BranchCode, sTransactionType)
        
        End Sub
        
        ''' <summary>
        ''' Gets a single value from the risk dataexc
        ''' </summary>
        ''' <param name="sPath">Path in XML to the required attribute</param>
        ''' <param name="sAttribute">Attribute value to fetch</param>
        ''' <returns></returns>
        ''' <remarks>If path specified contains more than one node, then the value from the first node is returned</remarks>
        Protected Function GetValue(ByVal sPath As String, ByVal sAttribute As String) As String
            Dim xNode As XmlNodeList = GetXmlNodes(sPath)
            If xNode IsNot Nothing Then
                If xNode.Item(0) IsNot Nothing Then
                    If xNode.Item(0).Attributes(sAttribute) IsNot Nothing Then
                        Return xNode.Item(0).Attributes(sAttribute).Value.ToString
                    End If
                End If
            End If
            'there's nothing to return, so return nothing
            Return Nothing
        End Function
        
        ''' <summary>
        ''' Returns an XML node list from the specified path in the current risk dataset
        ''' </summary>
        ''' <param name="sPath"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Function GetXmlNodes(ByVal sPath As String) As XmlNodeList
        
            Dim srDataset As New System.IO.StringReader(System.Web.HttpContext.Current.Session(CNDataSet))
            Dim xmlTR As New XmlTextReader(srDataset)
            Dim Doc As New XmlDocument
            Doc.Load(xmlTR)
            xmlTR.Close()
        
            Try
                'return the nodes from the selected path, use current datamodel code from session
                Return Doc.SelectNodes("//" & Session.Item(CNDataModelCode) & "_POLICY_BINDER/" & sPath)
            Catch ex As System.Exception
                'an invalid path will result in an exception, return nothing instead
                Return Nothing
            End Try
        End Function
        
        Protected Function GetListItemCodefromID(ByVal sListType As String, ByVal sListCode As String, ByVal iItemId As String) As String
            Dim sItemCode As String = String.Empty
        
            Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
            Dim oList As New NexusProvider.LookupListCollection
        
            ' SAM call to retrieve the list of items from user defined list
            If sListType = "UserDefined" Then
                oList = oWebService.GetList(NexusProvider.ListType.UserDefined, sListCode, False, False)
            Else
                oList = oWebService.GetList(NexusProvider.ListType.PMLookup, sListCode, False, False)
            End If
        
            ' Get code for ID
            For iListCount As Integer = 0 To oList.Count - 1
                If oList(iListCount).Key = iItemId Then
                    sItemCode = oList(iListCount).Code
                    Exit For
                End If
            Next
            Return sItemCode
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
             
        
          Protected Shadows Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
                               Dim oClaim As NexusProvider.Claim = CType(Session(CNClaim), NexusProvider.Claim)
        
                    Dim sXMLDataset As String = DirectCast(Session(CNDataSet), System.Object)
        
                    Dim sTransactionType As String = String.Empty
                    If CType(Session.Item(CNMode), Mode) = Mode.NewClaim Then
                        sTransactionType = "NEWCLAIM"
                    ElseIf CType(Session.Item(CNMode), Mode) = Mode.EditClaim Then
                        sTransactionType = "EDITCLAIM"
                    ElseIf CType(Session.Item(CNMode), Mode) = Mode.PayClaim Then
                        sTransactionType = "PAYCLAIM"
                    End If
        
                    SCHEDULE_LOSS__TransactionType.Text = sTransactionType
        
                    If (sTransactionType <> "PAYCLAIM") Then
        
        
                        Dim sReserveId As String = GetAutoNumber("//DNOLBCLAIM/SCHEDULE_LOSS", sXMLDataset)
                        If sReserveId <> "0" Then
                            SCHEDULE_LOSS__ITEM_NUMBER.Text = "L" & sReserveId
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
        
                Public Function GetAutoNumber(ByVal Xpath As String, ByVal strXMLDataSet As String) As String
                    Dim dStrValue As String = "0"
                    If Not String.IsNullOrEmpty(strXMLDataSet) Then
                        Dim srDataset As New System.IO.StringReader(strXMLDataSet)
                        Dim xmlTR As New XmlTextReader(srDataset)
                        Dim Doc As New XmlDocument
                        Doc.Load(xmlTR)
                        xmlTR.Close()
        
                        Dim oNodes As XmlNodeList = Doc.SelectNodes(Xpath)
                        If oNodes IsNot Nothing Then
                            If oNodes.Count = 1 Then
                                dStrValue = oNodes.Count
                            Else
                                Dim oLastNode As XmlNode = oNodes(oNodes.Count - 1)
                                If oLastNode IsNot Nothing Then
                                    If oLastNode.Attributes("ITEM_NUMBER") Is Nothing Then
                                        Dim oNode As XmlNode = oNodes(oNodes.Count - 2)
                                        If oNode IsNot Nothing Then
                                            If oNode.Attributes("ITEM_NUMBER") IsNot Nothing Then
                                                Dim nLossIdValue = CInt(oNode.Attributes("ITEM_NUMBER").Value.Replace("L", "")) + 1
                                                dStrValue = nLossIdValue
                                            End If
                                        End If
                                    End If
                                End If
                            End If
                        End If
                    End If
                    Return dStrValue
                End Function
        		
        		 ' Protected Sub LSRSV__Cover_SelectedIndexChange(sender As Object, e As EventArgs) Handles LSRSV__Cover.SelectedIndexChange
                    ' LSRSV__Sum_Insured.Text = "1000"
                ' End Sub
        	

    End Class
End Namespace