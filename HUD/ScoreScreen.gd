extends Control
class_name ScoreScreen
#The connection point into the ScoreScreen. Connect game signals its functions. 

onready var score_label = $Score/Label_ScoreAmount
onready var score_node = $Score
onready var continue_node = $Continue
onready var score_tween = $ScoreTween

signal score_screen_finished

func on_game_over(score):
	continue_node.visible = false
	score_label.text = str(score)
	
	#store original values
	var position_y = score_node.rect_global_position.y
	var scale = score_node.rect_scale

	#let tween do it's animations
	score_tween.interpolate_property(score_node, "rect_scale", #bring in scale from 0
		Vector2.ZERO, scale, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	score_tween.interpolate_property(score_node, "rect_position:y", #bring in score_node from the top
		0, position_y , 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	score_tween.start()
	
func on_win(score):
	continue_node.visible = false
	score_label.text = str(score)
	
	#store original values
	var position_y = score_node.rect_global_position.y
	var scale = score_node.rect_scale

	#let tween do it's animations
	score_tween.interpolate_property(score_node, "rect_scale", #bring in scale from 0
		Vector2.ZERO, scale, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	score_tween.interpolate_property(score_node, "rect_position:y", #bring in score_node from the top
		0, position_y , 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	score_tween.start()

func _on_ScoreTween_tween_all_completed():
	continue_node.visible = true
	emit_signal("score_screen_finished")


