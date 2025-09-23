extends Control

@onready var ic_logs: RichTextLabel = %ICLogs
@onready var ic_message_input: TextEdit = %ICMessageInput

signal ic_sent(ic_message: ICMessage)

func _ready() -> void:
	ic_message_input.gui_input.connect(_ic_message_input_gui_input)


func add_message(ic_message: ICMessage) -> void:
	ic_logs.push_color(Color(0.85, 0.85, 0.85, 1.0))
	var showname = ic_message.showname
	if showname.is_empty():
		showname = ic_message.char_name
	ic_logs.add_text(showname)
	ic_logs.pop()
	ic_logs.add_text(": ")
	ic_logs.add_text(ic_message.message)
	ic_logs.newline()

func construct_ic_message() -> ICMessage:
	var ic_message: ICMessage = ICMessage.new()
	ic_message.char_id = Globals.character_id
	if ic_message.char_id >= 0 and ic_message.char_id < Globals.character_list.size():
		ic_message.char_name = Globals.character_list[Globals.character_id]
	ic_message.message = ic_message_input.text
	ic_message.showname = ""
	return ic_message

#region SIGNALS
# ic_message_input signals
func _ic_message_input_gui_input(event: InputEvent):
	# only send on Enter key, not text newline key
	if event.is_action_pressed("ui_text_submit") and not event.is_action_pressed("ui_text_newline_blank"):
		# Handle the input here, preventing it from creating a new line.
		get_tree().root.set_input_as_handled()
		ic_sent.emit(construct_ic_message())
		ic_message_input.clear()

#endregion
