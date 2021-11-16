extends KinematicBody2D

var knockback : Vector2 = Vector2(0,1)
onready var stats : Node = $Stats
const Bat_death_effect = preload("res://Effects/BatDeathEffect.tscn")

onready var animated_sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var detect_player_zone = $DetectPlayerZone/CollisionShape2D
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var stateShuffleTimer = $StateShuffleTimer

var player
var player_direction 
var velocity = Vector2.ZERO
const WANDER_SPEED = 25
var  state

const MAX_SPEED = 95
var deceleration = 100
const ACCELERATION = 130

enum {
	IDLE,
	WANDER,
	CHASE
}

func _ready() -> void:
	randomize()
	animated_sprite.frame = randi() % 5
	animated_sprite.playing = true
	stateShuffleTimer.connect("timeout", self, "state_shuffle")
	state_shuffle()
	
func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, delta * deceleration)
	knockback = move_and_slide(knockback)
	
	match state: 
		IDLE:
			animated_sprite.self_modulate = Color(1, 1, 1, 1)
			velocity = velocity.move_toward(Vector2.ZERO, delta * deceleration)
			if stateShuffleTimer.is_stopped():
				stateShuffleTimer.start()
				
		WANDER: 
			velocity = velocity.move_toward(WANDER_SPEED * wanderController.direction(), delta * ACCELERATION)
			if position.distance_to(wanderController.target_location) < 10:
				wanderController.set_target_location()
			elif is_on_wall():
				wanderController.set_target_location()
			
			if stateShuffleTimer.is_stopped():
				stateShuffleTimer.start()
		CHASE:
			stateShuffleTimer.stop()
			animated_sprite.self_modulate = Color(.65, .12, .12, 1) 
			player_direction = global_position.direction_to(player.global_position)
			animated_sprite.flip_h = player.global_position.x < global_position.x
			velocity = velocity.move_toward(MAX_SPEED * player_direction, delta * ACCELERATION)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * 120 * delta
	
	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	knockback = area.knockback_vector * 105
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
#	hurtbox.disable_zone(.8)

func _on_Hitbox_area_entered(_area):
	velocity = Vector2.ZERO

func state_shuffle(): 
	state = wanderController.state_shuffle([WANDER, IDLE])

