MODULE moveModule
    
    PERS bool actionReady := FALSE;
    PERS bool pause := FALSE;
    PERS bool abort := FALSE;
    PERS num frame := 1; ! 0 for curent pos, 1 for table, 2 for conveyor,
    PERS num frameOfRef := 0;
    PERS num mode := 3;
    PERS num action := 1; ! 1 for move, 2 for pose, 3 for jog
    PERS speeddata speed:= [100, 500, 5000, 1000];
    PERS num stepSize:= 5;
    PERS num rotSize := 1;
    PERS num offset_x := 0; 
    PERS num offset_y := 0;
    PERS num offset_z := 0;
    PERS num offset_j1 := -90;
    PERS num offset_j2 := 0;
    PERS num offset_j3 := 0;
    PERS num offset_j4 := 0;
    PERS num offset_j5 := 0;
    PERS num offset_j6 := 0;
    PERS num jog_x := 0;
    PERS num jog_y := 0;
    PERS num jog_z := 0;
    PERS num readyForNextCommand;
    CONST num queueLength := 100;
    PERS num actionQueue{queueLength,13};
    PERS num queueFront := 1;
    PERS num queueBack := 1;
    
    VAR intnum pauseTrig;
    VAR intnum abortTrig;
    VAR bool first := TRUE;
    
    VAR num testFlag := 0;
    
    PROC Main()
        
        IF first THEN
            first := FALSE;
            CONNECT pauseTrig WITH pauseMovement;
            CONNECT abortTrig WITH cancelMovement;
            ITimer 0.25, pauseTrig;
            ITimer 0.25, abortTrig;
            queueFront := 1;
            queueBack := 1;
        ENDIF
        
        IF queueFront = queueBack THEN
            actionReady := FALSE;
        ENDIF
        
        WaitUntil actionReady;
	readyForNextCommand:=0;
        
        IF action <> 3 THEN
            unpackAction;
        ENDIF
        
        ! Check action
        IF action = 1 THEN
            ! Move
            moveAction;
            
        ELSEIF action = 2 THEN
            ! Pose
            poseAction;
            
        ELSEIF action = 3 THEN
            ! set action as not jogging for queueing purposes
            action := 1;
            
        ENDIF
        
    ENDPROC
    
    PROC incrementQueueFront()
        ! Looping queue from 1 to 100
        IF queueFront = queueLength THEN
            queueFront := 1;
        ELSE
            queueFront := queueFront + 1;
        ENDIF
        
    ENDPROC
    
    PROC unpackAction()
        
        action := actionQueue{queueFront,1};
        mode := actionQueue{queueFront,2};
        frameOfRef := actionQueue{queueFront,3};
        frame := actionQueue{queueFront,4};
        offset_x := actionQueue{queueFront,5};
        offset_y := actionQueue{queueFront,6};
        offset_z := actionQueue{queueFront,7};
        offset_j1 := actionQueue{queueFront,8};
        offset_j2 := actionQueue{queueFront,9};
        offset_j3 := actionQueue{queueFront,10};
        offset_j4 := actionQueue{queueFront,11};
        offset_j5 := actionQueue{queueFront,12};
        offset_j6 := actionQueue{queueFront,13};
        
        incrementQueueFront;
        
    ENDPROC
    
    PROC poseAction()
        VAR jointtarget JTarget;
        
        JTarget.robax := [offset_j1, offset_j2, offset_j3, offset_j4, offset_j5, offset_j6];
        MoveAbsJ JTarget, speed,fine,tSCup;
        readyForNextCommand:=1;
    ENDPROC
    
    
    
    PROC moveAction()
        VAR jointtarget JTarget;
        VAR robtarget RTarget;
        VAR num x := 0;
        VAR num y := 0;
        VAR num z := 0;
        
        ! Check mode
        IF mode = 1 THEN
            ! Moving joins 1-3
            JTarget := CjointT();
            JTarget.robax.rax_1 := JTarget.robax.rax_1 + offset_x;
            JTarget.robax.rax_1 := JTarget.robax.rax_2 + offset_y;
            JTarget.robax.rax_1 := JTarget.robax.rax_3 + offset_z;
            
            MoveAbsJ JTarget, speed,fine,tSCup;
            
        ELSEIF mode = 2 THEN
            ! Moving joints 4-6
            JTarget := CjointT();
            JTarget.robax.rax_1 := JTarget.robax.rax_4 + offset_x;
            JTarget.robax.rax_1 := JTarget.robax.rax_5 + offset_y;
            JTarget.robax.rax_1 := JTarget.robax.rax_6 + offset_z;
            
            MoveAbsJ JTarget, speed,fine,tSCup;
            
        ELSEIF mode = 3 THEN
            ! Moving linear
            moveLinear;
            
        ELSEIF mode = 4 THEN
            ! Moving rotation
            RTarget := CROBT();
            x := RTarget.trans.x - pTableHome.trans.x;
            y := RTarget.trans.y - pTableHome.trans.y;
            z := RTarget.trans.z - pTableHome.trans.z;
            MoveL RelTool(Offs(pTableHome, x, y, z), 0, 0, 0, \Rx:=offset_x, \Ry:=offset_y, \Rz:=offset_z), speed, fine, tSCup;
            
        ENDIF
	readyForNextCommand:=1;
        
    ENDPROC
    
    PROC moveLinear()
        VAR jointtarget JTarget;
        JTarget := CjointT();
        
        IF JTarget.robax.rax_5 < 1 AND JTarget.robax.rax_5 > -1 THEN
            JTarget.robax.rax_5 := 5;
            MoveAbsJ JTarget, speed,fine,tSCup;
            
        ENDIF
        
        !SingArea \Wrist;
        
        ! Check frame of reference
        IF frame = 0 THEN
            ! WRT current position
            
            JTarget := CalcJointT(Offs(CRobT(), offset_x, offset_y, offset_z), tSCup);
            MoveL Offs(CRobT(), offset_x, offset_y, offset_z), speed, fine, tSCup;
            
        ELSEIF frame = 1 THEN
            ! WRT table home
            JTarget := CalcJointT(Offs(pTableHome, offset_x, offset_y, offset_z), tSCup);
            MoveL Offs(pTableHome, offset_x, offset_y, offset_z), speed, fine, tSCup;
            
        ELSEIF frame = 2 THEN
            ! WRT conveyor home
            JTarget := CalcJointT(Offs(pConvHome, offset_x, offset_y, offset_z), tSCup);
            MoveL Offs(pConvHome, offset_x, offset_y, offset_z), speed, fine, tSCup;
            
        ENDIF
	readyForNextCommand:=1;
    ERROR
    
        IF ERRNO = ERR_ROBLIMIT THEN
            testFlag := ERR_ROBLIMIT;
            !RETRY;
            EXITCYCLE;
        ENDIF
        
    ENDPROC
    
    TRAP pauseMovement
        !Interrupt on detection of pause variable set to 1. Waits until it is 0 to begin movement again.
        IF pause = TRUE THEN
            ISleep pauseTrig;
            ISleep abortTrig;
        	StopMove \Quick;
        	WaitUntil pause = FALSE;
        	StartMove;
            testFlag := testFlag + 1;
            IWatch pauseTrig;
            IWatch abortTrig;
        ENDIF
    ENDTRAP

    TRAP cancelMovement
        ! Interrupt on detection of cancel variable set to 1. Restores to home position.
        IF abort = TRUE THEN
            abort := FALSE;
            StopMove \Quick;
            ClearPath;
            StartMove;
            queueFront := 1;
            queueBack := 1;
            ExitCycle;
        ENDIF
        
    ENDTRAP
    
ENDMODULE