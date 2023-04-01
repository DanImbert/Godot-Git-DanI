extends NME_Base
#extends KinematicBody2D
class_name NME_Blob

var _generation_number = 0



var is_moving = true



onready var move_type = get_node("Move_FollowTarget")



#onready var soft_collision = $Soft_Collision



signal enemy_spawned(enemy)

func _physics_process(delta):
	# Movement
	if is_moving:
		move_and_slide(_move_state.do_rotate_and_get_move_vector(delta))
	# Soft Collisions for enemies not to overlap so much
	#if soft_collision.is_colliding():
		#move_and_slide(soft_collision.get_push_vector() * delta)
		
func _ready():
	# setting speed and connecting signal when it's anything exept first generation
	if _generation_number > 0:
		move_type.speed = move_type.speed * (_generation_number * 2.5)
	if Globals.game_mode.get_child(1) is GameState_Play_Flag:
		if self.is_connected("enemy_spawned", Globals.game_mode.get_child(1), "on_enemy_spawned") == false:
			print("happened ", self.name)
			Globals.game_mode.get_child(1).enemy_spawned_untraditionally(self)
			emit_signal("enemy_spawned", self)
		
func spawn_next_generation(offset_x:int, offset_y:int):
	# Actual spawning    
	var spawned_obj = Utils.spawn(NMEList.GetPreloadedEnemy(Enums.ENME_Types.BLOB), Vector2(global_position.x + offset_x, global_position.y + offset_y), global_rotation)
	# Setting generation number and scale (The rest is set in _ready function)
	spawned_obj._generation_number = _generation_number + 1
	spawned_obj.set_scale(spawned_obj.get_scale()/(_generation_number + 2))
	
	 # Throws error without .call_deferred() ¯\_(ツ)_/¯
	Globals.level.enemies_root.call_deferred("add_child", spawned_obj)



func _on_Health_health_depleted():
	var rng = RandomNumberGenerator.new()
	# Spawn 4 more slimes if this is not the last generation
	if _generation_number < 1:
		for i in range(-1, 2, 2):
			for j in range(-1, 2, 2):
				rng.randomize()
				spawn_next_generation(i * rng.randf_range(40,60), j * rng.randf_range(40,60))



   #Calling inherited function
	._on_Health_health_depleted()
	
	
	
		
		
		

#const move_speed = 80
#const attack_distance = 80
#
#var is_moving = false
#var is_attacking = false
#export(PackedScene) var blobette = preload("res://Enemies/NME_Blobette.tscn")
##var Enemy = preload ("res://Enemies/NME_Blob.tscn")
#
#func _ready():
#	_move_state = get_node(move_state_path)
#	is_moving = true
#
#func _physics_process(delta: float) -> void:
#
#
#	if Globals.player:
#		if is_moving:
#		 move(delta)
#
#
#		if ! is_attacking && position.distance_to(Globals.player.position) < attack_distance:
#
#			is_attacking = true
#			is_moving = true
#
#
#func move(delta):
#
#	var raw_direction = (Globals.player.position - position).normalized()
#
#
#	var direction = Vector2(int(round(raw_direction.x)), int(round(raw_direction.x)))
#	var velocity = direction * move_speed * delta
#	move_and_collide(velocity)	
#
#func stop_moving():
#		is_moving = false
#
#
#
#func _on_EnemyTimer_timeout():
#	var player = get_node("res://Player/Player.tscn")
#	#var e = Enemy.instance()
#	var pos = player.position
#
#	if randf() < 0.5:
#		# On the left
#		pos.x -= rand_range(50.0, 200.0)
#	else:
#		# On the right
#		pos.x += rand_range(50.0, 200.0)
#
#	#e.position = pos
#	#add_child(e)
#
#
#
#
#func spawn(spawn_global_position):
#	var instance = blobette.instance()
#	instance.global_position = spawn_global_position
#	add_child(instance)
#
#
#



