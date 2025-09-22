extends Node

var tcp_server: TCPServer

func _ready():
	tcp_server = TCPServer.new()
	tcp_server.listen(10000)
	print("started tcp server")
	print(tcp_server.is_listening())
