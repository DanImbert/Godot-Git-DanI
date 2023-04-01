extends Node
class_name GameMode
# GameMode logic is contained in this node's children with a GameState script. No other children should be present.

#preload playmode scripts, add to array and Enums.EPlayModes in the same order 
const play_survival = preload("res://Game/GameStates/GameState_Play_Survival.gd")
const play_cratebox = preload("res://Game/GameStates/GameState_Play_Cratebox.gd")
const play_flag = preload("res://Game/GameStates/GameState_Play_Flag.gd")
var play_modes = [play_flag, play_cratebox, play_survival]

export var initial_state_path := NodePath() #select the child node of gamemode that is the initial state
export(Enums.EPlayModes) var initial_play_mode #select the initial play mode
export(Enums.EDifficulty) var difficulty = Enums.EDifficulty.NORMAL

var score = 0 setget set_score #score persists over different GameStates so is stored here
var _current_state : GameState_Base
onready var _play_state = $Play

signal score_changed(total_score)
signal state_changed(new_state)

func _ready():
	connect("score_changed", Globals.hud.in_game_screen, "on_score_changed")
	connect("state_changed", Globals.analytics, "on_state_changed")
	set_play_mode(initial_play_mode)
	_current_state = get_node(initial_state_path)
	_current_state.enter_state()
	emit_signal("state_changed", initial_state_path) #signal state change so listeners can respond with their logic at game start.

func _physics_process(delta):
	#process_tick sends a tick down the chain of gamestate -> player, etc. this needs to run on 
	#physics_process and not _process as it will down the line call player movement functions
	_current_state.process_tick(delta)

func set_play_mode(play_mode = Enums.EPlayModes.SURVIVAL):
	# Catches the debug swapping a state that is currently in use.
	var swappedcurrent = false
	if current_state_is_play():
		_play_state.exit_state()
		swappedcurrent = true
	
	# Sets the script to the correct one.
	_play_state.set_script(play_modes[play_mode])
	_play_state._ready() # Calls ready to avoid missing variables.
	
	# calls ready again and starts the game state if the script was changed while the game was running.
	if (swappedcurrent):
			_play_state.enter_state()

func set_difficulty(a_difficulty = Enums.EDifficulty.HARD):
		difficulty = a_difficulty
		if current_state_is_play():		#difficulty can be changed while playing through debug
			_play_state.set_difficulty(difficulty)

func current_state_is_play():
	# check if the current state is play
	return _current_state == _play_state && is_instance_valid(_current_state)

func set_score(value):
	var old_score = score
	score = value
	if (old_score != score):
		emit_signal("score_changed", score)

func reset_score():
	self.score = 0
	
	

func transition_to(target_state_name: String): 
	#transitions to a specific gamestate with a dictionary of arguments 
	if (!has_node(target_state_name)):
		push_warning("GameMode.gd - transition_to() failed to find node named: " + str(target_state_name))
		return
	
	_current_state.exit_state()
	_current_state = get_node(target_state_name)
	_current_state.enter_state()
	
	emit_signal("state_changed", target_state_name)
