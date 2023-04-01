extends Proj_Base
class_name Proj_Bounce


func _physics_process(delta):
	var move_direction = _move_state.do_rotate_and_get_move_vector(delta)
	var collision = move_and_collide(move_direction)	
	
	if collision != null:
		#get remainder and move owner
		var bounced_direction = collision.remainder.bounce(collision.normal)
		move_and_collide(bounced_direction)
		
		#rotate the owner
		var angle = move_direction.angle_to(bounced_direction)
		rotation += angle

func _on_hit_wall(_wall : Wall):	#override in child class to change behaviour 
	pass

func _on_ActivationTimer_timeout():
	_hitbox.set_collision_mask_bit(1, true) #turn on collision with player after timer
