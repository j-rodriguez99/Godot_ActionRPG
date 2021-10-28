extends Area2D

const Hit_effect = preload("res://Effects/HitEffect.tscn") 

func _ready():
	assert(connect("area_entered", get_parent(), "damage_taken")==0)

func show_hit(): 
		var hit_effect_node = Hit_effect.instance()
		get_tree().current_scene.add_child(hit_effect_node)
		hit_effect_node.global_position = global_position
