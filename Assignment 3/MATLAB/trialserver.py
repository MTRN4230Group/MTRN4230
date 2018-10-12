import socket
import threading
import time

global QUIT
QUIT = False

global LOCAL_HOST
LOCAL_HOST = ' '


global HOST_RECV_PORT
HOST_RECV_PORT = 56000

global HOST_SEND_PORT
HOST_SEND_PORT = 50000

global HOST_SEND_PORT1
HOST_SEND_PORT1 = 54000

global ERRORS
ERRORS = list("0 0 0 0 0 0 0")

global CONSTAT
CONSTAT = list("0")

def MessageListener() :
	global QUIT
	global ERRORS
	global CONSTAT

	# Create a TCP socket, and bind it to a port. Start listening and 
	# set timeout for recieving data as to prevent blockage
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	sock.bind((LOCAL_HOST, HOST_RECV_PORT))
	sock.listen(1)
	sock.setblocking(1);
	conn, addr = sock.accept()
	while not QUIT :
		try :
			
			request = conn.recv(1000)
			#print(request.decode())

			if (request.decode() == "REQ_POSE") :
				message = "1.00 2.00 3.00 4.00 5.00 6.00 7.00 8.00 9.00".encode()
				conn.send(message)

			if (request.decode() == "HEARTBEAT"):
				message = "1".encode()
				conn.send(message)

			if (request.decode() == "REQ_ERR") :
				message = "".join(ERRORS)
				message = message.encode()
				# try:
				conn.send(message)

			if request.decode() == "QUIT" :
				QUIT = True

			if request.decode() == "REQ_CONSTAT" :
				message = "".join(CONSTAT)
				message = message.encode()
				conn.send(message)

				# except:
					# pass

		except socket.timeout:
			pass
	conn.close()		
	sock.close()

def SendMessage() :
	global QUIT
	# Create a TCP socket, and bind it to a port. Start listening and 
	# set timeout for recieving data as to prevent blockage
	sock1 = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	
	while not QUIT :
		try:
			message = "1.00 2.00 3.00 4.00 5.00 6.00 7.00 8.00 9.00 10.00".encode()
			sock.sendto(message,(LOCAL_HOST,HOST_RECV_PORT));
		except:
			pass

	# while not QUIT :
	# 	try :
	# 		print('hello')
	# 		msg = "Hey"
	# 		sock1.sendto(msg.encode(),(LOCAL_HOST,HOST_SEND_PORT))
	# 		print('sent')
	# 		time.sleep(4)
	# 	except socket.timeout :
	# 		print('failed')
	# 		pass


	sock1.close()


def main() :

	global QUIT
	global ERRORS
	global CONSTAT

	messages = threading.Thread(target=MessageListener,args=())
	messages.start()
	sender = threading.Thread(target=SendMessage,args=())
	sender.start()

	print('Message listener thread started')

	while not QUIT :
		try :
			cmd = input('-->')

			if cmd == 'quit' :
				QUIT = True
				messages.join()
				sender.join()
				break

			if cmd == "E1" :
				if ERRORS[0] == "1" :
					ERRORS[0] = "0"
				else :
					ERRORS[0] = "1"


			if cmd == "E2" :
				if ERRORS[2] == "1" :
					ERRORS[2] = "0"
				else :
					ERRORS[2] = "1"


			if cmd == "E3" :
				if ERRORS[4] == "1" :
					ERRORS[4] = "0"
				else :
					ERRORS[4] = "1"


			if cmd == "E4" :
				if ERRORS[6] == "1" :
					ERRORS[6] = "0"
				else :
					ERRORS[6] = "1"


			if cmd == "E5" :
				if ERRORS[8] == "1" :
					ERRORS[8] = "0"
				else :
					ERRORS[8] = "1"


			if cmd == "E6" :
				if ERRORS[10] == "1" :
					ERRORS[10] = "0"
				else :
					ERRORS[10] = "1"


			if cmd == "E7" :
				if ERRORS[12] == "1" :
					ERRORS[12] = "0"
				else :
					ERRORS[12] = "1"

			if cmd == "CS" :
				if CONSTAT[0] == "1":
					CONSTAT[0] = "0"
				else :
					CONSTAT[0] = "1"



		except KeyboardInterrupt :
			QUIT = True
			messages.join()
			sender.join()
			break

		except :
			pass

if __name__ == "__main__" :
	main()