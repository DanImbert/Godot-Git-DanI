extends KinematicBody2D
class_name Shooter
# base class for those who can shoot weapons

var fire_input_pressed = false

func apply_knockback(_amount, _duration):
	#This functionality for this is implemented in a child class such as Player.
	pass
	
func block_movement(_multiplier, _duration):
	#This functionality for this is implemented in a child class such as Player.
	pass	
	
func block_rotation(_duration):
	#This functionality for this is implemented in a child class such as Player.
	pass
