class_name Utils
extends Node
#A shared utility class with only static functions that can be called from anywhere.

static func radian_to_vector2(rotation : float):
	return Vector2(cos(rotation), sin(rotation))

static func get_overlapping_objects_in_circle(position : Vector2, radius : float, bodies := true, areas := true, bit_flags := 0b11111111111111111111) -> Array: 
#	This function takes a position, radius, and layers, and returns the objects
#	Example use: var objects = Utils.get_overlapping_objects_in_circle(global_position, 20, true, true, 0b00000000000000001011)
#	bit_flags is an int interpreted as bits. ON or OFF for all 20 layers. Counts down 20 to 1 left to right. 
#	Example: 0b00000000000000001011 checks layers 4, 2 and 1
#	To expose the bit_flags as a variable in inspector use: export(int, LAYERS_2D_PHYSICS) var bit_flags
#	for layers: https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
	
#	create parameters for the query
	var params = Physics2DShapeQueryParameters.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
	params.set_shape(shape) 
	params.transform = Transform(Basis.IDENTITY, Vector3(position.x, position.y, 0))
	params.collision_layer = bit_flags  
	params.collide_with_bodies = bodies
	params.collide_with_areas = areas

	# do query and return colliders
	var space_state = Globals.level.get_world_2d().direct_space_state # this gets the physics information of the world
	var query_results = space_state.intersect_shape(params) # checks for intersections based on the parameters
	var objects = []
	for result in query_results:
		objects.append(result.collider)
	return objects

static func spawn(scene : PackedScene, position : Vector2, rotation : float) -> Node:
	var spawned_obj  = scene.instance()
	spawned_obj.global_position = position
	spawned_obj.global_rotation = rotation	
	
	return spawned_obj
