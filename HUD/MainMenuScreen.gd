extends Control
class_name MainMenuScreen
#The connection point into the Main Menu. Listens to events in its children

func _ready():
	yield (get_tree().create_timer(0.1), "timeout") #BUG? Strange that I need this delay to get grab focus to work
	$Continue/Continue_Button.grab_focus()
	
func _on_Continue_Button_button_down():
	var screen = Globals.hud.select_screen
	Globals.hud.open_screen(screen)
