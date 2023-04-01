extends GameState_Base
class_name GameState_Play_Flag

var _spawned_enemies = []
var _kill_count : int


var position_timer = Vector2(756,25)

var pickup_scene = preload("res://World/FlagPickup.tscn")
var safe_scene = preload("res://SafeZone.tscn")
var timer_scene = preload("res://Weapons/Countdown_Timer.tscn")
export(PackedScene) var flag_enemy_scene = preload("res://Enemies/NME_FlagSwarmer.tscn")




var _pickup : FlagPickup
var player : Player
var _timer_ : Countdown_Timer
var _safezone : SafeZone
var _flag_minion : NME_FlagSwarmer


var player_took_flag : bool = false
var flag_icon = Globals.hud.in_game_screen.flag_taken_label










signal time_reset
signal delete_timer





func process_tick(_delta):
	Globals.player.process_tick(_delta)
	
	
	
var flag_pos = Vector2(764,564)

var flag_enemy_pos = Vector2(110,970)
#func _ready():
	#pass

func enter_state():
	_spawn_pickup()
	_spawn_timer()
	_spawn_element(position_timer, 2, timer_scene, false)
	
	
	Globals.hud.open_screen(Globals.hud.in_game_screen) 
	Globals.player.reset()
	Globals.game_mode.reset_score()
	Globals.player.connect("player_died", self, "_on_player_died")
	for spawner in Globals.level.spawners:
		print(spawner.time_between_spawns)
		spawner.active = true
		if (spawner.spawn_nme_on_start == true):
			spawner.spawn(spawner.NME_to_spawn)
		spawner.spawn_timer.start(spawner.time_between_spawns)
		spawner.connect("enemy_spawned", self, "on_enemy_spawned")
		if !is_connected("enemy_spawned", self, "on_enemy_spawned"):
			Globals.hud.debug_screen.connect("enemy_spawned", self, "on_enemy_spawned")

func exit_state():
	for spawner in Globals.level.spawners:
		spawner.active = false
		spawner.disconnect("enemy_spawned", self, "on_enemy_spawned")
	Globals.hud.debug_screen.disconnect("enemy_spawned", self, "on_enemy_spawned")
	

	for projectile in get_tree().get_nodes_in_group("projectiles"):
		projectile.queue_free()

	for enemy in _spawned_enemies:
		if is_instance_valid(enemy):
			enemy.destroy()
	_spawned_enemies.clear()
	_kill_count = 0
	
	Globals.player.disconnect("player_died", self, "_on_player_died")
	Globals.player.reset()
	
	
	
	
	destroy_the_object_instance(_pickup)
	destroy_the_object_instance(_timer_)
	destroy_the_object_instance(_safezone)
	
func destroy_the_object_instance(_object):
	if is_instance_valid(_object):
		#_object.queue_free()
		_object = null

func _on_player_died():
		emit_signal("delete_timer")
		Globals.game_mode.transition_to("GameOver")
		Globals.player.reset()
		
		
		
		
		
	
	#_spawn_pickup()

func on_enemy_spawned(enemy):
	_spawned_enemies.append(enemy)
	enemy.connect("enemy_died", self, "on_enemy_death", [], CONNECT_ONESHOT)

func on_enemy_death (enemy, score_amount, _a_position):
	
	_spawned_enemies.erase(enemy)
	_kill_count += 1
	Globals.game_mode.score += 1
	
func _spawn_pickup():
	
	
	#create a random position on screen
	var screensize = get_viewport().size
	
	var padding = 50 #don't spawn pickup on border of screen
	var pos = Vector2.ZERO
	#pos.x = rand_range(padding,screensize.x - padding)	
	#pos.y = rand_range(padding,screensize.y - padding)
	pos.x = flag_pos.x
	pos.y = flag_pos.y
	
	
	_pickup = pickup_scene.instance()
	_pickup.global_position = pos 
	Globals.level.pickups_root.call_deferred("add_child", _pickup)	#cannot directly add child because this code results from a collision event
	_pickup.connect("picked_up_flag", self, "_has_flag")
	
	#cannot directly add child because this code results from a collision event
func _spawn_element(position_of_element, _script_instance, selected_scene, is_pick_up : bool):
	
	var screensize = get_viewport().size
	var pos = Vector2.ZERO
	
func _spawn_timer():
	
	
	#create a random position on screen
	var screensize = get_viewport().size
	
	var padding = 50 #don't spawn pickup on border of screen
	var pos = Vector2.ZERO

	pos.x = 300
	pos.y = 500

	#_timer_.instance()
	#timer_scene.global_position = pos 
	Globals.level.pickups_root.call_deferred("add_child", timer_scene)

	
	
func destroy():
	queue_free()
	
	
	
	
func goal_achieved():
	if player_took_flag:
		print("win")
		
		#INITIATE WIN STATE
		Globals.game_mode.transition_to("GameOver")
		player_took_flag = false
		flag_icon.visible = false
		Globals.hud.in_game_screen.flag_text_label.visible = false
		destroy_the_object_instance(timer_scene)
	
		
		
		
	else:
		print("You're missing something")
	
	
func _has_flag():
	player_took_flag = true
	print("Flag_taken")
	destroy_the_object_instance(_timer_)	
	# .on_flag_obtained(true)
	emit_signal("time_reset")
	spawn_flag_enemy()
	
	
	

	
	if (player_took_flag == true):
		Globals.player.health.current_health += 1
		Globals.hud.in_game_screen.flag_taken_label.visible = true
		Globals.hud.in_game_screen.flag_text_label.visible = true

		Globals.hud.in_game_screen.flag_text_label.visible = true
		
		
		
		
		
		
	
	if (Globals.player.health.current_health > 2):
		Globals.player.health.current_health = 2	
#	emit_signal("health_changed")
#	health.connect("health_chamged", Player.health, "set_current_health", [1])

	
	
		
		
func _flag_dropped():
	#player.connect("player_hit_with_flag", self, "_flag_dropped")
	player_took_flag = false
	Globals.hud.in_game_screen.flag_taken_label.visible = false
	Globals.hud.in_game_screen.flag_text_label.visible = false
	_spawn_pickup()
	print("Flag_dropped")
	Globals.game_mode.reset_score()
	
	#destroy_the_object_instance(_timer_)
	#_spawn_timer()
	Globals.game_mode.play_flag

func enemy_spawned_untraditionally(enemy):
	enemy.connect("enemy_spawned", self, "on_enemy_spawned")

	
func spawn_flag_enemy():
	
	var instance = flag_enemy_scene.instance(5)
	#flag_enemy_scene.get_node("Flag_Enemy").get_children()
	add_child(instance)
	
#	print("enemy spawned")
	
	
