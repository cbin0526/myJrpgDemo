extends Node

signal battle_result_requested(result_text: String)
signal player_action_finished
signal redraw_requested

var battle_state
var grid_board
var animator


func configure(next_battle_state, next_grid_board, next_animator) -> void:
	battle_state = next_battle_state
	grid_board = next_grid_board
	animator = next_animator


func can_afford_skill(skill: String) -> bool:
	if skill == battle_state.SKILL_SLASH:
		return battle_state.player_ap >= battle_state.SLASH_AP_COST
	if skill == battle_state.SKILL_REND:
		return battle_state.player_ap >= battle_state.REND_AP_COST
	if skill == battle_state.SKILL_CHARGE:
		return battle_state.player_ap >= battle_state.CHARGE_AP_COST and battle_state.player_mp >= battle_state.CHARGE_MP_COST
	if skill == battle_state.SKILL_BLOOD_STRIKE:
		return battle_state.player_ap >= battle_state.BLOOD_STRIKE_AP_COST
	if skill == battle_state.SKILL_WHIRLWIND:
		return battle_state.player_ap >= battle_state.WHIRLWIND_AP_COST
	return false


func select_skill(skill: String) -> void:
	if battle_state.battle_state != battle_state.BATTLE_STATE_PLAYER_TURN or battle_state.input_locked:
		return

	battle_state.selected_skill = skill
	battle_state.skill_targeting = true
	battle_state.add_battle_log("已选择技能：%s" % battle_state.get_skill_display_name(battle_state.selected_skill))
	battle_state.state_changed.emit()
	redraw_requested.emit()


func try_use_selected_skill_on_enemy(enemy_index: int) -> void:
	if battle_state.input_locked:
		return

	if battle_state.selected_skill == battle_state.SKILL_SLASH:
		try_slash(enemy_index)
	elif battle_state.selected_skill == battle_state.SKILL_REND:
		try_rend(enemy_index)
	elif battle_state.selected_skill == battle_state.SKILL_CHARGE:
		try_charge(enemy_index)
	elif battle_state.selected_skill == battle_state.SKILL_BLOOD_STRIKE:
		try_blood_strike(enemy_index)
	elif battle_state.selected_skill == battle_state.SKILL_WHIRLWIND:
		try_whirlwind(enemy_index)


func try_slash(enemy_index: int) -> void:
	var enemy: Dictionary = battle_state.enemies[enemy_index]
	if not grid_board.is_adjacent(battle_state.player_grid, enemy.grid):
		battle_state.add_battle_log("斩击失败：敌人不相邻。")
		return
	if battle_state.player_ap < battle_state.SLASH_AP_COST:
		battle_state.add_battle_log("斩击失败：行动点不足。剩余行动点：%d" % battle_state.player_ap)
		return

	battle_state.set_input_locked(true)
	await animator.animate_player_lunge(enemy.grid)
	battle_state.player_ap -= battle_state.SLASH_AP_COST
	damage_enemy(enemy_index, battle_state.SLASH_DAMAGE, "斩击")
	await animator.animate_enemy_hit(enemy_index)
	add_player_rage(battle_state.SLASH_RAGE_GAIN, "斩击命中")
	finish_player_action()
	battle_state.set_input_locked(false)


func try_rend(enemy_index: int) -> void:
	var enemy: Dictionary = battle_state.enemies[enemy_index]
	if not grid_board.is_adjacent(battle_state.player_grid, enemy.grid):
		battle_state.add_battle_log("撕裂失败：敌人不相邻。")
		return
	if battle_state.player_ap < battle_state.REND_AP_COST:
		battle_state.add_battle_log("撕裂失败：行动点不足。剩余行动点：%d" % battle_state.player_ap)
		return

	battle_state.set_input_locked(true)
	await animator.animate_player_lunge(enemy.grid)
	battle_state.player_ap -= battle_state.REND_AP_COST
	damage_enemy(enemy_index, battle_state.REND_DAMAGE, "撕裂")
	await animator.animate_enemy_hit(enemy_index)
	if battle_state.is_enemy_alive(enemy_index):
		battle_state.enemies[enemy_index].bleed_turns = battle_state.REND_BLEED_TURNS
		battle_state.add_battle_log("%s 流血，持续 %d 回合。" % [battle_state.enemies[enemy_index].name, battle_state.enemies[enemy_index].bleed_turns])
	add_player_rage(battle_state.REND_RAGE_GAIN, "撕裂命中")
	finish_player_action()
	battle_state.set_input_locked(false)


