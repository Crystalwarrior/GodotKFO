extends VSplitContainer

func _ready() -> void:
	for child in get_children():
		child.visibility_changed.connect(_on_child_visibility_changed)

func _on_child_visibility_changed() -> void:
	show()
	for child in get_children():
		if child.visible:
			return
	hide()
