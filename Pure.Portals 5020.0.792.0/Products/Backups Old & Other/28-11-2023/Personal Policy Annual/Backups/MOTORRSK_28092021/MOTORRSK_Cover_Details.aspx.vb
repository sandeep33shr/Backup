﻿Imports CMS.Library
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
Imports System.IO
Imports System.Net
Imports System.Linq


Namespace Nexus
    Partial Class PB2_MOTORRSK_Cover_Details : Inherits BaseRisk
        Protected iMode As Integer
        Private coverNoteBookKey As Integer = 0
        Dim oWebService As NexusProvider.ProviderBase = Nothing
        Dim FinishButtonClick As Boolean

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
        
		Public Enum DataType As Integer
            DT_Date = 1
            DT_Integer = 2
            DT_Text = 5	'Note - includes String & Label
            DT_Comment = 7
            DT_Checkbox = 20
            DT_Currency = 21
            DT_Percentage = 22
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
            Me.Page.ClientScript.RegisterStartupScript(Me.GetType, "DoLogicStartup", "enableNext(false); BuildComponents(); DoLogic(true); GetLastDivPosition(); enableNext(true);", True)

            If Session(CNQuoteMode) = QuoteMode.ReQuote Then
                Session(CNQuoteMode) = QuoteMode.FullQuote
            End If

            Dim oQuote As NexusProvider.Quote = Session(CNQuote)
            FinishButtonClick = False

			eLifecycleEvent = LifecycleEvent.Page_Load
			CallRuleScripts()
			
			'If first page, remove Back and Finish buttons -- Derick 2019/07/08
			If String.IsNullOrEmpty(ctrlTabIndex.PreviousTab) Then			
				btnFinish.Visible = False
				btnBack.Visible = False			
				btnFinishTop.Visible = False
				btnBackTop.Visible = False
			End If
        End Sub
		
		Protected Shadows Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
            Dim oQuote As NexusProvider.Quote = Session(CNQuote)

            ' Output the XMLDataSet
            XMLDataSet.Text = oQuote.Risks(Session(CNCurrentRiskKey)).XMLDataset.Replace("'", "\'").Replace(vbCr, "").Replace(vbLf, "")

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

        Protected Sub btnFinish_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFinish.Click
            If Page.IsValid Then
                FinishButtonClick = True
                Dim oQuote As NexusProvider.Quote = Session(CNQuote)
                'oQuote.PolicyStatusCode = cboPolicyStatus.Value
                'If ValidTime(PCATLIN__INCEPTIONTIME.Text) = True Then
                '    POLICYHEADER__COVERSTARTDATE.Text = POLICYHEADER__COVERSTARTDATE.Text & " " & PCATLIN__INCEPTIONTIME.Text
                'End If
            End If
			eLifecycleEvent = LifecycleEvent.btnFinish_Click
			CallRuleScripts()
		End Sub

        Protected Sub btnNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
            If Page.IsValid Then
                Dim oQuote As NexusProvider.Quote = Session(CNQuote)
                'oQuote.PolicyStatusCode = cboPolicyStatus.Value
                'If ValidTime(PCATLIN__INCEPTIONTIME.Text) = True Then
                '    POLICYHEADER__COVERSTARTDATE.Text = POLICYHEADER__COVERSTARTDATE.Text & " " & PCATLIN__INCEPTIONTIME.Text
                'End If
            End If
			eLifecycleEvent = LifecycleEvent.btnNext_Click
			CallRuleScripts()
        End Sub
		
        Protected Overrides Sub Render(ByVal writer As HtmlTextWriter)
            'Dim PickListOverrideScripts As String = ("<script src='" & (ResolveClientUrl("~/App_Themes/Catlin/js/PickList.js") & "' type='text/javascript'></script>"))
            'Me.Page.ClientScript.RegisterStartupScript(Me.GetType, "PickListOverrideScripts", PickListOverrideScripts, False)
            'Me.Page.ClientScript.RegisterStartupScript(Me.GetType, "AddValuesToPickList", "addValueToList('ctl00_cntMainBody_PCATLIN__ENDORSEMENTS_PckTemplates_AvailList');", True)
            MyBase.Render(writer)
			eLifecycleEvent = LifecycleEvent.Render
			CallRuleScripts()
        End Sub

		' Fix for pressing the back button when the previous page is main details.
		Public Overrides Sub BackButtonRedirect()
            If String.IsNullOrEmpty(ctrlTabIndex.PreviousTab) = False Then
                Dim urlSegments As String() = ctrlTabIndex.PreviousTab.Split("/")

                If urlSegments.Length > 2 Then
                    Dim aspxPage As String = urlSegments(urlSegments.Length - 1)

                    For i As Integer = urlSegments.Length - 1 To 2 Step -1
                        Dim testUrl As String = String.Join("/", urlSegments, 0, i) + "/" + aspxPage

                        Dim physicalPath As String = Server.MapPath(testUrl)

                        If System.IO.File.Exists(physicalPath) Then
                            Response.Redirect(testUrl)
                            Exit For
                        End If
                    Next
                End If
            End If
        End Sub

		Protected Function GetTransactionType() As String
			If String.IsNullOrEmpty(Session(CNMTAType)) = False Then
			
				If Session(CNMTAType) = MTAType.CANCELLATION Then
					Return "MTC"
				End If

				If Session(CNMTAType) = MTAType.REINSTATEMENT Then
					Return "MTR"
				End If

				If Session(CNMTAType) = MTAType.TEMPORARY Then
					Return "MTATEMP"
				End If

				Return "MTA"
			End If
			
			'	Renewal
			If String.IsNullOrEmpty(Session(CNRenewal)) = False Then
				Return "REN"
			End If
			
			Return CType(Session.Item(Nexus.Constants.Session.CNQuote), NexusProvider.Quote).TransactionType.ToString()
		End Function

		'Remove all empty attributes which are numeric datatypes (inc checkbox)
        Protected Sub StripEmptyAttributes(ByVal sDataSetDefinition As String, ByRef xmlData As String, dataModelCode As String)

            Dim xDoc As XmlDocument = New XmlDocument()
            xDoc.LoadXml(xmlData)

            Dim DSDDoc As XmlDocument = New XmlDocument()
            DSDDoc.LoadXml(sDataSetDefinition)

            'Create a list of empty attributes.
            Dim attrList As XmlNodeList = xDoc.SelectNodes("//@*[not(string())]")

            For i As Integer = 0 To attrList.Count - 1
                Dim attr As XmlAttribute = CType(attrList(i), XmlAttribute)
                If Not attr Is Nothing Then
                    'Obtain the attribute's owner (the containing node, really)
                    Dim elem As XmlElement = attr.OwnerElement
                    If Not elem Is Nothing Then

                        'Now attempt to locate this attribute - by name - in the Data Set Definition
                        Dim selectStr = String.Format("//{0}/{0}.{1}", elem.Name, attr.Name)

                        Dim node As XmlNode = DSDDoc.SelectSingleNode(selectStr)
                        If Not node Is Nothing Then
							'Having located it, retrieve it's datatype
                            Dim data_Type_Str As String = node.Attributes.GetNamedItem("DataType").Value
                            Dim data_Type As Integer = 0

                            'Check that the retrieved datatype is indeed one of our chosen numeric ones.
                            'If so, remove the attribute.
                            If Not String.IsNullOrEmpty(data_Type_Str) AndAlso Int32.TryParse(data_Type_Str, data_Type) Then
                                Select Case data_Type
                                    Case DataType.DT_Integer, DataType.DT_Checkbox, DataType.DT_Currency, DataType.DT_Percentage
                                        elem.RemoveAttributeNode(attr)
                                End Select
                            End If
                        End If
                    End If
                End If
            Next

            xmlData = xDoc.OuterXml

        End Sub
		
		Protected Function IsLastTab() As Boolean
            IsLastTab = String.IsNullOrEmpty(ctrlTabIndex.NextTab)
        End Function
		
		Protected Sub onValidate_GENERAL__PRODCODE()
         
