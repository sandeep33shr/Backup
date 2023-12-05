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
    Partial Class PB2_PIPESTRCLM_Underwriting_Information : Inherits BaseClaim
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

		Protected Sub onValidate_PIPESTRCLAIM__IS_FAC()
        
End Sub
Protected Sub onValidate_PIPESTRCLAIM__SITEDETCLM()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_PIPESTRCLAIM__IS_FAC()
    onValidate_PIPESTRCLAIM__SITEDETCLM()
End Sub

		    
        Protected Shadows Sub Page_Load_ClientInfo(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            Dim oClaimQuote As NexusProvider.Quote = Session(CNClaimQuote)
            Dim oParty As NexusProvider.BaseParty = Nothing
        
        
            'Dim iCount As Integer
            If Session(CNParty) IsNot Nothing Then
                If TypeOf Session(CNParty) Is NexusProvider.CorporateParty Then
                    oParty = CType(Session(CNParty), NexusProvider.CorporateParty)
                    PIPESTRCLAIM__INSURED.Text = DirectCast(oParty, NexusProvider.CorporateParty).CompanyName
                End If
        
                If TypeOf Session(CNParty) Is NexusProvider.PersonalParty Then
                    oParty = CType(Session(CNParty), NexusProvider.PersonalParty)
                    Dim firstName, LastName As String
                    Dim Count, mIndex As Integer
        			Dim MobileNo As String
        			Count = oParty.Contacts.Count - 1
        			For mIndex = 0 To Count
        				If oParty.Contacts(mIndex).ContactType = 2 Then
        					MobileNo = oParty.Contacts(mIndex).Number
        				End If
        			Next
                    firstName = Trim(DirectCast(oParty, NexusProvider.PersonalParty).Forename).ToString
                    LastName = Trim(DirectCast(oParty, NexusProvider.PersonalParty).Lastname).ToString
                    PIPESTRCLAIM__INSURED.Text = (firstName + " " + LastName).ToString
                    PIPESTRCLAIM__CONTACTNUM.Text = Trim(MobileNo).ToString
                End If
        
        
            End If
        
            If Session(CNClaimQuote) IsNot Nothing Then
                PIPESTRCLAIM__POLNUMBER.Text = RTrim(LTrim(oClaimQuote.InsuranceFileRef))
                PIPESTRCLAIM__ALTERPOLICY.Text = RTrim(LTrim(oClaimQuote.AlternativeRef))
                PIPESTRCLAIM__CVR_STARTDATE.Text = RTrim(LTrim(oClaimQuote.CoverStartDate))
                PIPESTRCLAIM__CVR_ENDDATE.Text = RTrim(LTrim(oClaimQuote.CoverEndDate))
                PIPESTRCLAIM__INCEPT_DATE.Text = RTrim(LTrim(oClaimQuote.InceptionDate))
        
                Dim CurrClaim As NexusProvider.Claim = Session(CNClaim)
        		Dim Cnt As Integer = oClaimQuote.Risks.Count
        		Dim nIndex As Integer
        		Dim FAC As Boolean
        		Cnt -= 1
        		For nIndex = 0 To Cnt
        			If oClaimQuote.Risks(nIndex).Key = CurrClaim.RiskKey Then
        				FAC = oClaimQuote.Risks.Item(nIndex).HasFacProp
        			End If
        		Next
        		PIPESTRCLAIM__IS_FAC.Text = FAC.ToString
            End If
        
                  'DNOLBCLAIM__CONTACTNUM.Text = oQuote.ClientMobileNo
                    'DNOLBCLAIM__POLNUMBER.Text = oQuote.InsuranceFileRef
                    'DNOLBCLAIM__ALTERPOLICY.Text = oQuote.OldPolicyNumber
                    'DNOLBCLAIM__CVR_STARTDATE.Text = String.Format("{0:dd/MM/yyyy}",oQuote.CoverStartDate)
                    'DNOLBCLAIM__CVR_ENDDATE.Text = String.Format("{0:dd/MM/yyyy}",oQuote.CoverEndDate)
                    'DNOLBCLAIM__INCEPT_DATE.Text = String.Format("{0:dd/MM/yyyy}",oQuote.InceptionDate)
        End Sub
     
        ' Note: This rule removes the "Add" button row of a child-screen grid
        ' PIPESTRCLAIM = The parent object name of child screen
        ' SITECLAIM = The child screen object name
        
        Protected Sub PIPESTRCLAIM__SITECLAIM_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles PIPESTRCLAIM__SITECLAIM.RowDataBound
        	If e.Row.RowType = DataControlRowType.Footer Then
        		e.Row.Visible = False
        	End If
        
        End Sub
        

    End Class
End Namespace