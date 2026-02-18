extends TabContainer

@onready var dock_popup: Popup = %DockPopup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_popup(dock_popup)
	child_order_changed.connect(_on_child_order_changed)
	pre_popup_pressed.connect(_on_pre_popup_pressed)

func _on_pre_popup_pressed() -> void:
	dock_popup.current_dock = self

func _on_child_order_changed() -> void:
	visible = get_child_count() >= 1
