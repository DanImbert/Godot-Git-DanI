class_name Move_Wander
extends Move_Base
#Wandering movement behaviour

export var noise_effect = 100

var noise = OpenSimplexNoise.new()	#Simplex noise is akin to Perlin noise, a random that is "smoothed"
var noise_offset = 0				#stores noise input value

func _ready():
	#set values for the randomness
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 20.0
	noise.persistence = 0.8


func do_rotate_and_get_move_vector(delta):
	noise_offset += noise_effect * delta #Change noise input value
	var noise_value = noise.get_noise_1d(noise_offset)	#transforms noise input into noise output
	
	rotate_owner(noise_value, delta)

	return Vector2.RIGHT.rotated(owner.rotation) * speed * delta



