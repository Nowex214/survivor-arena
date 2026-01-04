extends CharacterBody2D

@onready var player_raycast : RayCast2D = $RayCast2D
@onready var light : PointLight2D = $Light/PointLight2D

@export_group("Stat")
@export var move_speed : float = 300.0
@export var max_health : int = 100
@export var fire_rate : float = 0.25
@export var damage : float = 25.0

var fire_cooldown : float = 0.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * move_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	look_at(get_global_mouse_position())

	fire_cooldown = max(0.0, fire_cooldown - delta)

	if Input.is_action_pressed("shoot") and fire_cooldown <= 0.0:
		shoot()

# UTILS FUNCTIONS

func shoot() -> void:
	fire_cooldown = fire_rate
	if player_raycast.is_colliding():
		var collider = player_raycast.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(damage)

func reset_game():
	get_tree().reload_current_scene()

func take_damage(amount: int) -> void:
	max_health -= amount
	if max_health > 0:
		print("Player HP: ", max_health)
	if max_health <= 0:
		print("Game Over")
		call_deferred("reset_game")
