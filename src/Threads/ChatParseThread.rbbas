#tag Class
Protected Class ChatParseThread
Inherits Thread
	#tag Event
		Sub Run()
		  
		  Dim msg As ChatMessage
		  Dim acl As UserAccess
		  Dim res As ChatResponse
		  
		  Dim responses() As ChatResponse
		  
		  Do Until UBound(Me.messages) < 0
		    
		    msg = Me.messages.Pop()
		    acl = Nil
		    res = Nil
		    
		    Select Case msg.eventId
		    Case Packets.EID_USERSHOW, Packets.EID_USERJOIN, Packets.EID_USERUPDATE
		      
		      Dim username As String = Battlenet.onlineNameToAccountName(msg.username, Me.client.state.product, True, "")
		      
		      Me.client.state.channelUsers.Value(username) = New ChannelUser(msg.username, msg.text, msg.ping, msg.flags)
		      
		      stdout.WriteLine("BNET: " + username + " joined")
		      
		      If msg.eventId = Packets.EID_USERJOIN And Me.client.config.greetEnabled = True Then
		        Dim greetMsg As ChatResponse = Battlenet.GreetBot(Me.client, msg, username)
		        If greetMsg <> Nil Then responses.Append(greetMsg)
		      End If
		      
		    Case Packets.EID_USERLEAVE
		      
		      Dim username As String = Battlenet.onlineNameToAccountName(msg.username, Me.client.state.product, True, "")
		      
		      If Me.client.state.channelUsers.HasKey(username) Then
		        Me.client.state.channelUsers.Remove(username)
		      End If
		      
		      stdout.WriteLine("BNET: " + username + " left")
		      
		    Case Packets.EID_WHISPER, Packets.EID_TALK, Packets.EID_EMOTE
		      
		      acl       = Me.client.getAcl(msg.username)
		      responses = BotCommand.handleCommand(Me.client, acl, msg)
		      
		    Case Packets.EID_BROADCAST
		      
		      If msg.username <> "Battle.net" And Len(msg.username) > 0 Then
		        stdout.WriteLine(App.PrefixLines(msg.text, "BNET Broadcast from " + msg.username + ": "))
		      Else
		        stdout.WriteLine(App.PrefixLines(msg.text, "BNET Broadcast: "))
		      End If
		      
		    Case Packets.EID_CHANNEL
		      
		      Me.client.state.channel      = msg.text
		      Me.client.state.channelUsers = New Dictionary()
		      
		      stdout.WriteLine("BNET: Joined Channel: " + msg.text)
		      
		    Case Packets.EID_CHANNEL_EMPTY
		      
		      Me.client.socBNET.Write(Packets.CreateBNET_SID_JOINCHANNEL(Packets.FLAG_FORCEJOIN, msg.text))
		      
		    Case Packets.EID_CHANNEL_FULL
		      
		      stdout.WriteLine("BNET: Channel " + msg.text + " is full")
		      
		      If Me.client.state.joinCommandState <> Nil And _
		        Me.client.state.joinCommandState.Right = msg.text Then
		        responses.Append(New ChatResponse(ChatResponse.TYPE_TALK, _
		        "/w " + Me.client.state.joinCommandState.Left + " " + msg.text + " is full"))
		      End If
		      
		    Case Packets.EID_CHANNEL_RESTRICTED
		      
		      stdout.WriteLine("BNET: Channel " + msg.text + " is restricted")
		      
		      If Me.client.state.joinCommandState <> Nil And _
		        Me.client.state.joinCommandState.Right = msg.text Then
		        responses.Append(New ChatResponse(ChatResponse.TYPE_TALK, _
		        "/w " + Me.client.state.joinCommandState.Left + " " + msg.text + " is restricted"))
		      End If
		      
		    Case Packets.EID_INFO
		      
		      stdout.WriteLine(App.PrefixLines(msg.text, "BNET Info: "))
		      
		    Case Packets.EID_ERROR
		      
		      stdout.WriteLine(App.PrefixLines(msg.text, "BNET Error: "))
		      
		    End Select
		    
		    If Me.client = Nil Or Me.client.socBNET = Nil Or Me.client.socBNET.IsConnected = False Then Continue Do
		    
		    If responses <> Nil Then
		      Do Until UBound(responses) < 0
		        
		        res = responses.Pop()
		        
		        Select Case res.type
		        Case res.TYPE_PACKET
		          If LenB(res.text) > 0 Then
		            Me.client.socBNET.Write(res.text)
		          End If
		        Case res.TYPE_TALK
		          If LenB(res.text) > 0 Then
		            Me.client.socBNET.Write(Packets.CreateBNET_SID_CHATCOMMAND(res.text))
		          End If
		        Case res.TYPE_EMOTE
		          Me.client.socBNET.Write(Packets.CreateBNET_SID_CHATCOMMAND("/me " + res.text))
		        Case res.TYPE_WHISPER
		          Me.client.socBNET.Write(Packets.CreateBNET_SID_CHATCOMMAND("/w " + msg.username + " " + res.text))
		        End Select
		        
		      Loop
		    End If
		    
		  Loop
		  
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h0
		client As BNETClient
	#tag EndProperty

	#tag Property, Flags = &h0
		messages() As ChatMessage
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass