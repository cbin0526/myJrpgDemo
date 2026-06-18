extends Node2D

const GRID_WIDTH := 10
const GRID_HEIGHT := 10
const TILE_WIDTH := 96.0
const TILE_HEIGHT := 48.0
const GRID_ORIGIN := Vector2(640.0, 120.0)
const PLAYER_MAX_MP := 3
const PLAYER_MAX_AP := 6
const PLAYER_MAX_RAGE := 100

const SKILL_SLASH := "slash"
const SKILL_REND := "rend"
const SKILL_CHARGE := "charge"
const SKILL_BLOOD_STRIKE := "blood_strike"
const SKILL_WHIRLWIND := "whirlwind"

const TEX_PLAYER := preload("res://assets/art/player_berserker.png")
const TEX_LAMB := preload("res://assets/art/lamb.png")
const TEX_SHEEP_GUARD := preload("res://assets/art/sheep_guard.png")
const TEX_GRASS_TILE := preload("res://assets/art/grass_tile.png")
const TEX_STONE_OBSTACLE := preload("res://assets/art/stone_obstacle.png")
const TEX_SLASH_ICON := preload("res://assets/art/slash_icon.png")
const TEX_REND_ICON := preload("res://assets/art/rend_icon.png")
const TEX_CHARGE_ICON := preload("res://assets/art/charge_icon.png")
const TEX_BLOOD_STRIKE_ICON := preload("res://assets/art/blood_strike_icon.png")
const TEX_WHIRLWIND_ICON := preload("res://assets/art/whirlwind_icon.png")

const SLASH_AP_COST := 3
const SLASH_DAMAGE := 18
const SLASH_RAGE_GAIN := 5
const REND_AP_COST := 3
const REND_DAMAGE := 10
const REND_BLEED_TURNS := 2
const REND_BLEED_DAMAGE := 8
const REND_RAGE_GAIN := 5
const CHARGE_AP_COST := 2
const CHARGE_MP_COST := 1
const CHARGE_DAMAGE := 14
const CHARGE_MIN_RANGE := 2
const CHARGE_MAX_RANGE := 3
const CHARGE_RAGE_GAIN := 8
const BLOOD_STRIKE_AP_COST := 4
const BLOOD_STRIKE_BASE_DAMAGE := 22
const BLOOD_STRIKE_RAGE_STEP := 20
const BLOOD_STRIKE_RAGE_BONUS := 0.10
const BLOOD_STRIKE_RAGE_GAIN := 5
const WHIRLWIND_AP_COST := 5
const WHIRLWIND_DAMAGE := 16
const WHIRLWIND_RAGE_GAIN := 10
const HIT_KILL_RAGE_GAIN := 20
const DAMAGED_RAGE_GAIN := 10
const ENEMY_MAX_MP := 2
const ENEMY_ATTACK_DAMAGE := 8
const PLAYER_MAX_HP := 100
const ENEMY_MAX_HP := 40
const SHEEP_GUARD_MAX_HP := 70
const SHEEP_GUARD_ATTACK_DAMAGE := 6
const SHEEP_GUARD_MAX_MP := 1
const CHALLENGE_TURN_LIMIT := 5
const BATTLE_LOG_LIMIT := 8
const FLOATING_TEXT_DURATION := 0.9
const ENEMY_ACTION_DELAY := 0.35
const MOVE_ANIMATION_DURATION := 0.22
const CHARGE_ANIMATION_DURATION := 0.18
const ATTACK_LUNGE_DISTANCE := 18.0
const ATTACK_LUNGE_DURATION := 0.08
const HIT_SHAKE_DISTANCE := 8.0
const HIT_SHAKE_DURATION := 0.06
const WHIRLWIND_EFFECT_DURATION := 0.25

const COLOR_TILE := Color(0.23, 0.29, 0.31, 1.0)
const COLOR_TILE_ALT := Color(0.20, 0.26, 0.28, 1.0)
const COLOR_TILE_LINE := Color(0.50, 0.62, 0.64, 1.0)
const COLOR_HOVER := Color(0.95, 0.90, 0.45, 0.45)
const COLOR_SELECTED := Color(0.25, 0.78, 1.0, 0.45)
const COLOR_MOVE := Color(0.20, 0.65, 1.0, 0.32)
const COLOR_ATTACK := Color(1.0, 0.22, 0.14, 0.42)
const COLOR_CHARGE := Color(1.0, 0.62, 0.10, 0.42)
const COLOR_BLOCKED := Color(0.10, 0.10, 0.12, 0.95)
const COLOR_PLAYER := Color(0.95, 0.22, 0.15, 1.0)
const COLOR_PLAYER_SHADOW := Color(0.05, 0.04, 0.04, 0.45)
const COLOR_ENEMY := Color(0.42, 0.30, 0.95, 1.0)
const COLOR_ENEMY_DARK := Color(0.16, 0.10, 0.42, 1.0)
const COLOR_TEXT := Color(0.88, 0.94, 0.95, 1.0)
const COLOR_TEXT_DIM := Color(0.62, 0.72, 0.75, 1.0)
const COLOR_HP_BACK := Color(0.10, 0.04, 0.04, 0.95)
const COLOR_HP_FILL := Color(0.22, 0.85, 0.30, 1.0)
const COLOR_HP_LOW := Color(0.95, 0.22, 0.16, 1.0)

var player_grid := Vector2i(2, 2)
var player_hp := PLAYER_MAX_HP
var player_ap := PLAYER_MAX_AP
var player_mp := PLAYER_MAX_MP
var player_rage := 0
var player_selected := false
var skill_targeting := false
var selected_skill := SKILL_SLASH
var hover_grid := Vector2i(-1, -1)
var battle_state := "player_turn"
var turn_count := 1
var battle_logs: Array[String] = []
var floating_texts: Array[Dictionary] = []
var enemy_turn_running := false
var input_locked := false
var player_draw_offset := Vector2.ZERO
var enemy_draw_offsets: Array[Vector2] = []
var attack_effects: Array[Dictionary] = []
var side_panel_visible := true

var enemies: Array[Dictionary] = create_room_enemies()

var blocked_tiles: Array[Vector2i] = [
	Vector2i(4, 3),
	Vector2i(4, 4),
	Vector2i(5, 4),
	Vector2i(5, 5),
	Vector2i(3, 6),
	Vector2i(6, 2),
]

