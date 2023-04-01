extends Area2D

signal on_body_bounced

func _process(_delta):
	for body in get_overlapping_bodies():
		if body.has_method("force_jump"):
			if body.force_jump():
				emit_signal("on_body_bounced")

func _on_BounceArea_body_entered(body):
	if body is Player:
		if body.has_method("force_jump"):
			if body.force_jump():
				emit_signal("on_body_bounced")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
