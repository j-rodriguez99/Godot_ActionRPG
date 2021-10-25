extends AnimatedSprite

func _ready() -> void:
	play("Animate")
	assert(connect("animation_finished", self, "_on_animation_finished") == 0)


func _on_animation_finished() -> void:
	queue_free()
	
