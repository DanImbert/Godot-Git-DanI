extends Node2D


class_name Countdown_Timer

var time_interval = 1
var time_left : int
#var time_reset = false 
export var timer_span : int = 20

onready var timer = $CTimer


onready var time_display = $Display
onready var play_flag_node = load("res://Game/GameStates/GameState_Play_Flag.gd")




func _ready():
	
	#Globals.game_mode.connect("time_reset", self, "reset_timer")
	#Globals.game_mode.connect("delete_timer", self, "delete_timer")
	begin_timer()
	
	
		
		
		
		

func begin_timer():
	
	timer.set_wait_time(time_interval)
	print("tic-tac")
	time_left = timer_span
	time_display.text = str(time_left)
	
	timer.start()
	
	

func reset_timer():
	timer.stop()
	time_left = timer_span
	print("time restablished")
	#Timer.reset()

func delete_timer():
	print("timer gone")
	queue_free()






	


func _on_CTimer_timeout():
	if time_left <= timer_span && time_left >= 0:
		time_left -= 1
		time_display.text = str(time_left) 
	
	
	if time_left == 0:
		Globals.game_mode.transition_to("GameOver")
		print("TIME OUT! Game over!")
		timer.stop()
		queue_free()

