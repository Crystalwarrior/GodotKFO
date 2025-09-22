extends Control

@onready var ic_tab: Control = %ICTab
@onready var ooc_tab: Control = %OOCTab

signal ic_outbound(showname: String, message: String)
signal ooc_outbound(ooc_name: String, message: String)

func _ready():
	ic_tab.ic_sent.connect(ic_outbound.emit)
	ooc_tab.ooc_sent.connect(ooc_outbound.emit)
