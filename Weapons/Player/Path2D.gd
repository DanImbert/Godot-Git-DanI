extends Path2D
class_name Trajectory

export(float) var curveMultiplier = 2 # multiplier for moving curve points with mouse
export(bool) var clampBezier = true # clamp the curve points so it won't get too big 
export(float) var bezier_radius = 2 # radius for clamping
export(bool) var use_preview = false # user a preview sprite on the curve
export(float) var can_shoot_treshold = 50 # min move threshold of the mouse in oder to shoot 
export(Gradient) var can_shoot_gradient # show a gradient color on line2d when user can shoot. Its green to transparent
export(Gradient) var not_shoot_gradient # show a gradient color on line2d when user can not shoot. Its red to transparent
# Nodes
onready var raycast_path = get_node("RayCast2D")
onready var line = get_node("Line2D")
onready var preview = get_node("PathFollow2D")
# private 
var last_mouse_pos = Vector2.ZERO # stored with first click and used to calculate distance with drag
var edit_Bezier = false # controls editing bezier
var can_shoot # can shoot boolean

func _ready():
	_reset()
func _reset():
		# hide the line so we don't show anything
	line.hide()
		# clear curve points
	curve.clear_points()
		# add 3 points, first and third points are are going to be player root position and second point is going to be mouse click position
	curve.add_point(position)
	curve.add_point(position)
	curve.add_point(position)
	
	
	
	
func on_pressed(_delta):
	# set mouse position
	var mousepos = get_local_mouse_position()
	last_mouse_pos = mousepos
	# current mouse position is set to pos 1
	curve.set_point_position(1, mousepos)
	edit_Bezier = true
	if use_preview:
		preview.show()
		# we will clear the line 2d points, they will be updated from process function later
	line.clear_points()
	line.show()
 
func on_released(_delta):
	edit_Bezier = false
	# hide stuff
	line.hide()
	preview.hide()
	
func _update_bezier():
	if not edit_Bezier:
		return
	# Set positions
	var point1 = curve.get_point_position(0)
	var point2 = curve.get_point_position(1)
	
	

	# Bezier setup, curve in and out positions
	