End Sub
Protected Sub onValidate_GENERAL__TRANSTYPE()
        If eLifecycleEvent = LifecycleEvent.Page_Load Then
        		Dim transType, transactionValue
        		If Session(CNMTAType) = MTAType.PERMANENT Or Session(CNMTAType) = MTAType.TEMPORARY Then
        			transactionValue = "MTA"
        		ElseIf Session(CNRenewal) IsNot Nothing Or Session.Item("CNRenewal") IsNot Nothing Then
        			transactionValue = "REN"
        		ElseIf Session(CNMTAType) = MTAType.CANCELLATION Then
        			transactionValue = "MTC"
        		Else
        			transactionValue = "NB"
        		End  If	
        		GENERAL__TRANSTYPE.Text= transactionValue
        End If
End Sub
Protected Sub onValidate_GENERAL__VATNUMBER()
        
End Sub
Protected Sub onValidate_ADDRESS__TOWN()
        
End Sub
Protected Sub onValidate_ADDRESS__COUNTRY()
        
End Sub
Protected Sub onValidate_MOTOR__VEHTYPE()
        
End Sub
Protected Sub onValidate_MOTOR__UNSUPPORTED()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_GENERAL__PRODCODE()
    onValidate_GENERAL__TRANSTYPE()
    onValidate_GENERAL__VATNUMBER()
    onValidate_ADDRESS__TOWN()
    onValidate_ADDRESS__COUNTRY()
    onValidate_MOTOR__VEHTYPE()
    onValidate_MOTOR__UNSUPPORTED()