@onready var ui_root: Control = $CanvasLayer/UIRoot
@onready var skill_bar: HBoxContainer = $CanvasLayer/UIRoot/SkillBar
@onready var slash_button: Button = $CanvasLayer/UIRoot/SkillBar/SlashButton
@onready var rend_button: Button = $CanvasLayer/UIRoot/SkillBar/RendButton
@onready var charge_button: Button = $CanvasLayer/UIRoot/SkillBar/ChargeButton
@onready var blood_strike_button: Button = $CanvasLayer/UIRoot/SkillBar/BloodStrikeButton
@onready var whirlwind_button: Button = $CanvasLayer/UIRoot/SkillBar/WhirlwindButton
@onready var end_turn_button: Button = $CanvasLayer/UIRoot/EndTurnButton
@onready var toggle_side_panel_button: Button = $CanvasLayer/UIRoot/ToggleSidePanelButton
@onready var log_panel: PanelContainer = $CanvasLayer/UIRoot/LogPanel
@onready var battle_log_label: RichTextLabel = $CanvasLayer/UIRoot/LogPanel/BattleLog
@onready var info_panel: PanelContainer = $CanvasLayer/UIRoot/InfoPanel
@onready var info_label: RichTextLabel = $CanvasLayer/UIRoot/InfoPanel/InfoLabel
@onready var result_panel: PanelContainer = $CanvasLayer/UIRoot/ResultPanel
@onready var result_label: Label = $CanvasLayer/UIRoot/ResultPanel/ResultBox/ResultLabel
@onready var restart_button: Button = $CanvasLayer/UIRoot/ResultPanel/ResultBox/RestartButton


func create_enemy(name: String, enemy_type: String, grid: Vector2i, max_hp: int, attack_damage: int, max_mp: int) -> Dictionary:
	return {
		"name": name,
		"type": enemy_type,
		"grid": grid,
		"hp": max_hp,
		"max_hp": max_hp,
		"attack_damage": attack_damage,
		"max_mp": max_mp,
		"bleed_turns": 0,
		"alive": true,
	}


func create_room_enemies() -> Array[Dictionary]:
	return [
		create_enemy("Lamb A", "Lamb", Vector2i(6, 3), ENEMY_MAX_HP, ENEMY_ATTACK_DAMAGE, ENEMY_MAX_MP),
		create_enemy("Lamb B", "Lamb", Vector2i(8, 5), ENEMY_MAX_HP, ENEMY_ATTACK_DAMAGE, ENEMY_MAX_MP),
		create_enemy("Sheep Guard", "Guard", Vector2i(6, 6), SHEEP_GUARD_MAX_HP, SHEEP_GUARD_ATTACK_DAMAGE, SHEEP_GUARD_MAX_MP),
	]


func _ready() -> void:
	reset_enemy_draw_offsets()
	setup_ui()
	add_battle_log("Sheep Dungeon Room 1 begins. Win within %d turns for challenge clear." % CHALLENGE_TURN_LIMIT)
	update_ui()
	queue_redraw()


func setup_ui() -> void:
	ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	skill_bar.add_theme_constant_override("separation", 12)

	var buttons := get_skill_buttons()
	var skills := get_skill_list()
	for index in range(buttons.size()):
		var button := buttons[index]
		button.custom_minimum_size = Vector2(142.0, 64.0)
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(select_skill.bind(skills[index]))

	log_panel.custom_minimum_size = Vector2(300.0, 230.0)
	battle_log_label.custom_minimum_size = Vector2(280.0, 210.0)
	battle_log_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info_panel.custom_minimum_size = Vector2(300.0, 210.0)
	info_label.custom_minimum_size = Vector2(280.0, 190.0)
	info_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	end_turn_button.custom_minimum_size = Vector2(140.0, 46.0)
	end_turn_button.focus_mode = Control.FOCUS_NONE
	end_turn_button.pressed.connect(end_player_turn)
	toggle_side_panel_button.custom_minimum_size = Vector2(116.0, 36.0)
	toggle_side_panel_button.focus_mode = Control.FOCUS_NONE
	toggle_side_panel_button.pressed.connect(toggle_side_panel)
	result_panel.custom_minimum_size = Vector2(260.0, 130.0)
	result_label.custom_minimum_size = Vector2(220.0, 52.0)
	result_label.add_theme_font_size_override("font_size", 30)
	restart_button.custom_minimum_size = Vector2(160.0, 42.0)
	restart_button.pressed.connect(restart_battle)

	position_ui()


func position_ui() -> void:
	var viewport_size := get_viewport_rect().size
	var skill_width := get_skill_bar_slot_size().x * float(get_skill_list().size()) + get_skill_bar_gap() * float(get_skill_list().size() - 1)
	skill_bar.position = Vector2((viewport_size.x - skill_width) * 0.5, viewport_size.y - get_skill_bar_slot_size().y - 28.0)
	toggle_side_panel_button.position = Vector2(viewport_size.x - 140.0, 24.0)
	log_panel.position = Vector2(viewport_size.x - 324.0, 24.0)
	info_panel.position = Vector2(viewport_size.x - 324.0, 270.0)
	end_turn_button.position = Vector2(skill_bar.position.x + skill_width + 18.0, skill_bar.position.y + 9.0)
	result_panel.position = Vector2((viewport_size.x - result_panel.custom_minimum_size.x) * 0.5, (viewport_size.y - result_panel.custom_minimum_size.y) * 0.5)


func get_skill_buttons() -> Array[Button]:
	return [
		slash_button,
		rend_button,
		charge_button,
		blood_strike_button,
		whirlwind_button,
	]


func _process(_delta: float) -> void:
	position_ui()
	update_floating_texts(_delta)
	update_attack_effects(_delta)
	var next_hover := world_to_grid(get_global_mouse_position())
	if next_hover != hover_grid:
		hover_grid = next_hover
		update_info_panel()
		queue_redraw()


func update_ui() -> void:
	update_skill_buttons()
	update_info_panel()
	update_battle_log()
	end_turn_button.disabled = battle_state != "player_turn" or enemy_turn_running or input_locked
	log_panel.visible = side_panel_visible
	info_panel.visible = side_panel_visible
	toggle_side_panel_button.text = "Hide Log" if side_panel_visible else "Show Log"


func toggle_side_panel() -> void:
	side_panel_visible = not side_panel_visible
	update_ui()


func update_skill_buttons() -> void:
	var buttons := get_skill_buttons()
	var skills := get_skill_list()
	for index in range(skills.size()):
		var skill := skills[index]
		var button := buttons[index]
		button.text = "%d  %s\n%s" % [index + 1, get_skill_display_name(skill), get_skill_cost_text(skill)]
		button.icon = get_skill_icon(skill)
		button.expand_icon = true
		button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
		button.disabled = battle_state != "player_turn" or enemy_turn_running or input_locked or not can_afford_skill(skill)
		if skill == selected_skill:
			button.add_theme_color_override("font_color", Color(1.0, 0.82, 0.35, 1.0))
			button.add_theme_color_override("font_pressed_color", Color(1.0, 0.82, 0.35, 1.0))
		else:
			button.remove_theme_color_override("font_color")
			button.remove_theme_color_override("font_pressed_color")


func can_afford_skill(skill: String) -> bool:
	match skill:
		SKILL_SLASH:
			return player_ap >= SLASH_AP_COST
		SKILL_REND:
			return player_ap >= REND_AP_COST
		SKILL_CHARGE:
			return player_ap >= CHARGE_AP_COST and player_mp >= CHARGE_MP_COST
		SKILL_BLOOD_STRIKE:
			return player_ap >= BLOOD_STRIKE_AP_COST
		SKILL_WHIRLWIND:
			return player_ap >= WHIRLWIND_AP_COST
	return false


