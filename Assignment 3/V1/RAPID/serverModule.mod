MODULE serverModule

    ! MTRN ROBOTICS COMMON PROCEDURES
    !********************************
    ! For the ABB IRB120 Robot in the Mechatronics Blockhouse Lab for the MTRN4230 Robotics Course 2014

    !-----------------------------------------------------------------------------------------------------
    !-----------------------------------------------------------------------------------------------------


    PERS bool actionReady:=TRUE;
    PERS bool pause:=FALSE;
    PERS bool abort:=FALSE;
    PERS num frame:=1;
    ! 0 for curent pos, 1 for table, 2 for conveyor,
    PERS num frameOfRef:=0;
    ! 0 for base, 1 for tool
    PERS num mode:=3;
    ! TODO
    PERS num action:=2;
    ! 1 for move, 2 for pose, 3 for jog
    PERS speeddata speed:=[100,500,5000,1000];
    PERS speeddata jogSpeed:=[100,5,5000,1000];
    PERS num stepSize:=5;
    PERS num rotSize:=1;
    PERS num offset_x:=0;
    PERS num offset_y:=0;
    PERS num offset_z:=40;
    PERS num offset_j1:=90;
    PERS num offset_j2:=0;
    PERS num offset_j3:=0;
    PERS num offset_j4:=0;
    PERS num offset_j5:=0;
    PERS num offset_j6:=0;
    PERS num jog_x:= 0;
    PERS num jog_y:= 0;
    PERS num jog_z:= 0;
    PERS num readyForNextCommand;
    
    CONST num queueLength := 100;
    PERS num actionQueue{queueLength,13};
    PERS num queueFront := 19;
    PERS num queueBack := 19;
    
    VAR socketdev client_socket;
    VAR bool temp;
    VAR num dtrack:=0;

    VAR num ID_end_mon;
    VAR num ID_last_mon;
    VAR string ID_mon;

    VAR intnum robClose;
    VAR string outTest;
    
    !-----------------------------------------------------------------------------------------------------
    !-----------------------------------------------------------------------------------------------------

    PROC main()
        queueFront := 1;
        queueBack := 1;
        readyForNextCommand:=1;
        speed:=v500;
        listenandstartConnection;
        startListening;
    ENDPROC

    PROC listenandstartConnection()
