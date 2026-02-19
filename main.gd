extends Node

# TODO: don't call this "main", call this "AOClient" instead
# as it just translates AO commands

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
	ao_protocol.music_list.connect(_on_ao_music_list)
	ao_protocol.music_change.connect(_on_ao_music_change)
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


func _on_ao_music_list(songs: PackedStringArray) -> void:
	var area_list: PackedStringArray = []
	var music_list: Dictionary[StringName, Array]
	music_list[""] = []

	var actual_songs = songs.duplicate()
	for song in songs:
		if song.get_extension() in ["wav", "mp3", "mp4", "ogg", "opus"]:
			# We're no longer in areas, previous item was erroneously added as an area
			# when it's not. Correct that!
			var last_song = area_list.get(area_list.size()-1)
			area_list.remove_at(area_list.size()-1)
			actual_songs.insert(0, last_song)
			break
		area_list.append(song)
		actual_songs.erase(song)

	var category = null
	for song in actual_songs:
		# not a real song
		if song.to_lower() == "~stop.mp3" or song.to_lower().remove_chars("=") == "stop":
			continue

		# First, cut off the file extension
		var song_basename = song.get_basename()
		# Second, cut off the folder path and just get the name
		song_basename = song_basename.substr(song_basename.rfind("/")+1)

		if song_basename != song:
			if category != null:
				music_list[category].append(song)
			else:
				music_list[""].append(song)
		else:
			category = song
			if category not in music_list:
				music_list[category] = []
	Globals.area_list = area_list
	Globals.music_list = music_list
	chat.populate_music_list(music_list)

func _on_ao_music_change(song: String, by_char_id: int, showname: String, looping: bool, channel: int, effect_flags: int) -> void:
	# First, cut off the file extension
	var song_basename = song.get_basename()
	# Second, cut off the folder path and just get the name
	song_basename = song_basename.substr(song_basename.rfind("/")+1)
	# update the display name
	chat.song_name_label.text = song_basename
