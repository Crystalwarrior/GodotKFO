extends Control

@onready var ic_tab: Control = %ICTab
@onready var ooc_tab: Control = %OOCTab
@onready var character_dropdown: OptionButton = %CharacterDropdown

signal ic_outbound(showname: String, message: String)
signal ooc_outbound(ooc_name: String, message: String)
signal character_selected(char_folder: String)

func _ready():
	ic_tab.ic_sent.connect(ic_outbound.emit)
	ooc_tab.ooc_sent.connect(ooc_outbound.emit)
	character_dropdown.item_selected.connect(_on_character_selected)

func _on_character_selected(index: int):
	# we substract 1 because 0th entry is SPECTATOR
	character_selected.emit(index-1) #character_dropdown.get_item_text(index))

func populate_character_dropdown(character_list: PackedStringArray):
	character_dropdown.clear()
	character_dropdown.add_item("SPECTATOR")
	for character in character_list:
		character_dropdown.add_item(character)
