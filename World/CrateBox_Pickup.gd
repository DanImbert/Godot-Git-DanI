extends Area2D
class_name CrateBox_Pickup

export var pickup_sound : AudioStream

signal picked_up

func destroy():
	queue_free()

func _on_CrateBox_Pickup_body_entered(_body):
	Globals.audio.play_sound_at_location(pickup_sound, global_position, "Pickups")
	Globals.analytics.add_message("picked up score" + str(position))
	emit_signal("picked_up")
	destroy()
