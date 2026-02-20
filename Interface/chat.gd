extends Control

@onready var ic_tab: Control = %"In Character"
@onready var ooc_tab: Control = %"Out Of Character"
@onready var character_dropdown: OptionButton = %CharacterDropdown
@onready var dock_popup: Popup = %DockPopup
@onready var music_list: Tree = %MusicList
@onready var song_name_label: Label = %SongNameLabel
# TODO: rename to "music_dock"
@onready var music: PanelContainer = %Music
@onready var viewport_rect: ColorRect = %ViewportRect

signal ic_outbound(showname: String, message: String)
signal ooc_outbound(ooc_name: String, message: String)
signal character_selected(char_folder: String)

@onready var dock_a: TabContainer = %dock_a
@onready var dock_b: TabContainer = %dock_b
@onready var dock_c: TabContainer = %dock_c
@onready var dock_d: TabContainer = %dock_d
@onready var dock_e: TabContainer = %dock_e
@onready var dock_f: TabContainer = %dock_f

func _ready():
	ic_tab.ic_sent.connect(ic_outbound.emit)
	ooc_tab.ooc_sent.connect(ooc_outbound.emit)
	character_dropdown.item_selected.connect(_on_character_selected)
	dock_popup.position_pressed.connect(_on_dock_popup_position_pressed)

func _on_character_selected(index: int):
	# we substract 1 because 0th entry is SPECTATOR
	character_selected.emit(index-1) #character_dropdown.get_item_text(index))

func populate_character_dropdown(character_list: PackedStringArray):
	character_dropdown.clear()
	character_dropdown.add_item("SPECTATOR")
	for character in character_list:
		character_dropdown.add_item(character)

func populate_music_list(song_list: Dictionary[StringName, Array]):
	music_list.clear()
	var root = music_list.create_item()
	music_list.hide_root = true
	for category in song_list.keys():
		var category_item = root
		if category != "":
			category_item = music_list.create_item(root)
			category_item.set_text(0, category)
			category_item.set_metadata(0, category)
		for song in song_list[category]:
			# First, cut off the file extension
			var song_basename = song.get_basename()
			# Second, cut off the folder path and just get the name
			song_basename = song_basename.substr(song_basename.rfind("/")+1)

			var song_item = music_list.create_item(category_item)
			song_item.set_text(0, song_basename)
			song_item.set_metadata(0, song)
			song_item.set_tooltip_text(0, song)

func _on_dock_popup_position_pressed(position_name: StringName):
	var move_control: Control = dock_popup.current_dock.get_current_tab_control()
	dock_popup.current_dock.remove_child(move_control)
	var target_dock: TabContainer
	match position_name:
		&"a":
			target_dock = dock_a
		&"b":
			target_dock = dock_b
		&"c":
			target_dock = dock_c
		&"d":
			target_dock = dock_d
		&"e":
			target_dock = dock_e
		&"f":
			target_dock = dock_f
	target_dock.add_child(move_control)
	move_control.show()
	dock_popup.hide()
