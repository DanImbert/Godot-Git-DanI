extends GameState_Base
class_name GameState_MainMenu
# The main menu game state

func enter_state():
	Globals.hud.open_screen(Globals.hud.main_menu_screen)

func process_tick(_delta):
#	if Input.is_action_just_pressed("fire"):
#		_game_mode.transition_to("Play")
	pass
