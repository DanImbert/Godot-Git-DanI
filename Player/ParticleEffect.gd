extends CPUParticles2D

onready var effect_timer = $EffectTimer

func play_effect(duration ):
	emitting = true
	effect_timer.start(duration)

func _on_Timer_timeout():
	emitting = false
