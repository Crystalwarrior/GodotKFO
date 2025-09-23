extends BaseClient
## Basic Websocket Client Class to exchange information with the server
class_name WSClient

var websocket_stream: WebSocketPeer = WebSocketPeer.new()

func connect_to_url(url: String) -> void:
	print("Connecting to %s" % url)
	#var _error = websocket_stream.connect_to_url("ws://%s:%s" % [host, str(port)])
	var _error = websocket_stream.connect_to_url("ws://%s" % url)
	if _error != OK:
		printerr("Error connecting to host!")

func _process(_delta: float) -> void:
	if not websocket_stream:
		return
	websocket_stream.poll()

	var new_status: int = websocket_stream.get_ready_state()
	if new_status != status:
		status = new_status
		match status:
			websocket_stream.STATE_CLOSED:
				print("Disconnected from host :(")
				disconnected.emit()
			websocket_stream.STATE_CONNECTING:
				print("Connecting to host...")
			websocket_stream.STATE_OPEN:
				print("Connected! :D")
				connected.emit()
			websocket_stream.STATE_CLOSING:
				print("Closing Connection...")
	if new_status == websocket_stream.STATE_OPEN:
		while websocket_stream.get_available_packet_count():
			data_received.emit(websocket_stream.get_packet())

func send(data: PackedByteArray) -> bool:
	if status != websocket_stream.STATE_OPEN:
		printerr("Error: Stream is not currently connected.")
		return false
	var _error: int = websocket_stream.put_packet(data)
	if _error != OK:
		printerr("Error writing to stream: ", _error)
		return false
	return true

func send_string(data: String) -> bool:
	return send(data.to_utf8_buffer())
