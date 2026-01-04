extends CharacterBody2D

@onready var player_raycast : RayCast2D = $RayCast2D
@onready var healthbar : ProgressBar = $Camera2D/CanvasLayer/HUD/Healthbar
@onready var camera2D : Camera2D = $Camera2D

@export_group("Stat")
@export var move_speed : float = 300.0
@export var max_health : int = 100
@export var fire_rate : float = 0.25
@export var damage : float = 25.0

var fire_cooldown : float = 0.0
var current_health : int

var camera_shake_noise : FastNoiseLite

func _ready():
	current_health = max_health
	healthbar.init_health(max_health)
	camera_shake_noise = FastNoiseLite.new()

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

func camera_shake(intensity : float):
	var camera_offset = camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensity
	camera2D.offset.x = camera_offset
	camera2D.offset.y = camera_offset

func shoot() -> void:
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(camera_shake, 5.0, 1.0, 0.15)
	fire_cooldown = fire_rate
	if player_raycast.is_colliding():
		var collider = player_raycast.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(damage)

func reset_game():
	get_tree().reload_current_scene()

func take_damage(amount: int) -> void:
	current_health -= amount
	healthbar.health = current_health
	if current_health > 0:
		print("Player HP: ", current_health)
	if current_health <= 0:
		print("Game Over")
		call_deferred("reset_game")
