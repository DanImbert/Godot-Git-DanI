extends Camera2D
class_name CameraShake
#Makes the camera randomly shake
#based on https://kidscancode.org/godot_recipes/2d/screen_shake/

export var shake_force = 3	#exposed variable which sets the overall magnitude of the shakes

var _noise_y = 0
var _is_shaking = false
var _amount 
var _shake_duration = 0.1

onready var _noise = OpenSimplexNoise.new()	#A form of 3D smoothed randomness: a "cube-cloud" if you will
onready var _shake_timer = $ShakeTimer

func _ready():
	randomize()
	_noise.seed = randi()
	_noise.period = 4	#sets the amount of variation in the randomness
	_noise.octaves = 2	#sets the amount of variation in the randomness
	
func _process(_delta):
	if _is_shaking:
		_noise_y += 1	#moves 1 step 'up' in the cloud
		offset.x = _amount * _noise.get_noise_2d(_noise.seed*2, _noise_y)
		offset.y = _amount * _noise.get_noise_2d(_noise.seed*3, _noise_y)
	
func shake(a_amount):
	_amount = a_amount * shake_force
	_is_shaking = true
	_shake_timer.start(_shake_duration)

func _reset():
	_is_shaking = false
	offset.x = 0
	offset.y = 0
	
func _on_ShakeTimer_timeout():
	_reset()
