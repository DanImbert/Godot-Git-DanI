extends Node
class_name GameState_Base
#The base class for all GameStates, basically a set of functions all gamestates will implement

var _game_mode

func _ready():
	_game_mode = Globals.game_mode

# Virtual functions. If you add content here you need to call the super from the derived class.
func process_tick(_delta: float):
	pass

func enter_state():
	set_difficulty(_game_mode.difficulty)
	

func exit_state():
	pass

func set_difficulty(a_difficulty = Enums.EDifficulty.NORMAL):
	pass

