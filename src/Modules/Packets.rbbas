#tag Module
Protected Module Packets
	#tag Method, Flags = &h21
		Private Function CreateBNET(packetId As Byte, packetData As String) As String
		  
		  Dim o As New MemoryBlock(4 + LenB(packetData))
		  
		  o.UInt8Value(0) = &HFF
		  o.UInt8Value(1) = packetId
		  o.UInt16Value(2) = o.Size
		  o.StringValue(4, o.Size - 4) = packetData
		  
		  If App.logPackets Then
		    stderr.WriteLine("BNET: Creating packet id 0x" + Right("0" + Hex(packetId), 2))
		  End If
		  
		  Return o
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_AUTH_ACCOUNTCREATE(salt As String, verifier As String, username As String) As String
		  
		  Dim o As New MemoryBlock(65 + LenB(username))
		  
		  o.StringValue(0, 32) = salt
		  o.StringValue(32, 32) = verifier
		  o.CString(64) = username
		  
		  Return Packets.CreateBNET(Packets.SID_AUTH_ACCOUNTCREATE, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_AUTH_CHECK(clientToken As UInt32, versionNumber As UInt32, versionChecksum As UInt32, numberOfKeys As UInt32, spawnKey As Boolean, keyData As String, versionSignature As String, keyOwner As String) As String
		  
		  Dim o As New MemoryBlock(20 + (numberOfKeys * 36) + 2 + LenB(versionSignature) + LenB(keyOwner))
		  
		  o.UInt32Value(0) = clientToken
		  o.UInt32Value(4) = versionNumber
		  o.UInt32Value(8) = versionChecksum
		  o.UInt32Value(12) = numberOfKeys
		  
		  If spawnKey Then
		    o.UInt32Value(16) = 1
		  ELse
		    o.UInt32Value(16) = 0
		  End If
		  
		  o.StringValue(20, LenB(keyData)) = keyData
		  o.CString(20 + LenB(keyData)) = versionSignature
		  o.CString(21 + LenB(keyData) + LenB(versionSignature)) = keyOwner
		  
		  Return Packets.CreateBNET(Packets.SID_AUTH_CHECK, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_AUTH_INFO(platform As UInt32, product As UInt32, versionByte As UInt32, productLanguage As UInt32, localIP As UInt32, timezoneBias As UInt32, localeId As UInt32, languageId As UInt32, countryShort As String, countryLong As String) As String
		  
		  Dim o As New MemoryBlock(38 + LenB(countryShort) + LenB(countryLong))
		  
		  o.UInt32Value(0) = 0 // (DWORD) Protocol Id
		  o.UInt32Value(4) = platform
		  o.UInt32Value(8) = product
		  o.UInt32Value(12) = versionByte
		  o.UInt32Value(16) = productLanguage
		  o.UInt32Value(20) = localIP
		  o.UInt32Value(24) = timezoneBias
		  o.UInt32Value(28) = localeId
		  o.UInt32Value(32) = languageId
		  o.CString(36) = countryShort
		  o.CString(37 + LenB(countryShort)) = countryLong
		  
		  Return Packets.CreateBNET(Packets.SID_AUTH_INFO, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_CHANGEPASSWORD(clientToken As UInt32, serverToken As UInt32, oldPasswordHash As String, newPasswordHash As String, username As String) As String
		  
		  Dim o As New MemoryBlock(49 + LenB(username))
		  
		  o.UInt32Value(0) = clientToken
		  o.UInt32Value(4) = serverToken
		  o.StringValue(8, 20) = oldPasswordHash
		  o.StringValue(28, 20) = newPasswordHash
		  o.CString(48) = username
		  
		  Return Packets.CreateBNET(Packets.SID_CHANGEPASSWORD, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_CHATCOMMAND(text As String) As String
		  
		  Dim o As New MemoryBlock(1 + LenB(text))
		  
		  o.CString(0) = text
		  
		  Return Packets.CreateBNET(Packets.SID_CHATCOMMAND, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_CREATEACCOUNT2(passwordHash As String, username As String) As String
		  
		  Dim o As New MemoryBlock(21 + LenB(username))
		  
		  o.StringValue(0, 20) = passwordHash
		  o.CString(20) = username
		  
		  Return Packets.CreateBNET(Packets.SID_CREATEACCOUNT2, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_ENTERCHAT(username As String, statstring As String) As String
		  
		  Dim o As New MemoryBlock(2 + LenB(username) + LenB(statstring))
		  
		  o.CString(0) = username
		  o.CString(1 + LenB(username)) = statstring
		  
		  Return Packets.CreateBNET(Packets.SID_ENTERCHAT, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_GETCHANNELLIST(product As UInt32) As String
		  
		  Dim o As New MemoryBlock(4)
		  
		  o.UInt32Value(0) = product
		  
		  Return Packets.CreateBNET(Packets.SID_GETCHANNELLIST, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_JOINCHANNEL(flags As UInt32, channel As String) As String
		  
		  Dim o As New MemoryBlock(5 + LenB(channel))
		  
		  o.UInt32Value(0) = flags
		  o.CString(4) = channel
		  
		  Return Packets.CreateBNET(Packets.SID_JOINCHANNEL, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_LEAVECHAT() As String
		  
		  Return Packets.CreateBNET(Packets.SID_LEAVECHAT, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_LOGONRESPONSE2(clientToken As UInt32, serverToken As UInt32, passwordHash As String, username As String) As String
		  
		  Dim o As New MemoryBlock(29 + LenB(username))
		  
		  o.UInt32Value(0) = clientToken
		  o.UInt32Value(4) = serverToken
		  o.StringValue(8, 20) = passwordHash
		  o.CString(28) = username
		  
		  Return Packets.CreateBNET(Packets.SID_LOGONRESPONSE2, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_NOTIFYJOIN(productId As UInt32, versionByte As UInt32, gameName As String, gamePassword As String) As String
		  
		  Dim o As New MemoryBlock(10 + LenB(gameName) + LenB(gamePassword))
		  
		  o.UInt32Value(0) = productId
		  o.UInt32Value(4) = versionByte
		  o.CString(8) = gameName
		  o.CString(9 + LenB(gameName)) = gamePassword
		  
		  Return Packets.CreateBNET(Packets.SID_NOTIFYJOIN, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_NULL() As String
		  
		  Return Packets.CreateBNET(Packets.SID_NULL, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_PING(cookie As UInt32) As String
		  
		  Dim o As New MemoryBlock(4)
		  
		  o.UInt32Value(0) = cookie
		  
		  Return Packets.CreateBNET(Packets.SID_PING, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_RESETPASSWORD(username As String, email As String) As String
		  
		  Dim o As New MemoryBlock(2 + LenB(username) + LenB(email))
		  
		  o.CString(0) = username
		  o.CString(1 + LenB(username)) = email
		  
		  Return Packets.CreateBNET(Packets.SID_RESETPASSWORD, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNET_SID_SETEMAIL(emailAddress As String) As String
		  
		  Return Packets.CreateBNET(Packets.SID_SETEMAIL, emailAddress + ChrB(0))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreateBNLS(packetId As Byte, packetData As String) As String
		  
		  Dim o As New MemoryBlock(3 + LenB(packetData))
		  
		  o.UInt16Value(0) = o.Size
		  o.UInt8Value(2) = packetId
		  o.StringValue(3, o.Size - 3) = packetData
		  
		  If App.logPackets Then
		    stderr.WriteLine("BNLS: Creating packet id 0x" + Right("0" + Hex(packetId), 2))
		  End If
		  
		  Return o
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNLS_NULL() As String
		  
		  Return Packets.CreateBNLS(Packets.BNLS_NULL, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNLS_REQUESTVERSIONBYTE(product As UInt32) As String
		  
		  Dim o As New MemoryBlock(4)
		  
		  o.UInt32Value(0) = product
		  
		  Return Packets.CreateBNLS(Packets.BNLS_REQUESTVERSIONBYTE, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateBNLS_VERSIONCHECKEX2(product As UInt32, flags As UInt32, cookie As UInt32, archiveFileTime As UInt64, archiveFileName As String, archiveChallenge As String) As String
		  
		  Dim o As New MemoryBlock(22 + LenB(archiveFileName) + LenB(archiveChallenge))
		  
		  o.UInt32Value(0) = product
		  o.UInt32Value(4) = flags
		  o.UInt32Value(8) = cookie
		  o.UInt64Value(12) = archiveFileTime
		  o.CString(20) = archiveFileName
		  o.CString(21 + LenB(archiveFileName)) = archiveChallenge
		  
		  Return Packets.CreateBNLS(Packets.BNLS_VERSIONCHECKEX2, o)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ReceiveBNET(client As BNETClient, packetObject As MemoryBlock) As Boolean
		  
		  Dim packetId As UInt8
		  
		  Try
		    
		    packetId = packetObject.UInt8Value(1)
		    
		    Select Case packetId
		    Case Packets.SID_NULL
		      Packets.ReceiveBNET_SID_NULL(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_ENTERCHAT
		      Packets.ReceiveBNET_SID_ENTERCHAT(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_GETCHANNELLIST
		      Packets.ReceiveBNET_SID_GETCHANNELLIST(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_CHATEVENT
		      Packets.ReceiveBNET_SID_CHATEVENT(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_FLOODDETECTED
		      Packets.ReceiveBNET_SID_FLOODDETECTED(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_MESSAGEBOX
		      Packets.ReceiveBNET_SID_MESSAGEBOX(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_PING
		      Packets.ReceiveBNET_SID_PING(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_CHANGEPASSWORD
		      Packets.ReceiveBNET_SID_CHANGEPASSWORD(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_LOGONRESPONSE2
		      Packets.ReceiveBNET_SID_LOGONRESPONSE2(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_CREATEACCOUNT2
		      Packets.ReceiveBNET_SID_CREATEACCOUNT2(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_REQUIREDWORK
		      Packets.ReceiveBNET_SID_REQUIREDWORK(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_AUTH_INFO
		      Packets.ReceiveBNET_SID_AUTH_INFO(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_AUTH_CHECK
		      Packets.ReceiveBNET_SID_AUTH_CHECK(client, MidB(packetObject, 5))
		      
		    Case Packets.SID_SETEMAIL
		      Packets.ReceiveBNET_SID_SETEMAIL(client, MidB(packetObject, 5))
		      
		    Case Else
		      Raise New UnknownPacketException()
		      
		    End Select
		    
		  Catch err As OutOfBoundsException // thrown if trying to read past end of MemoryBlock object
		    
		    stderr.WriteLine("BNET: Out of bounds while parsing packet id 0x" + Right("0" + Hex(packetId), 2))
		    Return False
		    
		  Catch err As UnknownPacketException // thrown if packetId is unknown
		    
		    stderr.WriteLine("BNET: Unable to recognize packet id 0x" + Right("0" + Hex(packetId), 2))
		    Return False
		    
		  Finally // path achievable only if successfully handled packet
		    
		    If App.logPackets Then
		      stderr.WriteLine("BNET: Parsed packet id 0x" + Right("0" + Hex(packetId), 2))
		    End If
		    Return True
		    
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_AUTH_CHECK(client As BNETClient, packetObject As MemoryBlock)
		  
		  client.state.versionAndKeyPassed = True
		  client.socBNLS.Disconnect()
		  
		  Dim result As UInt32 = packetObject.UInt32Value(0)
		  Dim value As String  = ""
		  
		  // PvPGN uses improper formatting.
		  If packetObject.Size > 4 Then value = packetObject.CString(4)
		  
		  Const RESULT_SUCCESS               = &H000
		  Const RESULT_OLD_VERSION           = &H100
		  Const RESULT_BAD_VERSION           = &H101
		  Const RESULT_NEW_VERSION           = &H102
		  Const RESULT_KEY1_INVALID          = &H200
		  Const RESULT_KEY1_IN_USE           = &H201
		  Const RESULT_KEY1_BANNED           = &H202
		  Const RESULT_KEY1_PRODUCT_MISMATCH = &H203
		  Const RESULT_KEY2_INVALID          = &H210
		  Const RESULT_KEY2_IN_USE           = &H211
		  Const RESULT_KEY2_BANNED           = &H212
		  Const RESULT_KEY2_PRODUCT_MISMATCH = &H213
		  
		  Select Case result
		  Case RESULT_SUCCESS
		  Case RESULT_OLD_VERSION
		    stdout.WriteLine("BNET: Game version too old.")
		  Case RESULT_BAD_VERSION
		    stdout.WriteLine("BNET: Game version invalid.")
		  Case RESULT_NEW_VERSION
		    stdout.WriteLine("BNET: Game version too new.")
		  Case client.state.versionByte
		    stdout.WriteLine("BNET: Game version byte invalid.")
		  Case RESULT_KEY1_INVALID
		    stdout.WriteLine("BNET: Invalid game key.")
		  Case RESULT_KEY1_IN_USE
		    stdout.WriteLine("BNET: Game key in use by " + value + ".")
		  Case RESULT_KEY1_BANNED
		    stdout.WriteLine("BNET: Banned game key.")
		  Case RESULT_KEY1_PRODUCT_MISMATCH
		    stdout.WriteLine("BNET: Mismatched game key product.")
		  Case RESULT_KEY2_INVALID
		    stdout.WriteLine("BNET: Invalid expansion key.")
		  Case RESULT_KEY2_IN_USE
		    stdout.WriteLine("BNET: Expansion key in use by " + value + ".")
		  Case RESULT_KEY2_BANNED
		    stdout.WriteLine("BNET: Banned expansion key.")
		  Case RESULT_KEY2_PRODUCT_MISMATCH
		    stdout.WriteLine("BNET: Mismatched expansion key product.")
		  Case Else
		    Raise New InvalidPacketException()
		  End Select
		  
		  If result <> RESULT_SUCCESS Then
		    client.socBNET.Disconnect()
		    Return
		  End If
		  
		  stderr.WriteLine("BNET: Version and key challenge passed.")
		  
		  // Battlenet.resetPassword(client)
		  
		  If Len(client.state.passwordNew) > 0 And StrComp(client.state.password, client.state.passwordNew, 0) <> 0 Then
		    Battlenet.changePassword(client)
		  ElseIf client.config.createAccount = Configuration.CreateAccountOnCreateThenLogin Then
		    Battlenet.createAccount(client)
		  Else
		    Battlenet.login(client)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_AUTH_INFO(client As BNETClient, packetObject As MemoryBlock)
		  
		  client.state.logonType             = packetObject.UInt32Value(0)
		  client.state.serverToken           = packetObject.UInt32Value(4)
		  client.state.udpToken              = packetObject.UInt32Value(8)
		  client.state.versionCheckFileTime  = packetObject.UInt64Value(12)
		  client.state.versionCheckFileName  = packetObject.CString(20)
		  client.state.versionCheckSignature = packetObject.CString(_
		  21 + LenB(client.state.versionCheckFileName))
		  
		  If packetObject.Size > 22 + LenB(client.state.versionCheckFileName) _
		    + LenB(client.state.versionCheckSignature) Then
		    client.state.serverSignature = packetObject.StringValue(_
		    22 + LenB(client.state.versionCheckFileName) + _
		    LenB(client.state.versionCheckSignature), 128)
		  Else
		    client.state.serverSignature = ""
		  End If
		  
		  client.socBNLS.Write(Packets.CreateBNLS_VERSIONCHECKEX2(_
		  Battlenet.productToBNLS(client.state.product), _
		  0, 0, client.state.versionCheckFileTime, _
		  client.state.versionCheckFileName, _
		  client.state.versionCheckSignature))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_CHANGEPASSWORD(client As BNETClient, packetObject As MemoryBlock)
		  
		  Dim status As UInt32 = packetObject.UInt32Value(0)
		  
		  Const STATUS_SUCCESS = &H00
		  Const STATUS_FAILURE = &H01
		  
		  Select Case status
		  Case STATUS_SUCCESS
		    client.config.password    = client.config.passwordNew
		    client.config.passwordNew = ""
		    client.state.password     = client.state.passwordNew
		    client.state.passwordNew  = ""
		  Case STATUS_FAILURE
		    stdout.WriteLine("BNET: Failed to change password.")
		  Case Else
		    Raise New InvalidPacketException()
		  End Select
		  
		  If status <> STATUS_SUCCESS Then
		    client.socBNET.Disconnect()
		    Return
		  End If
		  
		  stderr.WriteLine("BNET: Password was successfully changed.")
		  
		  Battlenet.login(client)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_CHATEVENT(client As BNETClient, packetObject As MemoryBlock)
		  
		  Dim msg As New ChatMessage()
		  
		  msg.eventId               = packetObject.UInt32Value(0)
		  msg.flags                 = packetObject.UInt32Value(4)
		  msg.ping                  = packetObject.Int32Value(8)
		  msg.ipAddress             = packetObject.UInt32Value(12)
		  msg.accountNumber         = packetObject.UInt32Value(16)
		  msg.registrationAuthority = packetObject.UInt32Value(20)
		  msg.username              = packetObject.CString(24)
		  msg.text                  = packetObject.CString(25 + LenB(msg.username))
		  
		  client.chatParser.messages.Insert(0, msg)
		  
		  If client.chatParser.State = client.chatParser.NotRunning Then
		    client.chatParser.Run()
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_CREATEACCOUNT2(client As BNETClient, packetObject As MemoryBlock)
		  
		  Dim status As UInt32 = packetObject.UInt32Value(0)
		  
		  // packet format may have additional data after the 4-bytes. See:
		  // <https://bnetdocs.org/packet/255/sid-createaccount2>
		  
		  Const STATUS_SUCCESS = &H00
		  Const STATUS_NAME_SHORT = &H01
		  Const STATUS_NAME_INVALID = &H02
		  Const STATUS_NAME_BANNED = &H03
		  Const STATUS_NAME_EXISTS = &H04
		  Const STATUS_NAME_BEING_CREATED = &H05
		  Const STATUS_NAME_NEEDS_ALPHANUMERIC = &H06
		  Const STATUS_NAME_ADJACENT_PUNCTUATION = &H07
		  Const STATUS_NAME_TOO_MANY_PUNCTUATION = &H08
		  
		  Select Case status
		  Case STATUS_SUCCESS
		    stdout.WriteLine("BNET: Account was successfully created.")
		  Case STATUS_NAME_SHORT
		    stdout.WriteLine("BNET: Account name is too short in length.")
		  Case STATUS_NAME_INVALID
		    stdout.WriteLine("BNET: Account name contains invalid characters.")
		  Case STATUS_NAME_BANNED
		    stdout.WriteLine("BNET: Account name contains a banned word.")
		  Case STATUS_NAME_EXISTS
		    stdout.WriteLine("BNET: Account already exists.")
		  Case STATUS_NAME_BEING_CREATED
		    stdout.WriteLine("BNET: Account is already being created.")
		  Case STATUS_NAME_NEEDS_ALPHANUMERIC
		    stdout.WriteLine("BNET: Account name needs more alphanumeric characters.")
		  Case STATUS_NAME_ADJACENT_PUNCTUATION
		    stdout.WriteLine("BNET: Account name contains adjacent punctuation characters.")
		  Case STATUS_NAME_TOO_MANY_PUNCTUATION
		    stdout.WriteLine("BNET: Account name contains too many punctuation characters.")
		  Case Else
		    Raise New InvalidPacketException()
		  End Select
		  
		  If status <> STATUS_SUCCESS And status <> STATUS_NAME_EXISTS And status <> STATUS_NAME_BEING_CREATED Then
		    client.socBNET.Disconnect()
		    Return
		  End If
		  
		  Battlenet.login(client)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_ENTERCHAT(client As BNETClient, packetObject As MemoryBlock)
		  
		  client.state.uniqueName  = packetObject.CString(0)
		  client.state.statstring  = packetObject.CString(1 + LenB(client.state.uniqueName))
		  client.state.accountName = packetObject.CString(2 + LenB(client.state.uniqueName) + LenB(client.state.statstring))
		  
		  If client.config.idleEnabled = True And client.config.idleBaseInterval > 0 _
		    And client.idleBotTimer.Mode <> IdleBotTimer.ModeMultiple Then
		    client.idleBotTimer.Mode = IdleBotTimer.ModeMultiple
		  End If
		  
		  stdout.WriteLine("BNET: Logged on as " + client.state.uniqueName + "!")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_FLOODDETECTED(client As BNETClient, packetObject As MemoryBlock)
		  
		  #pragma Unused client
		  
		  If packetObject.Size <> 0 Then
		    Raise New InvalidPacketException()
		  End If
		  
		  stdout.WriteLine("BNET: Flood detected.")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_GETCHANNELLIST(client As BNETClient, packetObject As MemoryBlock)
		  
		  Dim channels(), channel As String
		  Dim cursor As Integer = 0
		  
		  While packetObject.Size > cursor
		    channel = packetObject.CString(cursor)
		    cursor = cursor + LenB(channel) + 1
		    channels.Append(channel)
		  Wend
		  
		  Dim lastIndex As Integer = UBound( channels )
		  
		  If LenB( channels( lastIndex )) = 0 Then channels.Remove( lastIndex )
		  
		  client.state.channelList = channels
		  
		  Dim total As Integer = UBound(channels) + 1
		  
		  If total = 1 Then
		    stderr.WriteLine("BNET: Received 1 channel.")
		  Else
		    stderr.WriteLine("BNET: Received " + Format(total, "-#") + " channels.")
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_LOGONRESPONSE2(client As BNETClient, packetObject As MemoryBlock)
		  
		  Dim status As UInt32 = packetObject.UInt32Value(0)
		  Dim value As String  = ""
		  
		  Const STATUS_SUCCESS      = &H00
		  Const STATUS_NOT_FOUND    = &H01
		  Const STATUS_BAD_PASSWORD = &H02
		  Const STATUS_CLOSED       = &H06
		  
		  Select Case status
		  Case STATUS_SUCCESS
		  Case STATUS_NOT_FOUND
		    stdout.WriteLine("BNET: Account does not exist.")
		  Case STATUS_BAD_PASSWORD
		    stdout.WriteLine("BNET: Incorrect password.")
		  Case STATUS_CLOSED
		    value = packetObject.CString(4)
		    If LenB(value) = 0 Then
		      stdout.WriteLine("BNET: Account closed.")
		    Else
		      stdout.WriteLine("BNET: Account closed. Reason: " + value)
		    End If
		  Case Else
		    Raise New InvalidPacketException()
		  End Select
		  
		  If status <> STATUS_SUCCESS Then
		    If client.config.createAccount = Configuration.CreateAccountOff Then
		      client.socBNET.Disconnect()
		    Else
		      Battlenet.createAccount(client)
		    End If
		    Return
		  End If
		  
		  stderr.WriteLine("BNET: Account login success.")
		  
		  Dim flags As UInt32, channel As String
		  
		  If Len(client.config.homeChannel) = 0 Then
		    Battlenet.getDefaultChannel(client.state.product, flags, channel)
		  Else
		    flags   = Packets.FLAG_NOCREATE
		    channel = client.config.homeChannel
		  End If
		  
		  client.socBNET.Write(_
		  Packets.CreateBNET_SID_ENTERCHAT(client.state.username, "") + _
		  Packets.CreateBNET_SID_GETCHANNELLIST(client.state.product) + _
		  Packets.CreateBNET_SID_JOINCHANNEL(flags, channel)_
		  )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_MESSAGEBOX(client As BNETClient, packetObject As MemoryBlock)
		  
		  #pragma Unused client
		  
		  If packetObject.Size < 6 Then
		    Raise New InvalidPacketException()
		  End If
		  
		  Dim style As UInt32 = packetObject.UInt32Value(0)
		  Dim text As String = packetObject.CString(4)
		  Dim caption As String = packetObject.CString(5 + LenB(text))
		  
		  stdout.WriteLine("BNET: Received MessageBox [style: 0x" + Right("0000000" + Hex(style), 8) + ", " _
		  + "caption: """ + ReplaceAll(ReplaceAll(caption, "\", "\\"), """", "\""") + """, " _
		  + "text: """ + ReplaceAll(ReplaceAll(text, "\", "\\"), """", "\""") + """]")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_NULL(client As BNETClient, packetObject As MemoryBlock)
		  
		  #pragma Unused client
		  
		  If packetObject.Size <> 0 Then
		    Raise New InvalidPacketException()
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_PING(client As BNETClient, packetObject As MemoryBlock)
		  
		  client.socBNET.Write(Packets.CreateBNET_SID_PING(packetObject.UInt32Value(0)))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_REQUIREDWORK(client As BNETClient, packetObject As MemoryBlock)
		  
		  #pragma Unused client
		  
		  Dim filename As String = packetObject.CString(0)
		  
		  stdout.WriteLine("BNET: Required Work Archive [" + filename + "]")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNET_SID_SETEMAIL(client As BNETClient, packetObject As MemoryBlock)
		  
		  #pragma Unused client
		  
		  If packetObject.Size <> 0 Then
		    Raise New InvalidPacketException()
		  End If
		  
		  If LenB(client.config.email) = 0 Then
		    stdout.WriteLine("BNET: Email is not set.")
		  Else
		    stdout.WriteLine("BNET: Email is not set, setting email.")
		    client.socBNET.Write(Packets.CreateBNET_SID_SETEMAIL(client.config.email))
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ReceiveBNLS(client As BNETClient, packetObject As MemoryBlock) As Boolean
		  
		  Dim packetId As UInt8
		  
		  Try
		    
		    packetId = packetObject.UInt8Value(2)
		    
		    Select Case packetId
		    Case Packets.BNLS_NULL
		      Packets.ReceiveBNLS_NULL(client, MidB(packetObject, 4))
		      
		    Case Packets.BNLS_REQUESTVERSIONBYTE
		      Packets.ReceiveBNLS_REQUESTVERSIONBYTE(client, MidB(packetObject, 4))
		      
		    Case Packets.BNLS_VERSIONCHECKEX2
		      Packets.ReceiveBNLS_VERSIONCHECKEX2(client, MidB(packetObject, 4))
		      
		    Case Else
		      Raise New UnknownPacketException()
		      
		    End Select
		    
		  Catch err As OutOfBoundsException // thrown if trying to read past end of MemoryBlock object
		    
		    stderr.WriteLine("BNLS: Out of bounds while parsing packet id 0x" + Right("0" + Hex(packetId), 2))
		    Return False
		    
		  Catch err As UnknownPacketException // thrown if packetId is unknown
		    
		    stderr.WriteLine("BNLS: Unable to recognize packet id 0x" + Right("0" + Hex(packetId), 2))
		    Return False
		    
		  Finally // path achievable only if successfully handled packet
		    
		    If App.logPackets Then
		      stderr.WriteLine("BNLS: Parsed packet id 0x" + Right("0" + Hex(packetId), 2))
		    End If
		    Return True
		    
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNLS_NULL(client As BNETClient, packetObject As MemoryBlock)
		  
		  #pragma Unused client
		  
		  If packetObject.Size <> 0 Then
		    Raise New InvalidPacketException()
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNLS_REQUESTVERSIONBYTE(client As BNETClient, packetObject As MemoryBlock)
		  
		  If packetObject.UInt32Value(0) <> Battlenet.productToBNLS(client.state.product) Then
		    Raise New UnknownPacketException()
		  End If
		  
		  client.state.versionByte = packetObject.UInt32Value(4)
		  
		  If client.socBNET.IsConnected = True Then
		    
		    client.socBNET.Write(Packets.CreateBNET_SID_AUTH_INFO(_
		    client.state.platform, client.state.product, _
		    client.state.versionByte, _
		    0, client.state.localIP, client.state.timezoneBias, _
		    1033, 1033, "USA", "United States"_
		    ))
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReceiveBNLS_VERSIONCHECKEX2(client As BNETClient, packetObject As MemoryBlock)
		  
		  Dim success As UInt32     = packetObject.UInt32Value(0)
		  Dim version As UInt32     = packetObject.UInt32Value(4)
		  Dim checksum As UInt32    = packetObject.UInt32Value(8)
		  Dim signature As String   = packetObject.CString(12)
		  Dim cookie As UInt32      = packetObject.UInt32Value(13 + LenB(signature))
		  Dim versionByte As UInt32 = packetObject.UInt32Value(17 + LenB(signature))
		  
		  If cookie <> 0 Then
		    Raise New InvalidPacketException()
		  End If
		  
		  If success = 0 Then
		    stdout.WriteLine("BNLS: Version check failed.")
		    client.socBNLS.Disconnect()
		    client.socBNET.Disconnect()
		    Return
		  End If
		  
		  client.state.versionNumber    = version
		  client.state.versionChecksum  = checksum
		  client.state.versionSignature = signature
		  client.state.versionByte      = versionByte
		  
		  stderr.WriteLine("BNLS: Version check success.")
		  
		  Dim numberOfKeys As UInt32 = 0
		  Dim keyData() As String
		  
		  If Battlenet.needsGameKey1(client.state.product) And _
		    Battlenet.needsGameKey2(client.state.product) Then
		    numberOfKeys = 2
		    keyData.Append(Battlenet.getKeyData(client.state.gameKey1, client.state.clientToken, client.state.serverToken))
		    keyData.Append(Battlenet.getKeyData(client.state.gameKey2, client.state.clientToken, client.state.serverToken))
		  ElseIf Battlenet.needsGameKey1(client.state.product) Then
		    numberOfKeys = 1
		    keyData.Append(Battlenet.getKeyData(client.state.gameKey1, client.state.clientToken, client.state.serverToken))
		  ElseIf Battlenet.needsGameKey2(client.state.product) Then
		    numberOfKeys = 1
		    keyData.Append(Battlenet.getKeyData(client.state.gameKey2, client.state.clientToken, client.state.serverToken))
		  End If
		  
		  client.socBNET.Write(Packets.CreateBNET_SID_AUTH_CHECK(_
		  client.state.clientToken, client.state.versionNumber, _
		  client.state.versionChecksum, numberOfKeys, False, _
		  Join(keyData, ""), client.state.versionSignature, _
		  client.state.gameKeyOwner))
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = BNLS_NULL, Type = Double, Dynamic = False, Default = \"&H00", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BNLS_REQUESTVERSIONBYTE, Type = Double, Dynamic = False, Default = \"&H10", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BNLS_VERSIONCHECKEX2, Type = Double, Dynamic = False, Default = \"&H1A", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_BROADCAST, Type = Double, Dynamic = False, Default = \"&H06", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_CHANNEL, Type = Double, Dynamic = False, Default = \"&H07", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_CHANNEL_EMPTY, Type = Double, Dynamic = False, Default = \"&H0E", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_CHANNEL_FULL, Type = Double, Dynamic = False, Default = \"&H0D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_CHANNEL_RESTRICTED, Type = Double, Dynamic = False, Default = \"&H0F", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_EMOTE, Type = Double, Dynamic = False, Default = \"&H17", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_ERROR, Type = Double, Dynamic = False, Default = \"&H13", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_INFO, Type = Double, Dynamic = False, Default = \"&H12", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_TALK, Type = Double, Dynamic = False, Default = \"&H05", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_USERJOIN, Type = Double, Dynamic = False, Default = \"&H02", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_USERLEAVE, Type = Double, Dynamic = False, Default = \"&H03", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_USERSHOW, Type = Double, Dynamic = False, Default = \"&H01", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_USERUPDATE, Type = Double, Dynamic = False, Default = \"&H09", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_WHISPER, Type = Double, Dynamic = False, Default = \"&H04", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = EID_WHISPERSENT, Type = Double, Dynamic = False, Default = \"&H0A", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = FLAG_DIABLO2JOIN, Type = Double, Dynamic = False, Default = \"&H04", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = FLAG_FIRSTJOIN, Type = Double, Dynamic = False, Default = \"&H01", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = FLAG_FORCEJOIN, Type = Double, Dynamic = False, Default = \"&H02", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = FLAG_NOCREATE, Type = Double, Dynamic = False, Default = \"&H00", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_AUTH_ACCOUNTCHANGE, Type = Double, Dynamic = False, Default = \"&H55", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_AUTH_ACCOUNTCHANGEPROOF, Type = Double, Dynamic = False, Default = \"&H56", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_AUTH_ACCOUNTCREATE, Type = Double, Dynamic = False, Default = \"&H52", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_AUTH_ACCOUNTLOGON, Type = Double, Dynamic = False, Default = \"&H53", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_AUTH_ACCOUNTLOGONPROOF, Type = Double, Dynamic = False, Default = \"&H54", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_AUTH_ACCOUNTUPGRADE, Type = Double, Dynamic = False, Default = \"&H57", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_AUTH_ACCOUNTUPGRADEPROOF, Type = Double, Dynamic = False, Default = \"&H58", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_AUTH_CHECK, Type = Double, Dynamic = False, Default = \"&H51", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_AUTH_INFO, Type = Double, Dynamic = False, Default = \"&H50", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_CHANGEPASSWORD, Type = Double, Dynamic = False, Default = \"&H31", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_CHATCOMMAND, Type = Double, Dynamic = False, Default = \"&H0E", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_CHATEVENT, Type = Double, Dynamic = False, Default = \"&H0F", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_CLIENTID, Type = Double, Dynamic = False, Default = \"&H05", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_CLIENTID2, Type = Double, Dynamic = False, Default = \"&H1E", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_CREATEACCOUNT2, Type = Double, Dynamic = False, Default = \"&H3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_ENTERCHAT, Type = Double, Dynamic = False, Default = \"&H0A", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_FLOODDETECTED, Type = Double, Dynamic = False, Default = \"&H13", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_GETCHANNELLIST, Type = Double, Dynamic = False, Default = \"&H0B", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_JOINCHANNEL, Type = Double, Dynamic = False, Default = \"&H0C", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_LEAVECHAT, Type = Double, Dynamic = False, Default = \"&H10", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_LOCALEINFO, Type = Double, Dynamic = False, Default = \"&H12", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_LOGONCHALLENGEEX, Type = Double, Dynamic = False, Default = \"&H1D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_LOGONRESPONSE2, Type = Double, Dynamic = False, Default = \"&H3A", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_MESSAGEBOX, Type = Double, Dynamic = False, Default = \"&H19", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_NOTIFYJOIN, Type = Double, Dynamic = False, Default = \"&H22", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_NULL, Type = Double, Dynamic = False, Default = \"&H00", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_PING, Type = Double, Dynamic = False, Default = \"&H25", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_REQUIREDWORK, Type = Double, Dynamic = False, Default = \"&H4C", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_RESETPASSWORD, Type = Double, Dynamic = False, Default = \"&H5A", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_SETEMAIL, Type = Double, Dynamic = False, Default = \"&H59", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SID_STARTVERSIONING, Type = Double, Dynamic = False, Default = \"&H06", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
