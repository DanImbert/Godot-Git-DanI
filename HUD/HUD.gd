extends CanvasLayer
class_name HUD
#This is the central connection point to the HUD. It allows you to go into specific screens. The screens themselves should not be called directly, but respond to events

onready var main_menu_screen : MainMenuScreen = $MainMenuScreen
onready var select_screen : SelectScreen = $SelectScreen
onready var in_game_screen : InGameScreen = $InGameScreen
onready var score_screen : ScoreScreen = $ScoreScreen
onready var debug_screen : DebugScreen = $DebugScreen

var _debug_paused = false

func _process(_delta):
	if Input.is_action_just_pressed("DEBUG_menu"):
		if (!_debug_paused):
			Globals.hud.open_screen(Globals.hud.debug_screen)
		else:
			Globals.hud.open_screen(Globals.hud.in_game_screen)
		_debug_paused = !_debug_paused
		get_tree().paused = _debug_paused


func _unhandled_input(event):
	if (event.is_action_pressed("exit")):
		get_tree().quit()
		get_tree().set_input_as_handled()


func open_screen(screen):
	main_menu_screen.visible = false
	select_screen.visible = false
	in_game_screen.visible = false
	score_screen.visible = false
	debug_screen.visible = false
	
	match(screen):
		main_menu_screen:
			main_menu_screen.visible = true
		select_screen:
				select_screen.visible = true
		in_game_screen:
			in_game_screen.visible = true
		score_screen:
			score_screen.visible = true
		debug_screen:
			debug_screen.visible = true
