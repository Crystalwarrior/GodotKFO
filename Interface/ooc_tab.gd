extends Control

@onready var ooc_logs: RichTextLabel = %OOCLogs
@onready var ooc_name_input: LineEdit = %OOCNameInput
@onready var ooc_message_input: TextEdit = %OOCMessageInput

signal ooc_sent(ooc_name: String, message: String)

func _ready() -> void:
	ooc_name_input.text_submitted.connect(_on_ooc_name_input_text_submitted)
	ooc_message_input.gui_input.connect(_on_ooc_message_input_gui_input)


func add_message(ooc_name: String, message: String, message_type: int) -> void:
	# Master Server sender
	if message_type == 0:
		ooc_logs.push_color(Color(0.0, 0.741, 0.725, 1.0))
	# Server Sender
	elif message_type == 1:
		ooc_logs.push_color(Color(0.384, 0.616, 1.0, 1.0))
	ooc_logs.add_text(ooc_name)
	if message_type in [0, 1]:
		ooc_logs.pop()
	ooc_logs.add_text(": ")
	ooc_logs.add_text(message)
	ooc_logs.newline()

#region SIGNALS
func _on_ooc_name_input_text_submitted(_new_text: String):
	ooc_message_input.grab_focus()

func _on_ooc_message_input_gui_input(event: InputEvent):
	# only send on Enter key, not text newline key
	if event.is_action_pressed("ui_text_submit") and not event.is_action_pressed("ui_text_newline_blank"):
		# Handle the input here, preventing it from creating a new line.
		get_tree().root.set_input_as_handled()
		ooc_sent.emit(ooc_name_input.text, ooc_message_input.text)
		ooc_message_input.clear()

#endregion
