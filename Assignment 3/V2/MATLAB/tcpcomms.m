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
            obj.IP = '192.168.125.1';
            obj.PORT = 1025;
            obj.SENDSOCKET = tcpip(obj.IP,obj.PORT);
        end
        
        
        % --- Called when the manual connect button is pressed
        % --------------------------------------------------
        % --- Provides the ability to reconfigure the IP address and the port number if it is incorrect when the object was created.
        % --- Takes input from a dialoge box regarding IP address and port number
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function manualConnect(obj)
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
                obj.STATUS = true;
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
                set(handles.ConnStatus,'String','Connected','ForegroundColor','g');
%                 set(handles.ConvStatusBtn,'Enable','on');
%                 set(handles.ConvRunBtn,'Enable','on');
%                 set(handles.ConvDirBtn,'Enable','on');
%                 set(handles.VacSolBtn,'Enable','on');
%                 set(handles.VacPumpBtn,'Enable','on');
                set(handles.ResumeProgBtn,'Enable','on');
                set(handles.PauseProgBtn,'Enable','on');
                set(handles.CancelProgBtn,'Enable','on');
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
%                 set(handles.ConvStatusBtn,'Enable','off');
%                 set(handles.ConvRunBtn,'Enable','off');
%                 set(handles.ConvDirBtn,'Enable','off');
%                 set(handles.VacSolBtn,'Enable','off');
%                 set(handles.VacPumpBtn,'Enable','off');
                set(handles.ResumeProgBtn,'Enable','off');
                set(handles.PauseProgBtn,'Enable','off');
                set(handles.CancelProgBtn,'Enable','off');
                set(handles.ProgShutDownBtn,'Enable','off');
            end
        end
               
        
        % --------------------------------------------------
        % --- This function takes in the desired Pose XYZ array. It formats the string to be sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function setPose(obj,Pose)
            try
                poseMessage = sprintf('SET_POSET_%0.2f_%0.2f_%0.2f',Pose(:));
                fwrite(obj.SENDSOCKET, poseMessage,'uint8');
            catch
            end
        end
        
        function setJoints(obj,joints)
            try
                poseMessage = sprintf('SET_JOINTS_%0.2f_%0.2f_%0.2f_%0.2f_%0.2f_%0.2f',joints(:));
                fwrite(obj.SENDSOCKET, poseMessage,'uint8');
            catch
            end
        end
                
        % --------------------------------------------------
        % --- This function takes in the IO to be controlled and the state to which it should be set. It formats the string to be 
        % --- sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function setVacCtrl(obj,sol,pump)
            dioMessage = sprintf('VacCtrl_%d_%d',sol,pump);
            try
                fwrite(obj.SENDSOCKET,dioMessage,'uint8');
            catch
            end
        end
        
        function setConvCtrl(obj,dir,con)
             dioMessage = sprintf('ConvCtrl_%d_%d',dir,con);
             try
                 fwrite(obj.SENDSOCKET,dioMessage,'uint8');
             catch
             end
        end
        
        % --------------------------------------------------
        % --- This function takes in the desired FRAME value. It formats the string to be sent and then sends the string to RAPID.
        % --- Written by: Angat Vora (z3422540)
        %---------------------------------------------------
        function setFrame(obj,modeString)
            try
                modeMessage = sprintf('REL_POS_%s',modeString);
                fwrite(obj.SENDSOCKET,modeMessage,'uint8');
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
        
        function status = ReadyCheck(obj)
            try
                fwrite(obj.SENDSOCKET, "READY", 'uint8');
                pause(0.07);
                status = fread(obj.SENDSOCKET,[1,obj.SENDSOCKET.BytesAvailable],'uint8');
            end
            if (status == 49)
                status = true;
            else
                status = false;
            end
        end
        
        end
    end    


