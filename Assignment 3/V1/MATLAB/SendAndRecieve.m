% --- Group: 9
% --- Purpose: A calling function which will repeat periodically to recieve
% ------------ information from RAPID and to send any commands stored in
% ------------ command queue.

function SendAndRecieve(obj, event)
global QUIT
global CommandQueue
global Params
global Pose
global CommSocket
global Handles
global SentCommands
global IO
global ProgControl
global RecvCommands
global Err2Resolve
Err2Resolve = 0;
global Cameras
global TimeKeep
global Joints

    if ~QUIT
        % --------------------------------------------------
        % --- Attempt to obtain a snapshot image from the Table Camera feed
        % --- Then display this on the table camera plot (Axes1).
        % --- Written by: Angat Vora (z3422540)
        % --------------------------------------------------
        try
            elapsedTime = toc(TimeKeep.Conv);
            if (elapsedTime > 3)
                CommandQueue = ["ConvOff"];
                TimeKeep.Conv = 0;
            end
        catch
        end
            
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
%         [whiteBoxAnswer] = detect_whiteBox(Cameras.ConvCam.Image);
%         hold on;
%         plot(whiteBoxAnswer.boundaryX,whiteBoxAnswer.boundaryY,'r-','LineWidth',2);  %%Example outcome.
%         hold off;
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
                        set(Handles.ConstatPanel,'BackgroundColor',[0.47 0.67 0.19]);
                        set(Handles.ConstatText,'BackgroundColor',[0.47 0.67 0.19]);
                    else
                        set(Handles.ConstatPanel,'BackgroundColor',[0.86 0.12 0.12]);
                        set(Handles.ConstatText,'BackgroundColor',[0.86 0.12 0.12]);
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
                ready = CommSocket.ReadyCheck();
                if (ready == 1)

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
                    case {"SetTarget","SetDestination","SetAvoid1","SetAvoid2","SetAvoid3","SetAvoid4"}
                        try
                            if (nextCommand == "SetTarget")
                                CommSocket.setPose(Pose.Target);
                                CommandMsg = "Setting Target:";
                                CommandMsg2 = sprintf('%.2f, %.2f, %.2f',Pose.Target(:));
                            elseif (nextCommand == "SetDestination")
                                CommSocket.setPose(Pose.Destination);
                                CommandMsg = "Setting Destination:";
                                CommandMsg2 = sprintf('%.2f, %.2f, %.2f',Pose.Destination(:));
                            elseif (nextCommand == "SetAvoid1")
                                CommSocket.setPose(Pose.Avoid1);
                            elseif (nextCommand == "SetAvoid2")
                                CommSocket.setPose(Pose.Avoid2);
                            elseif (nextCommand == "SetAvoid3")
                                CommSocket.setPose(Pose.Avoid3);
                            elseif (nextCommand == "SetAvoid4")
                                CommSocket.setPose(Pose.Avoid4);
                            end
                            
                            if (CommSocket.STATUS)
                                SentCommands{length(SentCommands)+1} = CommandMsg;
                                SentCommands{length(SentCommands)+1} = CommandMsg2;
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
                case "ProgCtrl"
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
                    
                case {"VacOn","VacOff"}
                    if (nextCommand == "VacOn")
                        IO.VacSol = 1;
                        IO.VacPump = 1;
                    elseif (nextCommand == "VacOff")
                        IO.VacSol = 0;
                        IO.VacPump = 0;
                    end
                    
                    CommSocket.setVacCtrl(IO.VacSol,IO.VacPump);
                    
                    if (IO.VacSol)
                        CommandMsg = "Start Vacuum Solenoid and Pump";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.VacsolPanel,'BackgroundColor',[0.47 0.67 0.19]);
                        set(Handles.VacpumpPanel,'BackgroundColor',[0.47 0.67 0.19]);
                        set(Handles.VacsolText,'BackgroundColor',[0.47 0.67 0.19]);
                        set(Handles.VacpumpText,'BackgroundColor',[0.47 0.67 0.19]);
                    else
                        CommandMsg = "Stop Vacuum Solenoid and Pump";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.VacsolPanel,'BackgroundColor',[0.86 0.12 0.12]);
                        set(Handles.VacpumpPanel,'BackgroundColor',[0.86 0.12 0.12]);
                        set(Handles.VacsolText,'BackgroundColor',[0.86 0.12 0.12]);
                        set(Handles.VacpumpText,'BackgroundColor',[0.86 0.12 0.12]);
                    end
                    
                case {"ConvOn","ConvOff"}
                    if (nextCommand == "ConvOn")
                        IO.ConvRun = 1;
                    elseif (nextCommand == "ConvOff")
                        IO.ConvRun = 0;
                    end
                    
                    CommSocket.setConvCtrl(IO.ConvDir,IO.ConvRun);
                    
                    if (IO.ConvRun)
                        if (IO.ConvDir)
                            CommandMsg = "Start Conveyor: Load Blocks";
                        else
                            CommandMsg = "Start Conveyor: Reload Blocks";
                        end
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.ConrunPanel,'BackgroundColor',[0.47 0.67 0.19]);
                        set(Handles.ConrunText,'BackgroundColor',[0.47 0.67 0.19]);
                    else
                        CommandMsg = "Stop Conveyor";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        set(Handles.ConrunPanel,'BackgroundColor',[0.86 0.12 0.12]);
                        set(Handles.ConrunText,'BackgroundColor',[0.86 0.12 0.12]);
                    end
                    
                % --------------------------------------------------
                % --- When there is a FRAME to be set, this case is
                % --- activated calling on functions from TCPCOMMS().
                % -------------------------------------------------- 

                case {"SetDestFrame","SetTargetFrame"}
                    try
                        if (nextCommand == "SetDestFrame")
                            CommSocket.setFrame(Params.Frame2);
                        elseif (nextCommand == "SetTargetFrame")
                            CommSocket.setFrame(Params.Frame1);
                        end
                        if(CommSocket.STATUS)
                            CommandMsg = sprintf('Setting Frame: %s', Params.Frame);
                            SentCommands{length(SentCommands)+1} = CommandMsg;
                            set(Handles.TXcommands,'String',SentCommands);
                            set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        end
                    catch
                    end
                    
                case {"SetTargetJoints","SetDestJoints"}
                    try
                        if (nextCommand == "SetTargetJoints")
                            CommSocket.setJoints(Joints.Target);
                            CommandMsg = sprintf('Setting Joints: %s', Joints.Target);
                        elseif (nextCommand == "SetDestJoints")
                            CommSocket.setJoints(Joints.Destination);
                            CommandMsg = sprintf('Setting Joints: %s', Joints.Destination);
                        end
                        if(CommSocket.STATUS)
                            SentCommands{length(SentCommands)+1} = CommandMsg;
                            set(Handles.TXcommands,'String',SentCommands);
                            set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                        end
                    catch
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
                end

            end
        end
        
        if (Err2Resolve ~= 0)
            CommandQueue = [];
        end

        % --------------------------------------------------  
        % --- Check the status and check the errors and enable/disable 
        % --- GUI controls as required.
        % --------------------------------------------------
        CommSocket.guiControl(Handles,Err2Resolve)
    end  
end