func try_charge(enemy_index: int) -> void:
	var failure_reason: String = get_charge_failure_reason(enemy_index)
	if failure_reason != "":
		battle_state.add_battle_log("冲锋失败：%s" % failure_reason)
		return

	battle_state.set_input_locked(true)
	var from_grid: Vector2i = battle_state.player_grid
	var landing_grid: Vector2i = get_charge_landing_grid(enemy_index)
	await animator.animate_player_move(from_grid, landing_grid, battle_state.CHARGE_ANIMATION_DURATION)
	battle_state.player_ap -= battle_state.CHARGE_AP_COST
	battle_state.player_mp -= battle_state.CHARGE_MP_COST
	battle_state.add_battle_log("玩家冲锋到 %s。行动点：%d 移动点：%d" % [battle_state.player_grid, battle_state.player_ap, battle_state.player_mp])
	damage_enemy(enemy_index, battle_state.CHARGE_DAMAGE, "冲锋")
	await animator.animate_enemy_hit(enemy_index)
	add_player_rage(battle_state.CHARGE_RAGE_GAIN, "冲锋命中")
	finish_player_action()
	battle_state.set_input_locked(false)


func try_blood_strike(enemy_index: int) -> void:
	var enemy: Dictionary = battle_state.enemies[enemy_index]
	if not grid_board.is_adjacent(battle_state.player_grid, enemy.grid):
		battle_state.add_battle_log("血怒斩失败：敌人不相邻。")
		return
	if battle_state.player_ap < battle_state.BLOOD_STRIKE_AP_COST:
		battle_state.add_battle_log("血怒斩失败：行动点不足。剩余行动点：%d" % battle_state.player_ap)
		return

	battle_state.set_input_locked(true)
	await animator.animate_player_lunge(enemy.grid)
	var damage: int = get_blood_strike_damage()
	battle_state.player_ap -= battle_state.BLOOD_STRIKE_AP_COST
	damage_enemy(enemy_index, damage, "血怒斩")
	await animator.animate_enemy_hit(enemy_index)
	add_player_rage(battle_state.BLOOD_STRIKE_RAGE_GAIN, "血怒斩命中")
	finish_player_action()
	battle_state.set_input_locked(false)


func try_whirlwind(enemy_index: int) -> void:
	var enemy: Dictionary = battle_state.enemies[enemy_index]
	if battle_state.player_ap < battle_state.WHIRLWIND_AP_COST:
		battle_state.add_battle_log("旋风斩失败：行动点不足。剩余行动点：%d" % battle_state.player_ap)
		return
	if not is_in_whirlwind_range(enemy.grid):
		battle_state.add_battle_log("旋风斩失败：敌人不在周围 8 格内。")
		return

	battle_state.set_input_locked(true)
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var effect_grid: Vector2i = battle_state.player_grid + Vector2i(dx, dy)
			if grid_board.is_inside_grid(effect_grid):
				animator.add_attack_effect("whirlwind", effect_grid, battle_state.WHIRLWIND_EFFECT_DURATION)
	await get_tree().create_timer(battle_state.WHIRLWIND_EFFECT_DURATION).timeout
	battle_state.player_ap -= battle_state.WHIRLWIND_AP_COST
	var targets: Array[int] = get_whirlwind_target_indices()
	battle_state.add_battle_log("旋风斩命中 %d 个敌人。" % targets.size())
	for target_index in targets:
		damage_enemy(target_index, battle_state.WHIRLWIND_DAMAGE, "旋风斩")
		await animator.animate_enemy_hit(target_index)
	add_player_rage(battle_state.WHIRLWIND_RAGE_GAIN * targets.size(), "旋风斩命中")
	finish_player_action()
	battle_state.set_input_locked(false)


func finish_player_action() -> void:
	battle_state.player_selected = false
	battle_state.skill_targeting = false
	battle_state.state_changed.emit()
	player_action_finished.emit()
	redraw_requested.emit()


func get_action_preview_text(enemy_index: int) -> String:
	var skill_name: String = battle_state.get_skill_display_name(battle_state.selected_skill)
	var failure_reason: String = get_skill_failure_reason(battle_state.selected_skill, enemy_index)
	if failure_reason != "":
		return "\n[b]预览[/b]\n%s 无法命中：%s\n" % [skill_name, failure_reason]

	return "\n[b]预览[/b]\n%s 可以命中。\n伤害：%d\n消耗：%s\n" % [
		skill_name,
		get_skill_preview_damage(battle_state.selected_skill),
		battle_state.get_skill_cost_text(battle_state.selected_skill),
	]


func get_skill_preview_damage(skill: String) -> int:
	if skill == battle_state.SKILL_SLASH:
		return battle_state.SLASH_DAMAGE
	if skill == battle_state.SKILL_REND:
		return battle_state.REND_DAMAGE
	if skill == battle_state.SKILL_CHARGE:
		return battle_state.CHARGE_DAMAGE
	if skill == battle_state.SKILL_BLOOD_STRIKE:
		return get_blood_strike_damage()
	if skill == battle_state.SKILL_WHIRLWIND:
		return battle_state.WHIRLWIND_DAMAGE
	return 0


