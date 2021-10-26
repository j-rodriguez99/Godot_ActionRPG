extends Area2D

const Hit_effect = preload("res://Effects/HitEffect.tscn") 

export(bool) var show_hit = true

func _on_Hurtbox_area_entered(_area):
	if show_hit: 
		var hit_effect_node = Hit_effect.instance()
		get_tree().current_scene.add_child(hit_effect_node)
		hit_effect_node.global_position = global_position
