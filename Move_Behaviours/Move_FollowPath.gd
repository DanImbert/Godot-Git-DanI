class_name Move_FollowPath
extends Move_Base
#Creates a path_follow node on the path, and gets position to next point on the rail.

export(Enums.EFollowType) var rail_follow_type = Enums.EFollowType.PINGPONG

var rail : Path2D setget set_rail

var _path_follow : PathFollow2D
var _pingpong = 1 #variable used for pingpong movement calculations

func set_rail(value : Path2D):
	#set rail and create a PathFollow2D node to follow around
	rail = value
	_path_follow = PathFollow2D.new()
	rail.add_child(_path_follow)
	
func get_new_position(delta) -> Vector2:
	match rail_follow_type:
		Enums.EFollowType.LOOP:
			_path_follow.offset += speed * delta
		Enums.EFollowType.STOPATEND:
			if (_path_follow.offset + speed * delta < rail.curve.get_baked_length()):
				_path_follow.offset += speed * delta
		Enums.EFollowType.PINGPONG:	
			if (_path_follow.offset + (speed * delta * _pingpong) > rail.curve.get_baked_length()):
				_pingpong = -_pingpong
			_path_follow.offset += speed * delta * _pingpong
							
	return _path_follow.global_position
