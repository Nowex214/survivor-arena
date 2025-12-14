class_name Enemies
extends CharacterBody2D

@export var max_health : int = 100
@export var move_speed : float = 80.0
@export var attack_range : float = 20.0
@export var attack_damage : float = 10.0
@export var attack_speed : float = 1.0

@onready var raycast : RayCast2D = $RayCast2D

var player : CharacterBody2D
var current_health : int = max_health
var attack_cooldown: float = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("Player")


func _physics_process(delta: float):
	if player == null:
		return

	attack_cooldown = max(0, attack_cooldown - delta)

	# raycast find the player
	var direction = (player.global_position - global_position).normalized()
	raycast.target_position = direction * attack_range

	var distance = global_position.distance_to(player.global_position)

	# movement
	if distance > attack_range:
		velocity = direction * move_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

	# attack
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider == player:
			attack_player()


# UTILS FUNCTIONS
func attack_player():
	if attack_cooldown > 0:
		return
	attack_cooldown = 1.0 / attack_speed
	player.take_damage(attack_damage)

func take_damage(amount: int) -> void:
	max_health -= amount
	if max_health >= 0:
		print("Enemy HP: ", max_health)
	if max_health <= 0:
		queue_free()
