extends Proj_Base
class_name Proj_Mine

export var blink_sound : AudioStream 

func _ready():
	._ready()
	$AnimationPlayer_Blink.play("Blink")

func play_sound():
	Globals.audio.play_sound_at_location(blink_sound, global_position, "Player")