func add_battle_log(text: String) -> void:
	print(text)
	battle_logs.append(text)
	while battle_logs.size() > BATTLE_LOG_LIMIT:
		battle_logs.pop_front()
	update_battle_log()


func reset_enemy_draw_offsets() -> void:
	enemy_draw_offsets.clear()
	for _enemy in enemies:
		enemy_draw_offsets.append(Vector2.ZERO)


func set_input_locked(locked: bool) -> void:
	input_locked = locked
	update_ui()


func add_floating_text(text: String, world_position: Vector2, color: Color) -> void:
	floating_texts.append({
		"text": text,
		"position": world_position,
		"age": 0.0,
		"color": color,
	})
	queue_redraw()


func update_floating_texts(delta: float) -> void:
	var changed := false
	for floating_text in floating_texts:
		floating_text.age += delta
		floating_text.position += Vector2(0.0, -28.0 * delta)
		changed = true

	for index in range(floating_texts.size() - 1, -1, -1):
		if floating_texts[index].age >= FLOATING_TEXT_DURATION:
			floating_texts.remove_at(index)
			changed = true

	if changed:
		queue_redraw()


func add_attack_effect(kind: String, grid: Vector2i, duration: float) -> void:
	attack_effects.append({
		"kind": kind,
		"grid": grid,
		"age": 0.0,
		"duration": duration,
	})
	queue_redraw()


func update_attack_effects(delta: float) -> void:
	var changed := false
	for effect in attack_effects:
		effect.age += delta
		changed = true

	for index in range(attack_effects.size() - 1, -1, -1):
		if attack_effects[index].age >= attack_effects[index].duration:
			attack_effects.remove_at(index)
			changed = true

	if changed:
		queue_redraw()


func animate_player_move(from_grid: Vector2i, to_grid: Vector2i, duration: float) -> void:
	var from_world := grid_to_world(from_grid)
	var to_world := grid_to_world(to_grid)
	player_grid = to_grid
	player_draw_offset = from_world - to_world
	await animate_offset_value("player", -1, player_draw_offset, Vector2.ZERO, duration)


func animate_enemy_move(enemy_index: int, from_grid: Vector2i, to_grid: Vector2i, duration: float) -> void:
	var from_world := grid_to_world(from_grid)
	var to_world := grid_to_world(to_grid)
	enemies[enemy_index].grid = to_grid
	enemy_draw_offsets[enemy_index] = from_world - to_world
	await animate_offset_value("enemy", enemy_index, enemy_draw_offsets[enemy_index], Vector2.ZERO, duration)


func animate_player_lunge(target_grid: Vector2i) -> void:
	var direction := (grid_to_world(target_grid) - grid_to_world(player_grid)).normalized()
	if direction == Vector2.ZERO:
		return
	var lunge_offset := direction * ATTACK_LUNGE_DISTANCE
	await animate_offset_value("player", -1, Vector2.ZERO, lunge_offset, ATTACK_LUNGE_DURATION)
	await animate_offset_value("player", -1, lunge_offset, Vector2.ZERO, ATTACK_LUNGE_DURATION)


func animate_enemy_lunge(enemy_index: int, target_grid: Vector2i) -> void:
	var direction := (grid_to_world(target_grid) - grid_to_world(enemies[enemy_index].grid)).normalized()
	if direction == Vector2.ZERO:
		return
	var lunge_offset := direction * ATTACK_LUNGE_DISTANCE
	await animate_offset_value("enemy", enemy_index, Vector2.ZERO, lunge_offset, ATTACK_LUNGE_DURATION)
	await animate_offset_value("enemy", enemy_index, lunge_offset, Vector2.ZERO, ATTACK_LUNGE_DURATION)


func animate_player_hit() -> void:
	await animate_offset_value("player", -1, Vector2(-HIT_SHAKE_DISTANCE, 0.0), Vector2(HIT_SHAKE_DISTANCE, 0.0), HIT_SHAKE_DURATION)
	await animate_offset_value("player", -1, Vector2(HIT_SHAKE_DISTANCE, 0.0), Vector2.ZERO, HIT_SHAKE_DURATION)


func animate_enemy_hit(enemy_index: int) -> void:
	if not is_enemy_alive(enemy_index):
		return
	await animate_offset_value("enemy", enemy_index, Vector2(-HIT_SHAKE_DISTANCE, 0.0), Vector2(HIT_SHAKE_DISTANCE, 0.0), HIT_SHAKE_DURATION)
	if is_enemy_alive(enemy_index):
		await animate_offset_value("enemy", enemy_index, Vector2(HIT_SHAKE_DISTANCE, 0.0), Vector2.ZERO, HIT_SHAKE_DURATION)


func animate_offset_value(target: String, enemy_index: int, from_offset: Vector2, to_offset: Vector2, duration: float) -> void:
	var elapsed := 0.0
	while elapsed < duration:
		var delta := get_process_delta_time()
		elapsed += delta
		var t := clampf(elapsed / duration, 0.0, 1.0)
		var offset := from_offset.lerp(to_offset, t)
		if target == "player":
			player_draw_offset = offset
		elif enemy_index >= 0 and enemy_index < enemy_draw_offsets.size():
			enemy_draw_offsets[enemy_index] = offset
		queue_redraw()
		await get_tree().process_frame

	if target == "player":
		player_draw_offset = to_offset
	elif enemy_index >= 0 and enemy_index < enemy_draw_offsets.size():
		enemy_draw_offsets[enemy_index] = to_offset
	queue_redraw()


func update_battle_log() -> void:
	if not is_instance_valid(battle_log_label):
		return

	battle_log_label.text = "[b]Battle Log[/b]\n"
	for line in battle_logs:
		battle_log_label.text += "%s\n" % line


func update_info_panel() -> void:
	if not is_instance_valid(info_label):
		return

	var text := "[b]Player[/b]\n"
	text += "HP: %d/%d  AP: %d/%d  MP: %d/%d\n" % [player_hp, PLAYER_MAX_HP, player_ap, PLAYER_MAX_AP, player_mp, PLAYER_MAX_MP]
	text += "Rage: %d/%d\n" % [player_rage, PLAYER_MAX_RAGE]
	text += "Skill: %s\n\n" % get_skill_display_name(selected_skill)

	var enemy_index := get_enemy_index_at(hover_grid)
	if enemy_index != -1:
		var enemy := enemies[enemy_index]
		text += "[b]%s[/b]\n" % enemy.name
		text += "Type: %s\n" % enemy.type
		text += "HP: %d/%d  Bleed: %d\n" % [enemy.hp, enemy.max_hp, enemy.bleed_turns]
		text += "ATK: %d  MP: %d\n" % [enemy.attack_damage, enemy.max_mp]
		text += "Grid: %s\n" % enemy.grid
		text += get_action_preview_text(enemy_index)
	elif is_inside_grid(hover_grid):
		text += "[b]Tile[/b]\nGrid: %s\n" % hover_grid
		if is_blocked(hover_grid):
			text += "Blocked\n"
		elif hover_grid == player_grid:
			text += "Player position\n"
		else:
			text += "Distance from player: %d\n" % get_grid_distance(player_grid, hover_grid)
	else:
		text += "[b]Hover a tile or enemy[/b]\n"

	info_label.text = text


