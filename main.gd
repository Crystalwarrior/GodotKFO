extends Node

@onready var ao_protocol: AOProtocol = %AOProtocol
@onready var chat: Control = %Chat
@onready var lobby: Control = %Lobby

func _ready() -> void:
	ao_protocol.connected.connect(_on_ao_protocol_connected)
	ao_protocol.disconnected.connect(_on_ao_protocol_disconnected)
	chat.ooc_outbound.connect(ao_protocol.send_ooc_message)

func _on_ao_protocol_connected() -> void:
	lobby.set_visible(false)
	chat.set_visible(true)

func _on_ao_protocol_disconnected() -> void:
	lobby.info_label.text = "Disconnected from server!"
	lobby.set_visible(true)
	chat.set_visible(false)

func _on_lobby_direct_connect(address: String) -> void:
	ao_protocol.join(address)


func _on_ao_protocol_ooc_message(ooc_name: String, message: String, message_type: int) -> void:
	chat.ooc_tab.add_message(ooc_name, message, message_type)
