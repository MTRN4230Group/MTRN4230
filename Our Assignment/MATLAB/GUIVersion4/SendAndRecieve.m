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
    
    try
        Errors = CommSocket.reqErrors();
               
            if(CommSocket.STATUS)
                Errors = strsplit(char(Errors),' ')
                Errors = string(Errors)
                [~,Err] = find(Errors == "1");
                

                
                Err2Resolve = length(Err)
                Errors(Err) = "On"
                [~,NoErr] = find(Errors == "0")
                Errors(NoErr) = "Off"
                if (ismember(7,Err))
                    set(Handles.ConvRunBtn,'Value',0);
                    set(Handles.ConvRunBtn,'BackgroundColor',[0.86 0.12 0.12]);
                end
                set(Handles.eStopPanel,'Visible',Errors(1));
                set(Handles.LCPanel,'Visible',Errors(2));
                set(Handles.motorsPanel,'Visible',Errors(3));
                set(Handles.holdEnablePanel,'Visible',Errors(4));
                set(Handles.execErrPanel,'Visible',Errors(5));
                set(Handles.motionSupPanel,'Visible',Errors(6));
                set(Handles.convDisPanel,'Visible',Errors(7));

                CommandMsg = "Recieved Errors:";
                RecvCommands{length(RecvCommands)+1} = CommandMsg;
                set(Handles.RXcommands,'String',RecvCommands);
                set(Handles.RXcommands,'ListboxTop',length(RecvCommands));
                drawnow;
            end
    catch
    end

        
    
    
    
    % Check what the next command is in the queue 
    if ~isempty(CommandQueue) && (CommSocket.STATUS == true) && (Err2Resolve == 0)
        nextCommand = CommandQueue(1);

        switch nextCommand
            % Next Command was to set the pose
            case "SetTarget"
                try
                    CommSocket.setPose(TargetPose.PoseArray);

                    if (CommSocket.STATUS)
                        CommandMsg = "Setting Pose:";
                        CommandMsg2 = sprintf('%.2f, %.2f, %.2f, %.2f, %.2f, %.2f',TargetPose.PoseArray(:));
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        SentCommands{length(SentCommands)+1} = CommandMsg2;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                    end
                catch
                end
                
            % Next Command was to set Speed    
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
                
            % Next Command was to set Mode
            case "SetMode"
                try
                    CommSocket.setMode(Params.Mode);
                    if (CommSocket.STATUS)
                        CommandMsg = sprintf('Setting Speed: %s', Params.Mode);
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                    end
                catch
                end
                
            % Next Command was to set Frame
            case "SetFrame"
                try
                    CommSocket.setFrame(Params.Frame);
                    if(CommSocket.STATUS)
                        CommandMsg = sprintf('Setting Speed: %s', Params.Frame);
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                    end
                catch
                end
                
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
                        end
                        
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));
                    end
                catch
                end
                
            % Next Command was to set Conveyor Run
            case "ConvRun"
                Result = CommSocket.setIO(nextCommand,IO.ConvRun);

                % If Sending was successful, check state and produce
                % appropriate message for command history and change
                % background color to indicate STATUS. If unsuccessful,
                % change state.
                if (Result)
                    if (IO.ConvRun)
                        CommandMsg = "Start Conveyor";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));

                        set(Handles.ConvRunBtn,'BackgroundColor',[0.47 0.67 0.19]);
                    else
                        CommandMsg = "Stop Conveyor";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));

                        set(Handles.ConvRunBtn,'BackgroundColor',[0.86 0.12 0.12]);
                    end
                else
                    IO.ConvRun = ~IO.ConvRun;
                end

            % Next Command was to set Conveyor Direction    
            case "ConvDir"
                Result = CommSocket.setIO(nextCommand,IO.ConvDir);

                % If Sending was successful, check state and produce
                % appropriate message for command history and change
                % background color to indicate STATUS. If unsuccessful,
                % change state.
                if (Result)
                    if (IO.ConvDir)
                        CommandMsg = "Set Conveyor Direction Towards Robot";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));

                        set(Handles.ConvDirBtn,'String','ConvDir:  >>>')
                    else
                        CommandMsg = "Set Conveyor Direction Away From Robot";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));

                        set(Handles.ConvDirBtn,'String','ConvDir:  <<<')
                    end
                else
                    IO.ConvDir = ~IO.ConvDir;
                end

            % Next command was to set Vacuum Solenoid    
            case "VacSol"
                Result =  CommSocket.setIO(nextCommand,IO.VacSol);

                % If Sending was successful, check state and produce
                % appropriate message for command history and change
                % background color to indicate STATUS. If unsuccessful,
                % change state.
                if (Result)
                    if (IO.VacSol)
                        CommandMsg = "Start Vacuum Solenoid";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));

                        set(Handles.VacSolBtn,'BackgroundColor',[0.47 0.67 0.19]);
                    else
                        CommandMsg = "Stop Vacuum Solenoid";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));

                        set(Handles.VacSolBtn,'BackgroundColor',[0.86 0.12 0.12]);
                    end
                else
                    IO.VacSol = ~IO.VacSol;
                end

            case "VacPump"
                Result = CommSocket.setIO(nextCommand,IO.VacPump);

                % If Sending was successful, check state and produce
                % appropriate message for command history and change
                % background color to indicate STATUS. If unsuccessful,
                % change state.
                if (Result)
                    if (IO.VacPump)
                        CommandMsg = "Start Vacuum Pump";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));

                        set(Handles.VacPumpBtn,'BackgroundColor',[0.47 0.67 0.19]);
                    else
                        CommandMsg = "Stop Vacuum Pump";
                        SentCommands{length(SentCommands)+1} = CommandMsg;
                        set(Handles.TXcommands,'String',SentCommands);
                        set(Handles.TXcommands,'ListboxTop',length(SentCommands));

                        set(Handles.VacPumpBtn,'BackgroundColor',[0.86 0.12 0.12]);
                    end 
                else
                    IO.VacPump = ~IO.VacPump;
                end
        end
        
        % Advance the command queue if the connection is valid else clear
        % queue.
        if(CommSocket.STATUS)
            CommandQueue = CommandQueue(2:end);
        else
            CommandQueue = [];
        end
    end
    CommSocket.guiControl(Handles,Err2Resolve)
end