func get_action_preview_text(enemy_index: int) -> String:
	var skill_name := get_skill_display_name(selected_skill)
	var failure_reason := get_skill_failure_reason(selected_skill, enemy_index)
	if failure_reason != "":
		return "\n[b]Preview[/b]\n%s cannot hit: %s\n" % [skill_name, failure_reason]

	return "\n[b]Preview[/b]\n%s can hit.\nDamage: %d\nCost: %s\n" % [
		skill_name,
		get_skill_preview_damage(selected_skill),
		get_skill_cost_text(selected_skill),
	]


func get_skill_preview_damage(skill: String) -> int:
	match skill:
		SKILL_SLASH:
			return SLASH_DAMAGE
		SKILL_REND:
			return REND_DAMAGE
		SKILL_CHARGE:
			return CHARGE_DAMAGE
		SKILL_BLOOD_STRIKE:
			return get_blood_strike_damage()
		SKILL_WHIRLWIND:
			return WHIRLWIND_DAMAGE
	return 0


func get_skill_failure_reason(skill: String, enemy_index: int) -> String:
	if not is_enemy_alive(enemy_index):
		return "enemy is already defeated"

	match skill:
		SKILL_SLASH:
			if player_ap < SLASH_AP_COST:
				return "not enough AP"
			if not is_adjacent(player_grid, enemies[enemy_index].grid):
				return "enemy is not adjacent"
		SKILL_REND:
			if player_ap < REND_AP_COST:
				return "not enough AP"
			if not is_adjacent(player_grid, enemies[enemy_index].grid):
				return "enemy is not adjacent"
		SKILL_CHARGE:
			return get_charge_failure_reason(enemy_index)
		SKILL_BLOOD_STRIKE:
			if player_ap < BLOOD_STRIKE_AP_COST:
				return "not enough AP"
			if not is_adjacent(player_grid, enemies[enemy_index].grid):
				return "enemy is not adjacent"
		SKILL_WHIRLWIND:
			if player_ap < WHIRLWIND_AP_COST:
				return "not enough AP"
			if not is_in_whirlwind_range(enemies[enemy_index].grid):
				return "enemy is not in the surrounding 8 tiles"

	return ""


func show_battle_result(result_text: String) -> void:
	if result_text == "Victory":
		var challenge_text := "Challenge clear" if turn_count <= CHALLENGE_TURN_LIMIT else "Challenge missed"
		result_label.text = "Victory\nTurns: %d\n%s: win within %d turns" % [turn_count, challenge_text, CHALLENGE_TURN_LIMIT]
	elif result_text == "Defeat":
		result_label.text = "Defeat\nTurns: %d" % turn_count
	else:
		result_label.text = result_text
	result_panel.visible = true
	update_ui()
	queue_redraw()


func restart_battle() -> void:
	player_grid = Vector2i(2, 2)
	player_hp = PLAYER_MAX_HP
	player_ap = PLAYER_MAX_AP
	player_mp = PLAYER_MAX_MP
	player_rage = 0
	player_selected = false
	skill_targeting = false
	selected_skill = SKILL_SLASH
	hover_grid = Vector2i(-1, -1)
	battle_state = "player_turn"
	turn_count = 1
	enemy_turn_running = false
	input_locked = false
	player_draw_offset = Vector2.ZERO
	floating_texts.clear()
	attack_effects.clear()
	enemies = create_room_enemies()
	reset_enemy_draw_offsets()
	battle_logs.clear()
	result_panel.visible = false
	add_battle_log("Battle restarted. Win within %d turns for challenge clear." % CHALLENGE_TURN_LIMIT)
	update_ui()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if input_locked:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_handle_left_click()
	elif event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1:
				select_skill(SKILL_SLASH)
			KEY_2:
				select_skill(SKILL_REND)
			KEY_3:
				select_skill(SKILL_CHARGE)
			KEY_4:
				select_skill(SKILL_BLOOD_STRIKE)
			KEY_5:
				select_skill(SKILL_WHIRLWIND)
			KEY_SPACE:
				end_player_turn()


func _handle_left_click() -> void:
	if input_locked:
		return
	if battle_state != "player_turn":
		add_battle_log("Input ignored. Current state: %s" % battle_state)
		return

	if not is_inside_grid(hover_grid):
		player_selected = false
		add_battle_log("Clicked outside grid.")
		queue_redraw()
		return

	print("Clicked grid: ", hover_grid)
	var enemy_index := get_enemy_index_at(hover_grid)

	if hover_grid == player_grid:
		player_selected = not player_selected
		skill_targeting = false
		queue_redraw()
		return

	if enemy_index != -1 and (player_selected or skill_targeting):
		try_use_selected_skill_on_enemy(enemy_index)
		queue_redraw()
		return

	if player_selected and can_player_move_to(hover_grid):
		move_player_to_grid(hover_grid)
		return

	if is_blocked(hover_grid):
		add_battle_log("Blocked tile: %s" % hover_grid)
	elif enemy_index != -1:
		add_battle_log("Enemy tile. Click a skill first or select the player.")
	elif player_selected:
		add_battle_log("Tile is outside movement range: %s" % hover_grid)

	queue_redraw()


func move_player_to_grid(target_grid: Vector2i) -> void:
	var from_grid := player_grid
	var distance := get_grid_distance(from_grid, target_grid)
	player_selected = false
	skill_targeting = false
	set_input_locked(true)
	await animate_player_move(from_grid, target_grid, MOVE_ANIMATION_DURATION)
	player_mp -= distance
	add_battle_log("Player moved to %s. MP left: %d" % [player_grid, player_mp])
	set_input_locked(false)
	update_ui()
	queue_redraw()


func select_skill(skill: String) -> void:
	if battle_state != "player_turn" or input_locked:
		return

	selected_skill = skill
	skill_targeting = true
	add_battle_log("Selected skill: %s" % get_skill_display_name(selected_skill))
	update_ui()
	queue_redraw()


func try_use_selected_skill_on_enemy(enemy_index: int) -> void:
	if input_locked:
		return

	match selected_skill:
		SKILL_SLASH:
			try_slash(enemy_index)
		SKILL_REND:
			try_rend(enemy_index)
		SKILL_CHARGE:
			try_charge(enemy_index)
		SKILL_BLOOD_STRIKE:
			try_blood_strike(enemy_index)
		SKILL_WHIRLWIND:
			try_whirlwind(enemy_index)


