extends Control

@onready var ic_logs: RichTextLabel = %ICLogs
@onready var ic_message_input: TextEdit = %ICMessageInput

func _ready() -> void:
	ic_message_input.gui_input.connect(_ic_message_input_gui_input)


#region SIGNALS
# ic_message_input signals
func _ic_message_input_gui_input(event: InputEvent):
	# only send on Enter key, not text newline key
	if event.is_action_pressed("ui_text_submit") and not event.is_action_pressed("ui_text_newline_blank"):
		# Handle the input here, preventing it from creating a new line.
		get_tree().root.set_input_as_handled()
		# TODO: placeholder
		ic_logs.newline()
		ic_logs.add_text(ic_message_input.text)
		ic_message_input.clear()

#endregion
