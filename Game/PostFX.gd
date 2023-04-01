extends WorldEnvironment
class_name PostFX
# https://www.youtube.com/watch?v=0GToqNid43U

export var player_hit_exposure = 4
export var player_hit_exposure_duration = 0.25

onready var player_hit_tween = $PlayerHitTween

func play_player_hitFX():
	var original_exposure = environment.tonemap_exposure
	environment.tonemap_exposure = player_hit_exposure
	player_hit_tween.interpolate_property(environment, "tonemap_exposure", 
		environment.tonemap_exposure, original_exposure, player_hit_exposure_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	player_hit_tween.start()
