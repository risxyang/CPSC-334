import socket
import os

# create an INET, STREAMing socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# bind the socket to a public host, and a well-known port
s.bind(("172.29.30.152", 8091))
# become a server socket
s.listen(0)

#open file



while True:
    # fp = open("wifiread.txt", "w")
    # accept connections from outside
    (cs, addr) = s.accept()
    # now do something with the clientsocket
    content = cs.recv(1024).decode("utf-8")
    # print(len(content))
    # arr = content.split(",")
    print(content)
    # fp.truncate(0) #clear
    # fp.write(content)
    os.system('cp wifiread.txt wifiread')
    os.system('echo '+ content + '> wifiread')
    cs.send(content.encode())
    content = 0
    # fp.flush()
    # fp.close()
client.close()
