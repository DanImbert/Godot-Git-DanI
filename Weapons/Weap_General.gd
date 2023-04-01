extends Weap_Base
class_name Weap_Boomerang
#Weapon script has general functionality to build various weapons by creating a scene and editing the inspector
#A burst consists of multiple shots, and a multiburst consists of multiple bursts.

enum EShotType{
	SINGLE,
	BURST,
	MULTI_BURST,
}
export(EShotType) var _shot_type = EShotType.SINGLE
export(EShotType) var _play_sound_type = EShotType.SINGLE

#exposed weapon variables
export var display_name = "weapon name"
export(PackedScene) var projectile
export var time_between_shots = 0.2 	#set to 0 to shoot burst in single frame
export var auto_fire = false			#keep trigger pressed to keep firing
export var num_shots_per_burst = 3		#ignored if EShotType.SINGLE
export var num_bursts = 2				#ignored if EShotType.SINGLE or #ignored if EShotType.BURST
export var time_between_bursts = 1.5 	#time after burst is finished and next burst starts
export var delay_after_bursts = 1.0 	#time after last burst is finished and player can fire again
export var knockback_amount = 50		#amount of knockback displacement
export var knockback_duration = 0.1		#duration of knockback
export var block_mov_amount = 1.0 		#speed multiplier on player. 0 to stop completely
export var block_mov_duration = 0.5 	#time for which player movement is blocked 
export var block_rot_duration = 0.5 	#time for which player rotation is blocked 
export var accuracy = 0.0				#max degrees offset from aim
export(NodePath) var proj_socket		#projectile attaches to this. if not set attaches to level's proj root 

#private variables for internal state
var _shooter : Shooter 					#can be Player or NME_
var _can_shoot = true					#used for internally keeping track of time between shots
var _can_burst = true					#used for internally keeping track of time between bursts
var _can_multi_burst = true				#used for internally keeping track of time between multi-bursts
var _burst_shots_remaining = 0
var _bursts_remaining = 0
onready var _shot_timer = $ShotTimer
onready var _shot_sound = $ShotSound
var _burst_timer 
var _multi_burst_timer

signal shot_fired 						#Use this to connect to the moment the weapon is fired
signal burst_start						#Use this to connect to the moment the burst is started
signal burst_complete					#Use this to connect to the moment the burst is completed

func initialise(shooter):
	_shooter = shooter
	match _shot_type:
		EShotType.BURST:
			_burst_timer = $BurstTimer
			assert(_burst_timer != null, "Burst type weapon requires BurstTimer node")
		EShotType.MULTI_BURST:
			_burst_timer = $BurstTimer
			_multi_burst_timer = $MultiBurstTimer
			assert(_burst_timer != null, "Burst type weapon requires BurstTimer node")
			assert(_multi_burst_timer != null, "Burst type weapon requires MultiBurstTimer node")

func trigger_pressed():
	match _shot_type:
		EShotType.SINGLE:
			if (_can_shoot):
				_do_shot()
		EShotType.BURST:
			if (_can_burst):
				_do_burst()
				emit_signal("burst_start")
		EShotType.MULTI_BURST:
			if (_can_multi_burst):
				_can_multi_burst = false
				_multi_burst_timer.start(time_between_bursts * num_bursts + delay_after_bursts)
				_do_burst(num_bursts)
				if _play_sound_type == EShotType.MULTI_BURST:
					_shot_sound.play_sound()

func trigger_released():
	pass

func _spawn_projectile():
	#create the actual projectile and add it to the level
	var p = projectile.instance()
	if proj_socket:
		get_node(proj_socket).add_child(p)
	else:
		Globals.level.projectiles_root.add_child(p)
	p.global_position = global_position
	p.global_rotation_degrees = global_rotation_degrees + rand_range(-accuracy, accuracy)
	p.bullet_owner = _shooter.name
	
	if _play_sound_type == EShotType.SINGLE:
		_shot_sound.play_sound()

func _do_shot(a_num_shots = 1):
	if (time_between_shots == 0):
		#if time between shots is set to 0, shoot all shots this current frame
		for i in a_num_shots:
			_spawn_projectile()
	else:
		#shoot one projectile from the current burst
		_spawn_projectile()
		_burst_shots_remaining = a_num_shots - 1
		if (_burst_shots_remaining == 0):
			emit_signal("burst_complete")
		_can_shoot = false
		_shot_timer.start(time_between_shots)
	
	emit_signal("shot_fired")
	_shooter.apply_knockback(knockback_amount, knockback_duration)
	
	if _shot_type == EShotType.SINGLE:
		_shooter.block_movement(block_mov_amount, block_mov_duration)
		_shooter.block_rotation(block_rot_duration)

func _do_burst(a_num_bursts = 1):
	_do_shot(num_shots_per_burst)
	_can_burst = false
	_bursts_remaining = a_num_bursts - 1
	_burst_timer.start(num_shots_per_burst * time_between_shots + time_between_bursts)
	
	_shooter.block_movement(block_mov_amount, block_mov_duration)
	_shooter.block_rotation(block_rot_duration)
	if _play_sound_type == EShotType.BURST:
			_shot_sound.play_sound()

func _on_ShotTimer_timeout():
	_can_shoot = true
	if _burst_shots_remaining > 0:
		_do_shot(_burst_shots_remaining)
		return
	match _shot_type:
		EShotType.SINGLE:
			if  auto_fire and _shooter.fire_input_pressed:
				_do_shot()

func _on_BurstTimer_timeout():
	_can_burst = true
	
	match _shot_type:
		EShotType.BURST:
			if  auto_fire and _shooter.fire_input_pressed:
				_do_burst()
		EShotType.MULTI_BURST:
			if (_bursts_remaining > 0):
				_do_burst(_bursts_remaining)

func _on_MultiBurstTimer_timeout():
	_can_multi_burst = true
	if auto_fire and _shooter.fire_input_pressed:
		_do_burst(num_bursts)
