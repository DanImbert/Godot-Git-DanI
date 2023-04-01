extends Position2D


export(Enums.ENME_Types) var NME_to_spawn = Enums.ENME_Types.SWARMER
export var rail : NodePath #used for enemies who move on rails 
export var time_between_spawns = 2.0 

onready var spawn_timer = $Timer
 
var active = false

signal enemy_spawned(enemy)

func _ready():
	spawn_timer.wait_time = time_between_spawns	

func set_time_between_spawns(time = 1):
	spawn_timer.wait_time = time

func spawn(NME_type):
	if active and Globals.debug_spawners_on:
		var spawned_obj = NMEList.GetPreloadedEnemy(NME_type).instance()
		Globals.level.enemies_root.add_child(spawned_obj)
		spawned_obj.global_position = global_position
		spawned_obj.global_rotation = global_rotation
		spawned_obj.initialise({"rail" : get_node(rail)}) #send the enemy reference to this spawnpoints rail in case it needs it
		emit_signal("enemy_spawned", spawned_obj)

func _on_Timer_timeout():
	spawn(NME_to_spawn)


