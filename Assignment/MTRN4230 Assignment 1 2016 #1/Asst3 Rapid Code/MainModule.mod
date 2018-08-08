MODULE MainModule
    
    
    PROC Main()
        !Author: Roshen Mathew
        !Date Created: 2/5/16 
        !Date Modified Last: 31/5/16
        !this is the main function that robot studio will run. This also handles all the motion of the robot as well
        !as the communication with matlab.
        
        
        !SetSpeed v1000;
        VAR num buffer:= 0;
        
        MoveToCalibPos;
        !Init_IO;
        currentJ;
        MoveAbsJ [[0,0,0,0,pi/2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]], robSpeed,fine, tool0;
        j1 := -90;
        updateJoints;
        WHILE serverFlag <> 0 DO
            serverFlag := StartServer1();
        ENDWHILE
        
        WHILE ListenFlag = 1 DO
            IF serverFlag = 0 THEN
                Listen;
            ELSEIF serverFlag = 1 THEN
                CloseConnection;
            ENDIF
        ENDWHILE
        Close_IO;
        
        
    ENDPROC
    
    PROC Init_IO()
        !Author: Roshen Mathew
        !Date Created: 2/5/16 
        !Date Modified Last: 2/5/16
        !Runs through all the IOs and checks that they all work
        
        TurnVacOn;
        ! Time to wait in seconds.
        WaitTime 2;
        TurnVacOff;
        
        ConToRob;
        TurnConOnSafely;
        WaitTime 2;
        TurnConOff;
        
        ConAwayRob;
        TurnConOnSafely;
        WaitTime 2;
        TurnConOff;
        
        
    ENDPROC
    
    PROC Close_IO ()
        !Author: Roshen Mathew
        !Date Created: 2/5/16 
        !Date Modified Last: 2/5/16
        !Turns off any IOs that may be running
        TurnVacOff;
        TurnConOff;
        TurnSolOff;
    ENDPROC
        
        
    
    PROC Listen()
        !Author: Roshen Mathew
        !Date Created: 2/5/16 
        !Date Modified Last: 31/5/16
        !Reads the string sent by matlab and extracts the useful data to detrmine which command is being asked
        !as well as the inout values. It will also run the command that was sent
        !Returns a sucessful command back to matlab in order to run next command
        
        VAR string Scommand;
        VAR string Saction;
        VAR string Sproc;
        VAR string Sjoint;
        VAR string Sxi;
        VAR string Syi;
        VAR string Szi;
        VAR string Sti;
        VAR string Sxf;
        VAR string Syf;
        VAR string Szf;
        VAR string Stf;
        
        VAR num Vjoint;
        VAR num xi;
        VAR num yi;
        VAR num zi;
        VAR num ti;
        VAR num xf;
        VAR num yf;
        VAR num zf;
        VAR num tf;
        VAR num size_command;
        VAR bool check;
        SocketReceive client_socket \Str:=Scommand;
        !\ReadNoOfBytes:=size_command;
        size_command:= StrLen(Scommand);
        Saction := StrPart(Scommand,1,3);
        Sproc := StrPart(Scommand,5,1);
        Sjoint := StrPart(Scommand,7,7);
        Sxi := StrPart(Scommand,15,7);
        Syi := StrPart(Scommand,23,7);
        Szi := StrPart(Scommand,31,7);
        Sti := StrPart(Scommand,39,7);
        Sxf := StrPart(Scommand,47,7);
        Syf := StrPart(Scommand,55,7);
        Szf := StrPart(Scommand,63,7);
        Stf := StrPart(Scommand,71,7);

        check := StrToVal(Sjoint,Vjoint);
        check := StrToVal(Sxi,xi);
        check := StrToVal(Syi,yi);
        check := StrToVal(Szi,zi);
        check := StrToVal(Sti,ti);
        check := StrToVal(Sxf,xf);
        check := StrToVal(Syf,yf);
        check := StrToVal(Szf,zf);
        check := StrToVal(Stf,tf);
        
        IF Saction = "S01" THEN      
            j1 := Vjoint;
            updateJoints;
            SocketSend client_socket \Str:=("100" + "\0A");
        ELSEIF Saction = "S02" THEN
            j2 := Vjoint;
            updateJoints;
            SocketSend client_socket \Str:=("100" + "\0A");
        ELSEIF Saction = "S03" THEN
            j3 := Vjoint;
            updateJoints;
            SocketSend client_socket \Str:=("100" + "\0A");
        ELSEIF Saction = "S04" THEN
            j4 := Vjoint;
            updateJoints;
            SocketSend client_socket \Str:=("100" + "\0A");
        ELSEIF Saction = "S05" THEN
            j5 := Vjoint;
            updateJoints;
            SocketSend client_socket \Str:=("100" + "\0A");
        ELSEIF Saction = "S06" THEN
            j6 := Vjoint;
            updateJoints;
            SocketSend client_socket \Str:=("100" + "\0A");
            
        !Conveyer Run
        ELSEIF Saction = "S07" THEN
            IF Sproc = "0" THEN !Off
                TurnConOff;
                SocketSend client_socket \Str:=("100" + "\0A");
            ELSEIF Sproc = "1" THEN !On
                TurnConOnSafely;
                SocketSend client_socket \Str:=("100" + "\0A");
            ELSE
                !Error_Response;
            ENDIF
            
        !Conveyer Direction
        ELSEIF Saction = "S08" THEN
            IF Sproc = "0" THEN !Away
                ConAwayRob;
                SocketSend client_socket \Str:=("100" + "\0A");
            ELSEIF Sproc = "1" THEN !Toward
                ConToRob;
                SocketSend client_socket \Str:=("100" + "\0A");
            ELSE
                !Error_Response;
            ENDIF    
            
        !Vacuum Run
        ELSEIF Saction = "S09" THEN
            IF Sproc = "0" THEN !Off
                TurnVacOff;
                SocketSend client_socket \Str:=("100" + "\0A");
            ELSEIF Sproc = "1" THEN !On
                TurnVacOn;
                SocketSend client_socket \Str:=("100" + "\0A");
            ELSE
                !Error_Response;
            ENDIF           
            
        !Vacuum Grip
        ELSEIF Saction = "S10" THEN
            IF Sproc = "0" THEN !Off
                TurnSolOff;
                SocketSend client_socket \Str:=("100" + "\0A");
            ELSEIF Sproc = "1" THEN !On
                TurnSolOn;
                SocketSend client_socket \Str:=("100" + "\0A");
            ELSE
                !Error_Response;
            ENDIF
            
        !Pause/ Play
        ELSEIF Saction = "S11" THEN
            
        !Table to Table
        ELSEIF Saction = "S12" THEN
            
            check := tableToTable(xi,yi,zi,ti,xf,yf,zf,tf);
            SocketSend client_socket \Str:=("100" + "\0A");
            
        !Table to Flip
        ELSEIF Saction = "S13" THEN
            
            check:= tableToFlip(xi,yi,zi,ti);
            SocketSend client_socket \Str:=("100" + "\0A");
            
        !Flip Retrieval to Table
        ELSEIF Saction = "S14" THEN
            
            check := flipRetrieval(xi,yi,zi,ti,xf,yf,zf,tf);
            SocketSend client_socket \Str:=("100" + "\0A");
            
        !Table to Conveyer
        ELSEIF Saction = "S15" THEN
            
            check := tableToConveyer(xi,yi,zi,ti,xf,yf,zf,tf);
            SocketSend client_socket \Str:=("100" + "\0A");
            
        !Conveyer to Table
        ELSEIF Saction = "S16" THEN
            
            check := conveyerToTable(xi,yi,zi,ti,xf,yf,zf,tf);
            SocketSend client_socket \Str:=("100" + "\0A");

	ELSEIF Saction = "S17" THEN
            
		outOfWay;
		SocketSend client_socket \Str:=("100" + "\0A");

        ENDIF

    ENDPROC
    
    PROC getData()
        currentJ;
        currentR;
    ENDPROC
    
    
    
ENDMODULE