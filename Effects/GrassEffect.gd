extends Node2D


onready var animated_sprite : AnimatedSprite = $AnimatedSprite

func _ready() -> void:
	animated_sprite.play("Animate")


func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()