func get_skill_failure_reason(skill: String, enemy_index: int) -> String:
	if not battle_state.is_enemy_alive(enemy_index):
		return "敌人已被击败"

	if skill == battle_state.SKILL_SLASH:
		if battle_state.player_ap < battle_state.SLASH_AP_COST:
			return "行动点不足"
		if not grid_board.is_adjacent(battle_state.player_grid, battle_state.enemies[enemy_index].grid):
			return "敌人不相邻"
	elif skill == battle_state.SKILL_REND:
		if battle_state.player_ap < battle_state.REND_AP_COST:
			return "行动点不足"
		if not grid_board.is_adjacent(battle_state.player_grid, battle_state.enemies[enemy_index].grid):
			return "敌人不相邻"
	elif skill == battle_state.SKILL_CHARGE:
		return get_charge_failure_reason(enemy_index)
	elif skill == battle_state.SKILL_BLOOD_STRIKE:
		if battle_state.player_ap < battle_state.BLOOD_STRIKE_AP_COST:
			return "行动点不足"
		if not grid_board.is_adjacent(battle_state.player_grid, battle_state.enemies[enemy_index].grid):
			return "敌人不相邻"
	elif skill == battle_state.SKILL_WHIRLWIND:
		if battle_state.player_ap < battle_state.WHIRLWIND_AP_COST:
			return "行动点不足"
		if not is_in_whirlwind_range(battle_state.enemies[enemy_index].grid):
			return "敌人不在周围 8 格内"

	return ""


func get_blood_strike_damage() -> int:
	var bonus_steps: int = floori(float(battle_state.player_rage) / float(battle_state.BLOOD_STRIKE_RAGE_STEP))
	var multiplier: float = 1.0 + float(bonus_steps) * battle_state.BLOOD_STRIKE_RAGE_BONUS
	return int(round(float(battle_state.BLOOD_STRIKE_BASE_DAMAGE) * multiplier))


func damage_enemy(enemy_index: int, amount: int, source: String) -> void:
	if not battle_state.is_enemy_alive(enemy_index):
		return

	battle_state.enemies[enemy_index].hp -= amount
	battle_state.add_battle_log("%s 对 %s 造成 %d 点伤害。生命：%d" % [source, battle_state.enemies[enemy_index].name, amount, max(battle_state.enemies[enemy_index].hp, 0)])
	animator.add_floating_text("-%d" % amount, grid_board.grid_to_world(battle_state.enemies[enemy_index].grid) + Vector2(0.0, -74.0), Color(1.0, 0.34, 0.22, 1.0))
	if battle_state.enemies[enemy_index].hp <= 0:
		defeat_enemy(enemy_index)


func defeat_enemy(enemy_index: int) -> void:
	battle_state.enemies[enemy_index].hp = 0
	battle_state.enemies[enemy_index].alive = false
	battle_state.enemies[enemy_index].bleed_turns = 0
	add_player_rage(battle_state.HIT_KILL_RAGE_GAIN, "击败敌人")
	battle_state.add_battle_log("%s 被击败。" % battle_state.enemies[enemy_index].name)

	if battle_state.are_all_enemies_defeated():
		battle_state.battle_state = battle_state.BATTLE_STATE_BATTLE_OVER
		battle_state.player_selected = false
		battle_state.skill_targeting = false
		battle_result_requested.emit("Victory")
		battle_state.add_battle_log("胜利！所有敌人已被击败。")


func add_player_rage(amount: int, reason: String) -> void:
	battle_state.player_rage = mini(battle_state.PLAYER_MAX_RAGE, battle_state.player_rage + amount)
	battle_state.add_battle_log("%s，怒气 +%d。怒气：%d/%d" % [reason, amount, battle_state.player_rage, battle_state.PLAYER_MAX_RAGE])
	animator.add_floating_text("+%d 怒气" % amount, grid_board.grid_to_world(battle_state.player_grid) + Vector2(0.0, -84.0), Color(1.0, 0.74, 0.24, 1.0))


func resolve_enemy_bleed(enemy_index: int) -> void:
	if battle_state.enemies[enemy_index].bleed_turns <= 0:
		return

	battle_state.enemies[enemy_index].bleed_turns -= 1
	damage_enemy(enemy_index, battle_state.REND_BLEED_DAMAGE, "流血")
	if battle_state.is_enemy_alive(enemy_index):
		battle_state.add_battle_log("%s 剩余流血回合：%d" % [battle_state.enemies[enemy_index].name, battle_state.enemies[enemy_index].bleed_turns])


