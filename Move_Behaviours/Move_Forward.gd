class_name Move_Forward
extends Move_Base
#Basic forward moving behaviour

func do_rotate_and_get_move_vector(delta):
	return Vector2.RIGHT.rotated(owner.rotation) * speed * delta

