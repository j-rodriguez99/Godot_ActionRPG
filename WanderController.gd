extends Node2D

var starting_location 
var target_location 

func _ready():
	starting_location = global_position
	set_target_location()

func set_target_location(): 
	target_location = Vector2(rand_range(-32,32) + starting_location.x, rand_range(-32,32) + starting_location.y)
	
func direction(): 
	return global_position.direction_to(target_location)
	
func state_shuffle(states_array: Array):
	states_array.shuffle()
	return states_array.pop_front()
	