!        VAR num port:= 50000;
!        VAR string host:="192.168.0.5";
        VAR num port:=56000;
        VAR string host:="192.168.0.5"; !"192.168.125.1";
        VAR socketdev welcome_socket;
        VAR string receivedString:="";
        
        ! Create the socket to listen for a connection on. 
        SocketClose client_socket;
        SocketCreate welcome_socket;

        ! Bind the socket to the host and port.
        SocketBind welcome_socket,host,port;

        ! Listen on the welcome socket.
        SocketListen welcome_socket;

        ! Accept a connection on the host and port.
        SocketAccept welcome_socket,client_socket;

        ! SocketReceive client_socket\Str:=receivedString\Time:=WAIT_MAX;

        ! Close the welcome socket, as it is no longer needed.
        SocketClose welcome_socket;

    ERROR
        IF ERRNO=ERR_SOCK_TIMEOUT THEN
            RETRY;
        ELSEIF ERRNO=ERR_SOCK_CLOSED THEN
            SocketClose client_socket;
            SocketClose welcome_socket;
            listenandstartConnection;
        ELSE
            STOP;
        ENDIF
    ENDPROC

    PROC startListening()
        VAR string receivedString;

        WHILE TRUE DO

            ! Wait to recieve message
            SocketReceive client_socket\Str:=receivedString\Time:=WAIT_MAX;

            ! Decode and enact message
            ParseString(receivedString);

            ! Send response
            ! SocketSend client_socket\Str:=recieved_str;

        ENDWHILE
        SocketClose client_socket;

    ERROR

        IF ERRNO=ERR_SOCK_TIMEOUT THEN
            RETRY;

        ELSEIF ERRNO=ERR_SOCK_CLOSED THEN
            SocketClose client_socket;
            listenandstartConnection;
            RETRY;

        ELSE
            STOP;

        ENDIF

    ENDPROC

    PROC ParseString(string received_str)

        VAR string ID;
        VAR num ID_last;
        VAR num ID_end;
        
        VAR num temp_x;
        VAR num temp_y;
        VAR num temp_z;
        VAR num temp_j1;
        VAR num temp_j2;
        VAR num temp_j3;
        VAR num temp_j4;
        VAR num temp_j5;
        VAR num temp_j6;

        ID_end:=StrFind(received_str,1,"_");
        ID:=StrPart(received_str,1,ID_end-1);
	
	IF ID = "READY" THEN
	    ! check if the robot is ready to accept a new command
	    ! Reply with 1 or 0;
	    IF readyForNextCommand = 1 THEN
	        SocketSend client_socket\Str:="1";
	    ELSE
                SocketSend client_socket\Str:="0";
	    ENDIF
	
	
        ELSEIF ID = "HEARTBEAT" THEN
            ! Handle HEARTBEAT
            ! Reply with 1 to show socket is still replying
            SocketSend client_socket\Str:="1";
            
        ELSEIF ID="RESUME" THEN
            pause:=FALSE;

        ELSEIF ID="PAUSE" THEN
            pause:=TRUE;

        ELSEIF ID="CANCEL" THEN
            abort:=TRUE;

        ELSEIF ID="SET" THEN
            ! HANDLE SET: POSE, REL
            ! SET_POSE_XYZ %0.2f %0.2f %0.2f, SET_POSE_JOINTS %0.2f %0.2f %0.2f %0.2f %0.2f %0.2f
            ID_last:=ID_end;
            ID_end:=StrFind(received_str,ID_end+1,"_");
            ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);

            IF ID="POSET" THEN
             	ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_x);

                ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_y);

                ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_z);

                actionQueue{queueBack,1} := 1;
                actionQueue{queueBack,2} := mode;
                actionQueue{queueBack,3} := frameOfRef;
                actionQueue{queueBack,4} := frame;
                actionQueue{queueBack,5} := temp_x;
                actionQueue{queueBack,6} := temp_y;
                actionQueue{queueBack,7} := temp_z;
                actionQueue{queueBack,8} := offset_j1;
                actionQueue{queueBack,9} := offset_j2;
                actionQueue{queueBack,10} := offset_j3;
                actionQueue{queueBack,11} := offset_j4;
                actionQueue{queueBack,12} := offset_j5;
                actionQueue{queueBack,13} := offset_j6;
                    
                incrementQueueBack;
                action := 1;
                actionReady := TRUE;

            ELSEIF ID="POSED" THEN
             	ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_x);

                ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_y);

                ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_z);

                actionQueue{queueBack,1} := 1;
                actionQueue{queueBack,2} := mode;
                actionQueue{queueBack,3} := frameOfRef;
                actionQueue{queueBack,4} := frame;
                actionQueue{queueBack,5} := temp_x;
                actionQueue{queueBack,6} := temp_y;
                actionQueue{queueBack,7} := temp_z;
                actionQueue{queueBack,8} := offset_j1;
                actionQueue{queueBack,9} := offset_j2;
                actionQueue{queueBack,10} := offset_j3;
                actionQueue{queueBack,11} := offset_j4;
                actionQueue{queueBack,12} := offset_j5;
                actionQueue{queueBack,13} := offset_j6;
                    
                incrementQueueBack;
                action := 1;
                actionReady := TRUE;

            ELSEIF ID="JOINTS" THEN
                ! Handle set pose
                ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_j1);

                ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_j2);
 
                ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_j3);

                ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_j4);

                ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_j5);

                ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
                temp:=StrToVal(ID,temp_j6);
                actionQueue{queueBack,1} := 2;
                actionQueue{queueBack,2} := mode;
                actionQueue{queueBack,3} := frameOfRef;
                actionQueue{queueBack,4} := frame;
                actionQueue{queueBack,5} := offset_x;
                actionQueue{queueBack,6} := offset_y;
                actionQueue{queueBack,7} := offset_z;
                actionQueue{queueBack,8} := temp_j1;
                actionQueue{queueBack,9} := temp_j2;
                actionQueue{queueBack,10} := temp_j3;
                actionQueue{queueBack,11} := temp_j4;
                actionQueue{queueBack,12} := temp_j5;
                actionQueue{queueBack,13} := temp_j6;
                incrementQueueBack;
                action:=2;
                actionReady:=TRUE;
            ENDIF

            ELSEIF ID="REL" THEN
                ! Handle REL: POS
                ID_last:=ID_end;
                ID_end:=StrFind(received_str,ID_end+1,"_");
                ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);

                IF ID="POS" THEN
                    ! Handle POS: Table, Conv, Curr
                    ID_last:=ID_end;
                    ID_end:=StrFind(received_str,ID_end+1,"_");
                    ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);

                    IF ID="Curr" THEN
                        frame:=0;
                    ELSEIF ID="Table" THEN
                        frame:=1;
                    ELSEIF ID="Conv" THEN
                        frame:=2;
                    ENDIF

                ENDIF

   ELSEIF ID="DIO" THEN
            ! Handle DIO: DIO_1_X, DIO_2_X, DIO_3_X, DIO_4_X
            setDIO(received_str);

	ELSEIF ID="VacCtrl" THEN
	    VacCtrl(received_str);

	ELSEIF ID="ConvCtrl" THEN
	    ConvCtrl(received_str);


        ELSEIF ID="REQ" THEN
            ! Handle REQ:  REQ_POSE, REQ_ ERROR, REQ_CONSTANT
            ID_last:=ID_end;
            ID_end:=StrFind(received_str,ID_end+1,"_");
            ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);
            ID_end_mon:=ID_end;
            ID_last_mon:=ID_last;
            ID_mon:=ID;

            IF ID="POSE" THEN
                ! Send current joint position
                sendCurrentPosition;

            ELSEIF ID="ERR" THEN
                ! Send error status

                sendErrors;

                ! SocketSend client_socket\Str:="1";

            ELSEIF ID="CONSTAT" THEN
                ! Send the conveyors DO status
                outTest := NumToStr(DInput(DI10_1),0);
                SocketSend client_socket\Str:=( NumToStr(DInput(DI10_1),0) );

            ENDIF

         ! Old standard
            
