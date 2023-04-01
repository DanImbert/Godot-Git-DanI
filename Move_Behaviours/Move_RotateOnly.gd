class_name Move_RotateOnly
extends Move_Base
#stay stationary and rotate

var target : Node2D 

func _ready():
	._ready()
	target = Globals.player

func do_rotate_and_get_move_vector(delta):
	#get angle towards target limited by rotation_speed
	var angle = owner.get_angle_to(target.global_position)
	rotate_owner(angle, delta)


