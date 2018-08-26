import socket
import threading

global QUIT
QUIT = False

global LOCAL_HOST
LOCAL_HOST = '127.0.0.1'


global HOST_RECV_PORT
HOST_RECV_PORT = 50000

def MessageListener() :
	global QUIT
	# Create a TCP socket, and bind it to a port. Start listening and 
	# set timeout for recieving data as to prevent blockage
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	sock.bind((LOCAL_HOST, HOST_RECV_PORT))
	sock.listen(1)
	sock.settimeout(2)

	while not QUIT :
		try :
			conn, addr = sock.accept()
			request = conn.recv(50)

			print(request.decode())

			conn.close()

		except socket.timeout :
			pass

	sock.close()

def main() :

	global QUIT

	messages = threading.Thread(target=MessageListener,args=())
	messages.start()

	print('Message listener thread started')

	while True :
		try :
			cmd = input('-->')

			if cmd == 'quit' :
				QUIT = True
				messages.join()
				break

		except KeyboardInterrupt :
			QUIT = True
			break

		except :
			pass

if __name__ == "__main__" :
	main()

