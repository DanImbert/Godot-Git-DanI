extends Shooter
class_name Player
#The player's class. Takes care of input, movement and rotation, and player state.

#movement variables
export(int) var acceleration = 1000
export(int) var max_speed = 250
export(int) var friction = 600		
#export(int, 1, 100) var jump_count = 2

export(float) var invulnerable_duration_on_hit = 0.4 
export(Enums.EPlayerWeaponTypes) var initial_weapon_type		#set starting weapon here
export var spotlight_duration = 0.5	# duration of spotlight when weapon is fired
export(Color) var ability_unavailable_color = Color(0.5,0.5,1)

var _movement_multiplier = 1.0 	#used for blocking / slowing movement
var _can_rotate = true 	#used for blocking rotation
var _velocity = Vector2.ZERO	#used to store residual velocity over frames
var _knockback_offset = Vector2.ZERO #Used to store residual knockback
var _invulnerable 	#used to know if player is invulnerable. do not set directly but use set_invulnerable()
var _player_controller_type = Enums.EPlayerControllerType.GAMEPAD #keeps track whether player is currently aiming with Gamepad or Mouse
var _mouse_position = Vector2.ZERO#store mouse position to see if player is using mouse

var move_input = Vector2.ZERO #store last move input
var weapon_type
var weapon	#used to store actual weapon object
var damage_amount = 1	#hitbox uses this damage amount when you collide with an enemy
var spring = - 600
#var forced_jump = false
#var jump_left = jump_count
#var jump = false

#various nodes in the player scene are directly references. For instance, $NodePath is get_node("NodePath")
onready var sprite : CanvasItem = $Sprite
onready var health : Health = $Health
onready var weapon_socket = $WeaponSocket
onready var ability = $Ability
onready var block_movement_timer = $BlockMovementTimer
onready var block_rotation_timer = $BlockRotationTimer
onready var invulnerability_timer = $InvulnerabilityTimer
onready var hit_effect = $HitEffect
onready var hit_particles = $HitParticles
onready var spotlight = $SpotLight
onready var knockback_tween = $KnockbackTween
onready var death_sound = $DeathSound
onready var hit_sound = $HitSound
onready var flag_sound = $FlagSound

signal player_died
signal weapon_changed(display_name, position)
signal player_hit_with_flag

func _ready():
	health.connect("health_changed", Globals.hud.in_game_screen, "on_health_changed")
	connect("weapon_changed", Globals.analytics, "on_weapon_changed")
	connect("weapon_changed", Globals.hud.in_game_screen, "on_weapon_changed")
	reset()

func reset():
	#set player to initial state
	health.set_full_health()
	set_weapon(initial_weapon_type)
	_velocity = Vector2.ZERO
	fire_input_pressed = false
	Globals.player.global_position = Vector2 (1554,146)
	

# Called from the game states. CTRL + SHIFT + F to find all the places!
func process_tick(delta):
	#called from _physics_process() by GameMode
	_handle_move_input(delta)
	_handle_rotation_input()
	_handle_ability_input()
	_handle_fire_input()
	_mouse_position = get_global_mouse_position()

func _handle_move_input(delta):
	#read move input and store in vector. normalize if larger than 1
	move_input = Vector2.ZERO
	move_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if move_input.length() > 1:
		move_input = move_input.normalized()
		#var collider = $RayCast2D.get_collider()
	
	#if stick is used, accellerate towards it, otherwise use friction to brake
	if move_input != Vector2.ZERO:
		_velocity = _velocity.move_toward(move_input * max_speed, acceleration * delta)
		_velocity *= _movement_multiplier #take any external movement modifier into account
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, friction * delta)
	
	#do actual movement
	move_and_slide(_knockback_offset)
	_velocity = move_and_slide(_velocity) 

