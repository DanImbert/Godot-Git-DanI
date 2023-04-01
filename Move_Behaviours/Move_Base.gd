class_name Move_Base
extends Node
#Base class for all movement behaviours, 

export var start_at_max_speed = false
export var speed : int = 1000 setget set_speed		#starting speed
export var min_speed  : int = 0
export var max_speed : int = 10000	
export var max_speed_randomisation  : int = 0		#variation to maximum speed
export var acceleration = 0							#acceleration per second
export var max_rotation_speed = 180

func _ready():
	if max_speed_randomisation != 0: #newer versions of godot should use randi_range instead!
		max_speed += randi() % max_speed_randomisation - max_speed_randomisation
	if start_at_max_speed:
		speed = max_speed

func _physics_process(delta):
	self.speed += acceleration * delta

func set_speed(value):
	speed = value
	if speed > max_speed:
		speed = max_speed
	elif speed < min_speed:
		speed = min_speed

func do_rotate_and_get_move_vector(_delta : float) -> Vector2:
	print("Not all Move_states use do_rotate_and_get_move_vector(). Maybe use get_new_position() instead")
	return Vector2.ZERO
	
func get_new_position(_delta) -> Vector2:
	print("Not all Move_states use get_new_position(). Maybe use do_rotate_and_get_move_vector() instead")
	return Vector2.ZERO

func rotate_owner(degrees, delta):
	if (rad2deg(abs(degrees)) < max_rotation_speed * delta):
		owner.rotate(degrees)
	else:
		var side = -1 if not degrees > 0 else 1 #determine to rotate left or right
		owner.rotate(deg2rad(side * max_rotation_speed * delta))