func get_charge_failure_reason(enemy_index: int) -> String:
	if not battle_state.is_enemy_alive(enemy_index):
		return "敌人已被击败"
	if battle_state.player_ap < battle_state.CHARGE_AP_COST:
		return "行动点不足。剩余行动点：%d" % battle_state.player_ap
	if battle_state.player_mp < battle_state.CHARGE_MP_COST:
		return "移动点不足。剩余移动点：%d" % battle_state.player_mp
	if not grid_board.is_straight_line(battle_state.player_grid, battle_state.enemies[enemy_index].grid):
		return "目标不在同一行或同一列"

	var distance: int = grid_board.get_grid_distance(battle_state.player_grid, battle_state.enemies[enemy_index].grid)
	if distance < battle_state.CHARGE_MIN_RANGE or distance > battle_state.CHARGE_MAX_RANGE:
		return "目标距离必须为 %d-%d 格。当前距离：%d" % [battle_state.CHARGE_MIN_RANGE, battle_state.CHARGE_MAX_RANGE, distance]

	var landing_grid: Vector2i = get_charge_landing_grid(enemy_index)
	if landing_grid == battle_state.player_grid:
		return "已经相邻；请使用斩击或撕裂"
	if not grid_board.is_inside_grid(landing_grid):
		return "落点在地图外"
	if grid_board.is_blocked(landing_grid):
		return "落点被阻挡"
	if battle_state.get_enemy_index_at(landing_grid) != -1:
		return "落点被占用"

	for path_grid in get_charge_path_tiles(enemy_index):
		if grid_board.is_blocked(path_grid):
			return "路径在 %s 被阻挡" % path_grid
		var occupant: int = battle_state.get_enemy_index_at(path_grid)
		if occupant != -1 and occupant != enemy_index:
			return "路径在 %s 被占用" % path_grid

	return ""


func get_charge_landing_grid(enemy_index: int) -> Vector2i:
	var direction: Vector2i = grid_board.get_grid_direction(battle_state.player_grid, battle_state.enemies[enemy_index].grid)
	return battle_state.enemies[enemy_index].grid - direction


func get_charge_path_tiles(enemy_index: int) -> Array[Vector2i]:
	var path: Array[Vector2i] = []
	var direction: Vector2i = grid_board.get_grid_direction(battle_state.player_grid, battle_state.enemies[enemy_index].grid)
	var current: Vector2i = battle_state.player_grid + direction
	var landing: Vector2i = get_charge_landing_grid(enemy_index)

	while current != battle_state.enemies[enemy_index].grid:
		path.append(current)
		if current == landing:
			break
		current += direction

	return path


func is_in_whirlwind_range(grid: Vector2i) -> bool:
	if grid == battle_state.player_grid:
		return false
	var dx: int = absi(grid.x - battle_state.player_grid.x)
	var dy: int = absi(grid.y - battle_state.player_grid.y)
	return dx <= 1 and dy <= 1


func get_whirlwind_target_indices() -> Array[int]:
	var targets: Array[int] = []
	for enemy_index in range(battle_state.enemies.size()):
		if battle_state.is_enemy_alive(enemy_index) and is_in_whirlwind_range(battle_state.enemies[enemy_index].grid):
			targets.append(enemy_index)
	return targets


func can_selected_skill_target_enemy(enemy_index: int) -> bool:
	if battle_state.selected_skill == battle_state.SKILL_SLASH:
		return battle_state.is_enemy_alive(enemy_index) and grid_board.is_adjacent(battle_state.player_grid, battle_state.enemies[enemy_index].grid) and battle_state.player_ap >= battle_state.SLASH_AP_COST
	if battle_state.selected_skill == battle_state.SKILL_REND:
		return battle_state.is_enemy_alive(enemy_index) and grid_board.is_adjacent(battle_state.player_grid, battle_state.enemies[enemy_index].grid) and battle_state.player_ap >= battle_state.REND_AP_COST
	if battle_state.selected_skill == battle_state.SKILL_CHARGE:
		return battle_state.is_enemy_alive(enemy_index) and get_charge_failure_reason(enemy_index) == ""
	if battle_state.selected_skill == battle_state.SKILL_BLOOD_STRIKE:
		return battle_state.is_enemy_alive(enemy_index) and grid_board.is_adjacent(battle_state.player_grid, battle_state.enemies[enemy_index].grid) and battle_state.player_ap >= battle_state.BLOOD_STRIKE_AP_COST
	if battle_state.selected_skill == battle_state.SKILL_WHIRLWIND:
		return battle_state.is_enemy_alive(enemy_index) and is_in_whirlwind_range(battle_state.enemies[enemy_index].grid) and battle_state.player_ap >= battle_state.WHIRLWIND_AP_COST
	return false
