extends Node

signal battle_log_changed
signal state_changed

const GRID_WIDTH := 10
const GRID_HEIGHT := 10
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

const BATTLE_STATE_PLAYER_TURN := "player_turn"
const BATTLE_STATE_ENEMY_TURN := "enemy_turn"
const BATTLE_STATE_BATTLE_OVER := "battle_over"

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

var player_grid: Vector2i = Vector2i(2, 2)
var player_hp: int = PLAYER_MAX_HP
var player_ap: int = PLAYER_MAX_AP
var player_mp: int = PLAYER_MAX_MP
var player_rage: int = 0
var player_selected: bool = false
var skill_targeting: bool = false
var selected_skill: String = SKILL_SLASH
var hover_grid: Vector2i = Vector2i(-1, -1)
var battle_state: String = BATTLE_STATE_PLAYER_TURN
var turn_count: int = 1
var battle_logs: Array[String] = []
var enemy_turn_running: bool = false
var input_locked: bool = false
var side_panel_visible: bool = true

var enemies: Array[Dictionary] = create_room_enemies()

var blocked_tiles: Array[Vector2i] = [
	Vector2i(4, 3),
	Vector2i(4, 4),
	Vector2i(5, 4),
	Vector2i(5, 5),
	Vector2i(3, 6),
	Vector2i(6, 2),
]


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
		create_enemy("小羊甲", "Lamb", Vector2i(6, 3), ENEMY_MAX_HP, ENEMY_ATTACK_DAMAGE, ENEMY_MAX_MP),
		create_enemy("小羊乙", "Lamb", Vector2i(8, 5), ENEMY_MAX_HP, ENEMY_ATTACK_DAMAGE, ENEMY_MAX_MP),
		create_enemy("羊卫士", "Guard", Vector2i(6, 6), SHEEP_GUARD_MAX_HP, SHEEP_GUARD_ATTACK_DAMAGE, SHEEP_GUARD_MAX_MP),
	]


func reset_battle() -> void:
	player_grid = Vector2i(2, 2)
	player_hp = PLAYER_MAX_HP
	player_ap = PLAYER_MAX_AP
	player_mp = PLAYER_MAX_MP
	player_rage = 0
	player_selected = false
	skill_targeting = false
	selected_skill = SKILL_SLASH
	hover_grid = Vector2i(-1, -1)
	battle_state = BATTLE_STATE_PLAYER_TURN
	turn_count = 1
	enemy_turn_running = false
	input_locked = false
	enemies = create_room_enemies()
	battle_logs.clear()
	state_changed.emit()
	battle_log_changed.emit()


func set_input_locked(locked: bool) -> void:
	input_locked = locked
	state_changed.emit()


func add_battle_log(text: String) -> void:
	print(text)
	battle_logs.append(text)
	while battle_logs.size() > BATTLE_LOG_LIMIT:
		battle_logs.pop_front()
	battle_log_changed.emit()


func set_hover_grid(grid: Vector2i) -> void:
	hover_grid = grid
	state_changed.emit()


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


func get_skill_list() -> Array[String]:
	return [
		SKILL_SLASH,
		SKILL_REND,
		SKILL_CHARGE,
		SKILL_BLOOD_STRIKE,
		SKILL_WHIRLWIND,
	]


func get_skill_display_name(skill: String) -> String:
	if skill == SKILL_SLASH:
		return "斩击"
	if skill == SKILL_REND:
		return "撕裂"
	if skill == SKILL_CHARGE:
		return "冲锋"
	if skill == SKILL_BLOOD_STRIKE:
		return "血怒斩"
	if skill == SKILL_WHIRLWIND:
		return "旋风斩"
	return "未知"


func get_battle_state_display_name() -> String:
	if battle_state == BATTLE_STATE_PLAYER_TURN:
		return "玩家回合"
	if battle_state == BATTLE_STATE_ENEMY_TURN:
		return "敌方回合"
	if battle_state == BATTLE_STATE_BATTLE_OVER:
		return "战斗结束"
	return "未知"


func get_enemy_type_display_name(enemy: Dictionary) -> String:
	if enemy.type == "Guard":
		return "羊卫士"
	return "小羊"


func get_skill_icon(skill: String) -> Texture2D:
	if skill == SKILL_SLASH:
		return TEX_SLASH_ICON
	if skill == SKILL_REND:
		return TEX_REND_ICON
	if skill == SKILL_CHARGE:
		return TEX_CHARGE_ICON
	if skill == SKILL_BLOOD_STRIKE:
		return TEX_BLOOD_STRIKE_ICON
	if skill == SKILL_WHIRLWIND:
		return TEX_WHIRLWIND_ICON
	return TEX_SLASH_ICON


func get_enemy_texture(enemy: Dictionary) -> Texture2D:
	if enemy.type == "Guard":
		return TEX_SHEEP_GUARD
	return TEX_LAMB


func get_skill_cost_text(skill: String) -> String:
	if skill == SKILL_SLASH:
		return "%d行动 | %d伤" % [SLASH_AP_COST, SLASH_DAMAGE]
	if skill == SKILL_REND:
		return "%d行动 | %d+流血" % [REND_AP_COST, REND_DAMAGE]
	if skill == SKILL_CHARGE:
		return "%d行动 %d移动 | %d伤" % [CHARGE_AP_COST, CHARGE_MP_COST, CHARGE_DAMAGE]
	if skill == SKILL_BLOOD_STRIKE:
		return "%d行动 | %d+怒气" % [BLOOD_STRIKE_AP_COST, BLOOD_STRIKE_BASE_DAMAGE]
	if skill == SKILL_WHIRLWIND:
		return "%d行动 | 范围%d" % [WHIRLWIND_AP_COST, WHIRLWIND_DAMAGE]
	return ""
