extends Area2D
class_name FlagPickup

export var p_sound : AudioStream

signal picked_up_flag





	
	


func _on_FlagPickup_body_entered(body):
	
	
	
	Globals.audio.play_sound_at_location(p_sound, global_position, "Pickups")
	Globals.analytics.add_message("picked up score" + str(position))
	#emit_signal("picked_up")
	
	
	
	

	if body is Player:
		#CALL TO THE GAMEMODE TO TOGGLE THE HAS PICK UP FUNCTION
		emit_signal("picked_up_flag")
		
		
		#DISPLAY AN ICON ON HUD
		
		#HIDE THE OBJECT
		destroy()
		
		
func destroy():
	queue_free()
	


	
	
	









	
	


