extends Light2D
#simple component that switches lights on and off

onready var switch_timer = $Switch_Timer

func switch_on(duration = 0.1):
	enabled = true
	switch_timer.start(duration)

func _switch_off():
	enabled = false	
	
func _on_Switch_Timer_timeout():
	_switch_off()
