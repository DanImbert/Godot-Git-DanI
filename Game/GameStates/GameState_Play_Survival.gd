extends GameState_Base
class_name GameState_Play_Survival
#Core gamemode logic for the Survival gamemode. 
#spawning a pickup after a number of kills, and then give the player a random weapon.

var _spawned_enemies = []
var _kill_count = 0

# Called once when the state is entered.
func enter_state():
	Globals.hud.open_screen(Globals.hud.in_game_screen)
	Globals.player.connect("player_died", self, "_on_player_died")
	
	for spawner in Globals.level.spawners:
		spawner.active = true
		spawner.connect("enemy_spawned", self, "on_enemy_spawned")
	Globals.hud.debug_screen.connect("enemy_spawned", self, "on_enemy_spawned")
	
	Globals.player.reset()
	_game_mode.reset_score()

# Called every frame that's generated.
func process_tick(_delta):
	Globals.player.process_tick(_delta)

# Called once when the state is exited.
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
	_kill_count = 0

# Keep track of all enemies.
func on_enemy_spawned(enemy):
	_spawned_enemies.append(enemy)
	enemy.connect("enemy_died", self, "on_enemy_death", [], CONNECT_ONESHOT) # Connect "on death" and make it only fire once by setting it to ONESHOT

# Increase our score when an enemy dies.
func on_enemy_death(enemy, _score_amount, _a_position):
	_spawned_enemies.erase(enemy)
	_kill_count += 1
	_game_mode.score += 1

# The game ends when the player dies.
func _on_player_died():
	_game_mode.transition_to("GameOver")
