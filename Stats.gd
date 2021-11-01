extends Node

export(int) var max_health : int = 1
onready var health : int = max_health setget health_changed

signal death
signal health_changed

func health_changed(new_health): 
	health = new_health
	
	
	emit_signal("health_changed", health)

	if health <= 0: 
		emit_signal("death")
	


