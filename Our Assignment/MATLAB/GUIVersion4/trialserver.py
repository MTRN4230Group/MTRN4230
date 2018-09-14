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

def MessageListener() :
	global QUIT
	# Create a TCP socket, and bind it to a port. Start listening and 
	# set timeout for recieving data as to prevent blockage
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	sock.bind((LOCAL_HOST, HOST_RECV_PORT))
	sock.listen(1)
	sock.settimeout(2);

	while not QUIT :
		try :
			conn, addr = sock.accept()
			request = conn.recv(1000)

			if (request.decode() == "REQ_POSE") :
				message = "1.00 2.00 3.00 4.00 5.00 6.00 7.00 8.00 9.00 10.00".encode()
				# try:
				conn.send(message)


			if (request.decode() == "REQ_ERR") :
				message = "0 0 0 0 0 0 0 ".encode()
				# try:
				conn.send(message)

				# except:
					# pass
			print(request.decode())
			conn.close()
		except socket.timeout:
			pass
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
	messages = threading.Thread(target=MessageListener,args=())
	messages.start()
	sender = threading.Thread(target=SendMessage,args=())
	sender.start()

	print('Message listener thread started')

	while True :
		try :
			cmd = input('-->')

			if cmd == 'quit' :
				QUIT = True
				messages.join()
				sender.join()
				break

		except KeyboardInterrupt :
			QUIT = True
			messages.join()
			sender.join()
			break

		except :
			pass

if __name__ == "__main__" :
	main()