End Sub

        Protected Shadows Sub Page_Load_MandatesSet(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            Session("SIData") = Nothing
            Session("DiscountData") = Nothing
            Session("InvalidSI") = Nothing
        End Sub

        Protected Shadows Sub GetProdCode(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	 Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	  
        	If Session(CNQuote) IsNot Nothing Then
        		Dim TransactionType 
        		GENERAL__BRANCH.Text = Trim(oQuote.BranchCode).ToString
                GENERAL__PRODCODE.Text = Trim(oQuote.ProductCode).ToString
        		TransactionType = GENERAL__TRANSTYPE.Text
        		
        		If TransactionType ="NB" Then
        			GENERAL__QUOTENUMBER.Text = Trim(oQuote.InsuranceFileRef).ToString
        	    End If
        	End If
        End Sub
    
         Protected Shadows Sub GetVatNumber(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("vatNumber") IsNot Nothing Then
        		GENERAL__VATNUMBER.Text = Session("vatNumber")
         End If
        		 
        End Sub
    
        Protected Shadows Sub Page_Load_Address(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	If Session(CNParty) IsNot Nothing Then
        		'Dim partyKey As Int32 = CType(Session(CNParty), NexusProvider.BaseParty).Key
        			LoadOtherAddressList()
        	End If
        	
        	Dim param = Me.Request("__EVENTARGUMENT")
        			If Not param Is Nothing Then
        			Dim stringSeparators() As String = {","}
        			Dim result() As String
        			result = param.Split(stringSeparators, _
        				  StringSplitOptions.RemoveEmptyEntries)
        			If result.Length > 0 Then
        				Dim command As String = If(Not result(0) Is Nothing, result(0).ToString(), "")
        				If command.ToUpper() = "CLIENTADDRESS" Then
        					Dim addressDesc As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					AddressLoad(addressDesc)				
        				End If
        				If command.ToUpper() = "SITEADDRESS" Then
        					Dim siteDesc As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					OtherAddrLoad(siteDesc)
        				End If
        				
        				If command.ToUpper() = "HOMEADDRESS" Then
        					Dim homeDesc As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					OtherAddrLoad(homeDesc)
        				End If
        				
        				If command.ToUpper() = "BUSINESSADDRESS" Then
        					Dim businessDesc As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					OtherAddrLoad(businessDesc)
        				End If
        			End If
        		End If	
         End Sub
         
        'Correspondence Address Load Query section 
        Protected Sub AddressLoad(ByVal value As String)
        	Dim correspondAddress As NexusProvider.Address = Nothing
        	Dim oParty As NexusProvider.BaseParty = Nothing
        	Dim addressType As String = Nothing 'Added
        	
        	If value = "3131XCO" Then
        		addressType = "Correspondence" ' Added
        	End If
        	If value = "3131XSA" Then 
        		 addressType = "Site" ' Added
        	End If
        
        	If value = "3131002" Then 
        		 addressType = "Business Address" ' Added
        	End If
        	
        	If value = "3131001" Then 
        		 addressType = "Home Address" ' Added
        	End If	
        	
        	If Session(CNParty) IsNot Nothing Then
        		If TypeOf Session(CNParty) Is NexusProvider.BaseParty Then
        			oParty = CType(Session(CNParty), NexusProvider.BaseParty)
        			If addressType = "Correspondence" Then
        				For Each addr As NexusProvider.Address In oParty.Addresses
        					If addr.AddressType = NexusProvider.AddressType.CorrespondenceAddress Then
        						correspondAddress = addr
        						Exit For
        					End If
        				Next
        		
        				If correspondAddress IsNot Nothing Then
        					Dim addressLine As String = correspondAddress.Address1.Trim()
        					Dim town As String = correspondAddress.Address3.Trim()
        					Dim suburb As String = correspondAddress.Address2.Trim()
        					Dim region As String = correspondAddress.Address4.Trim()
        					Dim postCode As String = correspondAddress.PostCode.Trim()
        					Dim country As String = correspondAddress.CountryCode.Trim()
        					Dim ratingArea As String = ""
        				
        					ratingArea = GetListValue("UDL_TOWN_DESC", town, "rating_area")
        				
        					'call postback 
        						addressASyncPostback(addressLine, suburb, town, postCode, country, region, ratingArea)
        				Else
        						addressASyncPostback("", "", "", "", "", "", "")
        					
        				End If
        			End If
        			
        			If (addressType = "Site") OR (addressType = "Business Address") OR (addressType = "Home Address") Then
        				addressASyncPostback("", "", "", "", "", "", "")
        			End If
        		End If	
        	End If
        End Sub
        
        'Load Other Address List Item
        Protected Sub OtherAddrLoad(ByVal value As String)
        	Dim oParty As NexusProvider.BaseParty = Nothing
        	If Session(CNParty) IsNot Nothing Then
        		If TypeOf Session(CNParty) Is NexusProvider.BaseParty Then
        			oParty = CType(Session(CNParty), NexusProvider.BaseParty)
        			Dim OtherAddress As NexusProvider.Address = Nothing
        				For Each addr As NexusProvider.Address In oParty.Addresses
        					If addr.Key = value Then
        						OtherAddress = addr
        					Exit For
        					End If
        				Next
        	
        			If OtherAddress IsNot Nothing Then
        				Dim addressLine As String = OtherAddress.Address1.Trim()
        				Dim town As String = OtherAddress.Address3.Trim()
        				Dim suburb As String = OtherAddress.Address2.Trim()
        				Dim region As String = OtherAddress.Address4.Trim()
        				Dim postCode As String = OtherAddress.PostCode.Trim()
        				Dim country As String = OtherAddress.CountryCode.Trim()
        				Dim ratingArea As String = ""
        				
        				ratingArea = GetListValue("UDL_TOWN_DESC", town, "rating_area")
        				addressASyncPostback(addressLine, suburb, town, postCode, country, region, ratingArea)
        			Else
        				addressASyncPostback("", "", "", "", "", "", "")
        			End If
        		End If
        	End If	
        End Sub	
        
        'Load other Address List Item
        Protected Sub LoadOtherAddressList()
        	Dim oNexusFrameWork As Config.NexusFrameWork = CType(System.Web.Configuration.WebConfigurationManager.GetSection("NexusFrameWork"), Config.NexusFrameWork)
        	Dim oMaster As ContentPlaceHolder = GetMasterPlaceHolder(Page, oNexusFrameWork.MainContainerName)
        	Dim SiteAddressScheme As Object = oMaster.FindControl("ADDRESS__SITEADDRESSLIST")
        	Dim HomeAddressScheme As Object = oMaster.FindControl("ADDRESS__HOMEADDRESSLIST")
        	Dim BusinessAddressScheme As Object = oMaster.FindControl("ADDRESS__B_ADDRESSLIST")
        	
        	Dim siteAddrList As NexusProvider.LookupListV2 = CType(SiteAddressScheme, NexusProvider.LookupListV2)
        	Dim HomeAddrList As NexusProvider.LookupListV2 = CType(HomeAddressScheme, NexusProvider.LookupListV2)
        	Dim BusinessAddrList As NexusProvider.LookupListV2 = CType(BusinessAddressScheme, NexusProvider.LookupListV2)
        	Dim oParty As NexusProvider.BaseParty = Nothing
        	Dim addressType As String = Nothing 'Added
        	
        	'If value = "3131XSA" Then 
        		 'addressType = "Site" ' Added
        	'End If 
        	
        	If Session(CNParty) IsNot Nothing Then
        		If TypeOf Session(CNParty) Is NexusProvider.BaseParty Then
        				oParty = CType(Session(CNParty), NexusProvider.BaseParty)
        			
        			siteAddrList.Items.Clear()
        			HomeAddrList.Items.Clear()
        			BusinessAddrList.Items.Clear()
        			
        				Dim cnt As Integer = 0
        				For Each addr As NexusProvider.Address In oParty.Addresses
                                If addr.AddressType = NexusProvider.AddressType.SiteAddress Then
                                    cnt += 1
                                    Dim item As NexusProvider.LookupListItem = New NexusProvider.LookupListItem()
                                    item.Key = cnt
                                    item.Code = addr.Key
                                    item.Description = addr.Address1
                                    siteAddrList.Items.Add(item)
                                End If
        
                                If addr.AddressType = NexusProvider.AddressType.BusinessAddress Then
                                    cnt += 1
                                    Dim item As NexusProvider.LookupListItem = New NexusProvider.LookupListItem()
                                    item.Key = cnt
                                    item.Code = addr.Key
                                    item.Description = addr.Address1
                                    BusinessAddrList.Items.Add(item)
                                End If
        
                                If addr.AddressType = NexusProvider.AddressType.HomeAddress Then
                                    cnt += 1
                                    Dim item As NexusProvider.LookupListItem = New NexusProvider.LookupListItem()
                                    item.Key = cnt
                                    item.Code = addr.Key
                                    item.Description = addr.Address1
                                    HomeAddrList.Items.Add(item)
                                End If
                        Next
        		End If
        	End If
        End Sub
        
        
        Protected Function GetListValue(ByVal sListCode As String, ByVal itemDesc As String, ByVal sValue As String) As String
                    Dim value As String = String.Empty
                    Dim LstXmlElement As XmlElement = Nothing
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                    Dim oList As New NexusProvider.LookupListCollection
                    oList = oWebService.GetList(NexusProvider.ListType.PMLookup, sListCode, False, False,,,, LstXmlElement)
                    Dim sXML As String = LstXmlElement.OuterXml
                    Dim xmlDoc As New System.Xml.XmlDocument
                    Dim NodeList As XmlNodeList
                    xmlDoc.LoadXml(sXML)
        
                    NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & sListCode)
                    If NodeList.Count > 0 Then
                        value = (From Node As XmlNode In NodeList Where Node.SelectSingleNode("description").InnerText.Trim() = itemDesc Select Node.SelectSingleNode(sValue).InnerText.Trim()).FirstOrDefault()
                    End If
                Return value
         End Function
        
        'Address Postback
        Protected Sub addressASyncPostback(ByVal addressLine as String,ByVal suburb as String,ByVal town as String, ByVal postCode as String, byVal country as String, byVal region as String, byVal vRatingArea as String )
        	Dim buildScript as String = ""
        	buildScript += "Field.getInstance('ADDRESS', 'LINE1').setValue('"+ addressLine +"');"
        	buildScript += "Field.getInstance('ADDRESS', 'SUBURB').setValue('"+ suburb +"');"
        	buildScript += "Field.getInstance('ADDRESS', 'TOWN').setValue('"+ town +"');"
        	buildScript += "Field.getInstance('ADDRESS', 'REGION').setValue('"+ region +"');"
        	buildScript += "Field.getInstance('ADDRESS', 'POSTCODE').setValue('"+ postCode +"');"
        	buildScript += "Field.getInstance('ADDRESS', 'AREACODE').setValue('"+ vRatingArea +"');"
        	buildScript += "Field.getInstance('ADDRESS', 'COUNTRY').setByCode('"+ Trim(country) +"');"
        
        	If addressLine = "" Then
        		buildScript += "Field.getInstance('ADDRESS', 'COUNTRY').setValue(3);"
        	End If
        
           ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "AsyncPostback", buildScript,True)
            asyncPanel.Update()	
        End Sub
         
         
         
         
                 
                 
    
        
        Protected Shadows Sub btnNextTop_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNextTop.Click
        		ValidateAddress()
        End Sub
        
        Protected Shadows Sub btnNext_Click2(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
        		ValidateAddress()
        End Sub
        
        
        Protected Sub ValidateAddress()
        	
        	Dim oCustomValidator As New CustomValidator()
        	
        	Dim Line1 as String = ADDRESS__LINE1.Text
        	Dim Suburb as String = ADDRESS__SUBURB.Text
        	
        	oCustomValidator.IsValid = True
        	
        	If ((Line1 is Nothing OR Line1 = "") AND (Suburb is Nothing Or Suburb = "")) Then
        		oCustomValidator.ID = "ValidateAddressDetails"
        		oCustomValidator.ErrorMessage = "An address must be selected"
        		oCustomValidator.IsValid = False
        	Else
        		oCustomValidator.ID = "ValidateAccept"
        		oCustomValidator.ErrorMessage = "Address is valid"
        		oCustomValidator.IsValid = True
        	End If
        
        	Page.Validators.Add(oCustomValidator)
        
        End Sub
    
        
        Protected Shadows Sub Page_Load_For_Defaults_MOTOR_VEHTYPE(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Page.IsPostBack Then
            'Retreiving Argument from _doPostBack();
            Dim parameter = Me.Request("__EVENTARGUMENT")
            If Not parameter Is Nothing Then
                Dim stringSeparators() As String = {","}
                Dim result() As String
                result = parameter.Split(stringSeparators, _
                            StringSplitOptions.RemoveEmptyEntries)
                If result.Length > 0 Then
                    Dim command As String = If(Not result(0) Is Nothing, result(0).ToString(), "")
                    If command.ToUpper() = "POPULATEDEFAULTS_MOTOR_VEHTYPE".ToUpper() Then
                        If result.Length >= 1 Then
                            Dim onChangeType As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					Dim vCode As String = If(Not result(2) Is Nothing, result(2).ToString(), "")
                            If onChangeType <> "" Then
                                Retrieve_List_Defaults_For_MOTOR_VEHTYPE(onChangeType, vCode)
        						Retrieve_List_Defaults_For_MOTOR_VEHTYPE_KSUMINSMOT(onChangeType, vCode)
        						If vCode = "5" Then
        							Retrieve_List_Defaults_For_MOTOR_VEHTYPE_KMAXALOW(onChangeType, vCode)
        						End If
                            End If
                        End If
                    End If
                End If
            End If
        End If
        
        End Sub
        
        Protected Sub Retrieve_List_Defaults_For_MOTOR_VEHTYPE(ByVal onChangeType As String, ByVal sCode As String)
        
        Dim buildScript As new System.Text.StringBuilder()
        
        Dim ListCode = "UDL_KSTANDXS"
        Dim DepListCode = "UDL_KDEPOSLM"
        
        Dim sNewCode As String = ""
        Dim ProdCode = GENERAL__PRODCODE.Text
        If sCode IsNot Nothing Then
        	If ProdCode = "NSA" Or ProdCode = "NSM" Then
        		Select Case sCode
        			Case "106"
        				sNewCode = "108"
        			Case "126"
        				sNewCode = "128"
        			Case "136"
        				sNewCode = "138"
        			Case "137"
        				sNewCode = "139"
        			Case "196"
        				sNewCode = "198"
        			Case Else
        				sNewCode = sCode
        		End Select
        	Else
        		sNewCode = sCode
        	End If
        End If
        
        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim oList As NexusProvider.LookupListCollection
        Dim oListdep As NexusProvider.LookupListCollection
        Dim XmlList As System.Xml.XmlElement = Nothing
        Dim XmlListDep As System.Xml.XmlElement = Nothing
        Try
            oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        	oListdep = oWebService.GetList(NexusProvider.ListType.PMLookup, DepListCode, True, False, , , , XmlListDep,oQuote.CoverStartDate)
        
        
        If XmlListDep IsNot Nothing Then
        	Dim sXMLD As String = XmlListDep.OuterXml
        	Dim xmlDocd As New System.Xml.XmlDocument
        	Dim NodeListD As XmlNodeList
        	xmlDocd.LoadXml(sXMLD)
        
        	NodeListD = xmlDocd.SelectNodes("/AdditionalDetails/" & DepListCode)
        	If NodeListD IsNot Nothing And NodeListD.Count > 0 Then
        		For Each oNode As XmlNode In NodeListD
        			If onChangeType = "VEHTYPE" Then
        				If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = "1" Then
        					Dim ObjectsPropertiesArray As String() = {"MOTOR.DEPPAIDMAX,Max_Deposit"}
        					Dim x As Integer
        
        					For x = 0 To 15
        						Try
        							Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
        							Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        							Dim sobject = ObjectPropertySplit(0).ToString().Trim()
        							Dim sproperty = ColumnNameSplit(0).ToString().Trim()
        							Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        							
        							If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        								buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        							Else
        								buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        							End If
        						Catch
        							Exit For
        						End Try
        					Next x
        				End If
        			End If
        		Next
        	End If
        End If
        
        If XmlList IsNot Nothing Then
        	Dim sXML As String = XmlList.OuterXml
        	Dim xmlDoc As New System.Xml.XmlDocument
        	Dim NodeList As XmlNodeList
        	xmlDoc.LoadXml(sXML)
        
        	NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
        	If NodeList IsNot Nothing And NodeList.Count > 0 Then
        		For Each oNode As XmlNode In NodeList
        			If onChangeType = "VEHTYPE" Then
        				If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sNewCode Then
        					Dim ObjectsPropertiesArray As String() = {"MOTOR.TMPEXCESSPER,STDXSP", "MOTOR.TMPEXCESSAMNT,STDXSAMT", "MOTOR.TMPWSCRNEXPER,WSXSP", "MOTOR.TMPWSCRNEXAMNT,WSXSAMT", "MOTOR.TMPAUDIO,AEQUIPXSAMT", "MOTOR.TMPTHEFT,THJXSAMT", "{7}", "{8}", "{9}", "{10}", "{11}", "{12}", "{13}", "{14}", "{15}", "{16}"}
        					Dim x As Integer
        
        					For x = 0 To 15
        						Try
        							Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
        							Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        							Dim sobject = ObjectPropertySplit(0).ToString().Trim()
        							Dim sproperty = ColumnNameSplit(0).ToString().Trim()
        							Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        							
        							If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        								buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        							Else
        								buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        							End If
        						Catch
        							Exit For
        						End Try
        					Next x
        				End If
        			End If
        		Next
        		If buildScript.ToString() IsNot "" Then
        			CompleteASyncPostback_For_MOTOR_VEHTYPE(buildScript.ToString())
        		End If
        	End If
        End If
        
        Catch
            Exit Sub
        End Try
        
        End Sub
        
        Protected Sub Retrieve_List_Defaults_For_MOTOR_VEHTYPE_KSUMINSMOT(ByVal onChangeType As String, ByVal sCode As String)
        
        Dim buildScript As new System.Text.StringBuilder()
        
        Dim ListCode = "UDL_KSUMINSMOT"
        
        Dim sNewCode As String = ""
        Dim ProdCode = GENERAL__PRODCODE.Text
        If sCode IsNot Nothing Then
        	If ProdCode = "NSA" Or ProdCode = "NSM" Then
        		Select Case sCode
        			Case "106"
        				sNewCode = "108"
        			Case "126"
        				sNewCode = "128"
        			Case "136"
        				sNewCode = "138"
        			Case "137"
        				sNewCode = "139"
        			Case "196"
        				sNewCode = "198"
        			Case Else
        				sNewCode = sCode
        		End Select
        	Else
        		sNewCode = sCode
        	End If
        End If
        
        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim oList As NexusProvider.LookupListCollection
        Dim XmlList As System.Xml.XmlElement = Nothing
        Try
            oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        
        
        If XmlList IsNot Nothing Then
                Dim sXML As String = XmlList.OuterXml
                Dim xmlDoc As New System.Xml.XmlDocument
                Dim NodeList As XmlNodeList
                xmlDoc.LoadXml(sXML)
        
                NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
                If NodeList IsNot Nothing And NodeList.Count > 0 Then
                    For Each oNode As XmlNode In NodeList
                                    If onChangeType = "VEHTYPE" Then
                                        If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sNewCode Then
                                            Dim ObjectsPropertiesArray As String() = {"MOTOR.MINSI,Min_SI", "MOTOR.REFSI,Referral_SI"}
                                            Dim x As Integer
        
                                            For x = 0 To 15
                                                Try
                                                    Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
                                                    Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                                                    Dim sobject = ObjectPropertySplit(0).ToString().Trim()
                                                    Dim sproperty = ColumnNameSplit(0).ToString().Trim()
                                                    Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        											
        											If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        												buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        											Else
        												buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        											End If
                                                Catch
                                                    Exit For
                                                End Try
                                            Next x
                                        End If
                                    End If
                                Next
        			If buildScript.ToString() IsNot "" Then
        				CompleteASyncPostback_For_MOTOR_VEHTYPE_KSUMINSMOT(buildScript.ToString())
        			End If
                End If
            End If
        
        Catch
            Exit Sub
        End Try
        
        End Sub
        
        Protected Sub Retrieve_List_Defaults_For_MOTOR_VEHTYPE_KMAXALOW(ByVal onChangeType As String, ByVal sCode As String)
        
        Dim buildScript As new System.Text.StringBuilder()
        
        Dim ListCode = "UDL_KMAXALOW"
        
        Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        Dim oList As NexusProvider.LookupListCollection
        Dim XmlList As System.Xml.XmlElement = Nothing
        Try
            oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        
        
        If XmlList IsNot Nothing Then
                Dim sXML As String = XmlList.OuterXml
                Dim xmlDoc As New System.Xml.XmlDocument
                Dim NodeList As XmlNodeList
                xmlDoc.LoadXml(sXML)
        
                NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
                If NodeList IsNot Nothing And NodeList.Count > 0 Then
                    For Each oNode As XmlNode In NodeList
        				If onChangeType = "VEHTYPE" Then
        					If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sCode Then
        						Dim ObjectsPropertiesArray As String() = {"MOTOR.TMPMXKM,MAXKM", "MOTOR.TMPMXAGE,MAXVEHAGE"}
        						Dim x As Integer
        
        						For x = 0 To 15
        							Try
        								Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
        								Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        								Dim sobject = ObjectPropertySplit(0).ToString().Trim()
        								Dim sproperty = ColumnNameSplit(0).ToString().Trim()
        								Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        								
        								If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        									buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        								Else
        									buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        								End If
        							Catch
        								Exit For
        							End Try
        						Next x
        					End If
        				End If
        			Next
                End If
            End If
        	
        	ListCode = "UDL_KBASICXS"
        	
        	oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        
        
        If XmlList IsNot Nothing Then
        	Dim sXML As String = XmlList.OuterXml
        	Dim xmlDoc As New System.Xml.XmlDocument
        	Dim NodeList As XmlNodeList
        	xmlDoc.LoadXml(sXML)
        
        	NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
        	If NodeList IsNot Nothing And NodeList.Count > 0 Then
        		For Each oNode As XmlNode In NodeList
        			If onChangeType = "VEHTYPE" Then
        				If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sCode Then
        					Dim ObjectsPropertiesArray As String() = {"MOTOR.TMPMXSIXMONTH,BXS1TO6M", "MOTOR.TMPMXYEAR,BXS7TO12M", "MOTOR.TMPMXOVERYEAR,BXSO12M"}
        					Dim x As Integer
        
        					For x = 0 To 15
        						Try
        							Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
        							Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        							Dim sobject = ObjectPropertySplit(0).ToString().Trim()
        							Dim sproperty = ColumnNameSplit(0).ToString().Trim()
        							Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        							
        							If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        								buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        							Else
        								buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        							End If
        						Catch
        							Exit For
        						End Try
        					Next x
        				End If
        			End If
        		Next
        		'CompleteASyncPostback_For_MOTOR_VEHTYPE_KBASICXS(buildScript.ToString())
        	End If
        End If
        
        CompleteASyncPostback_For_MOTOR_VEHTYPE_KMAXALOW(buildScript.ToString())
        
        Catch
            Exit Sub
        End Try
        
        End Sub
        
        Protected Sub CompleteASyncPostback_For_MOTOR_VEHTYPE(ByVal buildScript As String)
        ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "AsyncPostback",
        													  buildScript,
        													  True)
        	asyncPanel.Update()
        End Sub
        
        Protected Sub CompleteASyncPostback_For_MOTOR_VEHTYPE_KSUMINSMOT(ByVal buildScript As String)
        ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "",
        													  buildScript,
        													  True)
        	asyncPanel.Update()
        End Sub
        
        Protected Sub CompleteASyncPostback_For_MOTOR_VEHTYPE_KMAXALOW(ByVal buildScript As String)
        ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "",
        													  buildScript,
        													  True)
        	asyncPanel.Update()
        End Sub
    
        
        Protected Shadows Sub Page_Load_For_Defaults_MOTOR_UNSUPPORTED(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Page.IsPostBack Then
            'Retreiving Argument from _doPostBack();
            Dim parameter = Me.Request("__EVENTARGUMENT")
            If Not parameter Is Nothing Then
                Dim stringSeparators() As String = {","}
                Dim result() As String
                result = parameter.Split(stringSeparators, _
                            StringSplitOptions.RemoveEmptyEntries)
                If result.Length > 0 Then
                    Dim command As String = If(Not result(0) Is Nothing, result(0).ToString(), "")
                    If command.ToUpper() = "POPULATEDEFAULTS_MOTOR_UNSUPPORTED".ToUpper() Then
                        If result.Length >= 1 Then
                            Dim onChangeType As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
        					Dim vCode As String = If(Not result(2) Is Nothing, result(2).ToString(), "")
                            If onChangeType <> "" Then
                                Retrieve_List_Defaults_For_MOTOR_UNSUPPORTED(onChangeType, vCode)
        						Retrieve_List_Defaults_For_MOTOR_UNSUPPORTED_KSUMINSMOT(onChangeType, vCode)
                            End If
                        End If
                    End If
        			
        			If command.ToUpper() = "POPULATECHECKBOXDEFAULTS_MOTOR_UNSUPPORTED".ToUpper() Then
                        If result.Length >= 1 Then
                            Dim onChangeType As String = If(Not result(1) Is Nothing, result(1).ToString(), "")
                            Dim vCode As String = If(Not result(2) Is Nothing, result(2).ToString(), "")
                            If onChangeType <> "" Then
                                Retrieve_Checkbox_Defaults_For_MOTOR_UNSUPPORTED(onChangeType, vCode)
        						Retrieve_Checkbox_Defaults_For_MOTOR_UNSUPPORTED_KSUMINSMOT(onChangeType, vCode)
                            End If
                        End If
                    End If
                End If
            End If
        End If
        
        End Sub
        
        Protected Sub Retrieve_List_Defaults_For_MOTOR_UNSUPPORTED(ByVal onChangeType As String, ByVal sCode As String)
        	
        	Dim buildScript As new System.Text.StringBuilder()
        
        	Dim ListCode = "UDL_KSTANDXS"
        
        	Dim sNewCode As String = ""
        	Dim ProdCode = GENERAL__PRODCODE.Text
        	If sCode IsNot Nothing Then
        		If ProdCode = "NSA" Or ProdCode = "NSM" Then
        			Select Case sCode
        				Case "106"
        					sNewCode = "108"
        				Case "126"
        					sNewCode = "128"
        				Case "136"
        					sNewCode = "138"
        				Case "137"
        					sNewCode = "139"
        				Case "196"
        					sNewCode = "198"
        				Case Else
        					sNewCode = sCode
        			End Select
        		Else
        			sNewCode = sCode
        		End If
        	End If
        
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim oList As NexusProvider.LookupListCollection
        	Dim XmlList As System.Xml.XmlElement = Nothing
        	Try
        		oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        
        
        	If XmlList IsNot Nothing Then
        			Dim sXML As String = XmlList.OuterXml
        			Dim xmlDoc As New System.Xml.XmlDocument
        			Dim NodeList As XmlNodeList
        			xmlDoc.LoadXml(sXML)
        
        			NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
        			If NodeList IsNot Nothing And NodeList.Count > 0 Then
        				For Each oNode As XmlNode In NodeList
        								If onChangeType = "UNSUPPORTED" Then
        									If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sNewCode Then
        										Dim ObjectsPropertiesArray As String() = {"196", "MOTOR.TMPEXCESSPER,STDXSP", "MOTOR.TMPEXCESSAMNT,STDXSAMT", "MOTOR.TMPWSCRNEXPER,WSXSP", "MOTOR.TMPWSCRNEXAMNT,WSXSAMT", "MOTOR.TMPAUDIO,AEQUIPXSAMT", "MOTOR.TMPTHEFT,THJXSAMT", "{8}", "{9}", "{10}", "{11}", "{12}", "{13}", "{14}", "{15}", "{16}"}
        										Dim x As Integer
        
        										For x = 0 To 15
        											Try
        												Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
        												Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        												Dim sobject = ObjectPropertySplit(0).ToString().Trim()
        												Dim sproperty = ColumnNameSplit(0).ToString().Trim()
        												Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        												
        												If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        													buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        												Else
        													buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        												End If
        											Catch
        												Exit For
        											End Try
        										Next x
        									End If
        								End If
        							Next
        				If buildScript.ToString() IsNot "" Then
        					CompleteASyncPostback_For_MOTOR_UNSUPPORTED(buildScript.ToString())
        				End If
        			End If
        		End If
        
        	Catch
        		Exit Sub
        	End Try
        
        End Sub
        
        Protected Sub Retrieve_List_Defaults_For_MOTOR_UNSUPPORTED_KSUMINSMOT(ByVal onChangeType As String, ByVal sCode As String)
        	
        	Dim buildScript As new System.Text.StringBuilder()
        
        	Dim ListCode = "UDL_KSUMINSMOT"
        
        	Dim sNewCode As String = ""
        	Dim ProdCode = GENERAL__PRODCODE.Text
        	If sCode IsNot Nothing Then
        		If ProdCode = "NSA" Or ProdCode = "NSM" Then
        			Select Case sCode
        				Case "106"
        					sNewCode = "108"
        				Case "126"
        					sNewCode = "128"
        				Case "136"
        					sNewCode = "138"
        				Case "137"
        					sNewCode = "139"
        				Case "196"
        					sNewCode = "198"
        				Case Else
        					sNewCode = sCode
        			End Select
        		Else
        			sNewCode = sCode
        		End If
        	End If
        
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim oList As NexusProvider.LookupListCollection
        	Dim XmlList As System.Xml.XmlElement = Nothing
        	Try
        		oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        
        
        	If XmlList IsNot Nothing Then
        			Dim sXML As String = XmlList.OuterXml
        			Dim xmlDoc As New System.Xml.XmlDocument
        			Dim NodeList As XmlNodeList
        			xmlDoc.LoadXml(sXML)
        
        			NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
        			If NodeList IsNot Nothing And NodeList.Count > 0 Then
        				For Each oNode As XmlNode In NodeList
        								If onChangeType = "UNSUPPORTED" Then
        									If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sNewCode Then
        										Dim ObjectsPropertiesArray As String() = {"MOTOR.MINSI,Min_SI", "MOTOR.REFSI,Referral_SI"}
        										Dim x As Integer
        
        										For x = 0 To 15
        											Try
        												Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
        												Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        												Dim sobject = ObjectPropertySplit(0).ToString().Trim()
        												Dim sproperty = ColumnNameSplit(0).ToString().Trim()
        												Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        												
        												If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        													buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        												Else
        													buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        												End If
        											Catch
        												Exit For
        											End Try
        										Next x
        									End If
        								End If
        							Next
        				If buildScript.ToString() IsNot "" Then
        					CompleteASyncPostback_For_MOTOR_UNSUPPORTED_KSUMINSMOT(buildScript.ToString())
        				End If
        			End If
        		End If
        
        	Catch
        		Exit Sub
        	End Try
        
        End Sub
        
        Protected Sub Retrieve_Checkbox_Defaults_For_MOTOR_UNSUPPORTED(ByVal onChangeType As String, ByVal vCode As String)
        	
        	Dim buildScript As new System.Text.StringBuilder()
        
        	Dim ListCode = "UDL_KSTANDXS"
        	Dim sCode = "196"
        	If Not(vCode.Equals("0")) Then
        		sCode = vCode
        	End If
        
        	Dim sNewCode As String = ""
        	Dim ProdCode = GENERAL__PRODCODE.Text
        	If sCode IsNot Nothing Then
        		If ProdCode = "NSA" Or ProdCode = "NSM" Then
        			Select Case sCode
        				Case "106"
        					sNewCode = "108"
        				Case "126"
        					sNewCode = "128"
        				Case "136"
        					sNewCode = "138"
        				Case "137"
        					sNewCode = "139"
        				Case "196"
        					sNewCode = "198"
        				Case Else
        					sNewCode = sCode
        			End Select
        		Else
        			sNewCode = sCode
        		End If
        	End If
        
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim oList As NexusProvider.LookupListCollection
        	Dim XmlList As System.Xml.XmlElement = Nothing
        	Try
        		oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        
        
        	If XmlList IsNot Nothing Then
        			Dim sXML As String = XmlList.OuterXml
        			Dim xmlDoc As New System.Xml.XmlDocument
        			Dim NodeList As XmlNodeList
        			xmlDoc.LoadXml(sXML)
        
        			NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
        			If NodeList IsNot Nothing And NodeList.Count > 0 Then
        				For Each oNode As XmlNode In NodeList
        								If onChangeType = "UNSUPPORTED" Then
        									If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sNewCode.Trim() Then
        										Dim ObjectsPropertiesArray As String() = {"MOTOR.TMPEXCESSPER,STDXSP", "MOTOR.TMPEXCESSAMNT,STDXSAMT", "MOTOR.TMPWSCRNEXPER,WSXSP", "MOTOR.TMPWSCRNEXAMNT,WSXSAMT", "MOTOR.TMPAUDIO,AEQUIPXSAMT", "MOTOR.TMPTHEFT,THJXSAMT", "{8}", "{9}", "{10}", "{11}", "{12}", "{13}", "{14}", "{15}", "{16}"}
        										Dim x As Integer
        
        										For x = 0 To 15
        											Try
        												Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
        												Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        												Dim sobject = ObjectPropertySplit(0).ToString().Trim()
        												Dim sproperty = ColumnNameSplit(0).ToString().Trim()
        												Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        												
        												If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        													buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        												Else
        													buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        												End If
        											Catch
        												Exit For
        											End Try
        										Next x
        									End If
        								End If
        							Next
        				If buildScript.ToString() IsNot "" Then
        					CompleteASyncPostback_For_MOTOR_UNSUPPORTED(buildScript.ToString())
        				End If
        			End If
        		End If
        
        	Catch
        		Exit Sub
        	End Try
        
        End Sub
        
        Protected Sub Retrieve_Checkbox_Defaults_For_MOTOR_UNSUPPORTED_KSUMINSMOT(ByVal onChangeType As String, ByVal vCode As String)
        	
        	Dim buildScript As new System.Text.StringBuilder()
        
        	Dim ListCode = "UDL_KSUMINSMOT"
        	Dim sCode = "196"
        	If Not(vCode.Equals("0")) Then
        		sCode = vCode
        	End If
        
        	Dim sNewCode As String = ""
        	Dim ProdCode = GENERAL__PRODCODE.Text
        	If sCode IsNot Nothing Then
        		If ProdCode = "NSA" Or ProdCode = "NSM" Then
        			Select Case sCode
        				Case "106"
        					sNewCode = "108"
        				Case "126"
        					sNewCode = "128"
        				Case "136"
        					sNewCode = "138"
        				Case "137"
        					sNewCode = "139"
        				Case "196"
        					sNewCode = "198"
        				Case Else
        					sNewCode = sCode
        			End Select
        		Else
        			sNewCode = sCode
        		End If
        	End If
        
        	Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim oList As NexusProvider.LookupListCollection
        	Dim XmlList As System.Xml.XmlElement = Nothing
        	Try
        		oList = oWebService.GetList(NexusProvider.ListType.PMLookup, ListCode, True, False, , , , XmlList,oQuote.CoverStartDate)
        
        
        	If XmlList IsNot Nothing Then
        			Dim sXML As String = XmlList.OuterXml
        			Dim xmlDoc As New System.Xml.XmlDocument
        			Dim NodeList As XmlNodeList
        			xmlDoc.LoadXml(sXML)
        
        			NodeList = xmlDoc.SelectNodes("/AdditionalDetails/" & ListCode)
        			If NodeList IsNot Nothing And NodeList.Count > 0 Then
        				For Each oNode As XmlNode In NodeList
        								If onChangeType = "UNSUPPORTED" Then
        									If oNode.SelectSingleNode("code").InnerXml.ToString().Trim() = sNewCode.Trim() Then
        										Dim ObjectsPropertiesArray As String() = {"MOTOR.MINSI,Min_SI", "MOTOR.REFSI,Referral_SI"}
        										Dim x As Integer
        
        										For x = 0 To 15
        											Try
        												Dim ObjectPropertySplit As String() = ObjectsPropertiesArray(x).Split(New Char() {"."}, StringSplitOptions.RemoveEmptyEntries)
        												Dim ColumnNameSplit As String() = ObjectPropertySplit(1).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        												Dim sobject = ObjectPropertySplit(0).ToString().Trim()
        												Dim sproperty = ColumnNameSplit(0).ToString().Trim()
        												Dim sColName = ColumnNameSplit(1).ToString().Trim().ToLower()
        												
        												If (oNode.SelectSingleNode(sColName).InnerXml.Trim() IsNot Nothing) Then
        													buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('").Append(oNode.SelectSingleNode(sColName).InnerXml.Trim()).Append("');")
        												Else
        													buildScript.Append("Field.getInstance('").Append(sobject).Append("', '").Append(sproperty).Append("').setValue('');")
        												End If
        											Catch
        												Exit For
        											End Try
        										Next x
        									End If
        								End If
        							Next
        				If buildScript.ToString() IsNot "" Then
        					CompleteASyncPostback_For_MOTOR_UNSUPPORTED_KSUMINSMOT(buildScript.ToString())
        				End If
        			End If
        		End If
        
        	Catch
        		Exit Sub
        	End Try
        
        End Sub
        
        Protected Sub CompleteASyncPostback_For_MOTOR_UNSUPPORTED(ByVal buildScript As String)
        ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "AsyncPostback",
        													  buildScript,
        													  True)
        	asyncPanel.Update()
        End Sub
        
        Protected Sub CompleteASyncPostback_For_MOTOR_UNSUPPORTED_KSUMINSMOT(ByVal buildScript As String)
        ScriptManager.RegisterStartupScript(asyncPanel, Me.GetType, "",
        													  buildScript,
        													  True)
        	asyncPanel.Update()
        End Sub

    End Class
End Namespace