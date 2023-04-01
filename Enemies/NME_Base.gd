extends Shooter
class_name NME_Base
#Base class for all enemies. Enemy scene requires a $Health component.

export var score = 1
export var damage_amount = 1
export var move_state_path : NodePath
export var attack_state_path : NodePath
export var weapon_path : NodePath
export var death_sound : AudioStream

onready var health = $Health
onready var hit_effect = $HitEffect

var _move_state : Move_Base
var _attack_state 
var _weapon : Weap_Base

signal enemy_died(enemy, score, location)

func _ready():
	connect("enemy_died", Globals.analytics, "on_enemy_death", [], CONNECT_ONESHOT)
	_move_state = get_node(move_state_path)
	assert(is_instance_valid(_move_state),  "This unit does not have a move state assigned in the root node! Please do so before running the game.")
	if (!attack_state_path.is_empty()):
		_attack_state = get_node(attack_state_path)
		_weapon = get_node(weapon_path)
		_weapon.initialise(self)

func initialise(_args := {}):
	#use this function to set initialise values in the enemy such as: initialise({"rail", my_rail}
	pass

func take_damage(damage_taken : int):
	health.current_health -= damage_taken
	hit_effect.play("Blink")

func destroy():
	Globals.audio.play_sound_at_location(death_sound, global_position, "Enemies")
	call_deferred("free")

func _on_Health_health_depleted():
	emit_signal("enemy_died", self, score, global_position)
	destroy()

func _on_Hitbox_body_entered(body):
	if body is Player:
		_on_hit_player(body)

func _on_hit_player(player : Player):
	Globals.analytics.on_hit_player(self.name)
	player.take_damage(damage_amount)
	self.take_damage(health.current_health) # Hurt myself for my remaining health.
