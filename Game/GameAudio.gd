extends AudioStreamPlayer
class_name GameAudio

var music_reverb_effect

func toggle_musicFX(_active):
	if music_reverb_effect == null:
		music_reverb_effect = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
	
	if (_active):
		music_reverb_effect.dry = 0
		music_reverb_effect.wet = 1
	else:
		music_reverb_effect.dry = 1
		music_reverb_effect.wet = 0

func play_sound_at_location(sound : AudioStream, g_position : Vector2, _bus):
	#This plays a sound at location while the actor can be destroyed. For instance for pickups.
	var audio_node = AudioStreamPlayer2D.new()
	add_child(audio_node)
	audio_node.global_position = g_position
	audio_node.stream = sound
	audio_node.bus = _bus
	audio_node.play()
	audio_node.connect("finished", self, "destroy_audio_node", [audio_node])

func destroy_audio_node (node : AudioStreamPlayer2D):
	node.queue_free()
