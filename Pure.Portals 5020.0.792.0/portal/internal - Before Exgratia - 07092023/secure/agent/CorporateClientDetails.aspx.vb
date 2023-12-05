Imports Nexus.Constants.Session
Imports Nexus.Constants.Constant
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Text
Imports System.Data

Namespace Nexus

    Partial Class secure_CorporateClientDetails
        Inherits BaseCorporateClient

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
		
		Protected Sub onValidate_CCLIENT__USERLEVEL()
        
End Sub
Protected Sub CallRuleScripts()
    onValidate_CCLIENT__USERLEVEL()
End Sub

    
        
        Protected Shadows Sub CheckUserAuthority(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        	CCLIENT__USERLEVEL.Text = 1
        	Dim oQuote As NexusProvider.Quote = Session(CNQuote)
        	Dim UserID As Integer
        	Dim sProdCode As String = "CHA"
        	Dim UserLevel As String
        	Dim Reader As SqlDataReader
        	Dim constr As String = ConfigurationManager.ConnectionStrings("Pure").ConnectionString
        
        	Using objConn As New SqlConnection(constr)
        		objConn.Open()
        		Dim strSQL As New StringBuilder()
        		strSQL.Append("dbo.spu_ICCS_6722_GetCCBondsDetails")
        
        		Using cmd As New SqlCommand(strSQL.ToString, objConn)
        			cmd.CommandType = CommandType.StoredProcedure
        			cmd.Parameters.Add(New SqlParameter("@sUserName", SqlDbType.VarChar, 255)).Value = Session(CNLoginName)
        
        
        			Reader = cmd.ExecuteReader()
        			While Reader.Read()
        				UserID = Reader(0)
        			End While
        		End Using
        		objConn.Close()
        	End Using
        
        	Using objConn As New SqlConnection(constr)
        		objConn.Open()
        		Dim strSQL As New StringBuilder()
        		strSQL.Append("dbo.spu_ICCS_6722_GetCCBondsLevel")
        
        		Using cmd As New SqlCommand(strSQL.ToString, objConn)
        			cmd.CommandType = CommandType.StoredProcedure
        			cmd.Parameters.Add(New SqlParameter("@lUserId", SqlDbType.Int, 0)).Value = UserID
        			cmd.Parameters.Add(New SqlParameter("@sProdCode", SqlDbType.VarChar, 10)).Value = sProdCode
        
        
        			Reader = cmd.ExecuteReader()
        			While Reader.Read()
        				UserLevel = Reader(0).Substring(1).Trim()
        			End While
        		End Using
        		objConn.Close()
        	End Using
        	CCLIENT__USERLEVEL.Text = UserLevel
        
        End Sub


    End Class

End Namespace