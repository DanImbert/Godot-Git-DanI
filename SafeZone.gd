extends Area2D
class_name SafeZone



onready var audio =  $AudioStreamPlayer2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

#onready var body = get_parent().get_node("KinematicBody2D")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

	





	



func _on_SafeZone_body_entered(body):
	
	if body is Player:
		Globals.game_mode._current_state.goal_achieved()
		print("player has entered safezone")
		#audio.play()
