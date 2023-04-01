extends PathFollow2D
#This component allows a node to automatically follow a path

export var speed = 50

func _process(delta):
	offset += delta * speed
