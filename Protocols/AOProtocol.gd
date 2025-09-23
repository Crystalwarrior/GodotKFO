extends Node
class_name AOProtocol

signal connected
signal disconnected
signal data_received(command: String, contents: PackedStringArray)

# Specific command signals
signal ooc_message(ooc_name: String, message: String, message_type: int)
signal ic_message(ic_msg: ICMessage)

var client: BaseClient

## If we only received partial data on last packet
var partial_data: String = ""

var feature_list: PackedStringArray = []

var keep_alive_timer: Timer
# By default, 45 seconds
var keep_alive_timer_wait_time: float = 45.0

# Time.get_ticks_msec() at the start of the ping
var ping_check_start: int = 0

func _ready() -> void:
	client = TCPClient.new()
	client.connected.connect(_handle_client_connected)
	client.disconnected.connect(_handle_client_disconnected)
	client.data_received.connect(_handle_client_data)
	add_child(client)

	keep_alive_timer = Timer.new()
	# Tell the server we're alive every X seconds
	keep_alive_timer.wait_time = keep_alive_timer_wait_time
	keep_alive_timer.ignore_time_scale = true
	keep_alive_timer.name = "KeepAliveTimer"
	keep_alive_timer.timeout.connect(_on_keep_alive_timer_timeout)
	add_child(keep_alive_timer)

func join(address: String):
	if client is WSClient:
		client.connect_to_url(address)
	elif client is TCPClient:
		var ip_port: PackedStringArray = address.split(":", true, 1)
		if ip_port.is_empty():
			return
		var ip: String = ip_port[0]
		if not ip.is_valid_ip_address():
			printerr("Invalid IP Address!")
			return
		if ip_port.size() < 2:
			printerr("Please include ip:port, e.g. 127.0.0.1:27015")
			return
		var port = ip_port[1]
		if not port.is_valid_int():
			printerr("Invalid port! Please make sure port is a number, e.g. 127.0.0.1:27015")
			return
		client.connect_to_host(ip, int(port))

func _handle_client_connected() -> void:
	print("Client connected to server.")
	client.name = "Client %s" % client.tcp_stream.get_local_port()
	connected.emit()
	# Begin ensuring the client remains ALIVE
	keep_alive_timer.start()

func _handle_client_data(data: PackedByteArray) -> void:
	var incoming_data: String = data.get_string_from_utf8()
	handle_server_packet(incoming_data)

func _handle_client_disconnected() -> void:
	print("Client disconnected from server.")
	disconnected.emit()

func handle_server_packet(incoming_data: String):
	# full packets always end in %
	if not incoming_data.ends_with("%"):
		partial_data += incoming_data
		return
	# full packet received, waiting on a partial packet
	if not partial_data.is_empty():
		incoming_data = partial_data + incoming_data
		partial_data = ""
	
	var packet_contents: PackedStringArray = incoming_data.split("%", false)
	for content in packet_contents:
		# Read and interpret a packet from the string
		var packet: AOPacket = AOPacket.from_string(content)
		if packet == null:
			push_warning("Empty packet received from the server, skipping...")
			continue
		# Parse it!
		receive_server_packet(packet)

func receive_server_packet(packet: AOPacket):
	packet.net_decode()
	var header: String = packet.header
	var contents: PackedStringArray = packet.contents
	print("Received Header: %s, Contents: %s" % [header, contents])

	# General data received
	data_received.emit(header, contents)

	# Specific parsing for AO Protocol stuff
	# Music Change"
	if header == "MC":
		print("MUSIC CHANGE %s" % contents)
	if header == "decryptor":
		send_server_packet(AOPacket.new("HI", [OS.get_unique_id()]))
	# "Identification"
	if header == "ID":
		send_server_packet(AOPacket.new("ID", ["AO2", "2.10.1"]))
		# We are only "actually" connected to the server with this packet
		send_server_packet(AOPacket.new("askchaa"))
	# "Feature List"
	if header == "FL":
		feature_list = contents
	# "Size" ?
	if header == "SI":
		if contents.size() != 3:
			return
		var _char_list_size = contents[0]
		var _evidence_list_size = contents[1]
		var _music_list_size = contents[2]
		# Asks for the whole character list (AO2)
		#send_server_packet(AOPacket.new("RC"))
		# Asks for the whole music list (AO2)
		#send_server_packet(AOPacket.new("RM"))
		# Asks for server metadata(charscheck, motd etc.) and a DONE#% signal(also best packet)
		send_server_packet(AOPacket.new("RD"))
	# "Send Characters"
	if header == "SC":
		var _character_list: PackedStringArray = []
		_character_list = contents
	# "Send Music"
	if header == "SM":
		var _music_list: PackedStringArray = []
		_music_list = contents
	if header == "DONE":
		print("This is where we would destroy the lobby as we are finished")
	# "Chat" ?
	if header == "CT":
		if contents.size() < 2:
			return
		var ooc_name: String = contents[0]
		var message: String = contents[1]
		var message_type: int = 0
		if contents.size() >= 3:
			message_type = int(contents[2])
		ooc_message.emit(ooc_name, message, message_type)
	# The "Pong" to our "Ping" ("CH" packet we sent to the server earlier)
	if header == "CHECK":
		var latency = pong()
		print("Ping-Pong: ", latency)
	if header == "MS":
		var new_ic_message = ICMessage.new_inbound(packet.contents)
		ic_message.emit(new_ic_message)

func send_server_packet(packet: AOPacket):
	# never send an unencoded packet!
	packet.net_encode()
	# Send the packet as string
	var packet_string = packet.get_packet_string()
	client.send_string(packet_string)

func send_ooc_message(ooc_name: String, message: String):
	send_server_packet(AOPacket.new("CT", [ooc_name, message]))

## Remind the server we're alive. ping_server() equivalent
func _on_keep_alive_timer_timeout() -> void:
	send_server_packet(AOPacket.new("CH", [-1]))
	ping_check_start = Time.get_ticks_msec()

## Calculate the time taken from us sending "CH" to the server, and receiving "CHECK" back
func pong() -> int:
	# Return elapsed time in msec
	return Time.get_ticks_msec() - ping_check_start