func try_slash(enemy_index: int) -> void:
	var enemy := enemies[enemy_index]
	if not is_adjacent(player_grid, enemy.grid):
		add_battle_log("Slash failed: enemy is not adjacent.")
		return
	if player_ap < SLASH_AP_COST:
		add_battle_log("Slash failed: not enough AP. AP left: %d" % player_ap)
		return

	set_input_locked(true)
	await animate_player_lunge(enemy.grid)
	player_ap -= SLASH_AP_COST
	damage_enemy(enemy_index, SLASH_DAMAGE, "Slash")
	await animate_enemy_hit(enemy_index)
	add_player_rage(SLASH_RAGE_GAIN, "Slash hit")
	finish_player_action()
	set_input_locked(false)


func try_rend(enemy_index: int) -> void:
	var enemy := enemies[enemy_index]
	if not is_adjacent(player_grid, enemy.grid):
		add_battle_log("Rend failed: enemy is not adjacent.")
		return
	if player_ap < REND_AP_COST:
		add_battle_log("Rend failed: not enough AP. AP left: %d" % player_ap)
		return

	set_input_locked(true)
	await animate_player_lunge(enemy.grid)
	player_ap -= REND_AP_COST
	damage_enemy(enemy_index, REND_DAMAGE, "Rend")
	await animate_enemy_hit(enemy_index)
	if is_enemy_alive(enemy_index):
		enemies[enemy_index].bleed_turns = REND_BLEED_TURNS
		add_battle_log("%s is bleeding for %d turns." % [enemies[enemy_index].name, enemies[enemy_index].bleed_turns])
	add_player_rage(REND_RAGE_GAIN, "Rend hit")
	finish_player_action()
	set_input_locked(false)


func try_charge(enemy_index: int) -> void:
	var failure_reason := get_charge_failure_reason(enemy_index)
	if failure_reason != "":
		add_battle_log("Charge failed: %s" % failure_reason)
		return

	set_input_locked(true)
	var from_grid := player_grid
	var landing_grid := get_charge_landing_grid(enemy_index)
	await animate_player_move(from_grid, landing_grid, CHARGE_ANIMATION_DURATION)
	player_ap -= CHARGE_AP_COST
	player_mp -= CHARGE_MP_COST
	add_battle_log("Player charges to %s. AP: %d MP: %d" % [player_grid, player_ap, player_mp])
	damage_enemy(enemy_index, CHARGE_DAMAGE, "Charge")
	await animate_enemy_hit(enemy_index)
	add_player_rage(CHARGE_RAGE_GAIN, "Charge hit")
	finish_player_action()
	set_input_locked(false)


func try_blood_strike(enemy_index: int) -> void:
	var enemy := enemies[enemy_index]
	if not is_adjacent(player_grid, enemy.grid):
		add_battle_log("Blood Strike failed: enemy is not adjacent.")
		return
	if player_ap < BLOOD_STRIKE_AP_COST:
		add_battle_log("Blood Strike failed: not enough AP. AP left: %d" % player_ap)
		return

	set_input_locked(true)
	await animate_player_lunge(enemy.grid)
	var damage := get_blood_strike_damage()
	player_ap -= BLOOD_STRIKE_AP_COST
	damage_enemy(enemy_index, damage, "Blood Strike")
	await animate_enemy_hit(enemy_index)
	add_player_rage(BLOOD_STRIKE_RAGE_GAIN, "Blood Strike hit")
	finish_player_action()
	set_input_locked(false)


func try_whirlwind(enemy_index: int) -> void:
	var enemy := enemies[enemy_index]
	if player_ap < WHIRLWIND_AP_COST:
		add_battle_log("Whirlwind failed: not enough AP. AP left: %d" % player_ap)
		return
	if not is_in_whirlwind_range(enemy.grid):
		add_battle_log("Whirlwind failed: enemy is not in the surrounding 8 tiles.")
		return

	set_input_locked(true)
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var effect_grid := player_grid + Vector2i(dx, dy)
			if is_inside_grid(effect_grid):
				add_attack_effect("whirlwind", effect_grid, WHIRLWIND_EFFECT_DURATION)
	await get_tree().create_timer(WHIRLWIND_EFFECT_DURATION).timeout
	player_ap -= WHIRLWIND_AP_COST
	var targets: Array[int] = get_whirlwind_target_indices()
	add_battle_log("Whirlwind hits %d enemies." % targets.size())
	for target_index in targets:
		damage_enemy(target_index, WHIRLWIND_DAMAGE, "Whirlwind")
		await animate_enemy_hit(target_index)
	add_player_rage(WHIRLWIND_RAGE_GAIN * targets.size(), "Whirlwind hit")
	finish_player_action()
	set_input_locked(false)


func finish_player_action() -> void:
	player_selected = false
	skill_targeting = false
	update_ui()
	queue_redraw()


func get_blood_strike_damage() -> int:
	var bonus_steps := floori(float(player_rage) / float(BLOOD_STRIKE_RAGE_STEP))
	var multiplier := 1.0 + float(bonus_steps) * BLOOD_STRIKE_RAGE_BONUS
	return int(round(float(BLOOD_STRIKE_BASE_DAMAGE) * multiplier))


func damage_enemy(enemy_index: int, amount: int, source: String) -> void:
	if not is_enemy_alive(enemy_index):
		return

	enemies[enemy_index].hp -= amount
	add_battle_log("%s deals %d damage to %s. HP: %d" % [source, amount, enemies[enemy_index].name, max(enemies[enemy_index].hp, 0)])
	add_floating_text("-%d" % amount, grid_to_world(enemies[enemy_index].grid) + Vector2(0.0, -74.0), Color(1.0, 0.34, 0.22, 1.0))
	if enemies[enemy_index].hp <= 0:
		defeat_enemy(enemy_index)


func defeat_enemy(enemy_index: int) -> void:
	enemies[enemy_index].hp = 0
	enemies[enemy_index].alive = false
	enemies[enemy_index].bleed_turns = 0
	add_player_rage(HIT_KILL_RAGE_GAIN, "Enemy defeated")
	add_battle_log("%s defeated." % enemies[enemy_index].name)

	if are_all_enemies_defeated():
		battle_state = "battle_over"
		player_selected = false
		skill_targeting = false
		show_battle_result("Victory")
		add_battle_log("Victory! All enemies defeated.")


func add_player_rage(amount: int, reason: String) -> void:
	player_rage = mini(PLAYER_MAX_RAGE, player_rage + amount)
	add_battle_log("%s rage +%d. Rage: %d/%d" % [reason, amount, player_rage, PLAYER_MAX_RAGE])
	add_floating_text("+%d Rage" % amount, grid_to_world(player_grid) + Vector2(0.0, -84.0), Color(1.0, 0.74, 0.24, 1.0))


func end_player_turn() -> void:
	if battle_state != "player_turn" or enemy_turn_running or input_locked:
		return

	player_selected = false
	skill_targeting = false
	set_input_locked(true)
	battle_state = "enemy_turn"
	add_battle_log("Player turn ended.")
	update_ui()
	queue_redraw()

	perform_enemy_turns()



func begin_player_turn() -> void:
	battle_state = "player_turn"
	turn_count += 1
	player_ap = PLAYER_MAX_AP
	player_mp = PLAYER_MAX_MP
	add_battle_log("Turn %d begins. AP: %d MP: %d" % [turn_count, player_ap, player_mp])
	set_input_locked(false)
	update_ui()
	queue_redraw()


