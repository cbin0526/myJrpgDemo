extends Node

const COLOR_TILE := Color(0.23, 0.29, 0.31, 1.0)
const COLOR_TILE_ALT := Color(0.20, 0.26, 0.28, 1.0)
const COLOR_TILE_LINE := Color(0.50, 0.62, 0.64, 1.0)
const COLOR_HOVER := Color(0.95, 0.90, 0.45, 0.45)
const COLOR_SELECTED := Color(0.25, 0.78, 1.0, 0.45)
const COLOR_MOVE := Color(0.20, 0.65, 1.0, 0.32)
const COLOR_ATTACK := Color(1.0, 0.22, 0.14, 0.42)
const COLOR_CHARGE := Color(1.0, 0.62, 0.10, 0.42)
const COLOR_BLOCKED := Color(0.10, 0.10, 0.12, 0.95)
const COLOR_TEXT := Color(0.88, 0.94, 0.95, 1.0)
const COLOR_TEXT_DIM := Color(0.62, 0.72, 0.75, 1.0)
const COLOR_HP_BACK := Color(0.10, 0.04, 0.04, 0.95)
const COLOR_HP_FILL := Color(0.22, 0.85, 0.30, 1.0)
const COLOR_HP_LOW := Color(0.95, 0.22, 0.16, 1.0)

var battle_state
var grid_board
var animator
var combat_controller
var canvas: Node2D
var chinese_font: Font


func configure(next_battle_state, next_grid_board, next_animator, next_combat_controller, next_canvas: Node2D, next_chinese_font: Font) -> void:
	battle_state = next_battle_state
	grid_board = next_grid_board
	animator = next_animator
	combat_controller = next_combat_controller
	canvas = next_canvas
	chinese_font = next_chinese_font


func draw_battle() -> void:
	if battle_state == null or grid_board == null or animator == null or combat_controller == null or canvas == null:
		return

	canvas.draw_rect(Rect2(Vector2.ZERO, canvas.get_viewport_rect().size), Color(0.12, 0.15, 0.17, 1.0), true)
	draw_grid()
	draw_attack_effects()
	draw_enemies()
	draw_player()
	draw_floating_texts()
	draw_hud()


func draw_grid() -> void:
	for y in range(battle_state.GRID_HEIGHT):
		for x in range(battle_state.GRID_WIDTH):
			var grid: Vector2i = Vector2i(x, y)
			var center: Vector2 = grid_board.grid_to_world(grid)
			var points: PackedVector2Array = grid_board.get_tile_points(center)
			var base_color: Color = COLOR_TILE if (x + y) % 2 == 0 else COLOR_TILE_ALT
			var overlay_color: Color = Color.TRANSPARENT
			var enemy_index: int = battle_state.get_enemy_index_at(grid)

			if grid_board.is_blocked(grid):
				base_color = COLOR_BLOCKED
			elif is_player_aiming() and battle_state.selected_skill == battle_state.SKILL_WHIRLWIND and combat_controller.is_in_whirlwind_range(grid):
				overlay_color = COLOR_ATTACK
			elif is_player_aiming() and enemy_index != -1 and combat_controller.can_selected_skill_target_enemy(enemy_index):
				overlay_color = get_selected_skill_target_color()
			elif battle_state.player_selected and grid_board.can_player_move_to(grid):
				overlay_color = COLOR_MOVE

			canvas.draw_colored_polygon(points, base_color)
			draw_texture_centered(battle_state.get_tile_texture(grid), center, Vector2(grid_board.TILE_WIDTH, grid_board.TILE_HEIGHT))
			if overlay_color.a > 0.0:
				canvas.draw_colored_polygon(points, overlay_color)
			if grid_board.is_blocked(grid):
				draw_texture_centered(battle_state.get_obstacle_texture(grid), center + Vector2(0.0, -26.0), Vector2(72.0, 72.0))
			canvas.draw_polyline(grid_board.close_points(points), COLOR_TILE_LINE, 1.0, true)

	if grid_board.is_inside_grid(battle_state.hover_grid):
		var hover_points: PackedVector2Array = grid_board.get_tile_points(grid_board.grid_to_world(battle_state.hover_grid))
		canvas.draw_colored_polygon(hover_points, COLOR_HOVER)
		canvas.draw_polyline(grid_board.close_points(hover_points), Color.WHITE, 2.0, true)

	if battle_state.player_selected:
		canvas.draw_colored_polygon(grid_board.get_tile_points(grid_board.grid_to_world(battle_state.player_grid)), COLOR_SELECTED)


func draw_player() -> void:
	var center: Vector2 = grid_board.grid_to_world(battle_state.player_grid) + animator.player_draw_offset
	draw_texture_centered(battle_state.TEX_PLAYER, center + Vector2(0.0, -32.0), Vector2(82.0, 82.0))
	draw_health_bar(center + Vector2(0.0, -58.0), battle_state.player_hp, battle_state.PLAYER_MAX_HP, 54.0)


