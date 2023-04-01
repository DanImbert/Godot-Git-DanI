extends NME_Base
class_name NME_FlagSwarmer
#A simple Swarmer enemy without attack behvaiour that always moves towards the player. 

onready var soft_collision = $SoftCollision

func _physics_process(delta):
	move_and_slide(_move_state.do_rotate_and_get_move_vector(delta))




	
