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


        Protected Shadows Sub VatNumberChange(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            Session("vatNumber") = PSCLIENT__VAT_NUMBER.Text

        End Sub


        Protected Shadows Sub ValidatingID(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click

            Dim oCustomValidator As New CustomValidator()
            Dim identityType As String = ddlServiceLevel.Value
            Dim identification As String = txtFileCode.Text
            Dim nationality As String = GISCorporate_Nationality.Value

            oCustomValidator.IsValid = True

            '======== Important information ================================================
            'CR 004 implementation by Badimu Kazadi 

            ' => The ddlServiceLevel dropdown list has been loaded with the identity type
            ' => The Service Level Label caption has been changed to Identification Type
            ' => The Filecode Label caption has been changed to Identification 
            '===============================================================================

            'Validating ID based on the ID Type selected if the Nationality selected is Namibian
            If (nationality = "NAMIBIAN") Then

                'When the ID Type selected is "Identification number"
                If (identityType = "ID") And (identification IsNot Nothing Or identification <> "") Then

                    'Checking if ID number provided has 11 Characters 
                    If (identification.Length < 11 Or identification.Length > 11) Then

                        oCustomValidator.ID = "vldIDNumberCharLength"
                        oCustomValidator.ErrorMessage = "The ID number entered is invalid, the number of characters is incorrect"
                        oCustomValidator.IsValid = False

                    Else
                        'Check if the first 6 digits on the ID matches the date of Birth
                        Dim DOB As String = txtDOB.Text
                        DOB = DOB.Replace("/", "")
                        Dim dd As String = DOB.Substring(0, 2)
                        Dim mm As String = DOB.Substring(2, 2)
                        Dim yy As String = DOB.Substring(6, 2)
                        Dim newDate As String = (yy + mm + dd).ToString
                        Dim ID As String = identification.Substring(0, 6)

                        If (newDate <> ID) Then
                            oCustomValidator.ID = "vldIDMatch"
                            oCustomValidator.ErrorMessage = "The Date of birth does not match the Identification Number"
                            oCustomValidator.IsValid = False

                        End If
                    End If
                End If

                'When the ID Type selected is "Passport"
                If (identityType = "Passport") And (identification IsNot Nothing Or identification <> "") Then
                    'Checking if Passport number provided has 8 Characters 
                    If (identification.Length < 8 Or identification.Length > 8) Then

                        oCustomValidator.ID = "vldPassportCharLength"
                        oCustomValidator.ErrorMessage = "The passport number entered is invalid, the number of characters is incorrect"
                        oCustomValidator.IsValid = False

                    Else
                        'Check if the first letter on the Passport number start with P
                        Dim ID As String = identification.Substring(0, 1)
                        If (ID <> "P") Then
                            oCustomValidator.ID = "vldPassportMatch"
                            oCustomValidator.ErrorMessage = "The passport number entered is invalid, start with a P followed by 7 numerical digits"
                            oCustomValidator.IsValid = False

                        End If
                    End If
                End If

            End If

            Page.Validators.Add(oCustomValidator)

        End Sub


    End Class
End Namespace
