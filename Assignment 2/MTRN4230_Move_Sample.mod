MODULE MTRN4230_Move_Sample
    
    PERS string str;
    
    ! The Main procedure. When you select 'PP to Main' on the FlexPendant, it will go to this procedure.
    PROC MainMove()
        
        VAR bool ok;
        VAR num posT;
        VAR num posX;
        VAR num posY;
        VAR num posZ;
        VAR num posS;
        VAR num posZo;
        VAR num found;
        VAR string typeOfOperation;
        VAR num xoffset;
        VAR num yoffset;
        VAR num zoffset;
        VAR num speed;
        VAR string zone;
        VAR num zonenum;
        VAR speeddata vel;
        VAR zonedata zoe;
        VAR zonedata zonebase;
        VAR jointtarget jtg;
        
        zonebase := z1;
        
        ! This is a procedure defined in a System Module, so you will have access to it.
        ! This will move the robot to its calibration.
        !MoveToCalibPos;
        
        ! Call a procedure that we have defined below.
       ! MoveJSample;
        
        ! Call another procedure that we have defined.
        !MoveLSample;
        
        
        posT := StrFind(str,1,STR_WHITE);
        typeOfOperation := StrPart(str,1,posT-1);
        IF typeOfOperation = "Move2PoseRelTHome" THEN      
            posX := StrFind(str,posT+1,STR_WHITE);
            posY := StrFind(str,posX+1,STR_WHITE);
            posZ := StrFind(str,posY+1,STR_WHITE);
            posS := StrFind(str,posZ+1,STR_WHITE);
            posZo := StrFind(str,posS+1,STR_WHITE);
            
            ok:=StrToVal(StrPart(str,posT+1,posX-posT-1),xoffset);
            ok:=StrToVal(StrPart(str,posX+1,posY-posX-1),yoffset);
            ok:=StrToVal(StrPart(str,posY+1,posZ-posY-1),zoffset);
            ok:=StrToVal(StrPart(str,posZ+1,posS-posZ-1),speed);
            ok := StrToVal(StrPart(str,posS+1,posZo-posS-1),zonenum);
            
            vel.v_tcp := speed;
            vel.v_ori := 500;
            vel.v_leax := 5000;
            vel.v_reax := 1000;
            IF zone = "fine" THEN
                zoe := fine;
            ELSE
                zoe.finep := FALSE;
                zoe.pzone_eax := zonebase.pzone_eax * zonenum;
                zoe.pzone_ori := zonebase.pzone_ori * 1.5 * zonenum;
                zoe.pzone_tcp := zonebase.pzone_tcp * 1.5 * zonenum;
                zoe.zone_leax := zonebase.zone_leax * 1.5 * zonenum;
                zoe.zone_ori := zonebase.zone_ori * 1.5 * zonenum;
                zoe.zone_reax := zonebase.zone_reax * 1.5 * zonenum;
            ENDIF
            
            VariableSample pTableHome, xoffset, yoffset, zoffset, vel, zoe;
        ELSEIF typeOfOperation = "Move2PoseRelCHome" THEN
            posX := StrFind(str,posT+1,STR_WHITE);
            posY := StrFind(str,posX+1,STR_WHITE);
            posZ := StrFind(str,posY+1,STR_WHITE);
            posS := StrFind(str,posZ+1,STR_WHITE);
            posZo := StrFind(str,posS+1,STR_WHITE);
            
            ok:=StrToVal(StrPart(str,posT+1,posX-posT-1),xoffset);
            ok:=StrToVal(StrPart(str,posX+1,posY-posX-1),yoffset);
            ok:=StrToVal(StrPart(str,posY+1,posZ-posY-1),zoffset);
            ok:=StrToVal(StrPart(str,posZ+1,posS-posZ-1),speed);
            ok := StrToVal(StrPart(str,posS+1,posZo-posS-1),zonenum);
            
            vel.v_tcp := speed;
            vel.v_ori := 500;
            vel.v_leax := 5000;
            vel.v_reax := 1000;
            IF zone = "fine" THEN
                zoe := fine;
            ELSE
                zoe.finep := FALSE;
                zoe.pzone_eax := zonebase.pzone_eax * zonenum;
                zoe.pzone_ori := zonebase.pzone_ori * 1.5 * zonenum;
                zoe.pzone_tcp := zonebase.pzone_tcp * 1.5 * zonenum;
                zoe.zone_leax := zonebase.zone_leax * 1.5 * zonenum;
                zoe.zone_ori := zonebase.zone_ori * 1.5 * zonenum;
                zoe.zone_reax := zonebase.zone_reax * 1.5 * zonenum;
            ENDIF
            
            VariableSample pConvHome, xoffset, yoffset, zoffset, vel, zoe;
            
        ELSEIF typeOfOperation = "Move2Pose" THEN
            
            jtg:=[[10,10,10,10,10,10],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
            MoveAbsJ jtg,v1000,z50,tool0;
            
        ENDIF
        
        ! Call another procedure, but provide some input arguments.
        
        
    ENDPROC
    
    PROC MoveJSample()
    
        ! 'MoveJ' executes a joint motion towards a robtarget. This is used to move the robot quickly from one point to another when that 
        !   movement does not need to be in a straight line.
        ! 'pTableHome' is a robtarget defined in system module. The exact location of this on the table has been provided to you.
        ! 'v100' is a speeddata variable, and defines how fast the robot should move. The numbers is the speed in mm/sec, in this case 100mm/sec.
        ! 'fine' is a zonedata variable, and defines how close the robot should move to a point before executing its next command. 
        !   'fine' means very close, other values such as 'z10' or 'z50', will move within 10mm and 50mm respectively before executing the next command.
        ! 'tSCup' is a tooldata variable. This has been defined in a system module, and represents the tip of the suction cup, telling the robot that we
        !   want to move this point to the specified robtarget. Please be careful about what tool you use, as using the incorrect tool will result in
        !   the robot not moving where you would expect it to. Generally you should be using
        MoveJ pTableHome, v100, fine, tSCup;
        
    ENDPROC
    
    PROC MoveLSample()
        
        ! 'MoveL' will move in a straight line between 2 points. This should be used as you approach to pick up a chocolate
        ! 'Offs' is a function that is used to offset an existing robtarget by a specified x, y, and z. Here it will be offset 100mm in the positive z direction.
        !   Note that function are called using brackets, whilst procedures and called without brackets.
        MoveL Offs(pTableHome, 0, 0, 100), v100, fine, tSCup;
        
    ENDPROC
   
    PROC VariableSample(robtarget target, num x_offset, num y_offset, num z_offset, speeddata speed, zonedata zone)
        
        ! Call 'MoveL' with the input arguments provided.
        MoveL Offs(target, x_offset, y_offset, z_offset), speed, zone, tSCup;
        
    ENDPROC
    
ENDMODULE