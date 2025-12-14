extends CharacterBody2D

var bullet_scene = preload("res://Weapon/Scene/bullet.tscn")

@onready var shoot_marker : Marker2D = $Marker2D

@export var move_speed : float = 300.0
@export var max_health : int = 100
@export var fire_rate : float = 0.25

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
	if Input.is_action_pressed("shoot"):
		shoot()

# UTILS FUNCTIONS

func shoot():
	var bullet = bullet_scene.instantiate()
	var dir = (get_global_mouse_position() - shoot_marker.global_position).normalized()

	if fire_cooldown > 0:
		return
	fire_cooldown = fire_rate

	bullet.global_position = shoot_marker.global_position
	bullet.direction = dir
	bullet.rotation = dir.angle()

	get_tree().current_scene.add_child(bullet)

func reset_game():
	get_tree().reload_current_scene()

func take_damage(amount: int) -> void:
	max_health -= amount
	if max_health >= 0:
		print("Player HP: ", max_health)
	if max_health <= 0:
		print("Game Over")
		call_deferred("reset_game")