func perform_enemy_turns() -> void:
	perform_enemy_turns_async()


func perform_enemy_turns_async() -> void:
	enemy_turn_running = true
	set_input_locked(true)
	update_ui()

	for enemy_index in range(enemies.size()):
		if battle_state == "battle_over":
			enemy_turn_running = false
			set_input_locked(false)
			update_ui()
			return
		if not is_enemy_alive(enemy_index):
			continue

		await get_tree().create_timer(ENEMY_ACTION_DELAY).timeout
		resolve_enemy_bleed(enemy_index)
		if battle_state == "battle_over":
			enemy_turn_running = false
			set_input_locked(false)
			update_ui()
			return
		if not is_enemy_alive(enemy_index):
			continue

		await get_tree().create_timer(ENEMY_ACTION_DELAY).timeout
		if is_adjacent(enemies[enemy_index].grid, player_grid):
			var attack_damage: int = enemies[enemy_index].attack_damage
			await animate_enemy_lunge(enemy_index, player_grid)
			player_hp -= attack_damage
			add_player_rage(DAMAGED_RAGE_GAIN, "Took damage")
			add_floating_text("-%d" % attack_damage, grid_to_world(player_grid) + Vector2(0.0, -74.0), Color(1.0, 0.34, 0.22, 1.0))
			add_battle_log("%s attacks player for %d damage. Player HP: %d" % [enemies[enemy_index].name, attack_damage, max(player_hp, 0)])
			await animate_player_hit()
			if player_hp <= 0:
				player_hp = 0
				battle_state = "battle_over"
				show_battle_result("Defeat")
				add_battle_log("Defeat. Player was defeated.")
			continue

		await move_enemy_toward_player(enemy_index)
		queue_redraw()

	enemy_turn_running = false
	if battle_state != "battle_over":
		begin_player_turn()
	else:
		set_input_locked(false)
		update_ui()


func resolve_enemy_bleed(enemy_index: int) -> void:
	if enemies[enemy_index].bleed_turns <= 0:
		return

	enemies[enemy_index].bleed_turns -= 1
	damage_enemy(enemy_index, REND_BLEED_DAMAGE, "Bleed")
	if is_enemy_alive(enemy_index):
		add_battle_log("%s bleed turns left: %d" % [enemies[enemy_index].name, enemies[enemy_index].bleed_turns])


func move_enemy_toward_player(enemy_index: int) -> void:
	var steps: int = enemies[enemy_index].max_mp
	while steps > 0 and not is_adjacent(enemies[enemy_index].grid, player_grid):
		var next_grid := get_best_enemy_step(enemy_index)
		if next_grid == enemies[enemy_index].grid:
			break
		var from_grid: Vector2i = enemies[enemy_index].grid
		await animate_enemy_move(enemy_index, from_grid, next_grid, MOVE_ANIMATION_DURATION)
		steps -= 1

	add_battle_log("%s moved to %s" % [enemies[enemy_index].name, enemies[enemy_index].grid])


func get_best_enemy_step(enemy_index: int) -> Vector2i:
	var directions: Array[Vector2i] = [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1),
	]
	var best_grid: Vector2i = enemies[enemy_index].grid
	var best_distance := get_grid_distance(enemies[enemy_index].grid, player_grid)

	for direction in directions:
		var candidate: Vector2i = enemies[enemy_index].grid + direction
		if not can_enemy_move_to(enemy_index, candidate):
			continue
		var distance := get_grid_distance(candidate, player_grid)
		if distance < best_distance:
			best_distance = distance
			best_grid = candidate

	return best_grid


func get_charge_failure_reason(enemy_index: int) -> String:
	if not is_enemy_alive(enemy_index):
		return "enemy is already defeated"
	if player_ap < CHARGE_AP_COST:
		return "not enough AP. AP left: %d" % player_ap
	if player_mp < CHARGE_MP_COST:
		return "not enough MP. MP left: %d" % player_mp
	if not is_straight_line(player_grid, enemies[enemy_index].grid):
		return "target is not in a straight row or column"

	var distance := get_grid_distance(player_grid, enemies[enemy_index].grid)
	if distance < CHARGE_MIN_RANGE or distance > CHARGE_MAX_RANGE:
		return "target distance must be %d-%d tiles. Current distance: %d" % [CHARGE_MIN_RANGE, CHARGE_MAX_RANGE, distance]

	var landing_grid := get_charge_landing_grid(enemy_index)
	if landing_grid == player_grid:
		return "already adjacent; use Slash or Rend"
	if not is_inside_grid(landing_grid):
		return "landing tile is outside the map"
	if is_blocked(landing_grid):
		return "landing tile is blocked"
	if get_enemy_index_at(landing_grid) != -1:
		return "landing tile is occupied"

	for path_grid in get_charge_path_tiles(enemy_index):
		if is_blocked(path_grid):
			return "path is blocked at %s" % path_grid
		var occupant := get_enemy_index_at(path_grid)
		if occupant != -1 and occupant != enemy_index:
			return "path is occupied at %s" % path_grid

	return ""


func get_charge_landing_grid(enemy_index: int) -> Vector2i:
	var direction := get_grid_direction(player_grid, enemies[enemy_index].grid)
	return enemies[enemy_index].grid - direction


func get_charge_path_tiles(enemy_index: int) -> Array[Vector2i]:
	var path: Array[Vector2i] = []
	var direction := get_grid_direction(player_grid, enemies[enemy_index].grid)
	var current := player_grid + direction
	var landing := get_charge_landing_grid(enemy_index)

	while current != enemies[enemy_index].grid:
		path.append(current)
		if current == landing:
			break
		current += direction

	return path


func is_straight_line(from_grid: Vector2i, to_grid: Vector2i) -> bool:
	return from_grid.x == to_grid.x or from_grid.y == to_grid.y


func get_grid_direction(from_grid: Vector2i, to_grid: Vector2i) -> Vector2i:
	var delta := to_grid - from_grid
	if delta.x != 0:
		return Vector2i(1 if delta.x > 0 else -1, 0)
	if delta.y != 0:
		return Vector2i(0, 1 if delta.y > 0 else -1)
	return Vector2i.ZERO


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), Color(0.12, 0.15, 0.17, 1.0), true)
	draw_grid()
	draw_attack_effects()
	draw_enemies()
	draw_player()
	draw_floating_texts()
	draw_hud()


