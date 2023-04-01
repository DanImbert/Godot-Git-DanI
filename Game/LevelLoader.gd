tool #this code runs in editor
extends Node2D
class_name LevelLoader
#This class loads and destroys levels.
#Add variable for the path, add to _levels and to Enums.ELevels in the same order. Also set enum on level itself

export(Enums.ELevels) var initial_level = Enums.ELevels.MAIN setget set_initial_level  #set initial level here

const main = preload("res://Levels/Main.tscn")
const gym_rene = preload("res://Levels/Gym_Rene.tscn")
const gym_dan = preload("res://Levels/GYM_Dan.tscn")

const _levels = [main, gym_rene, gym_dan]

var current_level : Level

func _ready():
	load_level(initial_level)

func set_initial_level(value):
	initial_level = value
	if Engine.editor_hint: #Only load the level when you're in the editor.
		load_level(initial_level)

func get_current_level():
	return current_level

func load_level(level_to_load = Enums.ELevels):
	if Engine.editor_hint: # Use a different technique if we're loading a level while in the editor
		editor_load_level(level_to_load)
		return
	
	# Exit the current game state if we are switching levels while playing
	if Globals.game_mode.current_state_is_play():
		Globals.game_mode._current_state.exit_state()
	
	if is_instance_valid(current_level): 
		current_level.destroy() #If we are in game we let the level destroy itself
	
	current_level = _levels[level_to_load].instance()
	add_child(current_level)
	
	# Put the player at the correct spot in the level.
	if (current_level.has_node("PlayerSpawn")):
		Globals.player.position = current_level.get_node("PlayerSpawn").position
	
	# Reenter the game state when we are done loading.
	if Globals.game_mode.current_state_is_play():
		Globals.game_mode._current_state.enter_state()

func editor_load_level(level_to_load = Enums.ELevels):
	if is_instance_valid(current_level):
		current_level.queue_free() #If we are in editor we destroy current level from here
	
	current_level = _levels[level_to_load].instance()
	add_child(current_level)
	
	# Put the player at the correct spot in the level.
	if (current_level.has_node("PlayerSpawn")): # We use get_tree() here because globals doesn't exist unless we're in game.
		get_tree().get_nodes_in_group("player")[0].global_position = current_level.get_node("PlayerSpawn").global_position

func cycle_level():
	load_level(GetNextLevel())

func GetNextLevel():
	var level_number = int(current_level.level_enum) + 1
	level_number %= _levels.size()
	return level_number


