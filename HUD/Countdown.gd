extends Control


export (int) var minutes = 0
export (int) var seconds = 0
var dsecs = 0

onready var s_display = $s
onready var ms_display = $ms



func _physics_process(delta):
	if seconds > 0 and dsecs <= 0 :
		seconds -= 1
		dsecs = 10	
		
	if minutes > 0 and seconds <= 0	:
		minutes -= 1
		seconds = 60
		
	if seconds <= 10:
		s_display.text = str(seconds)
	else :
		s_display.text = "0"+str(seconds)
		
	if dsecs <= 10:
		ms_display.text = str(seconds)
	else :
		ms_display.text = "0"+str(seconds)	


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	pass # Replace with function body.
