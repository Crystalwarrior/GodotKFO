extends Control

@onready var info_label = %InfoLabel
@onready var server_ip_line_edit = %ServerIPLineEdit
@onready var join_button = %JoinButton
@onready var ws_check_box = %WSCheckBox

signal direct_connect(address: String, use_ws: bool)

func _on_server_ip_line_edit_text_submitted(_new_text: String) -> void:
	var input = server_ip_line_edit.text
	if input.is_empty():
		return
	join(input)

func _on_join_button_pressed() -> void:
	var input = server_ip_line_edit.text
	if input.is_empty():
		input = server_ip_line_edit.placeholder_text
	join(input)

func join(address: String) -> void:
	info_label.text = "Connecting..."
	direct_connect.emit(address, ws_check_box.button_pressed)
