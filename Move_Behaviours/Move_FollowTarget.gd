class_name Move_FollowTarget
extends Move_Base
#follows target limited by angular velocity

export var target_distance = 1

var target : Node2D 

signal target_distance_reached

func _ready():
	._ready()
	target = Globals.player

func do_rotate_and_get_move_vector(delta) -> Vector2:
	if (is_instance_valid(target)):
		#Check distance and emit signal
		var distance = target.global_position - owner.global_position
		if distance.length() <= target_distance:
			emit_signal("target_distance_reached")
		
		#get angle towards target limited by rotation_speed
		var angle = owner.get_angle_to(target.global_position)
		rotate_owner(angle, delta)
		
		#set velocity and move object	
		var direction = Vector2(cos(owner.global_rotation), sin(owner.global_rotation))
		return direction * speed * delta 
	
	else:
		 return Vector2.ZERO



func _on_NME_Blob_ready():
	pass # Replace with function body.


func _on_NME_Blob_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on_NME_Blob_child_entered_tree(node):
	pass # Replace with function body.
