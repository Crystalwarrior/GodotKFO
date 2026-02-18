extends Popup

signal position_pressed(position_name: StringName)

@onready var grid_container: GridContainer = %GridContainer

var current_dock: TabContainer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child: Button in grid_container.get_children():
		child.pressed.connect(_on_button_pressed.bind(child))

func _on_button_pressed(button: Button):
	position_pressed.emit(button.name)
