extends Control
class_name SelectScreen

func _on_Continue_Button_button_down():
	Globals.game_mode.transition_to("Play")


func _on_SelectScreen_visibility_changed():
	if visible:
		$Continue/Continue_Button.grab_focus()