func draw_enemies() -> void:
	for enemy_index in range(battle_state.enemies.size()):
		if not battle_state.is_enemy_alive(enemy_index):
			continue

		var center: Vector2 = grid_board.grid_to_world(battle_state.enemies[enemy_index].grid) + animator.get_enemy_draw_offset(enemy_index)
		draw_texture_centered(battle_state.get_enemy_texture(battle_state.enemies[enemy_index]), center + Vector2(0.0, -30.0), Vector2(76.0, 76.0))
		canvas.draw_string(chinese_font, center + Vector2(-22.0, -42.0), "%d" % battle_state.enemies[enemy_index].hp, HORIZONTAL_ALIGNMENT_CENTER, 44.0, 13, COLOR_TEXT)
		draw_health_bar(center + Vector2(0.0, -58.0), battle_state.enemies[enemy_index].hp, battle_state.enemies[enemy_index].max_hp, 48.0)


func draw_hud() -> void:
	var pos: Vector2 = Vector2(24.0, 24.0)
	canvas.draw_string(chinese_font, pos, "等距战棋原型", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 22, COLOR_TEXT)
	canvas.draw_string(chinese_font, pos + Vector2(0.0, 32.0), "绵羊地下城第 1 房间 | 目标：击败全部敌人 | 挑战：%d 回合内获胜" % battle_state.CHALLENGE_TURN_LIMIT, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, COLOR_TEXT_DIM)
	canvas.draw_string(chinese_font, pos + Vector2(0.0, 58.0), "回合：%d | 状态：%s | 技能：%s | 玩家生命：%d 行动：%d/%d 移动：%d/%d 怒气：%d/%d" % [battle_state.turn_count, battle_state.get_battle_state_display_name(), battle_state.get_skill_display_name(battle_state.selected_skill), battle_state.player_hp, battle_state.player_ap, battle_state.PLAYER_MAX_AP, battle_state.player_mp, battle_state.PLAYER_MAX_MP, battle_state.player_rage, battle_state.PLAYER_MAX_RAGE], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, COLOR_TEXT_DIM)
	canvas.draw_string(chinese_font, pos + Vector2(0.0, 84.0), "存活敌人：%d/%d | 悬停：%s" % [battle_state.get_alive_enemy_count(), battle_state.enemies.size(), battle_state.hover_grid], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, COLOR_TEXT_DIM)


func draw_health_bar(center: Vector2, hp: int, max_hp: int, width: float) -> void:
	var height: float = 7.0
	var top_left: Vector2 = center - Vector2(width * 0.5, height * 0.5)
	var ratio: float = clampf(float(hp) / float(max_hp), 0.0, 1.0)
	var fill_color: Color = COLOR_HP_FILL if ratio > 0.35 else COLOR_HP_LOW
	canvas.draw_rect(Rect2(top_left, Vector2(width, height)), COLOR_HP_BACK, true)
	canvas.draw_rect(Rect2(top_left, Vector2(width * ratio, height)), fill_color, true)
	canvas.draw_rect(Rect2(top_left, Vector2(width, height)), Color(0.02, 0.02, 0.02, 1.0), false, 1.0)


func draw_texture_centered(texture: Texture2D, center: Vector2, size: Vector2) -> void:
	canvas.draw_texture_rect(texture, Rect2(center - size * 0.5, size), false)


func draw_attack_effects() -> void:
	for effect in animator.attack_effects:
		var duration: float = effect.duration
		var age: float = effect.age
		var alpha: float = 1.0 - clampf(age / duration, 0.0, 1.0)
		if effect.kind == "whirlwind":
			var center: Vector2 = grid_board.grid_to_world(effect.grid)
			var points: PackedVector2Array = grid_board.get_tile_points(center)
			canvas.draw_colored_polygon(points, Color(1.0, 0.18, 0.08, 0.28 * alpha))
			canvas.draw_polyline(grid_board.close_points(points), Color(1.0, 0.72, 0.20, alpha), 3.0, true)


func draw_floating_texts() -> void:
	for floating_text in animator.floating_texts:
		var alpha: float = 1.0 - clampf(float(floating_text.age) / battle_state.FLOATING_TEXT_DURATION, 0.0, 1.0)
		var color: Color = floating_text.color
		color.a = alpha
		canvas.draw_string(chinese_font, floating_text.position, floating_text.text, HORIZONTAL_ALIGNMENT_CENTER, 110.0, 18, color)


func is_player_aiming() -> bool:
	return battle_state.battle_state == battle_state.BATTLE_STATE_PLAYER_TURN and (battle_state.player_selected or battle_state.skill_targeting)


func get_selected_skill_target_color() -> Color:
	if battle_state.selected_skill == battle_state.SKILL_CHARGE:
		return COLOR_CHARGE
	return COLOR_ATTACK
