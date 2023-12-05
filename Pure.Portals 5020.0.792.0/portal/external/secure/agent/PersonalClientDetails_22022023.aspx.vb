Namespace Nexus
    Partial Class secure_PersonalClientDetails
        Inherits BasePersonalClient

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
		
		Protected Shadows Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
			eLifecycleEvent = LifecycleEvent.Page_Init
			CallRuleScripts()
        End Sub
		
		Protected Shadows Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
			eLifecycleEvent = LifecycleEvent.Page_Load
			CallRuleScripts()
        End Sub
		
		Protected Shadows Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
			eLifecycleEvent = LifecycleEvent.Page_LoadComplete
			CallRuleScripts()
		End Sub

        Protected Overrides Sub Render(ByVal writer As HtmlTextWriter)
            MyBase.Render(writer)
            eLifecycleEvent = LifecycleEvent.Render
            CallRuleScripts()
        End Sub

        Public Overrides Sub SaveChildButton(ByVal sender As Object, ByVal e As System.EventArgs)
            SaveChildButtonWithAllData(sender, e)
            MyBase.SaveChildButton(sender, e)
        End Sub
		
		Protected Sub onValidate_PSCLIENT__VAT_NUMBER()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_PSCLIENT__VAT_NUMBER()
End Sub

    
         Protected Shadows Sub VatNumberChange(ByVal sender As Object, ByVal e As System.EventArgs) Handles me.load
        		Session("vatNumber") = PSCLIENT__VAT_NUMBER.Text 
        		 
        End Sub


    End Class
End Namespace
