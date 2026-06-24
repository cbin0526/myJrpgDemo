extends Node

signal redraw_requested

var battle_state
var grid_board

var player_draw_offset: Vector2 = Vector2.ZERO
var enemy_draw_offsets: Array[Vector2] = []
var floating_texts: Array[Dictionary] = []
var attack_effects: Array[Dictionary] = []


func configure(next_battle_state, next_grid_board) -> void:
	battle_state = next_battle_state
	grid_board = next_grid_board


func reset() -> void:
	player_draw_offset = Vector2.ZERO
	floating_texts.clear()
	attack_effects.clear()
	reset_enemy_draw_offsets()


func reset_enemy_draw_offsets() -> void:
	enemy_draw_offsets.clear()
	for _enemy in battle_state.enemies:
		enemy_draw_offsets.append(Vector2.ZERO)


func add_floating_text(text: String, world_position: Vector2, color: Color) -> void:
	floating_texts.append({
		"text": text,
		"position": world_position,
		"age": 0.0,
		"color": color,
	})
	redraw_requested.emit()


func update_floating_texts(delta: float) -> void:
	var changed: bool = false
	for floating_text in floating_texts:
		floating_text.age += delta
		floating_text.position += Vector2(0.0, -28.0 * delta)
		changed = true

	for index in range(floating_texts.size() - 1, -1, -1):
		if floating_texts[index].age >= battle_state.FLOATING_TEXT_DURATION:
			floating_texts.remove_at(index)
			changed = true

	if changed:
		redraw_requested.emit()


func add_attack_effect(kind: String, grid: Vector2i, duration: float) -> void:
	attack_effects.append({
		"kind": kind,
		"grid": grid,
		"age": 0.0,
		"duration": duration,
	})
	redraw_requested.emit()


func update_attack_effects(delta: float) -> void:
	var changed: bool = false
	for effect in attack_effects:
		effect.age += delta
		changed = true

	for index in range(attack_effects.size() - 1, -1, -1):
		if attack_effects[index].age >= attack_effects[index].duration:
			attack_effects.remove_at(index)
			changed = true

	if changed:
		redraw_requested.emit()


func animate_player_move(from_grid: Vector2i, to_grid: Vector2i, duration: float) -> void:
	var from_world: Vector2 = grid_board.grid_to_world(from_grid)
	var to_world: Vector2 = grid_board.grid_to_world(to_grid)
	battle_state.player_grid = to_grid
	player_draw_offset = from_world - to_world
	await animate_offset_value("player", -1, player_draw_offset, Vector2.ZERO, duration)


func animate_enemy_move(enemy_index: int, from_grid: Vector2i, to_grid: Vector2i, duration: float) -> void:
	var from_world: Vector2 = grid_board.grid_to_world(from_grid)
	var to_world: Vector2 = grid_board.grid_to_world(to_grid)
	battle_state.enemies[enemy_index].grid = to_grid
	enemy_draw_offsets[enemy_index] = from_world - to_world
	await animate_offset_value("enemy", enemy_index, enemy_draw_offsets[enemy_index], Vector2.ZERO, duration)


func animate_player_lunge(target_grid: Vector2i) -> void:
	var direction: Vector2 = (grid_board.grid_to_world(target_grid) - grid_board.grid_to_world(battle_state.player_grid)).normalized()
	if direction == Vector2.ZERO:
		return
	var lunge_offset: Vector2 = direction * battle_state.ATTACK_LUNGE_DISTANCE
	await animate_offset_value("player", -1, Vector2.ZERO, lunge_offset, battle_state.ATTACK_LUNGE_DURATION)
	await animate_offset_value("player", -1, lunge_offset, Vector2.ZERO, battle_state.ATTACK_LUNGE_DURATION)


func animate_enemy_lunge(enemy_index: int, target_grid: Vector2i) -> void:
	var direction: Vector2 = (grid_board.grid_to_world(target_grid) - grid_board.grid_to_world(battle_state.enemies[enemy_index].grid)).normalized()
	if direction == Vector2.ZERO:
		return
	var lunge_offset: Vector2 = direction * battle_state.ATTACK_LUNGE_DISTANCE
	await animate_offset_value("enemy", enemy_index, Vector2.ZERO, lunge_offset, battle_state.ATTACK_LUNGE_DURATION)
	await animate_offset_value("enemy", enemy_index, lunge_offset, Vector2.ZERO, battle_state.ATTACK_LUNGE_DURATION)


func animate_player_hit() -> void:
	await animate_offset_value("player", -1, Vector2(-battle_state.HIT_SHAKE_DISTANCE, 0.0), Vector2(battle_state.HIT_SHAKE_DISTANCE, 0.0), battle_state.HIT_SHAKE_DURATION)
	await animate_offset_value("player", -1, Vector2(battle_state.HIT_SHAKE_DISTANCE, 0.0), Vector2.ZERO, battle_state.HIT_SHAKE_DURATION)


func animate_enemy_hit(enemy_index: int) -> void:
	if not battle_state.is_enemy_alive(enemy_index):
		return
	await animate_offset_value("enemy", enemy_index, Vector2(-battle_state.HIT_SHAKE_DISTANCE, 0.0), Vector2(battle_state.HIT_SHAKE_DISTANCE, 0.0), battle_state.HIT_SHAKE_DURATION)
	if battle_state.is_enemy_alive(enemy_index):
		await animate_offset_value("enemy", enemy_index, Vector2(battle_state.HIT_SHAKE_DISTANCE, 0.0), Vector2.ZERO, battle_state.HIT_SHAKE_DURATION)


func animate_offset_value(target: String, enemy_index: int, from_offset: Vector2, to_offset: Vector2, duration: float) -> void:
	var elapsed: float = 0.0
	while elapsed < duration:
		var delta: float = get_process_delta_time()
		elapsed += delta
		var t: float = clampf(elapsed / duration, 0.0, 1.0)
		var offset: Vector2 = from_offset.lerp(to_offset, t)
		if target == "player":
			player_draw_offset = offset
		elif enemy_index >= 0 and enemy_index < enemy_draw_offsets.size():
			enemy_draw_offsets[enemy_index] = offset
		redraw_requested.emit()
		await get_tree().process_frame

	if target == "player":
		player_draw_offset = to_offset
	elif enemy_index >= 0 and enemy_index < enemy_draw_offsets.size():
		enemy_draw_offsets[enemy_index] = to_offset
	redraw_requested.emit()


func get_enemy_draw_offset(enemy_index: int) -> Vector2:
	if enemy_index >= 0 and enemy_index < enemy_draw_offsets.size():
		return enemy_draw_offsets[enemy_index]
	return Vector2.ZERO