func draw_grid() -> void:
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			var grid := Vector2i(x, y)
			var center := grid_to_world(grid)
			var points := get_tile_points(center)
			var base_color := COLOR_TILE if (x + y) % 2 == 0 else COLOR_TILE_ALT
			var overlay_color := Color.TRANSPARENT
			var enemy_index := get_enemy_index_at(grid)

			if is_blocked(grid):
				base_color = COLOR_BLOCKED
			elif is_player_aiming() and selected_skill == SKILL_WHIRLWIND and is_in_whirlwind_range(grid):
				overlay_color = COLOR_ATTACK
			elif is_player_aiming() and enemy_index != -1 and can_selected_skill_target_enemy(enemy_index):
				overlay_color = get_selected_skill_target_color()
			elif player_selected and can_player_move_to(grid):
				overlay_color = COLOR_MOVE

			draw_colored_polygon(points, base_color)
			draw_texture_centered(TEX_GRASS_TILE, center, Vector2(TILE_WIDTH, TILE_HEIGHT))
			if overlay_color.a > 0.0:
				draw_colored_polygon(points, overlay_color)
			if is_blocked(grid):
				draw_texture_centered(TEX_STONE_OBSTACLE, center + Vector2(0.0, -26.0), Vector2(72.0, 72.0))
			draw_polyline(close_points(points), COLOR_TILE_LINE, 1.0, true)

	if is_inside_grid(hover_grid):
		var hover_points := get_tile_points(grid_to_world(hover_grid))
		draw_colored_polygon(hover_points, COLOR_HOVER)
		draw_polyline(close_points(hover_points), Color.WHITE, 2.0, true)

	if player_selected:
		draw_colored_polygon(get_tile_points(grid_to_world(player_grid)), COLOR_SELECTED)


func draw_player() -> void:
	var center := grid_to_world(player_grid) + player_draw_offset
	draw_texture_centered(TEX_PLAYER, center + Vector2(0.0, -32.0), Vector2(82.0, 82.0))
	draw_health_bar(center + Vector2(0.0, -58.0), player_hp, PLAYER_MAX_HP, 54.0)


func draw_enemies() -> void:
	for enemy_index in range(enemies.size()):
		if not is_enemy_alive(enemy_index):
			continue

		var center := grid_to_world(enemies[enemy_index].grid) + get_enemy_draw_offset(enemy_index)
		draw_texture_centered(get_enemy_texture(enemies[enemy_index]), center + Vector2(0.0, -30.0), Vector2(76.0, 76.0))
		draw_string(ThemeDB.fallback_font, center + Vector2(-22.0, -42.0), "%d" % enemies[enemy_index].hp, HORIZONTAL_ALIGNMENT_CENTER, 44.0, 13, COLOR_TEXT)
		draw_health_bar(center + Vector2(0.0, -58.0), enemies[enemy_index].hp, enemies[enemy_index].max_hp, 48.0)


func draw_hud() -> void:
	var pos := Vector2(24.0, 24.0)
	draw_string(ThemeDB.fallback_font, pos, "Isometric Tactics Prototype", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 22, COLOR_TEXT)
	draw_string(ThemeDB.fallback_font, pos + Vector2(0.0, 32.0), "Sheep Dungeon Room 1 | Goal: defeat all enemies | Challenge: win within %d turns" % CHALLENGE_TURN_LIMIT, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, COLOR_TEXT_DIM)
	draw_string(ThemeDB.fallback_font, pos + Vector2(0.0, 58.0), "Turn: %d | State: %s | Skill: %s | Player HP: %d AP: %d/%d MP: %d/%d Rage: %d/%d" % [turn_count, battle_state, get_skill_display_name(selected_skill), player_hp, player_ap, PLAYER_MAX_AP, player_mp, PLAYER_MAX_MP, player_rage, PLAYER_MAX_RAGE], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, COLOR_TEXT_DIM)
	draw_string(ThemeDB.fallback_font, pos + Vector2(0.0, 84.0), "Enemies alive: %d/%d | Hover: %s" % [get_alive_enemy_count(), enemies.size(), hover_grid], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, COLOR_TEXT_DIM)


func draw_health_bar(center: Vector2, hp: int, max_hp: int, width: float) -> void:
	var height := 7.0
	var top_left := center - Vector2(width * 0.5, height * 0.5)
	var ratio := clampf(float(hp) / float(max_hp), 0.0, 1.0)
	var fill_color := COLOR_HP_FILL if ratio > 0.35 else COLOR_HP_LOW
	draw_rect(Rect2(top_left, Vector2(width, height)), COLOR_HP_BACK, true)
	draw_rect(Rect2(top_left, Vector2(width * ratio, height)), fill_color, true)
	draw_rect(Rect2(top_left, Vector2(width, height)), Color(0.02, 0.02, 0.02, 1.0), false, 1.0)


func draw_texture_centered(texture: Texture2D, center: Vector2, size: Vector2) -> void:
	draw_texture_rect(texture, Rect2(center - size * 0.5, size), false)


func get_enemy_draw_offset(enemy_index: int) -> Vector2:
	if enemy_index >= 0 and enemy_index < enemy_draw_offsets.size():
		return enemy_draw_offsets[enemy_index]
	return Vector2.ZERO


func draw_attack_effects() -> void:
	for effect in attack_effects:
		var duration: float = effect.duration
		var age: float = effect.age
		var alpha := 1.0 - clampf(age / duration, 0.0, 1.0)
		if effect.kind == "whirlwind":
			var center := grid_to_world(effect.grid)
			var points := get_tile_points(center)
			draw_colored_polygon(points, Color(1.0, 0.18, 0.08, 0.28 * alpha))
			draw_polyline(close_points(points), Color(1.0, 0.72, 0.20, alpha), 3.0, true)


func draw_floating_texts() -> void:
	for floating_text in floating_texts:
		var alpha := 1.0 - clampf(float(floating_text.age) / FLOATING_TEXT_DURATION, 0.0, 1.0)
		var color: Color = floating_text.color
		color.a = alpha
		draw_string(ThemeDB.fallback_font, floating_text.position, floating_text.text, HORIZONTAL_ALIGNMENT_CENTER, 110.0, 18, color)


func get_skill_list() -> Array[String]:
	return [
		SKILL_SLASH,
		SKILL_REND,
		SKILL_CHARGE,
		SKILL_BLOOD_STRIKE,
		SKILL_WHIRLWIND,
	]


func get_skill_bar_slot_size() -> Vector2:
	return Vector2(142.0, 64.0)


func get_skill_bar_gap() -> float:
	return 12.0


func grid_to_world(grid: Vector2i) -> Vector2:
	return Vector2(
		(float(grid.x) - float(grid.y)) * TILE_WIDTH * 0.5,
		(float(grid.x) + float(grid.y)) * TILE_HEIGHT * 0.5
	) + GRID_ORIGIN


func world_to_grid(world_position: Vector2) -> Vector2i:
	var local := world_position - GRID_ORIGIN
	var grid_x := (local.x / (TILE_WIDTH * 0.5) + local.y / (TILE_HEIGHT * 0.5)) * 0.5
	var grid_y := (local.y / (TILE_HEIGHT * 0.5) - local.x / (TILE_WIDTH * 0.5)) * 0.5
	var candidate := Vector2i(floori(grid_x), floori(grid_y))

	if is_inside_grid(candidate) and point_in_tile(world_position, candidate):
		return candidate

	var best := Vector2i(-1, -1)
	var best_distance := INF
	for y in range(maxi(0, candidate.y - 1), mini(GRID_HEIGHT, candidate.y + 3)):
		for x in range(maxi(0, candidate.x - 1), mini(GRID_WIDTH, candidate.x + 3)):
			var grid := Vector2i(x, y)
			if point_in_tile(world_position, grid):
				var distance := world_position.distance_squared_to(grid_to_world(grid))
				if distance < best_distance:
					best_distance = distance
					best = grid

	return best


