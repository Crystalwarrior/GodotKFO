extends Node
class_name BaseClient

signal connected
signal disconnected
signal data_received(data: Array)

var status: int = 0
