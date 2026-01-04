extends Node2D

@export_group("Enemy spawner")
@export var tile_map_layer : TileMapLayer
@export var enemy : PackedScene

@export_group("Wave management")
@export var enemy_count : int
@export var enemy_delay : float

var spawnable_position : Array[Vector2i] = []

func _ready() -> void:
	find_spawnable_tile()
	start_wave(enemy_count, enemy_delay)

func _process(_delta: float) -> void:
	pass

# Utils

func start_wave(amount: int, interval: float):
	if spawnable_position.is_empty():
		print("Error: No spawning tiles is found")
		return

	print("Starting wave : ", amount, " ennemies")

	for i in range(amount):
		spawn_enemies()
		await get_tree().create_timer(interval).timeout

func find_spawnable_tile():
	spawnable_position.clear()

	var used_cells = tile_map_layer.get_used_cells()
	for cell_pos in used_cells:
		var tile_data = tile_map_layer.get_cell_tile_data(cell_pos)
		if tile_data and tile_data.get_custom_data("can_spawn") == true:
						spawnable_position.append(cell_pos)

func spawn_enemies():
	if enemy == null:
		print("Error: No enemy assign")
		return

	var random_cell = spawnable_position.pick_random()
	var local_pos = tile_map_layer.map_to_local(random_cell)
	var global_pos = tile_map_layer.to_global(local_pos)
	var enemies_instance = enemy.instantiate()
	enemies_instance.global_position = global_pos
	get_tree().root.add_child.call_deferred(enemies_instance)
