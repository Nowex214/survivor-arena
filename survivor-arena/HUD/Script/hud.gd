extends Control

@onready var health_label : Label = $health
@onready var ammo_label : Label = $ammo

func _on_player_change_label_ammo(ammo) -> void:
	ammo_label.text = str(ammo) + " AMMO"

func _on_player_change_label_health(health) -> void:
	health_label.text = str(health) + " HEALTH"
