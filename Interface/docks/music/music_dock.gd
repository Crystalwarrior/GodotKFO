extends PanelContainer

@onready var expand_button: Button = %ExpandButton
@onready var collapse_button: Button = %CollapseButton
@onready var music_list: Tree = %MusicList

@onready var song_name_label: Label = %SongNameLabel
@onready var music_scrubber: HSlider = %MusicScrubber

@onready var stop_button: Button = %StopButton

@onready var music_manager: MusicManager = %MusicManager

@onready var time_elapsed: Label = %TimeElapsed
@onready var time_total: Label = %TimeTotal

@onready var preview_button: TextureButton = %PreviewButton

signal play(song: String)
signal stop

var current_song: String = ""
var seeking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Core
	#play_button.pressed.connect(_on_play_button_pressed)
	stop_button.pressed.connect(_on_stop_button_pressed)
	preview_button.toggled.connect(_on_preview_button_toggled)
	music_list.item_activated.connect(_on_music_list_item_activated)
	
	music_scrubber.drag_started.connect(_on_music_scrubber_drag_started)
	music_scrubber.drag_ended.connect(_on_music_scrubber_drag_ended)
	
	# Quality of Life
	expand_button.pressed.connect(_on_expand_button_pressed)
	collapse_button.pressed.connect(_on_collapse_button_pressed)

func _process(_delta: float) -> void:
	if music_manager.get_current_audoiplayer().has_stream_playback():
		if current_song.is_empty():
			song_name_label.text = "Fading Out..."
		var stream: AudioStream = music_manager.get_current_audoiplayer().stream
		var stream_length: float = stream.get_length()
		var time: float = music_manager.get_current_audoiplayer().get_playback_position()

		# We're "seeking" if the user is trying to change the music scrubber value
		if not seeking:
			music_scrubber.max_value = stream_length
			music_scrubber.value = time

		var minutes: int = floori(time / 60.0)
		var seconds = floori(time) % 60
		var time_format: String = "%02d:%02d"
		time_elapsed.text = time_format % [minutes, seconds]

		var minutes_total: int = floori(stream_length / 60.0)
		var seconds_total: int = floori(stream_length) % 60
		time_total.text = time_format % [minutes_total, seconds_total]
	else:
		time_elapsed.text = "00:00"
		time_total.text = "00:00"
		song_name_label.text = ""
		music_scrubber.value = 0

func play_song(song: String, looping: bool = true, channel: int = 0,
	 effect_flags: MusicManager.MUSIC_EFFECT = MusicManager.MUSIC_EFFECT.FADE_OUT):
	if song.is_empty():
		stop_song(effect_flags)
		return
	current_song = song
	song_name_label.text = current_song.get_file().get_basename()
	var path = Globals.music_folder + song
	music_manager.play_track(path, 1.0, 1.0, effect_flags)

func stop_song(effect_flags: MusicManager.MUSIC_EFFECT = MusicManager.MUSIC_EFFECT.FADE_OUT):
	current_song = ""
	music_manager.play_track("", 1.0, 1.0, effect_flags)

func request_play_song(song: String) -> void:
	if preview_button.button_pressed:
		play_song(song)
		return
	play.emit(song)

func request_stop_song() -> void:
	if preview_button.button_pressed:
		stop_song()
		return
	stop.emit()

func _on_play_button_pressed() -> void:
	request_play_song(current_song)

func _on_stop_button_pressed() -> void:
	request_stop_song()

func _on_preview_button_toggled(toggled_on: bool) -> void:
	# TODO: decide if music scrubbing should be editable if online or not
	#music_scrubber.editable = toggled_on
	if not toggled_on:
		# TODO: resume from a specific point.
		# Either calculate it or simply lower volume of the online track
		play_song(Globals.current_song)

func _on_music_list_item_activated() -> void:
	var selected = music_list.get_selected().get_metadata(0)
	request_play_song(selected)

func _on_music_scrubber_drag_started() -> void:
	seeking = true

func _on_music_scrubber_drag_ended(value_changed: bool) -> void:
	seeking = false
	if not value_changed:
		return
	music_manager.get_current_audoiplayer().seek(music_scrubber.value)

func _on_expand_button_pressed() -> void:
	var root = music_list.get_root()
	root.set_collapsed_recursive(false)
	root.collapsed = false

func _on_collapse_button_pressed() -> void:
	var root = music_list.get_root()
	root.set_collapsed_recursive(true)
	root.collapsed = false
