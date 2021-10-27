extends Area2D


func _ready(): 
	var  parent = get_parent()
	assert(connect("body_entered", parent, "player_identified")==0)
