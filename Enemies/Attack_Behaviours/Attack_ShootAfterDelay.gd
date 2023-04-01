class_name Attack_ShootAfterDelay
extends Node

export var trigger_duration = 0.1 # amount of time the enemy keeps the trigger pressed
export var delay = 5.0

var weapon : Weap_Base

var _time_since_last_shot = 0.0

func process_tick(delta):
	_time_since_last_shot += delta
	if (_time_since_last_shot > delay):
		_time_since_last_shot -= delay
		shoot()

func shoot():
	weapon.trigger_pressed()
