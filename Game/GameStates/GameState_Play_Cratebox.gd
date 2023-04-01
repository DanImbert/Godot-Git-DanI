extends GameState_Base
class_name GameState_Play_CrateBox
#Core gamemode logic for the Cratebox gamemode. 
#spawning a pickup after a number of kills, and then give the player a random weapon.

var spawn_timers_easy = [20,10,7]	#These need to correspond with the spawners in the scene
var spawn_timers_normal = [18,9,5]	#These need to correspond with the spawners in the scene
var spawn_timers_hard = [16,7,3]# #These need to correspond with the spawners in the scene

var pickup_scene = preload("res://World/CrateBox_Pickup.tscn")

var _pickup : CrateBox_Pickup
var _spawned_enemies = []

func enter_state():
	.enter_state()
	Globals.hud.open_screen(Globals.hud.in_game_screen)
	Globals.audio.toggle_musicFX(false)
	Globals.player.connect("player_died", self, "_on_player_died")
	
	assert(spawn_timers_easy.size() == Globals.level.spawners.size(), "spawn timer settings and number of spawners in level needs to be the same")	
	assert(spawn_timers_normal.size() == Globals.level.spawners.size(), "spawn timer settings and number of spawners in level needs to be the same")
	assert(spawn_timers_hard.size() == Globals.level.spawners.size(), "spawn timer settings and number of spawners in level needs to be the same")
	
	for spawner in Globals.level.spawners:
		spawner.active = true
		spawner.connect("enemy_spawned", self, "on_enemy_spawned")
	Globals.hud.debug_screen.connect("enemy_spawned", self, "on_enemy_spawned")
	
	Globals.player.reset()
	_game_mode.reset_score()
	
	_spawn_pickup()

func process_tick(_delta):
	Globals.player.process_tick(_delta)

func set_difficulty(a_difficulty = Enums.EDifficulty.NORMAL):
	var spawn_timers 
	match (a_difficulty):
		Enums.EDifficulty.EASY:
			spawn_timers = spawn_timers_easy
		Enums.EDifficulty.NORMAL:
			spawn_timers = spawn_timers_normal
		Enums.EDifficulty.HARD:
			spawn_timers = spawn_timers_hard
	
	for i in Globals.level.spawners.size():
		Globals.level.spawners[i].set_time_between_spawns(spawn_timers[i])

func _spawn_pickup():
	#create a random position on screen
	var screensize = get_viewport().size
	
	var padding = 50 #don't spawn pickup on border of screen
	var pos = Vector2.ZERO
	pos.x = rand_range(padding,screensize.x - padding)
	pos.y = rand_range(padding,screensize.y - padding)
	
	_pickup = pickup_scene.instance()
	_pickup.global_position = pos 
	Globals.level.pickups_root.call_deferred("add_child", _pickup)	#cannot directly add child because this code results from a collision event
	_pickup.connect("picked_up", self, "on_pickup_picked_up")

func exit_state():
	#When this gamestate ends we need to clean up
	Globals.player.reset()
	Globals.player.disconnect("player_died", self, "_on_player_died")
	
	for spawner in Globals.level.spawners:
		spawner.active = false
		spawner.disconnect("enemy_spawned", self, "on_enemy_spawned")
	Globals.hud.debug_screen.disconnect("enemy_spawned", self, "on_enemy_spawned")
	
	for projectile in get_tree().get_nodes_in_group("projectiles"):
		projectile.queue_free()
	
	for enemy in _spawned_enemies:
		enemy.destroy()
	_spawned_enemies.clear()
	
	if is_instance_valid(_pickup):
		_pickup.destroy()
		_pickup = null

func on_pickup_picked_up():
	_game_mode.score += 1
	Globals.player.set_random_weapon()
	_pickup = null
	_spawn_pickup()

func on_enemy_spawned(enemy):
	_spawned_enemies.append(enemy)
	enemy.connect("enemy_died", self, "on_enemy_death", [], CONNECT_ONESHOT)

func on_enemy_death(enemy, _score_amount, a_position):
	_spawned_enemies.erase(enemy)

func _on_player_died():
	Globals.audio.toggle_musicFX(true)
	_game_mode.transition_to("GameOver")
