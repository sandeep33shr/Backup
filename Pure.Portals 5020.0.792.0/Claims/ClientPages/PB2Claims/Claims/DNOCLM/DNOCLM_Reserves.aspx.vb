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
    Partial Class PB2_DNOCLM_Reserves : Inherits BaseClaim
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

		Protected Sub onValidate_DNOLBCLAIM__SOL_COUNTER()
                    If eLifecycleEvent = LifecycleEvent.Page_Load Then
                        If Not Page.IsPostBack Then
                            GetClaimDetails(CType(Session.Item(CNClaim), NexusProvider.ClaimOpen).ClaimKey, Nothing)
                            SetScriptPayment()
                        End If
                    End If
End Sub
Protected Sub onValidate_DNOLBCLAIM__TransactionType()
        ' Clear Objects For which Cover is unselected.
        If eLifecycleEvent = LifecycleEvent.Page_Load Then
           Dim sTransactionType As String = String.Empty
                     If CType(Session.Item(CNMode), Mode) = Mode.NewClaim Then
                            sTransactionType = "NEWCLAIM"
                        ElseIf CType(Session.Item(CNMode), Mode) = Mode.EditClaim Then
                            sTransactionType = "EDITCLAIM"
                        ElseIf CType(Session.Item(CNMode), Mode) = Mode.PayClaim Then
                            sTransactionType = "PAYCLAIM"
                        ElseIf CType(Session.Item(CNMode), Mode) = Mode.SalvageClaim Then
                            sTransactionType = "SALVAGECLAIM"
                        ElseIf CType(Session.Item(CNMode), Mode) = Mode.TPRecovery Then
                            sTransactionType = "TPRECOVERY"
                        Else
                            sTransactionType = "VIEW"
                        End If
        
                     DNOLBCLAIM__TransactionType.Text = sTransactionType		 
        			 
        			Dim oClaimOpen As NexusProvider.ClaimOpen = CType(Current.Session.Item(CNClaim), NexusProvider.ClaimOpen)
                    Dim oWebService As NexusProvider.ProviderBase = New NexusProvider.ProviderManager().Provider
                    Dim sXMLDataset As String = DirectCast(Session(CNDataSet), System.Object)
                    Try
                        If (Not String.IsNullOrEmpty(Session(CNDataSet))) Then
                            Dim srDataset As New System.IO.StringReader(Session(CNDataSet))
                            Dim xmlTR As New XmlTextReader(srDataset)
                            Dim Doc As New XmlDocument
                            Doc.Load(xmlTR)
                            xmlTR.Close()
                            Dim oNodelist As XmlNodeList = Doc.SelectNodes("//DNOLBCLAIM/RECOVERIES")
                            Dim sTotalReceiptAmount As Double = 0
                            Dim sRecoveryTypeCode As String = String.Empty
                            Dim sReceivedAmount As Double = 0
                            For Each oNode As XmlNode In oNodelist
                                If oNode IsNot Nothing Then
                                    If (oNode.Attributes("RECOVERY_TYPE") IsNot Nothing) Then
                                        sRecoveryTypeCode = oNode.Attributes("RECOVERY_TYPE").Value.ToUpper()
                                    End If
        
                                    If (oNode.Attributes("NEGOTIATED_AMOUNT") IsNot Nothing) Then
                                        sReceivedAmount = oNode.Attributes("NEGOTIATED_AMOUNT").Value
                                    End If
        
                                    If (Session(CNMode) = Mode.SalvageClaim AndAlso sRecoveryTypeCode = "SALVAGE") Then
                                            sTotalReceiptAmount = sTotalReceiptAmount + CDbl(sReceivedAmount)
                                    ElseIf (Session(CNMode) = Mode.TPRecovery AndAlso sRecoveryTypeCode = "TPP") Then
                                            sTotalReceiptAmount = sTotalReceiptAmount + CDbl(sReceivedAmount)
                                    End If
                                End If
                            Next
        
                            'RESERVES__Total_This_Receipt.Text = sTotalReceiptAmount
                        End If
                    Catch ex As Exception
                    Finally
                        oClaimOpen = Nothing
                        oWebService = Nothing
                    End Try
                   
        End If
           
        
        
        
        			
        		
        			
        
        
        
        
        	
End Sub
Protected Sub CallRuleScripts()
    onValidate_DNOLBCLAIM__SOL_COUNTER()
    onValidate_DNOLBCLAIM__TransactionType()
End Sub

		
    End Class
End Namespace