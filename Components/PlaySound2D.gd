extends AudioStreamPlayer2D
class_name PlaySound2D

export(float, 0, 0.99) var pitch_randomisation = 0.0

func play_sound():
	pitch_scale = 1 + rand_range(-pitch_randomisation, pitch_randomisation)
	play()
