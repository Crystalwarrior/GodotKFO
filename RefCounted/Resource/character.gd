@icon("uid://badwcnq8k3s71")
class_name CharacterResource
extends Resource

## The character's icon to use as a profile
@export var icon: Texture:
	set(new_value):
		if icon != new_value:
			icon = new_value
			emit_changed()

## The default character name to show if no custom showname is defined
@export var showname: String = "":
	set(new_value):
		if showname != new_value:
			showname = new_value
			emit_changed()

## The blip sound effects to use if no custom blips are defined
@export var blips: String = "":
	set(new_value):
		if blips != new_value:
			blips = new_value
			emit_changed()

## The list of emotes available. Will be used to request the Character Scene to display them.
@export var emotes: Array[CharacterEmote]:
	set(new_value):
		if emotes != new_value:
			emotes = new_value
			emit_changed()

## The character scene to use when instantiating the character and to receive the above data.
@export var character_scene: PackedScene:
	set(new_value):
		if character_scene != new_value:
			character_scene = new_value
			emit_changed()

## The default camera destination key to use for this character
@export var default_camera_pos: String = "wit":
	set(new_value):
		if default_camera_pos != new_value:
			default_camera_pos = new_value
			emit_changed()
