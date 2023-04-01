extends GameState_Base
class_name GameState_GameOver
#Game Over state shows the score and after a delay of 2 seconds, allows the player to continue by pressing fire

const _delay = 2.0
var _allow_continue = false;	#value is set to true by screscreen when it is done animating


signal game_over(score)

func _ready():
	Globals.hud.score_screen.connect("score_screen_finished", self , "allow_continue")
	connect("game_over", Globals.hud.score_screen, "on_game_over")
	connect("game_over", Globals.analytics, "on_game_over")

func enter_state():
	emit_signal("game_over", _game_mode.score)
	Globals.hud.open_screen(Globals.hud.score_screen)
	_allow_continue = false
	
	
	
	
func process_tick(_delta):
	if _allow_continue and Input.is_action_pressed("fire"):
		_game_mode.transition_to("Play")
		
		

func allow_continue():
	_allow_continue = true
