extends BaseClient
## Basic TCP Client Class to exchange information with the server
class_name TCPClient

var tcp_stream: StreamPeerTCP = StreamPeerTCP.new()

func connect_to_url(url: String) -> void:
	var ip_port = url.split(":")
	var host: String = ip_port[0]
	var port: int = ip_port[1]
	connect_to_host(host, port)

func connect_to_host(host: String, port: int) -> void:
	print("Connecting to %s:%d" % [host, port])
	status = tcp_stream.STATUS_NONE
	if tcp_stream:
		tcp_stream.disconnect_from_host()
		#tcp_stream.free()
	var _error = tcp_stream.poll()
	if _error != OK:
		printerr("Failure to poll!")
	_error = tcp_stream.connect_to_host(host, port)
	if _error != OK:
		printerr("Error connecting to host!")

func _process(_delta: float) -> void:
	if not tcp_stream:
		return
	var _error = tcp_stream.poll()
	if _error != OK:
		printerr("Failure to poll: %s" % _error)
	var new_status: int = tcp_stream.get_status()
	if new_status != status:
		status = new_status
		match status:
			tcp_stream.STATUS_NONE:
				print("Disconnected from host :(")
				disconnected.emit()
			tcp_stream.STATUS_CONNECTING:
				print("Connecting to host...")
			tcp_stream.STATUS_CONNECTED:
				print("Connected! :D")
				connected.emit()
			tcp_stream.STATUS_ERROR:
				printerr("Error with socket stream.")
	if new_status == tcp_stream.STATUS_CONNECTED:
		var available_bytes: int = tcp_stream.get_available_bytes()
		if available_bytes > 0:
			var partial_data: Array = tcp_stream.get_partial_data(available_bytes)
			# Check for read error.
			if partial_data[0] != OK:
				printerr("Error getting data from stream: ", partial_data[0])
			else:
				data_received.emit(partial_data[1])

func send(data: PackedByteArray) -> bool:
	if status != tcp_stream.STATUS_CONNECTED:
		printerr("Error: Stream is not currently connected.")
		return false
	var _error: int = tcp_stream.put_data(data)
	if _error != OK:
		printerr("Error writing to stream: ", _error)
		return false
	return true

func send_string(data: String) -> bool:
	return send(data.to_utf8_buffer())