!        ELSEIF ID="PROG" THEN
!            ! Handle PROG: PROG_RESUME, PROG_PAUSE, PROG_CANCEL
!            ID_last:=ID_end;
!            ID_end:=StrFind(received_str,ID_end+1,"_");
!            ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);

!                        IF ID = "RESUME" THEN
!                            pause := FALSE;
!                        ELSEIF ID = "PAUSE" THEN
!                            pause := TRUE;
!                        ELSEIF ID = "CANCEL" THEN
!                            abort := TRUE;    
!                        ENDIF

        ELSEIF ID="SPEED" THEN
            ! Handle SDP: V5, V100, V1000, VMAX
            ID_last:=ID_end;
            ID_end:=StrFind(received_str,ID_end+1,"_");
            ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);

            ! Set speed as specified
            IF ID="V5" THEN
                jogSpeed:=[5,1,5000,1000];
                !based off v5 [5,500,5000,1000]
                speed:=v5;
                stepSize:=1;
                rotSize:=1;
            ELSEIF ID="V100" THEN
                jogSpeed:=[100,5,5000,1000];
                !5 !based off v100 [100,500,5000,1000]
                speed:=v100;
                stepSize:=5;
                rotSize:=1;
            ELSEIF ID="V1000" THEN
                jogSpeed:=[1000,15,5000,1000];
                !10 !based off v1000 [1000,500,5000,1000]
                speed:=v1000;
                stepSize:=15;
                rotSize:=1;
            ELSEIF ID="VMAX" THEN
                jogSpeed:=[1000,15,5000,1000];
                !10 !based off v1000 [1000,500,5000,1000]
                speed:=v1000;
                stepSize:=15;
                rotSize:=1;
            ENDIF

          ELSEIF ID="MODE" THEN
            ! Handle MDE: Mode1, Mode2, Mode3, Mode4
            ID_last:=ID_end;
            ID_end:=StrFind(received_str,ID_end+1,"_");
            ID:=StrPart(received_str,ID_last+1,ID_end-ID_last-1);

            IF ID="Mode 1" THEN
                mode:=1;
            ELSEIF ID="Mode 2" THEN
                mode:=2;
            ELSEIF ID="Mode 3" THEN
                mode:=3;
            ELSEIF ID="Mode 4" THEN
                mode:=4;
            ENDIF
        ENDIF
	ENDPROC
    
    PROC incrementQueueBack()
        ! Looping queue from 1 to 100
        IF queueBack = queueLength THEN
            queueBack := 1;
        ELSE
            queueBack := queueBack + 1;
        ENDIF
        
    ENDPROC
    
    FUNC bool isJogging()
        
        ! TODO
        
        RETURN FALSE;
    ENDFUNC

    ! Fetches error statuses and and sends them t the GUI
    PROC sendErrors()
        
        ! Emergency stop: DO_ESTOP, DO_ESTOP2
        ! Light curtain: DO_LIGHT_CURTAIN
        ! Motors are off: DI_MOTOR_ON, DO_MOTOR_ON_STATE
        ! Hold to enable not pressed: DO_HOLD_TO_ENABLE
        ! Motion task not running/ Execution Error: DO_EXEC_ERR
        ! Motion supervision triggered: DO_MOTION_SUP_TRIG
        ! Conveyor is not enabled when trying to use the conveyor:
        ! DO_TROB_RUNNING
        ! 
        ! Order expected from GUI:
        ! [eStop, Light Curtain, Motors off, hold to enable not pressed,
        ! execution error, motion supervision triggered,
        ! conveyor not enabled when trying to use conveyor]

        VAR string output_str:= "";
        dtrack:= dtrack + 1;
        ! Emergency stop
        IF DOutput(DO_ESTOP) = 0 OR DOutput(DO_ESTOP2) = 1 THEN
            ! Append 1
            output_str := output_str + "1";
        ELSE
            ! Append 0
            output_str := output_str + "0";
        ENDIF
        
        ! Light curtain
        IF DOutput(DO_LIGHT_CURTAIN) = 0 THEN
            ! Append 1
            output_str := output_str + " 1"; ! For robot applicaton
