extends Node

var character_id: int = -1
var client_id: int = 0

var character_list: PackedStringArray
var music_list: Dictionary[StringName, Array]
var area_list: PackedStringArray

var music_folder: String = "user://assets/music/"
var current_song: String = ""
