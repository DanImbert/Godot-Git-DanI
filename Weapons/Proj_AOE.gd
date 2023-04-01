extends Proj_Base
class_name Proj_AOE

export var early_collision_disable_time = 0.1 # turn off colliders before lifetime is over by this amount

onready var particles : Particles2D = $Particles2D
onready var deactivation_timer : Timer = $DeactivationTimer
onready var sprite : Sprite = $Sprite

func _ready():
	particles.emitting = true
	particles.lifetime = life_time
	deactivation_timer.start(life_time - early_collision_disable_time) # turn off colliders just before visuals disappear
	
func _on_DeactivationTimer_timeout():
	_hitbox.monitoring = false
	_hitbox.monitorable = false
	sprite.visible = false

func _on_hit_player(player:Player):
	player.take_damage(damage_amount)
