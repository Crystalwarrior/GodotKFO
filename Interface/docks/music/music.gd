extends PanelContainer

@onready var expand_button: Button = %ExpandButton
@onready var collapse_button: Button = %CollapseButton
@onready var music_list: Tree = %MusicList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	expand_button.pressed.connect(_on_expand_button_pressed)
	collapse_button.pressed.connect(_on_collapse_button_pressed)

func _on_expand_button_pressed() -> void:
	var root = music_list.get_root()
	root.set_collapsed_recursive(false)
	root.collapsed = false

func _on_collapse_button_pressed() -> void:
	var root = music_list.get_root()
	root.set_collapsed_recursive(true)
	root.collapsed = false
