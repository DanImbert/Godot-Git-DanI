extends NME_Base
class_name NME_Ranger

export var attack_duration = 3.0

var _is_moving = true
var _is_attacking = false

onready var _attack_timer = $AttackTimer
onready var _rotate_state = $Move_RotateOnly

signal attack_finished

func _ready():
	_attack_state.weapon = _weapon

func _physics_process(delta):
	if _is_moving:
		move_and_slide(_move_state.do_rotate_and_get_move_vector(delta))
	if _is_attacking:
		_rotate_state.do_rotate_and_get_move_vector(delta)
		_attack_state.process_tick(delta)

func _attack_and_resume_movement():
	_is_moving = false
	_start_attack()
	_attack_timer.start(attack_duration)
	yield(_attack_timer, "timeout")
	_end_attack()
	_is_moving = true

func _start_attack():
	_is_attacking = true

func _end_attack():
	_is_attacking = false
	emit_signal("attack_finished")

func _on_Move_FollowTarget_target_distance_reached():
	_attack_and_resume_movement()

