extends NME_Base
class_name NME_Liner

func initialise(args := {}):
	#Liner enemy requires a rail and is initialised by the Spawnpoint
	_move_state.set_rail(args["rail"])
	_attack_state.weapon = _weapon

func _physics_process(delta):
	position = _move_state.get_new_position(delta)
	_attack_state.process_tick(delta)
