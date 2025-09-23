extends Node

@onready var ao_protocol: AOProtocol = %AOProtocol
@onready var chat: Control = %Chat
@onready var lobby: Control = %Lobby

func _ready() -> void:
	ao_protocol.connected.connect(_on_ao_protocol_connected)
	ao_protocol.disconnected.connect(_on_ao_protocol_disconnected)
	ao_protocol.ooc_message.connect(_on_ao_protocol_ooc_message)
	ao_protocol.ic_message.connect(_on_ao_protocol_ic_message)
	ao_protocol.character_list.connect(_on_ao_character_list)
	ao_protocol.changed_character.connect(_on_ao_changed_character)
	chat.ic_outbound.connect(ao_protocol.send_ic_message)
	chat.ooc_outbound.connect(ao_protocol.send_ooc_message)
	chat.character_selected.connect(ao_protocol.select_character)

func _on_ao_protocol_connected() -> void:
	lobby.set_visible(false)
	chat.set_visible(true)

func _on_ao_protocol_disconnected() -> void:
	lobby.info_label.text = "Disconnected from server!"
	lobby.set_visible(true)
	chat.set_visible(false)

func _on_lobby_direct_connect(address: String, use_ws: bool) -> void:
	ao_protocol.join(address, use_ws)

func _on_ao_protocol_ooc_message(ooc_name: String, message: String, message_type: int) -> void:
	chat.ooc_tab.add_message(ooc_name, message, message_type)

func _on_ao_protocol_ic_message(ic_message: ICMessage) -> void:
	chat.ic_tab.add_message(ic_message)

func _on_ao_character_list(character_list: PackedStringArray) -> void:
	Globals.character_list = character_list
	chat.populate_character_dropdown(character_list)

func _on_ao_changed_character(client_id: int, character_id: int) -> void:
	Globals.client_id = client_id
	Globals.character_id = character_id