func point_in_tile(point: Vector2, grid: Vector2i) -> bool:
	var center := grid_to_world(grid)
	var local := point - center
	return absf(local.x) / (TILE_WIDTH * 0.5) + absf(local.y) / (TILE_HEIGHT * 0.5) <= 1.0


func get_tile_points(center: Vector2) -> PackedVector2Array:
	return PackedVector2Array([
		center + Vector2(0.0, -TILE_HEIGHT * 0.5),
		center + Vector2(TILE_WIDTH * 0.5, 0.0),
		center + Vector2(0.0, TILE_HEIGHT * 0.5),
		center + Vector2(-TILE_WIDTH * 0.5, 0.0),
	])


func close_points(points: PackedVector2Array) -> PackedVector2Array:
	var closed := PackedVector2Array(points)
	if points.size() > 0:
		closed.append(points[0])
	return closed


func get_ellipse_points(center: Vector2, radius: Vector2, segments: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index in range(segments):
		var angle := TAU * float(index) / float(segments)
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	return points


func is_inside_grid(grid: Vector2i) -> bool:
	return grid.x >= 0 and grid.y >= 0 and grid.x < GRID_WIDTH and grid.y < GRID_HEIGHT


func is_blocked(grid: Vector2i) -> bool:
	return blocked_tiles.has(grid)


func can_player_move_to(grid: Vector2i) -> bool:
	if battle_state != "player_turn":
		return false
	if not is_inside_grid(grid):
		return false
	if is_blocked(grid):
		return false
	if grid == player_grid:
		return false
	if get_enemy_index_at(grid) != -1:
		return false

	return get_grid_distance(player_grid, grid) <= player_mp


func can_enemy_move_to(enemy_index: int, grid: Vector2i) -> bool:
	if not is_inside_grid(grid):
		return false
	if is_blocked(grid):
		return false
	if grid == player_grid:
		return false

	var occupant := get_enemy_index_at(grid)
	return occupant == -1 or occupant == enemy_index


func can_selected_skill_target_enemy(enemy_index: int) -> bool:
	match selected_skill:
		SKILL_SLASH:
			return is_enemy_alive(enemy_index) and is_adjacent(player_grid, enemies[enemy_index].grid) and player_ap >= SLASH_AP_COST
		SKILL_REND:
			return is_enemy_alive(enemy_index) and is_adjacent(player_grid, enemies[enemy_index].grid) and player_ap >= REND_AP_COST
		SKILL_CHARGE:
			return is_enemy_alive(enemy_index) and get_charge_failure_reason(enemy_index) == ""
		SKILL_BLOOD_STRIKE:
			return is_enemy_alive(enemy_index) and is_adjacent(player_grid, enemies[enemy_index].grid) and player_ap >= BLOOD_STRIKE_AP_COST
		SKILL_WHIRLWIND:
			return is_enemy_alive(enemy_index) and is_in_whirlwind_range(enemies[enemy_index].grid) and player_ap >= WHIRLWIND_AP_COST
	return false


func is_player_aiming() -> bool:
	return battle_state == "player_turn" and (player_selected or skill_targeting)


func get_selected_skill_target_color() -> Color:
	if selected_skill == SKILL_CHARGE:
		return COLOR_CHARGE
	return COLOR_ATTACK


func get_skill_display_name(skill: String) -> String:
	match skill:
		SKILL_SLASH:
			return "Slash"
		SKILL_REND:
			return "Rend"
		SKILL_CHARGE:
			return "Charge"
		SKILL_BLOOD_STRIKE:
			return "Blood Strike"
		SKILL_WHIRLWIND:
			return "Whirlwind"
	return "Unknown"


func get_skill_icon(skill: String) -> Texture2D:
	match skill:
		SKILL_SLASH:
			return TEX_SLASH_ICON
		SKILL_REND:
			return TEX_REND_ICON
		SKILL_CHARGE:
			return TEX_CHARGE_ICON
		SKILL_BLOOD_STRIKE:
			return TEX_BLOOD_STRIKE_ICON
		SKILL_WHIRLWIND:
			return TEX_WHIRLWIND_ICON
	return TEX_SLASH_ICON


func get_enemy_texture(enemy: Dictionary) -> Texture2D:
	if enemy.type == "Guard":
		return TEX_SHEEP_GUARD
	return TEX_LAMB


func get_skill_cost_text(skill: String) -> String:
	match skill:
		SKILL_SLASH:
			return "%d AP | %d dmg" % [SLASH_AP_COST, SLASH_DAMAGE]
		SKILL_REND:
			return "%d AP | %d + bleed" % [REND_AP_COST, REND_DAMAGE]
		SKILL_CHARGE:
			return "%d AP %d MP | %d dmg" % [CHARGE_AP_COST, CHARGE_MP_COST, CHARGE_DAMAGE]
		SKILL_BLOOD_STRIKE:
			return "%d AP | %d+ rage" % [BLOOD_STRIKE_AP_COST, BLOOD_STRIKE_BASE_DAMAGE]
		SKILL_WHIRLWIND:
			return "%d AP | AOE %d" % [WHIRLWIND_AP_COST, WHIRLWIND_DAMAGE]
	return ""


func is_in_whirlwind_range(grid: Vector2i) -> bool:
	if grid == player_grid:
		return false
	var dx := absi(grid.x - player_grid.x)
	var dy := absi(grid.y - player_grid.y)
	return dx <= 1 and dy <= 1


func get_whirlwind_target_indices() -> Array[int]:
	var targets: Array[int] = []
	for enemy_index in range(enemies.size()):
		if is_enemy_alive(enemy_index) and is_in_whirlwind_range(enemies[enemy_index].grid):
			targets.append(enemy_index)
	return targets


func is_enemy_alive(enemy_index: int) -> bool:
	return enemy_index >= 0 and enemy_index < enemies.size() and enemies[enemy_index].alive


func get_enemy_index_at(grid: Vector2i) -> int:
	for enemy_index in range(enemies.size()):
		if is_enemy_alive(enemy_index) and enemies[enemy_index].grid == grid:
			return enemy_index
	return -1


func get_alive_enemy_count() -> int:
	var count := 0
	for enemy_index in range(enemies.size()):
		if is_enemy_alive(enemy_index):
			count += 1
	return count


func are_all_enemies_defeated() -> bool:
	return get_alive_enemy_count() == 0


func is_adjacent(from_grid: Vector2i, to_grid: Vector2i) -> bool:
	return get_grid_distance(from_grid, to_grid) == 1


func get_grid_distance(from_grid: Vector2i, to_grid: Vector2i) -> int:
	return absi(to_grid.x - from_grid.x) + absi(to_grid.y - from_grid.y)
