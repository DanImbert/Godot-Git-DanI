extends Control
class_name InGameScreen
#The connection point into the in-game HUD. Connect game signals its functions. 

export var show_weapon_name_duration = 2.0

onready var score_label = $Score/Label_ScoreAmount
onready var health_label = $Health/Label_HealthAmount
onready var weapon_node = $WeaponName
onready var weapon_label = $WeaponName/Label_WeaponName
onready var anim_weapon_label = $WeaponName/Animation_Label
onready var flag_taken_label = $FlagTaken
onready var flag_text_label = $FlagText
onready var fuck_you = $Countdown_Timer





func on_score_changed(value):
	score_label.text = str(value)

func on_health_changed(value):
	health_label.text = str(value)

func on_weapon_changed(weapon_name, position):
	weapon_label.text = weapon_name
	weapon_node.set_global_position(position)
	weapon_label.visible = true
	anim_weapon_label.play("MoveLabel")
	yield(get_tree().create_timer(show_weapon_name_duration), "timeout")
	weapon_label.visible = false
	
func on_flag_taken():
	flag_taken_label.visible = true
	flag_text_label.visible = true

	
	


	



#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
#
#
#
#
#
#func _on_Timer_timeout():
#	countdown_label.text = (str(m)+":"+str(s)+":"+str(ms))	



