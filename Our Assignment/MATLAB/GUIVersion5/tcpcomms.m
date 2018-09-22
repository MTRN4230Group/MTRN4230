% --- Group: 9
% --- Purpose: Class set up to be able to communicate between the IRB120 and 
% ------------ the GUI. Contains the functions which will format the messages 
% ------------ to be sent before sending them.

classdef tcpcomms < handle
   
    properties
        IP              % Stores the IP address
        PORT            % Stores the port number
        SENDSOCKET      % Stores the socket object
        STATUS          % Stores the status of the connection

    end
    
    methods
        % --- Default Constructor
        % --------------------------------------------------
        % --- Initialises the tcp socket object with a specified port and IP address.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function obj = tcpcomms()
            obj.IP = '127.0.0.1';
            obj.PORT = 60000;
            obj.SENDSOCKET = tcpip(obj.IP,obj.PORT);
        end
        
        
        % --- Called when the manual connect button is pressed
        % --------------------------------------------------
        % --- Provides the ability to reconfigure the IP address and the port number if it is incorrect when the object was created.
        % --- Takes input from a dialoge box regarding IP address and port number
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function manualConnect(obj,ip,port)
            obj.IP = ip;
            obj.PORT = port;
            obj.SENDSOCKET = tcpip(obj.IP,obj.PORT);
        end
        
        
        % --------------------------------------------------
        % --- Provides an ability to check the connection by opening and closing the socket. Sets status of the connection as
        % --- required. Calls guiControl() to either disable or enable functionality of the GUI controls.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function connectionCheck(obj,handles)
            try
                fopen(obj.SENDSOCKET);
            catch
                obj.STATUS = false;
            end
            obj.guiControl(handles,0);
        end
        
        
        % --------------------------------------------------
        % --- This function will take in the handles to the GUI and an activation parameter. It is set to 0 when the connection is
        % --- good or no errors are percievied. Enables GUI controls. Disables GUI controls when activation is set to 1, eg when 
        % --- there are errors detected or connection is lost.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function guiControl(obj,handles, activation)
            if (obj.STATUS && activation==0)
                set(handles.Move2PoseXYZBtn,'Enable','on');
                set(handles.Move2PoseJointsBtn,'Enable','on');
                set(handles.ConnStatus,'String','Connected','ForegroundColor','g');
                set(handles.JogXPlusBtn,'Enable','on');
                set(handles.JogXMinusBtn,'Enable','on');
                set(handles.JogYPlusBtn,'Enable','on');
                set(handles.JogYMinusBtn,'Enable','on');
                set(handles.JogZPlusBtn,'Enable','on');
                set(handles.JogZMinusBtn,'Enable','on');
                set(handles.ConvStatusBtn,'Enable','on');
                set(handles.ConvRunBtn,'Enable','on');
                set(handles.ConvDirBtn,'Enable','on');
                set(handles.VacSolBtn,'Enable','on');
                set(handles.VacPumpBtn,'Enable','on');
                set(handles.ResumeProgBtn,'Enable','on');
                set(handles.PauseProgBtn,'Enable','on');
                set(handles.CancelProgBtn,'Enable','on');
                set(handles.SetSpeedBtn,'Enable','on');
                set(handles.SetFrameBtn,'Enable','on');
                set(handles.SetModeBtn,'Enable','on');
                set(handles.SetIncrementBtn,'Enable','on');
                set(handles.SetRelPosBtn,'Enable','on');
                set(handles.ManualConnectBtn,'Enable','off');
                set(handles.ProgShutDownBtn,'Enable','on');
            else
                if (~obj.STATUS)
                    set(handles.ConnStatus,'String','Not Connected','ForegroundColor','r');
                    set(handles.ManualConnectBtn,'Enable','on');
                else
                    set(handles.ConnStatus,'String','Connected','ForegroundColor','g');
                    set(handles.ManualConnectBtn,'Enable','Off');
                end
                set(handles.Move2PoseXYZBtn,'Enable','off');
                set(handles.Move2PoseJointsBtn,'Enable','off');
                set(handles.JogXPlusBtn,'Enable','off');
                set(handles.JogXMinusBtn,'Enable','off');
                set(handles.JogYPlusBtn,'Enable','off');
                set(handles.JogYMinusBtn,'Enable','off');
                set(handles.JogZPlusBtn,'Enable','off');
                set(handles.JogZMinusBtn,'Enable','off');
                set(handles.ConvStatusBtn,'Enable','off');
                set(handles.ConvRunBtn,'Enable','off');
                set(handles.ConvDirBtn,'Enable','off');
                set(handles.VacSolBtn,'Enable','off');
                set(handles.VacPumpBtn,'Enable','off');
                set(handles.ResumeProgBtn,'Enable','off');
                set(handles.PauseProgBtn,'Enable','off');
                set(handles.CancelProgBtn,'Enable','off');
                set(handles.SetSpeedBtn,'Enable','off');
                set(handles.SetFrameBtn,'Enable','off');
                set(handles.SetModeBtn,'Enable','off');
                set(handles.SetIncrementBtn,'Enable','off');
                set(handles.SetRelPosBtn,'Enable','off');
                set(handles.ProgShutDownBtn,'Enable','off');
            end
        end
        
        
        % --------------------------------------------------
        % --- This function takes in the desired SPEED value. It formats the string to be sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function setSpeed(obj,speedString)
            try
                speedMessage = sprintf('SPEED_%s',speedString);
                fwrite(obj.SENDSOCKET,speedMessage,'uint8');
            catch
            end
        end
        
        
        % --------------------------------------------------
        % --- This function takes in the desired MOTION MODE value. It formats the string to be sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function setMode(obj,modeString)
            try    
                modeMessage = sprintf('MODE_%s',modeString);
                fwrite(obj.SENDSOCKET,modeMessage,'uint8');
            catch
            end
        end
        
        
        % --------------------------------------------------
        % --- This function takes in the desired FRAME value. It formats the string to be sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function setFrame(obj,modeString)
            try
                modeMessage = sprintf('FRAME_%s',modeString);
                fwrite(obj.SENDSOCKET,modeMessage,'uint8');
            catch
            end
        end
        
        
        % --------------------------------------------------
        % --- This function takes in the desired INCREMENT value. It formats the string to be sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function setIncrement(obj,incrementString)
            try
                incrementMessage = sprintf('INCREMENT_%s',incrementString);
                fwrite(obj.SENDSOCKET,incrementMessage,'uint8');
            catch
            end
        end
        
        
        % --------------------------------------------------
        % --- This function takes in the desired RELATIVE POSITION value. It formats the string to be sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function setRelPos(obj,RelativePosition)
            try
                RelPosMessage = sprintf('SET_REL_POS_%s',RelativePosition);
                fwrite(obj.SENDSOCKET,RelPosMessage,'uint8');
            catch
            end
        end
        
        
        % --------------------------------------------------
        % --- This function takes in the desired Pose XYZ array. It formats the string to be sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function setPoseXYZ(obj,TargetPoseXYZ)
            try
                poseMessage = sprintf('SET_POSE_XYZ_%0.2f_%0.2f_%0.2f',TargetPoseXYZ(:));
                fwrite(obj.SENDSOCKET, poseMessage,'uint8');
            catch
            end
        end
        
        
        % --------------------------------------------------
        % --- This function takes in the desired Pose Joints array. It formats the string to be sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function setPoseJoints(obj,TargetPoseJoints)
            try
                poseMessage = sprintf('SET_POSE_JOINTS_%0.2f_%0.2f_%0.2f_%0.2f_%0.2f_%0.2f',TargetPoseJoints(:));
                fwrite(obj.SENDSOCKET, poseMessage,'uint8');
            catch
                obj.STATUS = false;
            end
        end
        
        
        % --------------------------------------------------
        % --- This function takes in the IO to be controlled and the state to which it should be set. It formats the string to be 
        % --- sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function setIO(obj,io,state)
            switch io
                case "ConvRun"
                    dio = 1;
                case "ConvDir"
                    dio = 2;
                case "VacSol"
                    dio = 3;
                case "VacPump"
                    dio = 4;
            end
            dioMessage = sprintf('DIO_%d_%d',dio,state);
            try
                fwrite(obj.SENDSOCKET,dioMessage,'uint8');
            catch
            end
        end
        
        % --------------------------------------------------
        % --- This function takes in the parameter of the program control required. Checks which control function is required and
        % --- formats the string accordingly. It formats the string to be sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function functionControl(obj,DC)
            switch DC
                case 1
                    controlMessage = "RESUME_";
                case 2
                    controlMessage = "PAUSE_";
                case 3
                    controlMessage = "CANCEL_";
            end
            try
                fwrite(obj.SENDSOCKET, controlMessage,'uint8');
            catch
            end
        end
        
        
        % --------------------------------------------------
        % --- This function takes in the parameter JogAxis which relates to which axis array which was set during button press. It also 
        % --- takes in the Increment value set by the user. The function checks which axis is to be controlled and formats the string 
        % --- accordingly. It formats the string to be sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function result = setJog(obj,JogAxis,Inc)
            [~,axis] = find(JogAxis == 1);
            if(~isempty(axis))
                switch axis
                    case 1
                        jogMessage = sprintf("JOG_XPLUS_%s",Inc);
                        result = 1;
                    case 2
                        jogMessage = sprintf("JOG_XMINUS_%s",Inc);
                        result = 2;
                    case 3
                        jogMessage = sprintf("JOG_YPLUS_%s",Inc);
                        result = 3;
                    case 4
                        jogMessage = sprintf("JOG_YMINUS_%s",Inc);
                        result = 4;
                    case 5
                        jogMessage = sprintf("JOG_ZPLUS_%s",Inc);
                        result = 5;
                    case 6
                        jogMessage = sprintf("JOG_ZMINUS_%s",Inc);
                        result = 6;
                end
            else
                [~,axis] = find(JogAxis == -1);
                if(~isempty(axis))
                    switch axis
                        case 1
                            jogMessage = sprintf("JOG_OFF_X");
                            result = -1;
                        case 2
                            jogMessage = sprintf("JOG_OFF_X");
                            result = -2;
                        case 3
                            jogMessage = sprintf("JOG_OFF_Y");
                            result = -3;
                        case 4
                            jogMessage = sprintf("JOG_OFF_Y");
                            result = -4;
                        case 5
                            jogMessage = sprintf("JOG_OFF_Z");
                            result = -5;
                        case 6
                            jogMessage = sprintf("JOG_OFF_Z");
                            result = -6;
                    end
                end
            end
            try
                fwrite(obj.SENDSOCKET, jogMessage,'uint8');
            catch              
            end
        end
        
        % --------------------------------------------------
        % --- This functions sends a request string REQ_POSE to request for the current pose of the robot. Then it reads the information
        % --- and returns it to the calling function to be used.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function information = reqCurrentPose(obj)
            try
                fwrite(obj.SENDSOCKET, "REQ_POSE",'uint8');
                pause(0.07);
                information = fread(obj.SENDSOCKET,[1, obj.SENDSOCKET.BytesAvailable]);
            catch
            end
        end
        
        
        % --------------------------------------------------
        % --- This functions sends a request string ERR to request for the state of errors. Then it reads the information
        % --- and returns it to the calling function to be used.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function information = reqErrors(obj)            
            try                
                errMessage = "REQ_ERR";                                
                fwrite(obj.SENDSOCKET, errMessage,'uint8');
                pause(0.07);
                information = fread(obj.SENDSOCKET,[1, obj.SENDSOCKET.BytesAvailable],'uint8');
            catch                          
            end
        end
        
        
        % --------------------------------------------------
        % --- This functions sends a request string REQ_CONSTAT to request for the current status of the conveyor; If it is activated. 
        % --- Then it reads the information sent from RAPID and returns it to the calling function to be used.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function information = reqConstat(obj)            
            try                
                errMessage = "REQ_CONSTAT";                
                fwrite(obj.SENDSOCKET, errMessage,'uint8');                
                pause(0.07);                
                information = fread(obj.SENDSOCKET,[1, obj.SENDSOCKET.BytesAvailable]);                
            catch                
                information = 0;                
            end
        end
        
        
        function HeartBeat(obj)            
            beat = 0;            
            try                
                fwrite(obj.SENDSOCKET, "HEARTBEAT", 'uint8');                
                pause(0.07);                
                beat = fread(obj.SENDSOCKET,[1,obj.SENDSOCKET.BytesAvailable],'uint8');                           
            end            
            if (beat == 49)                
               obj.STATUS = true;               
            else                 
               obj.STATUS = false;
            end            
        end    
    end    
end

