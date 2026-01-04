class_name Enemies
extends CharacterBody2D

@export var player : Node2D

# STATS
@export_group("Stat")
@export var max_health : int = 100
@export var move_speed : float = 80.0
@export var attack_range : float = 20.0
@export var attack_damage : float = 10.0
@export var attack_speed : float = 1.0

@onready var attack_raycast : RayCast2D = $RayCast2D
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D

var current_health : int = max_health
var attack_cooldown: float = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	call_deferred("actor_setup")

func _physics_process(delta: float):
	if player == null:
		return

	if attack_cooldown > 0:
		attack_cooldown -= delta

	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player <= attack_range:
		attack_player()
		velocity = Vector2.ZERO
	else:
		var next_path_pos = nav_agent.get_next_path_position()
		var direction = (next_path_pos - global_position).normalized()
		velocity = direction * move_speed
		look_at(player.global_position)
	move_and_slide()


# UTILS FUNCTIONS

func actor_setup():
	await get_tree().physics_frame
	make_path()

func make_path():
	nav_agent.target_position = player.global_position

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

func _on_timer_timeout() -> void:
	make_path()
