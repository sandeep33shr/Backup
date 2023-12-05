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
    Partial Class PB2_PROIND_Cover_Details : Inherits BaseRisk
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
Protected Sub onValidate_ADDRESS__TOWN()
        
End Sub
Protected Sub onValidate_ADDRESS__COUNTRY()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_GENERAL__PRODCODE()
    onValidate_GENERAL__TRANSTYPE()
    onValidate_ADDRESS__TOWN()
    onValidate_ADDRESS__COUNTRY()
End Sub

		    
         Protected Shadows Sub GetProdCode(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	 Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	  
        	If Session(CNQuote) IsNot Nothing Then
        		GENERAL__BRANCH.Text = Trim(oQuote.BranchCode).ToString
        		GENERAL__PRODCODE.Text = Trim(oQuote.ProductCode).ToString
        	End If
        End Sub
    
        
        Protected Shadows Sub Page_Load_Address(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
                   		
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
                				End If
                			End If
                     
         End Sub
         
         'Address Load Query section 
         Protected Sub AddressLoad(ByVal value As String)
        	Dim connectionString as String = System.Configuration.ConfigurationManager.ConnectionStrings("PB2").ConnectionString
        	Dim queryString As String
        	'party
        	Dim oParty As NexusProvider.BaseParty = Nothing
        	Dim partyKey As String = Nothing
        	Dim addressValue As String = Nothing
        
                    If value = "3131XSA" Then 
                             addressValue = "3131 XSA"
                      End If 
                      If value = "3131XCO" Then
                                   addressValue = "3131 XCO"
                      
                      End If
        	
                    If Session(CNParty) IsNot Nothing Then
        
                        If TypeOf Session(CNParty) Is NexusProvider.BaseParty Then
        
                            oParty = CType(Session(CNParty), NexusProvider.BaseParty)
                            partyKey = DirectCast(oParty, NexusProvider.BaseParty).Key
        
        					queryString = "SELECT P.party_cnt AS ClientID,A.address1,A.address2,A.address3,A.address4,A.postal_code AS PostCode,C.description as Country "
                            queryString += " FROM party as P LEFT JOIN Party_Address_Usage as PAU on PAU.party_cnt = P.party_cnt "
                            queryString += " LEFT JOIN address as A on A.address_cnt = PAU.address_cnt "
                            queryString += " LEFT JOIN country as C on C.country_id = A.country_id "
                            queryString += " LEFT JOIN Address_Usage_Type as AUT on AUT.address_usage_type_id = PAU.address_usage_type_id "
                            queryString += " WHERE P.party_cnt = " + partyKey
                            queryString += " AND AUT.code = '" + addressValue + "'"
        
                        End If
                    End If
        
        	Dim adapter As SqlDataAdapter = New SqlDataAdapter(queryString, connectionString)
        	Dim results As System.Data.DataSet = New System.Data.DataSet
        	adapter.Fill(results)
        
        	If Not results Is Nothing Then
        		If results.Tables.Count > 0 Then
        			If results.Tables(0).Rows.Count > 0 Then
        				Dim clientID As String = results.Tables(0).Rows(0)("ClientID")
        				Dim  addressLine As String = results.Tables(0).Rows(0)("address1")
        				Dim  town As String = results.Tables(0).Rows(0)("address3")
        				Dim  suburb As String = results.Tables(0).Rows(0)("address2")
        				Dim  region As String = results.Tables(0).Rows(0)("address4")
        				Dim  postCode As String = results.Tables(0).Rows(0)("PostCode")
        				Dim  country As String = results.Tables(0).Rows(0)("Country")
        				
        				addressASyncPostback(addressLine,suburb,town, postCode,country,region)
        			
        			Else
        				addressASyncPostback("","","","","","")
        			End If
        		End If
        	End If
        	
        	
        End Sub
         
        
        'Address Postback
        Protected Sub addressASyncPostback(ByVal addressLine as String,ByVal suburb as String,ByVal town as String, ByVal postCode as String, byVal country as String, byVal region as String )
        	Dim buildScript as String = ""
        	buildScript += "Field.getInstance('ADDRESS', 'LINE1').setValue('"+ addressLine +"');"
        	buildScript += "Field.getInstance('ADDRESS', 'SUBURB').setValue('"+ suburb +"');"
        	buildScript += "Field.getInstance('ADDRESS', 'TOWN').setValue('"+ town +"');"
        	buildScript += "Field.getInstance('ADDRESS', 'REGION').setValue('"+ region +"');"
        	buildScript += "Field.getInstance('ADDRESS', 'POSTCODE').setValue('"+ postCode +"');"
        	buildScript += "Field.getInstance('ADDRESS', 'COUNTRY').setValue('"+ Trim(country) +"');"
        
        	' If addressLine = "" Then
        		' buildScript += "Field.getInstance('ADDRESS', 'COUNTRY').setValue(3);"
        	' '	buildScript += "Field.getInstance('ADDRESS', 'ADDRESS_CHECK').setValue(1);"
        	' 'Else
        	' '	buildScript += "Field.getInstance('ADDRESS', 'ADDRESS_CHECK').setValue(0);"
        	' End If
        
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
        		oCustomValidator.ID = "ValidateBankDetails"
        		oCustomValidator.ErrorMessage = "An address must be selected"
        		oCustomValidator.IsValid = False
        	Else
        		oCustomValidator.ID = "ValidateAccept"
        		oCustomValidator.ErrorMessage = "Address is valid"
        		oCustomValidator.IsValid = True
        	End If
        
        	Page.Validators.Add(oCustomValidator)
        
        End Sub

    End Class
End Namespace