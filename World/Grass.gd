extends Node2D

func create_grass_effect() -> void: 
	var GrassEffect : Resource =  load("res://Effects/GrassEffect.tscn")
	var grassEffectNode : Node2D = GrassEffect.instance() 
	var world : Node = get_tree().current_scene
	world.add_child(grassEffectNode)
	grassEffectNode.global_position = global_position


func _on_Hurtbox_area_entered(_area : Area2D) -> void:
	create_grass_effect()
	queue_free()
