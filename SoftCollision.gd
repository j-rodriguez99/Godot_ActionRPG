extends Area2D



func _ready():
	pass

func is_colliding(): 
	var areas = get_overlapping_areas()
	return areas.size() > 0

func get_push_vector(): 
	var area = get_overlapping_areas()
	return area[0].global_position.direction_to(global_position)
