extends Node
#singleton for easy access to important variables.

var game_mode : GameMode setget , get_game_mode # there is not setter for these. Is set when trying to get while it's null
var level_loader : LevelLoader setget , get_level_loader
var level : Level setget , get_level 
var player : Player setget , get_player
var hud : HUD setget , get_hud
var audio : GameAudio setget , get_audio
var camera : CameraShake setget , get_camera
var analytics : Analytics setget , get_analytics
var postFX : PostFX setget , get_postFX
var debug_god_mode  = false #Set god_mode to true here if you want it on when starting
var debug_spawners_on = true # set to false to turn off spawners for testing purposes
var debug_mute_music = false  setget set_debug_mute_music , get_debug_mute_music # set to true to mute music by default

func get_game_mode():
	return get_tree().current_scene.get_node("GameMode")

func get_level_loader():
	return get_tree().current_scene.get_node("LevelLoader")

func get_level():
	return get_level_loader().get_current_level()

func get_player():
	return get_tree().current_scene.get_node("Player")

func get_hud():
	return get_tree().current_scene.get_node("HUD")

func get_audio():
	return get_tree().current_scene.get_node("GameAudio")

func get_camera():
	return get_level().camera

func get_analytics():
	return get_tree().current_scene.get_node("Analytics")

func get_postFX():
	return get_tree().current_scene.get_node("PostFX")

func set_debug_mute_music(_mute):
	debug_mute_music = _mute
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), debug_mute_music)

func get_debug_mute_music():
	return debug_mute_music
