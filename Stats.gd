extends Node

export(int) var max_health : int = 1
onready var health : int = max_health setget health_changed

signal death

func health_changed(new_health): 
	health = new_health

	if health <= 0: 
		emit_signal("death")


