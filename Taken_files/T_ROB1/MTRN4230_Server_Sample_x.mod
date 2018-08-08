MODULE MTRN4230_Server_Sample_x

    ! The socket connected to the client.
    VAR socketdev client_socket;
    
    ! The host and port that we will be listening for a connection on.
    PERS string host := "192.168.125.1";
    
    CONST num port := 1025;
    
    PROC Main ()
        IF RobOS() THEN
            host := "192.168.125.1";
        ELSE
            host := "127.0.0.1";
        ENDIF
        MainServer;
        
    ENDPROC

    PROC MainServer()
        
        VAR string received_str;
        VAR num position := 1;
        VAR num next_position := 1;
        VAR num substrings_found := 0;
        VAR string substrings{10};
        
        ListenForAndAcceptConnection;
            
        ! Receive a string from the client.
        SocketReceive client_socket \Str:=received_str;
        
        WHILE position < StrLen(received_str) AND substrings_found < 10 DO
            next_position := StrFind(received_str, position, STR_WHITE);
            
            substrings{substrings_found + 1} := StrPart(received_str, position, next_position - position);
            substrings_found := substrings_found + 1;
            position := next_position + 1;
        ENDWHILE
        
        ! Send the string back to the client, adding a line feed character.
        position := 1;
        WHILE position <= substrings_found DO
            SocketSend client_socket \Str:=(substrings{position} + "\0A");
            position := 1;
        ENDWHILE

        CloseConnection;
		
    ENDPROC

    PROC ListenForAndAcceptConnection()
        
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