% --- Group: 9
% --- Purpose: A calling function which will repeat periodically to recieve
% ------------ information from RAPID and to send any commands stored in
% ------------ command queue.

function SendAndRecieve(obj, event)
global QUIT
global CommandQueue
global Params
global TargetPose
global CommSocket
global Handles
global SentCommands
global IO
global ProgControl
global RecvCommands
global Err2Resolve
Err2Resolve = 0;
global Cameras
global Jog
global Increment
global RelPosition

    if ~QUIT
        % --------------------------------------------------
        % --- Attempt to obtain a snapshot image from the Table Camera feed
        % --- Then display this on the table camera plot (Axes1).
        % --- Written by: Angat Vora (z3422540)
        % --------------------------------------------------
        try
        Cameras.TableCam.Image = getsnapshot(Cameras.TableCam.Obj);
        imshow(Cameras.TableCam.Image,'Parent',Handles.axes1);
        catch
        end

        % --------------------------------------------------
        % --- Attempt to obtain a snapshot image from the Conveyor Camera 
        % --- feed. Then display this on the table camera plot (Axes3).
        % --- Written by: Angat Vora (z3422540)
        % --------------------------------------------------
        try
        Cameras.ConvCam.Image = getsnapshot(Cameras.ConvCam.Obj);
        imshow(Cameras.ConvCam.Image,'Parent',Handles.axes3);
        [whiteBoxAnswer] = detect_whiteBox(Cameras.ConvCam.Image);
        hold on;
        plot(whiteBoxAnswer.boundaryX,whiteBoxAnswer.boundaryY,'r-','LineWidth',2);  %%Example outcome.
        hold off;
        catch
        end

        CommSocket.HeartBeat();

        if(CommSocket.STATUS == true)

            % --------------------------------------------------
            % --- Attempt to obtain the current pose of the robot. Then change 
            % --- this display this information in the required static text 
            % --- boxes. Then add string to RECV COMMANDS log.
            % --- Written by: Angat Vora (z3422540)
            % --------------------------------------------------
            try
                CurrentPose = CommSocket.reqCurrentPose();
                if(CommSocket.STATUS)
                    CurrentPose = strsplit(char(CurrentPose),' ');
                    set(Handles.Joint1Angle,'String',CurrentPose{1});
                    set(Handles.Joint2Angle,'String',CurrentPose{2});
                    set(Handles.Joint3Angle,'String',CurrentPose{3});
                    set(Handles.Joint4Angle,'String',CurrentPose{4});
                    set(Handles.Joint5Angle,'String',CurrentPose{5});
                    set(Handles.Joint6Angle,'String',CurrentPose{6});
                    set(Handles.EEX,'String',CurrentPose{7});
                    set(Handles.EEY,'String',CurrentPose{8});
                    set(Handles.EEZ,'String',CurrentPose{9});

                    CommandMsg = "Recieved Pose:";
                    RecvCommands{length(RecvCommands)+1} = CommandMsg;
                    set(Handles.RXcommands,'String',RecvCommands);
                    set(Handles.RXcommands,'ListboxTop',length(RecvCommands));
                    drawnow;
                end
            catch
            end


            % --------------------------------------------------
            % --- Attempt to obtain the state of the errors present. Then 
            % --- change this display this information in the required static 
            % --- text boxes. Then add string to RECV COMMANDS log.
            % --- Written by: Angat Vora (z3422540)
            % --------------------------------------------------
            try
                Errors = CommSocket.reqErrors();
                if(CommSocket.STATUS)
                    Errors = strsplit(char(Errors),' ');
                    Errors = string(Errors);
                    [~,Err] = find(Errors == "1");
                    Err2Resolve = length(Err);
                    Errors(Err) = "on";
                    [~,NoErr] = find(Errors == "0");
                    Errors(NoErr) = "off";

                    if (ismember(7,Err))
                        set(Handles.ConvStatusBtn,'Value',0);
                        set(Handles.ConvStatusBtn,'BackgroundColor',[0.86 0.12 0.12]);
                    end

                    set(Handles.eStopPanel,'Visible',char(Errors(1)));
                    set(Handles.LCPanel,'Visible',char(Errors(2)));
                    set(Handles.motorsPanel,'Visible',char(Errors(3)));
                    set(Handles.holdEnablePanel,'Visible',char(Errors(4)));
                    set(Handles.execErrPanel,'Visible',char(Errors(5)));
                    set(Handles.motionSupPanel,'Visible',char(Errors(6)));
                    set(Handles.convDisPanel,'Visible',char(Errors(7)));

                    CommandMsg = "Recieved Errors:";
                    RecvCommands{length(RecvCommands)+1} = CommandMsg;
                    set(Handles.RXcommands,'String',RecvCommands);
                    set(Handles.RXcommands,'ListboxTop',length(RecvCommands));
                    drawnow;
                end
            catch
            end


            % --------------------------------------------------
            % --- Attempt to obtain the status of the conveyor. Then 
            % --- change this display this information on the IO panel button 
            % --- Conveyor Enabled. Set background colors to display status.
            % --- Then add string to RECV COMMANDS log.
            % --- Written by: Angat Vora (z3422540)
            % --------------------------------------------------
            try
                Constat = CommSocket.reqConstat();
                if(CommSocket.STATUS)
                    Constat = strsplit(char(Constat),' ');
                    Constat = string(Constat);

                    if(str2double(Constat) == 1)
                        set(Handles.ConvStatusBtn,'BackgroundColor',[0.47 0.67 0.19]);
                    else
                        set(Handles.ConvStatusBtn,'BackgroundColor',[0.86 0.12 0.12]);
                        if IO.ConvRun == 1
                            IO.ConvRun = 0;
                            CommandQueue = [CommandQueue,"ConvRun"];
                        end
                    end
                    CommandMsg = "Recieved Conveyor Status:";
                    RecvCommands{length(RecvCommands)+1} = CommandMsg;
                    set(Handles.RXcommands,'String',RecvCommands);
                    set(Handles.RXcommands,'ListboxTop',length(RecvCommands));
                    drawnow;
                end
            catch
            end


            % --------------------------------------------------
            % --- Check the command queue for more commands. If there is and
            % --- connection is active and there are no errors, then obtain the
            % --- next command from the command queue. 
            % --- Written by: Angat Vora (z3422540)
            % --------------------------------------------------
            if ~isempty(CommandQueue) && (CommSocket.STATUS == true) && (Err2Resolve == 0)

                % --------------------------------------------------
                % --- Check the next command, and activated the required case.
                % --- Each case will call on functions from TCPCOMMS() as
                % --- required and update the SENT MESSAGES log if sending was
                % --- successful. Also update IO visual by changing background
                % --- color to match state where required.
                % --- Written by: Angat Vora (z3422540)
                % --------------------------------------------------
                nextCommand = CommandQueue(1);
                switch nextCommand

                    % --------------------------------------------------
                    % --- When there is a POSE to be set (XYZ), this case is
                    % --- activated calling on functions from TCPCOMMS().
                    % --------------------------------------------------
                    case "SetTargetXYZ"
                        try
                            CommSocket.setPoseXYZ(TargetPose.PoseXYZ);

                            if (CommSocket.STATUS)
                                CommandMsg = "Setting Pose XYZ:";
                                CommandMsg2 = sprintf('%.2f, %.2f, %.2f',TargetPose.PoseXYZ(:));
                                SentCommands{length(SentCommands)+1} = CommandMsg;
                                SentCommands{length(SentCommands)+1} = CommandMsg2;
                                set(Handles.TXcommands,'String',SentCommands);
                                set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                            end
                        catch
                        end


                % --------------------------------------------------
                % --- When there is a POSE to be set (JOINTS), this case is
                % --- activated calling on functions from TCPCOMMS().
                % --------------------------------------------------
                case "SetTargetJoints"
                    try
                        CommSocket.setPoseJoints(TargetPose.PoseJoints);
                        if (CommSocket.STATUS)
                            CommandMsg = "Setting Pose Joints:";
                            CommandMsg2 = sprintf('%.2f, %.2f, %.2f, %.2f, %.2f, %.2f',TargetPose.PoseJoints(:));
                            SentCommands{length(SentCommands)+1} = CommandMsg;
                            SentCommands{length(SentCommands)+1} = CommandMsg2;
                            set(Handles.TXcommands,'String',SentCommands);
                            set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        end
                    catch
                    end


                % --------------------------------------------------
                % --- When there is a SPEED to be set, this case is
                % --- activated calling on functions from TCPCOMMS().
                % -------------------------------------------------- 
                case "SetSpeed"
                    try
                        CommSocket.setSpeed(Params.Speed);
                        if (CommSocket.STATUS)
                            CommandMsg = sprintf('Setting Speed: %s', Params.Speed);
                            SentCommands{length(SentCommands)+1} = CommandMsg;
                            set(Handles.TXcommands,'String',SentCommands);
                            set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        end
                    catch
                    end


                % --------------------------------------------------
                % --- When there is a MODE to be set, this case is
                % --- activated calling on functions from TCPCOMMS().
                % -------------------------------------------------- 
                case "SetMode"
                    try
                        CommSocket.setMode(Params.Mode);
                        if (CommSocket.STATUS)
                            CommandMsg = sprintf('Setting Motion Mode: %s', Params.Mode);
                            SentCommands{length(SentCommands)+1} = CommandMsg;
                            set(Handles.TXcommands,'String',SentCommands);
                            set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        end
                    catch
                    end


                % --------------------------------------------------
                % --- When there is a FRAME to be set, this case is
                % --- activated calling on functions from TCPCOMMS().
                % -------------------------------------------------- 
                case "SetFrame"
                    try
                        CommSocket.setFrame(Params.Frame);
                        if(CommSocket.STATUS)
                            CommandMsg = sprintf('Setting Frame: %s', Params.Frame);
                            SentCommands{length(SentCommands)+1} = CommandMsg;
                            set(Handles.TXcommands,'String',SentCommands);
                            set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        end
                    catch
                    end


                % --------------------------------------------------
                % --- When there is a INCREMENT to be set, this case is
                % --- activated calling on functions from TCPCOMMS().
                % -------------------------------------------------- 
                case "SetIncrement"
                    try
                        CommSocket.setIncrement(Increment);
                        if(CommSocket.STATUS)
                            CommandMsg = sprintf('Setting Increment: %s', Increment);
                            SentCommands{length(SentCommands)+1} = CommandMsg;
                            set(Handles.TXcommands,'String',SentCommands);
                            set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        end
                    catch
                    end


                % --------------------------------------------------
                % --- When there is a RELATIVE POSITION to be set, this 
                % --- case is activated calling on functions from 
                % --- TCPCOMMS().
                % -------------------------------------------------- 
                case "SetRelPos"
                    try
                        CommSocket.setRelPos(RelPosition);
                        if(CommSocket.STATUS)
                            CommandMsg = sprintf('Setting Relative Position: %s', RelPosition);
                            SentCommands{length(SentCommands)+1} = CommandMsg;
                            set(Handles.TXcommands,'String',SentCommands);
                            set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        end
                    catch
                    end


                % --------------------------------------------------
                % --- When there is a CONTROL REQUEST to be sent, 
                % --- this case is activated calling on functions from 
                % --- TCPCOMMS().
                % -------------------------------------------------- 
                case "Control"
                    try
                        CommSocket.functionControl(ProgControl);
                        if(CommSocket.STATUS)
                            switch ProgControl
                                case 1
                                    CommandMsg = "Sending Resume Request";
                                case 2
                                    CommandMsg = "Sending Pause Request";
                                case 3
                                    CommandMsg = "Sending Cancel Request";
                                    CommandQueue = [];
                            end
                            SentCommands{length(SentCommands)+1} = CommandMsg;
                            set(Handles.TXcommands,'String',SentCommands);
                            set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        end
                    catch
                    end


                % --------------------------------------------------
                % --- When there is a JOG REQUEST to be sent, 
                % --- this case is activated calling on functions from 
                % --- TCPCOMMS().
                % -------------------------------------------------- 
                case "Jog"
                    Result = CommSocket.setJog(Jog,Increment);
                        if(CommSocket.STATUS)
                            switch abs(Result)
                                case 1
                                    if (Result>0)
                                        CommandMsg = "Jogging Robot: X+";
                                    else
                                        CommandMsg = "Turn Off Jog X Axis";
                                    end
                                case 2
                                    if (Result>0)
                                        CommandMsg = "Jogging Robot: X-";
                                    else
                                        CommandMsg = "Turn Off Jog X Axis";
                                    end
                                case 3
                                    if (Result>0)
                                        CommandMsg = "Jogging Robot: Y+";
                                    else
                                        CommandMsg = "Turn Off Jog Y Axis";
                                    end
                                case 4
                                    if (Result>0)
                                        CommandMsg = "Jogging Robot: Y-";
                                    else
                                        CommandMsg = "Turn Off Jog Y Axis";
                                    end
                                case 5
                                    if (Result>0)
                                        CommandMsg = "Jogging Robot: Z+";
                                    else
                                        CommandMsg = "Turn Off Jog Z Axis";
                                    end
                                case 6
                                    if (Result>0)
                                        CommandMsg = "Jogging Robot: Z-";
                                    else
                                        CommandMsg = "Turn Off Jog Z Axis";
                                    end
                            end
                            SentCommands{length(SentCommands)+1} = CommandMsg;
                            set(Handles.TXcommands,'String',SentCommands);
                            set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        end


                % --------------------------------------------------
                % --- When CONVEYOR RUN is to be activated or deactivated, 
                % --- this case is activated calling on functions from 
                % --- TCPCOMMS().
                % -------------------------------------------------- 
                case "ConvRun"
                    CommSocket.setIO(nextCommand,IO.ConvRun);
                    if (IO.ConvRun)
                        CommandMsg = "Start Conveyor";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.ConvRunBtn,'BackgroundColor',[0.47 0.67 0.19]);
                        set(Handles.ConvRunBtn,'Value',1);
                    else
                        CommandMsg = "Stop Conveyor";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.ConvRunBtn,'BackgroundColor',[0.86 0.12 0.12]);
                        set(Handles.ConvRunBtn,'Value',0);
                    end


                % --------------------------------------------------
                % --- When CONVEYOR DIRECTION is to be changed this case 
                % --- is activated calling on functions from TCPCOMMS().
                % --------------------------------------------------   
                case "ConvDir"
                    CommSocket.setIO(nextCommand,IO.ConvDir);
                    if (IO.ConvDir)
                        CommandMsg = "Set Conveyor Direction Towards Robot";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.ConvDirBtn,'String','ConvDir:  >>>')
                        set(Handles.ConvDirBtn,'Value',1);
                    else
                        CommandMsg = "Set Conveyor Direction Away From Robot";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.ConvDirBtn,'String','ConvDir:  <<<')
                        set(Handles.ConvDirBtn,'Value',0);
                    end


                % --------------------------------------------------
                % --- When VACUUM SOLENOID status is to be activated or 
                % --- deactivated, this case is activated calling on 
                % --- functions from TCPCOMMS().
                % --------------------------------------------------   
                case "VacSol"
                    CommSocket.setIO(nextCommand,IO.VacSol);
                    if (IO.VacSol)
                        CommandMsg = "Start Vacuum Solenoid";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.VacSolBtn,'BackgroundColor',[0.47 0.67 0.19]);
                        set(Handles.VacSolBtn,'Value',1);
                    else
                        CommandMsg = "Stop Vacuum Solenoid";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.VacSolBtn,'BackgroundColor',[0.86 0.12 0.12]);
                        set(Handles.VacSolBtn,'Value',0);
                    end


                % --------------------------------------------------
                % --- When VACUUM PUMP status is to be activated or 
                % --- deactivated, this case is activated calling on 
                % --- functions from TCPCOMMS().
                % --------------------------------------------------  
                case "VacPump"
                    CommSocket.setIO(nextCommand,IO.VacPump);
                    if (IO.VacPump)
                        CommandMsg = "Start Vacuum Pump";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.VacPumpBtn,'BackgroundColor',[0.47 0.67 0.19]);
                        set(Handles.VacPumpBtn,'Value',1);
                    else
                        CommandMsg = "Stop Vacuum Pump";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.VacPumpBtn,'BackgroundColor',[0.86 0.12 0.12]);
                        set(Handles.VacPumpBtn,'Value',0);
                    end 


                end

            end

        end


        % --------------------------------------------------
        % ---- Advance the command queue if the connection is valid 
        % --- else clear queue.
        % --------------------------------------------------  
        if(CommSocket.STATUS)
            CommandQueue = CommandQueue(2:end);
        else
            CommandQueue = [];
        end


        % --------------------------------------------------  
        % --- Check the status and check the errors and enable/disable 
        % --- GUI controls as required.
        % --------------------------------------------------
        CommSocket.guiControl(Handles,Err2Resolve)
    end
end
