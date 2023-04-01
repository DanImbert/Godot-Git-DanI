extends Node2D
class_name Ablity_Dodge

export var dodge_speed = 50000
export var dodge_duration = 0.4
export var charge_duration = 5.0

var _player
var _can_dodge = true
var _ability_active = false
var _direction  = Vector2.UP

signal ability_started(duration)
signal ability_available

func _ready():
	_player = get_parent()
	connect("ability_started", Globals.analytics, "on_ability_used")

func _physics_process(delta):
	if _ability_active:
		_player.move_to(_direction * dodge_speed * delta)

func trigger_ability():
	if _can_dodge:
		_can_dodge = false
		_ability_active = true
		_player.block_movement(0, dodge_duration)
		_player.block_rotation(dodge_duration)
		_player.set_invulnerable(true, dodge_duration)
		if _player.move_input.length() > 0:
			_direction = _player.move_input
		else:
			 _direction = Utils.radian_to_vector2(_player.rotation)
		emit_signal("ability_started", dodge_duration)
		yield(get_tree().create_timer(dodge_duration), "timeout")	#yield does not continue in current frame, but resumes code here after timer is done
		_ability_active = false
		yield(get_tree().create_timer(charge_duration), "timeout")
		_can_dodge = true
		emit_signal("ability_available")
	
