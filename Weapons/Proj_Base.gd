extends KinematicBody2D
class_name Proj_Base
#The base class all projectiles inherit from. Can also be used itself as projectile root node script

export var damage_amount = 1 
export var piercing = false		#when true, destroys object after doing damage
export var life_time = 10.0
export var move_state_path : NodePath
export(PackedScene) var object_to_spawn_on_destroy 

onready var _life_timer = $LifeTimer
onready var _hitbox : Area2D = $Hitbox

var _move_state : Move_Base
var _is_to_be_destroyed = false #flag to ensure destroy code is only run once
var bullet_owner = "" #Name of the object that shot this bullet.

signal bullet_hit_enemy
signal bullet_hit_player(bowner)

func _ready():
	if is_connected("bullet_hit_enemy", Globals.analytics, "on_bullet_hit_enemy") != true:
		connect("bullet_hit_enemy", Globals.analytics, "on_bullet_hit_enemy")
	if is_connected("bullet_hit_player", Globals.analytics, "on_hit_player") != true:
		connect("bullet_hit_player", Globals.analytics, "on_hit_player")
	if (!move_state_path.is_empty()):
		_move_state = get_node(move_state_path)
	_life_timer.start(life_time)

func _physics_process(delta):
	if (_move_state != null):
		move_and_collide(_move_state.do_rotate_and_get_move_vector(delta))

func attempt_destroy():
	# a method other objects call when they try to destroy this object
	_destroy()

func _destroy():
	if (!_is_to_be_destroyed):
		_is_to_be_destroyed = true
		if (object_to_spawn_on_destroy != null):
			var obj = object_to_spawn_on_destroy.instance()
			obj.global_position = global_position
			Globals.level.projectiles_root.call_deferred("add_child", obj)	#This is called from collision signals, and therefore needs to be deferred to next frame
		queue_free()

# Timer calls this with a signal.
func _on_LifeTimer_timeout():
	_destroy()

# Base function that is called by a signal when this object hits another "body" (bodies are not areas!)
func _on_Hitbox_body_entered(body):
	if body is Wall:
		_on_hit_wall(body)
	elif body is Player:
		_on_hit_player(body)
	elif body is NME_Base:
		_on_hit_enemy(body)
	elif body.is_in_group("projectiles") && body != self:
		_on_hit_projectile(body)

func _on_hit_wall(_wall : Wall):	#override in child class to change behaviour 
	_destroy()

func _on_hit_player(player : Player): #override in child class to change behaviour
	player.take_damage(damage_amount)
	emit_signal("bullet_hit_player", bullet_owner)
	_destroy()

func _on_hit_enemy(enemy : NME_Base): #override in child class to change behaviour
	enemy.take_damage(damage_amount)
	emit_signal("bullet_hit_enemy")
	if (!piercing):
		_destroy()

func _on_hit_projectile(projectile): #override in child class to change behaviour
	#will only hit projectiles in DestroyableProjectile layer
	projectile.attempt_destroy()
	if (!piercing):
		_destroy()
