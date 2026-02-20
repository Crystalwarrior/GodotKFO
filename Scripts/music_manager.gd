extends Node
class_name MusicManager

var channel_count = 0
var current_channel = 0

enum MUSIC_EFFECT {
	FADE_IN = 1,
	FADE_OUT = 2,
	SYNC_POS = 4
}

func _ready():
	channel_count = get_child_count()

func get_current_audoiplayer():
	return get_child(current_channel)

func play_track(path: String, target_volume: float = 1.0, duration: float = 1.0, effect_flags: MUSIC_EFFECT = MUSIC_EFFECT.FADE_OUT):
	var new_stream: AudioStream
	match path.get_extension():
		"mp3":
			new_stream = AudioStreamMP3.load_from_file(path)
			if new_stream:
				new_stream.loop = true
		"ogg":
			new_stream = AudioStreamOggVorbis.load_from_file(path)
			if new_stream:
				new_stream.loop = true
		"wav":
			new_stream = AudioStreamWAV.load_from_file(path)
			if new_stream:
				new_stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		_:
			push_error("Unsupported file type: ", path.get_extension())
	var current_audioplayer = get_current_audoiplayer()
	# Crossfade the old track
	if current_audioplayer.stream and current_audioplayer.stream != new_stream:
		var fade_out_duration = 0.0
		var audio_player = get_current_audoiplayer()
		if effect_flags & MUSIC_EFFECT.FADE_OUT:
			# Play on a different channel for crossfading
			current_channel = (current_channel + 1) % channel_count
			current_audioplayer = get_current_audoiplayer()
			fade_out_duration = 4.0
		audio_player.stop_track(fade_out_duration)
	# New track not found :(
	if not new_stream:
		push_error("Song not found: ", path)
		return
	var fade_in_duration = 0.0
	if effect_flags & MUSIC_EFFECT.FADE_IN:
		fade_in_duration = duration
	current_audioplayer.play_track(new_stream, target_volume, fade_in_duration)

func stop_track(duration: float = 4.0):
	get_current_audoiplayer().stop_track(duration)

func unpause_track(target_volume: float = 1.0, duration: float = 1.0):
	get_current_audoiplayer().unpause_track(target_volume, duration)

func fade(target_volume = 1.0, duration: float = 1.0):
	get_current_audoiplayer().fade(target_volume, duration)
