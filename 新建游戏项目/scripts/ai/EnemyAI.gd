extends Node

signal enemy_turn_finished
signal battle_result_requested(result_text: String)
signal redraw_requested

var battle_state
var grid_board
var animator
var combat_controller


func configure(next_battle_state, next_grid_board, next_animator, next_combat_controller) -> void:
	battle_state = next_battle_state
	grid_board = next_grid_board
	animator = next_animator
	combat_controller = next_combat_controller


func perform_enemy_turns() -> void:
	perform_enemy_turns_async()


func perform_enemy_turns_async() -> void:
	battle_state.enemy_turn_running = true
	battle_state.set_input_locked(true)
	battle_state.state_changed.emit()

	for enemy_index in range(battle_state.enemies.size()):
		if battle_state.battle_state == battle_state.BATTLE_STATE_BATTLE_OVER:
			battle_state.enemy_turn_running = false
			battle_state.set_input_locked(false)
			enemy_turn_finished.emit()
			return
		if not battle_state.is_enemy_alive(enemy_index):
			continue

		await get_tree().create_timer(battle_state.ENEMY_ACTION_DELAY).timeout
		combat_controller.resolve_enemy_bleed(enemy_index)
		if battle_state.battle_state == battle_state.BATTLE_STATE_BATTLE_OVER:
			battle_state.enemy_turn_running = false
			battle_state.set_input_locked(false)
			enemy_turn_finished.emit()
			return
		if not battle_state.is_enemy_alive(enemy_index):
			continue

		await get_tree().create_timer(battle_state.ENEMY_ACTION_DELAY).timeout
		if grid_board.is_adjacent(battle_state.enemies[enemy_index].grid, battle_state.player_grid):
			var attack_damage: int = battle_state.enemies[enemy_index].attack_damage
			await animator.animate_enemy_lunge(enemy_index, battle_state.player_grid)
			battle_state.player_hp -= attack_damage
			combat_controller.add_player_rage(battle_state.DAMAGED_RAGE_GAIN, "受到伤害")
			animator.add_floating_text("-%d" % attack_damage, grid_board.grid_to_world(battle_state.player_grid) + Vector2(0.0, -74.0), Color(1.0, 0.34, 0.22, 1.0))
			battle_state.add_battle_log("%s 攻击玩家，造成 %d 点伤害。玩家生命：%d" % [battle_state.enemies[enemy_index].name, attack_damage, max(battle_state.player_hp, 0)])
			await animator.animate_player_hit()
			if battle_state.player_hp <= 0:
				battle_state.player_hp = 0
				battle_state.battle_state = battle_state.BATTLE_STATE_BATTLE_OVER
				battle_result_requested.emit("Defeat")
				battle_state.add_battle_log("失败。玩家被击败。")
			continue

		await move_enemy_toward_player(enemy_index)
		redraw_requested.emit()

	battle_state.enemy_turn_running = false
	enemy_turn_finished.emit()


func move_enemy_toward_player(enemy_index: int) -> void:
	var steps: int = battle_state.enemies[enemy_index].max_mp
	while steps > 0 and not grid_board.is_adjacent(battle_state.enemies[enemy_index].grid, battle_state.player_grid):
		var next_grid: Vector2i = get_best_enemy_step(enemy_index)
		if next_grid == battle_state.enemies[enemy_index].grid:
			break
		var from_grid: Vector2i = battle_state.enemies[enemy_index].grid
		await animator.animate_enemy_move(enemy_index, from_grid, next_grid, battle_state.MOVE_ANIMATION_DURATION)
		steps -= 1

	battle_state.add_battle_log("%s 移动到 %s" % [battle_state.enemies[enemy_index].name, battle_state.enemies[enemy_index].grid])


func get_best_enemy_step(enemy_index: int) -> Vector2i:
	var directions: Array[Vector2i] = [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1),
	]
	var best_grid: Vector2i = battle_state.enemies[enemy_index].grid
	var best_distance: int = grid_board.get_grid_distance(battle_state.enemies[enemy_index].grid, battle_state.player_grid)

	for direction in directions:
		var candidate: Vector2i = battle_state.enemies[enemy_index].grid + direction
		if not grid_board.can_enemy_move_to(enemy_index, candidate):
			continue
		var distance: int = grid_board.get_grid_distance(candidate, battle_state.player_grid)
		if distance < best_distance:
			best_distance = distance
			best_grid = candidate

	return best_grid
