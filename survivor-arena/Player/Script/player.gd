extends CharacterBody2D

const SPEED : float = 300.0

var health : int = 100

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func reset_game():
	get_tree().reload_current_scene()

func take_damage(amount: int) -> void:
	health -= amount
	print("Player HP: ", health)
	if health <= 0:
		print("Game Over")
		call_deferred("reset_game")