!           output_str := output_str + " 0"; ! For Testing as is always triggered in virtual machine
        ELSE
            ! Append 0
            output_str := output_str + " 0";
        ENDIF
        
        ! Motors off
        IF DOutput(DO_MOTOR_ON_STATE) = 0 THEN
            ! Append 1
            output_str := output_str + " 1";
        ELSE
            ! Append 0
            output_str := output_str + " 0";
        ENDIF
        
        ! hold to enable not pressed
        IF DOutput(DO_HOLD_TO_ENABLE) = 1 THEN
            ! Append 1
            output_str := output_str + " 1";
        ELSE
            ! Append 0
            output_str := output_str + " 0";
        ENDIF
        
        ! execution error
        IF DOutput(DO_EXEC_ERR) = 1 THEN
            ! Append 1
            output_str := output_str + " 1";
        ELSE
            ! Append 0
            output_str := output_str + " 0";
        ENDIF
        
        ! motion supervision triggered
        IF DOutput(DO_MOTION_SUP_TRIG) = 1 THEN
            ! Append 1
            output_str := output_str + " 1";
        ELSE
            ! Append 0
            output_str := output_str + " 0";
        ENDIF
        
        ! conveyor not enabled when trying to use conveyor
        ! Code won't allow this to happen so hard coded as not triggered for now
        ! Append 0
        output_str := output_str + " 0";
        
        SocketSend client_socket\Str:=output_str;
        
    ENDPROC

    ! Set DIO based on recieved str
    PROC setDIO(string recieved_str)
        VAR string type;
        VAR string value;
        type:=StrPart(recieved_str,5,1);
        value:=StrPart(recieved_str,7,1);

        IF type="1" THEN
            functionConRun(value);

        ELSEIF type="2" THEN
            functionConDir(value);

        ELSEIF type="3" THEN
            functionVacSol(value);

        ELSEIF type="4" THEN
            functionVacPwr(value);

        ENDIF
    ENDPROC



    !!! --- Written by Angat Vora, check this in the lab
    PROC VacCtrl(string recieved_str)
        VAR string sol;
	VAR string pump;
	
	sol:=StrPart(recieved_str,9,1);
	pump:=StrPart(recieved_str,11,1);

	functionVacSol(sol);
	functionVacPwr(pump);
	
    ENDPROC

    PROC ConvCtrl(string recieved_str)
        VAR string dir;
	VAR string convrun;
	
	dir:=StrPart(recieved_str,10,1);
	convrun:=StrPart(recieved_str,12,1);

	functionConDir(dir);
	functionConRun(convrun);
    ENDPROC




    ! Sends joind and end effector position to GUI
    PROC sendCurrentPosition()
        VAR jointtarget JTarget;
        VAR robtarget PTarget;
        VAR string j1;
        VAR string j2;
        VAR string j3;
        VAR string j4;
        VAR string j5;
        VAR string j6;
        VAR string x;
        VAR string y;
        VAR string z;

        !CJointT reads the current joint angles.
        JTarget:=CJointT();
        j1:=NumToStr(JTarget.robax.rax_1,2);
        j2:=NumToStr(JTarget.robax.rax_2,2);
        j3:=NumToStr(JTarget.robax.rax_3,2);
        j4:=NumToStr(JTarget.robax.rax_4,2);
        j5:=NumToStr(JTarget.robax.rax_5,2);
        j6:=NumToStr(JTarget.robax.rax_6,2);

        PTarget:=CRobT();
        x:=NumToStr(PTarget.trans.x,2);
        y:=NumToStr(PTarget.trans.y,2);
        z:=NumToStr(PTarget.trans.z,2);

        SocketSend client_socket\Str:=(j1+" "+j2+" "+j3+" "+j4+" "+j5+" "+j6+" "+x+" "+y+" "+z);

    ENDPROC

    ! Digital output setters
    PROC functionVacPwr(string onOff)

        IF onOff="1" THEN
            SetDO DO10_1,1;
        ELSE
            SetDO DO10_1,0;
        ENDIF

    ENDPROC

    PROC functionVacSol(string onOff)
        IF onOff="1" THEN
            SetDO DO10_2,1;
        ELSE
            SetDO DO10_2,0;
        ENDIF

    ENDPROC

    PROC functionConRun(string onOff)
        IF onOff="1" AND DI10_1=1 THEN
            SetDO DO10_3,1;
        ELSE
            SetDO DO10_3,0;
        ENDIF

    ENDPROC

    PROC functionConDir(string onOff)
        IF onOff="1" THEN
            SetDO DO10_4,1;
        ELSE
            SetDO DO10_4,0;
        ENDIF

    ENDPROC

    !-----------------------------------------------------------------------------------------------------
    !-----------------------------------------------------------------------------------------------------

    !Important resources:
    !http://developercenter.robotstudio.com/BlobProxy/manuals/RapidIFDTechRefManual/doc522.html  - This is jointtarget struct definition.
    !http://developercenter.robotstudio.com/BlobProxy/manuals/RapidIFDTechRefManual/doc545.html  - Robtarget struct definition.
    !http://developercenter.robotstudio.com/BlobProxy/manuals/RapidIFDTechRefManual/doc110.html  - MoveAbsJ definition
    !https://library.e.abb.com/public/688894b98123f87bc1257cc50044e809/Technical%20reference%20manual_RAPID_3HAC16581-1_revJ_en.pdf  - Full Library of functions.
    !http://developercenter.robotstudio.com/BlobProxy/manuals/RapidIFDTechRefManual/doc122.html  - MoveL definition.
    !https://forums.robotstudio.com/discussion/10118/character-comparison - link to string functions of page
    !http://developercenter.robotstudio.com/BlobProxy/manuals/IRC5FlexPendantOpManual/doc141.html  - multitasking resourse
    !http://developercenter.robotstudio.com/BlobProxy/manuals/RapidIFDTechRefManual/doc30.html - CONNECT function resourse

ENDMODULE