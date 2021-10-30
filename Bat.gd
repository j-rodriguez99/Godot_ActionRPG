extends KinematicBody2D

var knockback : Vector2 = Vector2(0,1)
onready var stats : Node = $Stats
const Bat_death_effect = preload("res://Effects/BatDeathEffect.tscn")

onready var animated_sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var detect_player_zone = $DetectPlayerZone/CollisionShape2D


var player
var player_direction 
var velocity = Vector2.ZERO
var  state = IDLE

const MAX_SPEED = 95
var deceleration = 100
const ACCELERATION = 130

enum {
	IDLE,
	WANDER,
	CHASE
}

func _ready():
	animated_sprite.playing = true
	
func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, delta * deceleration)
	knockback = move_and_slide(knockback)
	
	match state: 
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, delta * deceleration)
		WANDER: 
			pass
		CHASE:
			player_direction = global_position.direction_to(player.global_position)
			animated_sprite.flip_h = player.global_position.x < global_position.x
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

func damage_taken(_area):
	hurtbox.show_hit()


func _on_Hitbox_area_entered(_area):
	detect_player_zone.set_deferred("disabled", true)
	deceleration = 300
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "enable_zone")
	timer.one_shot = true
	timer.set_wait_time(.15)
	timer.start()


func enable_zone(): 
	deceleration = 100
	detect_player_zone.set_deferred("disabled", false)

	
