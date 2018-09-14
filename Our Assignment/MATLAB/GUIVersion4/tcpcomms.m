% Group: 9
% Purpose: Class set up to be able to communicate between the IRB120 and the GUI

classdef tcpcomms < handle
    %TCPCOMMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        IP
        PORT
        SENDSOCKET
        STATUS

    end
    
    methods
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %~~~~~~~~~~~~~~ INITIALISATION METHODS ~~~~~~~~~~~~~~~~
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function obj = tcpcomms()
            obj.IP = '127.0.0.1';
            obj.PORT = 50007;
            obj.SENDSOCKET = tcpip(obj.IP,obj.PORT);
        end
        
        function manualConnect(obj,ip,port)
            obj.IP = ip;
            obj.PORT = port;
            obj.SENDSOCKET = tcpip(obj.IP,obj.PORT);
        end
            
        function connectionCheck(obj,handles)
            try
                fopen(obj.SENDSOCKET);
                fclose(obj.SENDSOCKET);
             
                obj.STATUS = true;
            catch             
                obj.STATUS = false;
            end
            obj.guiControl(handles,0);
        end
        
        function guiControl(obj,handles, activation)
            if (obj.STATUS && activation==0)
                set(handles.ConnStatus,'String','Connected','ForegroundColor','g');
                set(handles.Move2PoseBtn,'Enable','on');
                set(handles.JogXPlusBtn,'Enable','on');
                set(handles.JogXMinusBtn,'Enable','on');
                set(handles.JogYPlusBtn,'Enable','on');
                set(handles.JogYMinusBtn,'Enable','on');
                set(handles.JogZPlusBtn,'Enable','on');
                set(handles.JogZMinusBtn,'Enable','on');
                set(handles.ConvEnableBtn,'Enable','on');
                set(handles.ConvRunBtn,'Enable','on');
                set(handles.ConvDirBtn,'Enable','on');
                set(handles.VacSolBtn,'Enable','on');
                set(handles.VacPumpBtn,'Enable','on');
                set(handles.ResumeProgBtn,'Enable','on');
                set(handles.PauseProgBtn,'Enable','on');
                set(handles.CancelProgBtn,'Enable','on');
                set(handles.SetParamsBtn,'Enable','on');
                set(handles.ManualConnectBtn,'Enable','Off');
               
            else
                if (~obj.STATUS)
                    set(handles.ConnStatus,'String','Not Connected','ForegroundColor','r');
                    set(handles.ManualConnectBtn,'Enable','on');
                else
                    set(handles.ConnStatus,'String','Connected','ForegroundColor','g');
                    set(handles.ManualConnectBtn,'Enable','Off');
                end
                set(handles.Move2PoseBtn,'Enable','off');
                set(handles.JogXPlusBtn,'Enable','off');
                set(handles.JogXMinusBtn,'Enable','off');
                set(handles.JogYPlusBtn,'Enable','off');
                set(handles.JogYMinusBtn,'Enable','off');
                set(handles.JogZPlusBtn,'Enable','off');
                set(handles.JogZMinusBtn,'Enable','off');
                set(handles.ConvEnableBtn,'Enable','off');
                set(handles.ConvRunBtn,'Enable','off');
                set(handles.ConvDirBtn,'Enable','off');
                set(handles.VacSolBtn,'Enable','off');
                set(handles.VacPumpBtn,'Enable','off');
                set(handles.ResumeProgBtn,'Enable','off');
                set(handles.PauseProgBtn,'Enable','off');
                set(handles.CancelProgBtn,'Enable','off');
                set(handles.SetParamsBtn,'Enable','off');
                
                
            end
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %~~~~~~~~~~~ SEND COMMANDS TO ROBOT METHODS ~~~~~~~~~~~
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        function setSpeed(obj,speedString)
            try
                speedMessage = sprintf('SPD_%s',speedString);
                fopen(obj.SENDSOCKET);
                fwrite(obj.SENDSOCKET,speedMessage);
                fclose(obj.SENDSOCKET);
                obj.STATUS = true;
            catch
                obj.STATUS = false;
            end
        end
        
        function setMode(obj,modeString)
            try    
                modeMessage = sprintf('MDE %s',modeString);
                fopen(obj.SENDSOCKET);
                fwrite(obj.SENDSOCKET,modeMessage);
                fclose(obj.SENDSOCKET);      
                obj.STATUS = true;
            catch
                obj.STATUS = false;
            end
        end
        
        function setFrame(obj,modeString)
            try
                modeMessage = sprintf('FME %s',modeString);
                fopen(obj.SENDSOCKET);
                fwrite(obj.SENDSOCKET,modeMessage);
                fclose(obj.SENDSOCKET);
                obj.STATUS = true;
            catch
                obj.STATUS = false;
            end
        end
        
        function setPose(obj,TargetPose)
            try
                poseMessage = sprintf('%0.2f %0.2f %0.2f %0.2f %0.2f %0.2f %0.2f',TargetPose(:));
                fopen(obj.SENDSOCKET);
                fwrite(obj.SENDSOCKET, poseMessage);
                fclose(obj.SENDSOCKET);
                obj.STATUS = true;
            catch
                obj.STATUS = false;
            end
        end
        
        function result = setIO(obj,io,state)
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
            dioMessage = sprintf('DIO %d %d',dio,state);
            
                try
                    fopen(obj.SENDSOCKET);
                    fwrite(obj.SENDSOCKET,dioMessage);
                    fclose(obj.SENDSOCKET);
                    result = true;
                 catch
                    result = 0;
                end
        end
        
        function functionControl(obj,DC)
            switch DC
                case 1
                    controlMessage = "RESUME";
                case 2
                    controlMessage = "PAUSE";
                case 3
                    controlMessage = "CANCEL";
            end
            try
                fopen(obj.SENDSOCKET);
                fwrite(obj.SENDSOCKET, controlMessage);
                fclose(obj.SENDSOCKET);
                obj.STATUS = true;
            catch
                obj.STATUS = false;
            end
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %~~~~~~ REQUEST INFORMATION FROM ROBOT METHODS ~~~~~~~~
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
        function information = reqCurrentPose(obj)
            try
                poseMessage = "REQ_POSE";
                fopen(obj.SENDSOCKET);
                fwrite(obj.SENDSOCKET, poseMessage);
                pause(0.1);
                information = fread(obj.SENDSOCKET,[1, obj.SENDSOCKET.BytesAvailable]);
                fclose(obj.SENDSOCKET);
                obj.STATUS = true;
            catch
                obj.STATUS = false;
                information = 0;
            end
        end
        
        function information = reqErrors(obj)
            try
                errMessage = "REQ_ERR";
                fopen(obj.SENDSOCKET);
                fwrite(obj.SENDSOCKET, errMessage);
                pause(0.1);
                information = fread(obj.SENDSOCKET,[1, obj.SENDSOCKET.BytesAvailable]);
                fclose(obj.SENDSOCKET);
                obj.STATUS = true;
            catch
                obj.STATUS = false;
                information = 0;
            end
        end
    
    end
end

