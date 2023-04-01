extends Node2D
class_name Level
#This is a container for the relevant variables in the level, can be accessed through Global.level

#in inspector drag the relevant nodes into these Nodepaths
export(Enums.ELevels) var level_enum #let this coincide with the list in LevelLoader
export(NodePath) var projectiles_root_path #add all spawned projectiles to this node
export(NodePath) var enemies_root_path  #add all spawned enemies to this node
export(NodePath) var pickups_root_path  #add all spawned pickups to this node
export(NodePath) var camera_path #main camera

#properties allow external objects to get these values, but not set them
var projectiles_root  setget , get_projectiles_root #add all spawned projectiles to this node
var enemies_root setget  , get_enemies_root #add all spawned enemies to this node
var pickups_root  setget  , get_pickups_root #add all spawned pickups to this node
var camera setget  , get_camera #main camera
var spawners setget  , get_spawners #all spawners need to be added to "spawners" group



func _ready():
	assert(!projectiles_root_path.is_empty(), "level requires a projectiles root")
	projectiles_root = get_node(projectiles_root_path)
	assert(!enemies_root_path.is_empty(), "level requires a enemies root")
	enemies_root = get_node(enemies_root_path)
	assert(!pickups_root_path.is_empty(), "level requires a pickups root")
	pickups_root = get_node(pickups_root_path)
	assert(!camera_path.is_empty(), "level requires a camera")
	camera = get_node(camera_path)
	
	#Only add spawners that are a a subnode of this level
	var all_spawners = get_tree().get_nodes_in_group("spawners")
	spawners = []
	for spawner in all_spawners:
		if is_a_parent_of(spawner):
			spawners.append(spawner)

func get_projectiles_root():
	return projectiles_root
	
func get_enemies_root():
	return enemies_root

func get_pickups_root():
	return pickups_root
	
func get_camera():
	return camera
	
func get_spawners():
	return spawners

func destroy():
	queue_free()


func _on_NME_Blob_enemy_died(enemy, score, location):
	pass # Replace with function body.
