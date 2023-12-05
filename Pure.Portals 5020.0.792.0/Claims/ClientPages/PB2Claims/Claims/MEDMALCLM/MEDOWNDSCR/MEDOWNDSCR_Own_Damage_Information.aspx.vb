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
    Partial Class PB2_MEDOWNDSCR_Own_Damage_Information : Inherits BaseClaim
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

		Protected Sub onValidate_OWNDCLAIM__ITEM_NUMBER()
        
End Sub
Protected Sub onValidate_OWNDCLAIM__BASEPARTYKEY()
          
End Sub
Protected Sub onValidate_OWNDCLAIM__BANKLIST()
              
End Sub
Protected Sub onValidate_OWNDCLAIM__Comments()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_OWNDCLAIM__ITEM_NUMBER()
    onValidate_OWNDCLAIM__BASEPARTYKEY()
    onValidate_OWNDCLAIM__BANKLIST()
    onValidate_OWNDCLAIM__Comments()
End Sub

		             
        
          Protected Shadows Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
                    Dim oClaim As NexusProvider.Claim = CType(Session(CNClaim), NexusProvider.Claim)
        								
                    Dim sXMLDataset As String = DirectCast(Session(CNDataSet), System.Object)
        			Dim keyValue As string = ""
                    Dim sTransactionType As String = String.Empty
                    If CType(Session.Item(CNMode), Mode) = Mode.NewClaim Then
                        sTransactionType = "NEWCLAIM"
                    ElseIf CType(Session.Item(CNMode), Mode) = Mode.EditClaim Then
                        sTransactionType = "EDITCLAIM"
                    ElseIf CType(Session.Item(CNMode), Mode) = Mode.PayClaim Then
                        sTransactionType = "PAYCLAIM"
                    End If
        		
                    OWNDCLAIM__TransactionType.Text = sTransactionType
        					
                    If (sTransactionType <> "PAYCLAIM") Then
        
        
                        Dim sReserveId As String = GetAutoNumber("//MEDMALCLAIM/OWNDCLAIM", sXMLDataset)
                        If sReserveId <> "0" Then
                            OWNDCLAIM__ITEM_NUMBER.Text = "L" & sReserveId
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
        	
    
         
        Protected Shadows Sub Page_Load2(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
                    Dim oParty As NexusProvider.BaseParty = Nothing
                    Dim partyKey As String = Nothing
        
                    If Session(CNParty) IsNot Nothing Then
                        If TypeOf Session(CNParty) Is NexusProvider.CorporateParty Then
        
                            oParty = CType(Session(CNParty), NexusProvider.CorporateParty)
                            partyKey = DirectCast(oParty, NexusProvider.CorporateParty).Key
        
                        ElseIf TypeOf Session(CNParty) Is NexusProvider.PersonalParty Then
        
                            oParty = CType(Session(CNParty), NexusProvider.PersonalParty)
                            partyKey = DirectCast(oParty, NexusProvider.PersonalParty).Key
                        End If
        
                    End If
                    OWNDCLAIM__BASEPARTYKEY.Text = partyKey.ToString
        End Sub
    
         
        		Protected Shadows Sub Page_Load_Bank(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
                    'Check Party Key
                    Dim param = Me.Request("__EVENTARGUMENT")
                    If Not param Is Nothing Then
                        Dim stringSeparators() As String = {","}
                        Dim result() As String
                        result = param.Split(stringSeparators,
                                                      StringSplitOptions.RemoveEmptyEntries)
                        If result.Length > 0 Then
                            Dim command As String = If(Not result(0) Is Nothing, result(0).ToString(), "")
                            If command.ToUpper() = "CLIENTBANK" Then
                                Dim bankDesc As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
                                BankLoad(bankDesc)
                            End If
                        End If
                    End If
        
                End Sub
        
                Protected Sub BankLoad(ByVal code As String)
        
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                    Dim oPartyBankDetails As NexusProvider.BankCollection
                    Dim oParty As NexusProvider.BaseParty = Nothing
                    Dim AccountHolderName As String = ""
                    Dim BankName As String = ""
                    'Dim BankCode As String = ""
                    Dim AccountNumber As String = ""
                    Dim AccountType As String = ""
                    Dim BranchCode As String = ""
                    Dim buildScript As String = ""
                    Dim party_type() As String = code.Split("_")
                    Dim index As Int32 = SafeCInteger(party_type(0))
        
                    oPartyBankDetails = oWebService.GetPartyBankDetails(SafeCInteger(party_type(1)))
        
                    AccountHolderName = oPartyBankDetails.Item(index).AccountHolderName
                    AccountNumber = oPartyBankDetails.Item(index).AccountNumber
                    BankName = oPartyBankDetails.Item(index).BankName
                    'BankCode = DirectCast(oParty, NexusProvider.PersonalParty).BankDetails.Item(index).BankCode
                    AccountType = oPartyBankDetails.Item(index).AccountType
                    BranchCode = oPartyBankDetails.Item(index).BranchCode
        
                    buildScript += jsFormat("Payee_Name", AccountHolderName)
                    buildScript += jsFormat("Bank_Account_No", AccountNumber)
                    buildScript += jsFormat("Bank_Name", BankName)
                    'buildScript += jsFormat("Branch_Code", BankCode)
                    buildScript += jsFormat("Account_Type", AccountType)
                    buildScript += jsFormat("Branch_Code", BranchCode)
        
        
                    CompletePostback(buildScript)
        
                End Sub
        
                Protected Shadows Sub PartyKey_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
                    'Check Party Key
                    Dim param = Me.Request("__EVENTARGUMENT")
                    If Not param Is Nothing Then
                        Dim stringSeparators() As String = {","}
                        Dim result() As String
                        result = param.Split(stringSeparators,
                                                      StringSplitOptions.RemoveEmptyEntries)
                        If result.Length > 0 Then
                            Dim command As String = If(Not result(0) Is Nothing, result(0).ToString(), "")
                            If command.ToUpper() = "PARTY_KEY" Then
                                Dim partyKey As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
                                LoadPartyKey(partyKey)
                            End If
                        End If
                    End If
        
                End Sub
        
                Protected Shadows Sub LoadPartyKey(ByVal partyKey As Int32)
        
                    Dim oNexusFrameWork As Config.NexusFrameWork = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
                    Dim oMaster As ContentPlaceHolder = GetMasterPlaceHolder(Page, oNexusFrameWork.MainContainerName)
                    Dim lScheme As Object = oMaster.FindControl("OWNDCLAIM__BANKLIST")
                    Dim BanktypeList As NexusProvider.LookupListV2 = CType(lScheme, NexusProvider.LookupListV2)
                    Dim AccountType As String = ""
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        			
        			Dim oCustomValidator As New CustomValidator()
                    Dim count As Int32
                    Dim oPartyBankDetails As NexusProvider.BankCollection
                    oPartyBankDetails = oWebService.GetPartyBankDetails(partyKey)
        
                    count = oPartyBankDetails.Count
        
                    Dim BIndex As Int32
        
                    BanktypeList.Items.Clear()
        
                    For BIndex = 0 To count - 1
        				If oPartyBankDetails(BIndex).BankPaymentTypeCode = "CLM" And oPartyBankDetails(BIndex).IsActive = True Then
                            AccountType = "Claims"
                            Dim item As NexusProvider.LookupListItem = New NexusProvider.LookupListItem()
                            item.Key = BIndex + 1
                            item.Code = BIndex & "_" & partyKey
                            item.Description = AccountType & " - " & oPartyBankDetails(BIndex).AccountNumber
                            BanktypeList.Items.Add(item)
        
                        ElseIf oPartyBankDetails(BIndex).BankPaymentTypeCode = "ANY" And oPartyBankDetails(BIndex).IsActive = True Then
                            AccountType = "Any"
                            Dim item As NexusProvider.LookupListItem = New NexusProvider.LookupListItem()
                            item.Key = BIndex + 1
                            item.Code = BIndex & "_" & partyKey
                            item.Description = AccountType & " - " & oPartyBankDetails(BIndex).AccountNumber
                            BanktypeList.Items.Add(item)
        
                        End If
        
                    Next
        			
        			oCustomValidator.IsValid = True
        			If BanktypeList.Items.Count < = 0 Then
        				oCustomValidator.ID = "ValidateBankAccountWarningsReview"
        				oCustomValidator.ErrorMessage = "A valid bank account must be selected to process a claim payment"
        				oCustomValidator.IsValid = False
        			End If
        			Page.Validators.Add(oCustomValidator)
        
        
                End Sub
        
        		
        	Protected Sub CompletePostback(ByVal buildScript As String)
        
                    ScriptManager.RegisterClientScriptBlock(asyncPanel, GetType(UpdatePanel), "asyncPanel",
                                          buildScript,
                                          True)
                    asyncPanel.Update()
        
            End Sub
        
                Public Function SafeCInteger(ByVal obj As Integer) As Integer
                    Dim output As Integer
                    If Integer.TryParse(obj, output) Then
                        Return output
                    Else
                        Return 0
                    End If
                End Function
        
                Public Function jsFormat(ByVal propertyName As String, ByVal result As String) As String
        
                    Return "Field.getInstance('OWNDCLAIM', '" + propertyName + "').setValue('" + result + "');"
        
                End Function
    
        
        Protected Shadows Sub btnNextTop_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNextTop.Click
        	Dim PaymentMethod As String = OWNDCLAIM__PAYMENT_TYPE.Text
        	If CType(Session.Item(CNMode), Mode) = Mode.PayClaim and PaymentMethod = "EFT" Then
        		ValidateBank()
        	End If
        End Sub
        
        Protected Shadows Sub btnNext_Click2(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
        	Dim PaymentMethod As String = OWNDCLAIM__PAYMENT_TYPE.Text
        	If CType(Session.Item(CNMode), Mode) = Mode.PayClaim and PaymentMethod = "EFT" Then
        		ValidateBank()
        	End If
        End Sub
        
        
        Protected Sub ValidateBank()
        
        	Dim oValidationDetailsCollection As NexusProvider.ValidationDetailsCollection
        	Dim oCustomValidator As New CustomValidator()
        
        	'Bank Media ID should always go as '0'
        	Dim iBankMediaId As Integer = 0
        	'Country Id is being hardcoded as 0 since Country is not a mandatory field.
        	Dim iCountryId As Integer = 0
        	'Other fields set to 0 for testing purposes
        	Dim sBIC As String = ""
        	Dim sIBAN As String = ""
        	Dim sBankMediaCode As String = "Bank"
        
        	Dim sAccountNumber As String = OWNDCLAIM__Branch_Code.Text & "|" & OWNDCLAIM__Bank_Account_No.Text & "|" & OWNDCLAIM__Account_Type.Text
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        	Dim sBank As String = OWNDCLAIM__Bank_Name.Text
        	Dim sBankName As String = GetListItemCodefromDesc("PMLookUp", "CashListItem_Bank", sBank)
        
        	oValidationDetailsCollection = oWebService.ValidateBankAccountNumber(iBankMediaId, iCountryId, sAccountNumber, sBankMediaCode, sBIC, sIBAN, sBankName:=sBankName)
        
        	oCustomValidator.IsValid = True
        	If oValidationDetailsCollection(0).IsValid Then
        		oCustomValidator.ID = "ValidateAccept"
        		oCustomValidator.ErrorMessage = "Bank Details are valid"
        		oCustomValidator.IsValid = True
        	Else
        		oCustomValidator.ID = "ValidateBankDetails"
        		oCustomValidator.ErrorMessage = "The Banking details entered are invalid. Please check the Banking details before proceeding to next page"
        		oCustomValidator.IsValid = False
        	End If
        
        	Page.Validators.Add(oCustomValidator)
        
        End Sub
        
        Protected Function GetListItemCodefromDesc(ByVal sListType As String, ByVal sListCode As String, ByVal iItemDesc As String) As String
                    Dim sItemCode As String = String.Empty
        
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
                        If oList(iListCount).Description = iItemDesc Then
                            sItemCode = oList(iListCount).Code
                            Exit For
                        End If
                    Next
                    Return sItemCode
        End Function

    End Class
End Namespace