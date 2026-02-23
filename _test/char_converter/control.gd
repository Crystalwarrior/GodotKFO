extends Control

@onready var preview_node: Node2D = $"../HBoxContainer/AspectRatioContainer/Preview Node"


func _on_emotes_visible_pressed() -> void:
	$"../HBoxContainer/VBoxContainer".visible = !$"../HBoxContainer/VBoxContainer".visible


func _on_height_normal_value_changed(value: float) -> void:
	preview_node.preview_height = value
	preview_node.calc_preview_height()


func _on_offset_x_value_changed(value: float) -> void:
	preview_node.position_offset_normal.x = value
	preview_node.calc_preview_height()


func _on_offset_y_value_changed(value: float) -> void:
	preview_node.position_offset_normal.y = value
	preview_node.calc_preview_height()
