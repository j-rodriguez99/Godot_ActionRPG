extends KinematicBody2D

var knockback : Vector2 = Vector2(0,1)
onready var stats : Node = $Stats
const Bat_death_effect = preload("res://Effects/BatDeathEffect.tscn")

var player
var player_direction 
var velocity = Vector2.ZERO
var  state = IDLE

const MAX_SPEED = 95
const DECELERATION = 100
const ACCELERATION = 130

enum {
	IDLE,
	WANDER,
	CHASE
}

func _ready():
	var animated_sprite = $AnimatedSprite
	animated_sprite.playing = true
	
func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, delta * DECELERATION)
	knockback = move_and_slide(knockback)
	
	match state: 
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, delta * DECELERATION)
		WANDER: 
			pass
		CHASE:
			player_direction = global_position.direction_to(player.global_position)
			velocity = velocity.move_toward(MAX_SPEED * player_direction, delta * ACCELERATION)
	
	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	knockback = area.knockback_vector * 110
	
	stats.health -= area.damage

func _on_Stats_death() -> void:
	queue_free()
	create_death_effect()
	
func create_death_effect(): 
	var bat_death_node = Bat_death_effect.instance()
	get_parent().add_child(bat_death_node)
	bat_death_node.global_position = global_position

func player_identified(body): 
	player = body
	state = CHASE
	
	
func player_lost(_body): 
	player = null
	state = IDLE