func _handle_rotation_input():
	#checks whether gamepad or mouse is used as there is no menu options for it. both work now.	
	if _can_rotate:
		var rot_input = Vector2.ZERO
		
		#Check gamepad aim
		rot_input.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
		rot_input.y = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
		
		#set controller mode to gamepad or mouse
		if rot_input.length() > 0:
			_player_controller_type = Enums.EPlayerControllerType.GAMEPAD #player used right stick so that is used 
		elif (get_global_mouse_position() - _mouse_position).length() > 5:	#100 is used as value so it doesn't respond to simple mouse jitter
			_player_controller_type = Enums.EPlayerControllerType.MOUSE #set to mouse mode if no gamepad is used AND mouse moved significantly

		#Do actual rotation based on current control mode
		match _player_controller_type:
			Enums.EPlayerControllerType.GAMEPAD:
				look_at(global_position + rot_input)
			Enums.EPlayerControllerType.MOUSE:
				 look_at(get_global_mouse_position())

func _handle_fire_input():
	#relay fire input to weapon
	if (Input.is_action_pressed("fire")):
		if (!fire_input_pressed):
			fire_input_pressed = true
			weapon.trigger_pressed()
	else:
		if (fire_input_pressed):
			weapon.trigger_released()
			fire_input_pressed = false

func _handle_ability_input():
	if (Input.is_action_pressed("ability")):
		ability.trigger_ability()

func move_to(direction):
	#allows external objects (like dodge ability) to directly move the player, regardless of multipliers or input
	move_and_slide(direction)

func set_weapon(new_weapon_type):
	#used to spawn and set a new weapon
	#remove current weapon
	if is_instance_valid(weapon):
		weapon.queue_free()
	
	# spawn new weapon and add as child
	weapon_type = new_weapon_type
	weapon = WeaponList.GetPreloadedWeapon(new_weapon_type).instance()
	weapon_socket.add_child(weapon)
	weapon.initialise(self)
	weapon.connect("shot_fired", self, "switch_ON_spotlight")
	weapon.connect("shot_fired", Globals.analytics, "on_weapon_fired")
	emit_signal("weapon_changed", weapon.display_name, global_position)

func cycle_weapon():
	set_weapon(WeaponList.GetNextWeaponType(weapon_type))

func set_random_weapon():
	set_weapon(WeaponList.GetRandomWeaponType(weapon_type))

func take_damage(damage_taken : int):
	if !_invulnerable:
		hit_particles.play_effect(0.5)
		hit_sound.play_sound()
		Globals.postFX.play_player_hitFX() 
		Globals.camera.shake(2)
		
		health.current_health -= damage_taken
		set_invulnerable(true, invulnerable_duration_on_hit)
		#emit_signal("Player_hit_with_flag")

	if Globals.game_mode._current_state.name != "GameOver": 
		if Globals.game_mode._current_state.player_took_flag != null:
			Globals.game_mode._current_state._flag_dropped()
			flag_sound.play()
			
#

func set_invulnerable(value, duration):
	#use this to set player invulnerable. This is separate from the debug god_mode.
	_invulnerable = value
	if value == true:
		hit_effect.play("Blink")
		if (invulnerability_timer.time_left < duration):	#If invulnerability starts while it's already started, use the longest duration
			invulnerability_timer.start(duration)
	else:
		hit_effect.stop()

func apply_knockback(amount, duration):
	#use Tween to apply the knockback over duration
	var knockback_direction = -Utils.radian_to_vector2(global_rotation)
	knockback_direction *= amount 
	knockback_tween.interpolate_property(self, "_knockback_offset",
		knockback_direction, Vector2.ZERO, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	knockback_tween.start()

func block_movement(multiplier, duration):
	if (duration > 0):
		_movement_multiplier = multiplier
		block_movement_timer.start(duration)

func block_rotation(duration):
	if (duration > 0):
		_can_rotate = false
		block_rotation_timer.start(duration)

func switch_ON_spotlight():
	spotlight.switch_on(spotlight_duration)

func _on_BlockMovementTimer_timeout():
	_movement_multiplier = 1.0

func _on_BlockRotationTimer_timeout():
	_can_rotate = true

func _on_Health_health_depleted():
	death_sound.play_sound()
	emit_signal("player_died")

func _on_InvulnerabilityTimer_timeout():
	set_invulnerable(false, 0.0)

func _on_Hitbox_body_entered(_body):
	pass # Replace with logic if the player runs into anything
	

func _on_Ability_ability_available():
	sprite.self_modulate = Color.white

func _on_Ability_ability_started(duration):
	sprite.self_modulate = ability_unavailable_color
	



func _on_BounceArea_body_entered(body):
	_velocity.y = spring
