extends Node
class_name CharacterScene

## The animation player to be used for animations dependent on talking/not talking state
@export var talk_animationplayer: AnimationPlayer = get_node_or_null("TalkPlayer")
## The animation player to be used to switching between emotes
@export var emote_switcher: AnimationPlayer = get_node_or_null("EmoteSwitcher")
## The node containing camera data, such as the default camera angle for this character
#@export var camera_data:CameraData = get_node_or_null("CameraData")
## The default character resource to be used by this character scene.
## Only used by scripts!
var character_resource: CharacterResource


var is_talking: bool = false

var talk_prefix = ""

# The number of animations we're waiting on to finish
var waiting_on_animations: int = 0

signal animation_finished

func _init(char_res: CharacterResource = null) -> void:
	self.character_resource = char_res

func _ready() -> void:
	set_animation(emote_switcher.autoplay)
	emote_switcher.animation_started.connect(_animation_started)
	emote_switcher.animation_finished.connect(_animation_finished)

# TODO: this
#func get_camera_data() -> CameraData:
	#return camera_data


func set_emote(emote: CharacterEmote):
	set_animation(emote.animation_key)


func set_emote_by_name(emote_name: String):
	for emote in character_resource.emotes:
		if emote.emote_name == emote_name:
			set_emote(emote)
			break


func set_animation(anim_key):
	emote_switcher.stop(true)
	emote_switcher.play(anim_key)
	talk_prefix = anim_key
	if talk_animationplayer:
		set_talking(is_talking)


func set_talking(toggle: bool = false):
	var suffix = "_talk" if toggle else "silent"
	is_talking = toggle
	if talk_animationplayer and talk_animationplayer.has_animation(talk_prefix + suffix):
		talk_animationplayer.play(talk_prefix + suffix)


func _animation_finished(anim_name: StringName):
	waiting_on_animations -= 1
	if waiting_on_animations <= 0:
		waiting_on_animations = 0
		animation_finished.emit()


func _animation_started(anim_name: StringName):
	if emote_switcher.get_animation(anim_name).loop_mode == Animation.LOOP_NONE:
		waiting_on_animations += 1
