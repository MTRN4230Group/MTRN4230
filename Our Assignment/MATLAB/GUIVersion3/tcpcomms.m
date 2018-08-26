classdef tcpcomms
    %TCPCOMMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        socket
        status
    end
    
    methods
        function obj = tcpcomms()
            LOCALHOST = '127.0.0.1';
            PORT = 50000;
            obj.socket = tcpip(LOCALHOST,PORT);
        end
        
        function connectionCheck(obj,handles)
            try
                fopen(obj.socket);
                pause(1);
                fclose(obj.socket);
                set(handles.ConnStatus,'String','Connected','ForegroundColor','g');
                obj.status = true;
            catch
                set(handles.ConnStatus,'String','Not Connected','ForegroundColor','r');
                obj.status = false;
            end
        end
        
        function setSpeed(obj,speedString)
            speedMessage = sprintf('SS %s',speedString);
            fopen(obj.socket);
            fwrite(obj.socket,speedMessage);
            fclose(obj.socket);
        end
        
        function setMode(obj,modeString)
            modeMessage = sprintf('MS %s',modeString);
            fopen(obj.socket);
            fwrite(obj.socket,modeMessage);
            fclose(obj.socket);
        end
       
    end
end

