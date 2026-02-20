# It's a tool script so that resource name changes in editor too
@tool
@icon("uid://hkomwjc8p8xv")
class_name CharacterEmote
extends Resource

## The icon to use for the emote
@export var icon: Texture:
	set(new_value):
		if icon != new_value:
			icon = new_value
			emit_changed()

## The human-readable emote name for ui and various other cases
@export var emote_name: String:
	set(new_value):
		if emote_name != new_value:
			emote_name = new_value
			resource_name = new_value
			emit_changed()

## What the emote's animation key is
@export var animation_key: String:
	set(new_value):
		if animation_key != new_value:
			animation_key = new_value
			emit_changed()
