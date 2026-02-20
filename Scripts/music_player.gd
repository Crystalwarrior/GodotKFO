extends AudioStreamPlayer

var fadetween: Tween

func play_track(new_stream: AudioStream, target_volume: float = 1.0, duration: float = 1.0):
	stream = new_stream
	stream_paused = false
	if new_stream == null:
		stop_track(duration)
		return
	if duration > 0.0:
		volume_linear = 0.0
	fade(target_volume, duration)
	play()


func stop_track(duration: float = 1.0):
	fade(0.0, duration)
	if duration > 0:
		await fadetween.finished
	stop()


func unpause_track(target_volume: float = 1.0, duration: float = 1.0):
	fade(target_volume, duration)
	if duration > 0:
		await fadetween.finished
	stream_paused = false


func fade(target_volume = 1.0, duration: float = 1.0):
	target_volume = clampf(target_volume, 0.0, 1.0)
	if fadetween:
		fadetween.kill()
	if duration <= 0:
		volume_linear = target_volume
		stream_paused = volume_linear <= 0.0
		return
	# TODO: figure out why set_volume_db error happens sometimes
	# when volume reaches 0 ("Volume can't be set to NaN.), might be engine bug
	fadetween = create_tween()
	fadetween.tween_property(self, "volume_linear", target_volume, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN if target_volume > volume_linear else Tween.EASE_OUT)
	stream_paused = false
