extends Area2D

@export var bullet_speed : float = 1500.0
@export var bullet_damage : float = 30.0

var direction : Vector2 = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	position += direction * bullet_speed * delta


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemies"):
		body.take_damage(bullet_damage)
		queue_free()
