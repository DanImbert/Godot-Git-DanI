extends Line2D
class_name Trail
#creates trail 
#based on https://youtu.be/s5DwZZ0fZDg

export(NodePath) var trail_target
export var trail_length = 5

func _process(delta):
	#Trail origin will stay at 0,0 regardless of target movement or rotation 
	global_position = Vector2.ZERO	
	global_rotation = 0

	add_point(get_node(trail_target).global_position)
	while get_point_count() > trail_length:
		remove_point(0)	
