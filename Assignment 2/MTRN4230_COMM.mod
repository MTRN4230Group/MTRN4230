MODULE MTRN4230_COMM
    ! The host and port that we will be listening for a connection on.
    ! PERS string host := "127.0.0.1";
    PERS string host := "192.168.125.1";
    CONST num port := 1028;
    
    ! The socket connected to the client.
    VAR socketdev client_socket;
    CONST num MAX_ARGS := 10;
    
    ! Intertask comm
    PERS num cmdArgs{MAX_ARGS} := [90,0,0,0,0,0,100,766,0,0];
    PERS bool cmdReady := FALSE;
	PERS string cmdType;
    PERS bool robAcked := TRUE;
	PERS string robMsg;
    
    ! Main Routine
    PROC Main()
        VAR string received_str;
        VAR num found;
        VAR num prevPos := 1;
	    VAR num counter := 0;
        VAR string retString;
        VAR bool ok;
        
        ! Wait for any connection
        ListenForAndAcceptConnection2;
        WaitTime 0.1; 
        WHILE received_str <> "Q" DO
            WaitTime 0.1;
            ! Receive a string from the client.
            SocketReceive client_socket \Str:=received_str \Time:=WAIT_MAX;
            WHILE prevPos < StrLen(received_str) DO
                found := StrFind(received_str,prevPos,"/");
                ! SocketSend client_socket \Str:=(NumToStr(found,0) + "\0A");
                retString := StrPart(received_str,prevPos,found-prevPos);
                prevPos := found + 1;
        	    IF (counter = 0) THEN
        	        ! if this is the first time its found a slash, its the command type
        		    cmdType := retString;
                ELSE
                    ok := StrToVal(retString,cmdArgs{counter});
                ENDIF
                ! store each command value
        	    counter := counter + 1;
            ENDWHILE
            counter := 0;
            prevPos := 1;
            cmdReady := TRUE;
            
            ! Wait until the robot has ackowledged
            WaitUntil robAcked;
            robAcked := FALSE;
            SocketSend client_socket \Str:=(robMsg + "\0A");
        ENDWHILE
        ! Close this connection 
        ! TODO: does this connection need to be closed?
        CloseConnection;
    ENDPROC
    
    ! Wait for a connection routine
    PROC ListenForAndAcceptConnection2()
        
        ! Create the socket to listen for a connection on.
        VAR socketdev welcome_socket;
        SocketCreate welcome_socket;
        
        ! Bind the socket to the host and port.
        SocketBind welcome_socket, host, port;
        
        ! Listen on the welcome socket.
        SocketListen welcome_socket;
        
        ! Accept a connection on the host and port.
        SocketAccept welcome_socket, client_socket \Time:=WAIT_MAX;
        
        ! Close the welcome socket, as it is no longer needed.
        SocketClose welcome_socket;
        
    ENDPROC
    
    ! Close the connection to the client.
    PROC CloseConnection()
        SocketClose client_socket;
    ENDPROC
ENDMODULE