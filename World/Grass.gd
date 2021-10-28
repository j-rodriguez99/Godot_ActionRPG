extends Node2D

const GrassEffect : Resource = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect() -> void: 
	var grassEffectNode : Node2D = GrassEffect.instance()
	get_parent().add_child(grassEffectNode)
	grassEffectNode.global_position = global_position


func damage_taken(_area : Area2D) -> void:
	create_grass_effect()
	queue_free()
