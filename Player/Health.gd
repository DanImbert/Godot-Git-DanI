extends Node
class_name Health
#A component that can be reused for anything that needs health. 

export var max_health = 5 setget set_max_health

var current_health = 0 setget set_current_health, get_current_health

signal health_changed(current_health)
signal health_depleted

func set_max_health(value):
	max_health = value
	set_full_health()

func set_current_health(value):
	if Globals.debug_god_mode and owner.is_in_group("player"):	
		return
	if current_health == value:
		return

	current_health = value
	emit_signal("health_changed", current_health)
	if current_health <= 0:
		emit_signal("health_depleted")
		
	
		
		

func get_current_health():
	return current_health

func set_full_health():
	self.current_health = max_health
