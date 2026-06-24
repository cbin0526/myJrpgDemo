extends Node

signal skill_pressed(skill: String)
signal end_turn_pressed
signal restart_pressed

var battle_state
var grid_board
var combat_controller

var chinese_font := SystemFont.new()

@onready var ui_root: Control = $"../CanvasLayer/UIRoot"
@onready var skill_bar: HBoxContainer = $"../CanvasLayer/UIRoot/SkillBar"
@onready var slash_button: Button = $"../CanvasLayer/UIRoot/SkillBar/SlashButton"
@onready var rend_button: Button = $"../CanvasLayer/UIRoot/SkillBar/RendButton"
@onready var charge_button: Button = $"../CanvasLayer/UIRoot/SkillBar/ChargeButton"
@onready var blood_strike_button: Button = $"../CanvasLayer/UIRoot/SkillBar/BloodStrikeButton"
@onready var whirlwind_button: Button = $"../CanvasLayer/UIRoot/SkillBar/WhirlwindButton"
@onready var end_turn_button: Button = $"../CanvasLayer/UIRoot/EndTurnButton"
@onready var toggle_side_panel_button: Button = $"../CanvasLayer/UIRoot/ToggleSidePanelButton"
@onready var log_panel: PanelContainer = $"../CanvasLayer/UIRoot/LogPanel"
@onready var battle_log_label: RichTextLabel = $"../CanvasLayer/UIRoot/LogPanel/BattleLog"
@onready var info_panel: PanelContainer = $"../CanvasLayer/UIRoot/InfoPanel"
@onready var info_label: RichTextLabel = $"../CanvasLayer/UIRoot/InfoPanel/InfoLabel"
@onready var result_panel: PanelContainer = $"../CanvasLayer/UIRoot/ResultPanel"
@onready var result_label: Label = $"../CanvasLayer/UIRoot/ResultPanel/ResultBox/ResultLabel"
@onready var restart_button: Button = $"../CanvasLayer/UIRoot/ResultPanel/ResultBox/RestartButton"


func configure(next_battle_state, next_grid_board, next_combat_controller) -> void:
	battle_state = next_battle_state
	grid_board = next_grid_board
	combat_controller = next_combat_controller


func setup() -> void:
	ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	configure_chinese_font()
	skill_bar.add_theme_constant_override("separation", 12)

	var buttons: Array[Button] = get_skill_buttons()
	var skills: Array[String] = battle_state.get_skill_list()
	for index in range(buttons.size()):
		var button: Button = buttons[index]
		button.custom_minimum_size = Vector2(142.0, 64.0)
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(_emit_skill_pressed.bind(skills[index]))

	log_panel.custom_minimum_size = Vector2(300.0, 230.0)
	battle_log_label.custom_minimum_size = Vector2(280.0, 210.0)
	battle_log_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info_panel.custom_minimum_size = Vector2(300.0, 210.0)
	info_label.custom_minimum_size = Vector2(280.0, 190.0)
	info_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	end_turn_button.custom_minimum_size = Vector2(140.0, 46.0)
	end_turn_button.focus_mode = Control.FOCUS_NONE
	end_turn_button.pressed.connect(_emit_end_turn_pressed)
	toggle_side_panel_button.custom_minimum_size = Vector2(116.0, 36.0)
	toggle_side_panel_button.focus_mode = Control.FOCUS_NONE
	toggle_side_panel_button.pressed.connect(toggle_side_panel)
	result_panel.custom_minimum_size = Vector2(260.0, 130.0)
	result_label.custom_minimum_size = Vector2(220.0, 52.0)
	result_label.add_theme_font_size_override("font_size", 30)
	restart_button.custom_minimum_size = Vector2(160.0, 42.0)
	restart_button.pressed.connect(_emit_restart_pressed)

	apply_chinese_font()
	position_ui()


func configure_chinese_font() -> void:
	chinese_font.font_names = PackedStringArray([
		"Microsoft YaHei",
		"SimHei",
		"Noto Sans CJK SC",
		"Source Han Sans SC",
		"Arial Unicode MS",
	])


func apply_chinese_font() -> void:
	var controls: Array[Control] = [
		slash_button,
		rend_button,
		charge_button,
		blood_strike_button,
		whirlwind_button,
		end_turn_button,
		toggle_side_panel_button,
		result_label,
		restart_button,
	]

	for control in controls:
		control.add_theme_font_override("font", chinese_font)

	battle_log_label.add_theme_font_override("normal_font", chinese_font)
	battle_log_label.add_theme_font_override("bold_font", chinese_font)
	info_label.add_theme_font_override("normal_font", chinese_font)
	info_label.add_theme_font_override("bold_font", chinese_font)


func position_ui() -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var skill_width: float = get_skill_bar_slot_size().x * float(battle_state.get_skill_list().size()) + get_skill_bar_gap() * float(battle_state.get_skill_list().size() - 1)
	skill_bar.position = Vector2((viewport_size.x - skill_width) * 0.5, viewport_size.y - get_skill_bar_slot_size().y - 28.0)
	toggle_side_panel_button.position = Vector2(viewport_size.x - 140.0, 24.0)
	log_panel.position = Vector2(viewport_size.x - 324.0, 70.0)
	info_panel.position = Vector2(viewport_size.x - 324.0, 316.0)
	end_turn_button.position = Vector2(skill_bar.position.x + skill_width + 18.0, skill_bar.position.y + 9.0)
	result_panel.position = Vector2((viewport_size.x - result_panel.custom_minimum_size.x) * 0.5, (viewport_size.y - result_panel.custom_minimum_size.y) * 0.5)


func update_ui() -> void:
	update_skill_buttons()
	update_info_panel()
	update_battle_log()
	end_turn_button.disabled = battle_state.battle_state != battle_state.BATTLE_STATE_PLAYER_TURN or battle_state.enemy_turn_running or battle_state.input_locked
	log_panel.visible = battle_state.side_panel_visible
	info_panel.visible = battle_state.side_panel_visible
	toggle_side_panel_button.text = "隐藏面板" if battle_state.side_panel_visible else "显示面板"


func toggle_side_panel() -> void:
	battle_state.side_panel_visible = not battle_state.side_panel_visible
	update_ui()


func update_skill_buttons() -> void:
	var buttons: Array[Button] = get_skill_buttons()
	var skills: Array[String] = battle_state.get_skill_list()
	for index in range(skills.size()):
		var skill: String = skills[index]
		var button: Button = buttons[index]
		button.text = "%d  %s\n%s" % [index + 1, battle_state.get_skill_display_name(skill), battle_state.get_skill_cost_text(skill)]
		button.icon = battle_state.get_skill_icon(skill)
		button.expand_icon = true
		button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
		button.disabled = battle_state.battle_state != battle_state.BATTLE_STATE_PLAYER_TURN or battle_state.enemy_turn_running or battle_state.input_locked or not combat_controller.can_afford_skill(skill)
		if skill == battle_state.selected_skill:
			button.add_theme_color_override("font_color", Color(1.0, 0.82, 0.35, 1.0))
			button.add_theme_color_override("font_pressed_color", Color(1.0, 0.82, 0.35, 1.0))
		else:
			button.remove_theme_color_override("font_color")
			button.remove_theme_color_override("font_pressed_color")


func update_battle_log() -> void:
	if not is_instance_valid(battle_log_label):
		return

	battle_log_label.text = "[b]战斗日志[/b]\n"
	for line in battle_state.battle_logs:
		battle_log_label.text += "%s\n" % line


func update_info_panel() -> void:
	if not is_instance_valid(info_label):
		return

	var text: String = "[b]玩家[/b]\n"
	text += "生命：%d/%d  行动：%d/%d  移动：%d/%d\n" % [battle_state.player_hp, battle_state.PLAYER_MAX_HP, battle_state.player_ap, battle_state.PLAYER_MAX_AP, battle_state.player_mp, battle_state.PLAYER_MAX_MP]
	text += "怒气：%d/%d\n" % [battle_state.player_rage, battle_state.PLAYER_MAX_RAGE]
	text += "技能：%s\n\n" % battle_state.get_skill_display_name(battle_state.selected_skill)

	var enemy_index: int = battle_state.get_enemy_index_at(battle_state.hover_grid)
	if enemy_index != -1:
		var enemy: Dictionary = battle_state.enemies[enemy_index]
		text += "[b]%s[/b]\n" % enemy.name
		text += "类型：%s\n" % battle_state.get_enemy_type_display_name(enemy)
		text += "生命：%d/%d  流血：%d\n" % [enemy.hp, enemy.max_hp, enemy.bleed_turns]
		text += "攻击：%d  移动：%d\n" % [enemy.attack_damage, enemy.max_mp]
		text += "坐标：%s\n" % enemy.grid
		text += combat_controller.get_action_preview_text(enemy_index)
	elif grid_board.is_inside_grid(battle_state.hover_grid):
		text += "[b]格子[/b]\n坐标：%s\n" % battle_state.hover_grid
		if grid_board.is_blocked(battle_state.hover_grid):
			text += "被阻挡\n"
		elif battle_state.hover_grid == battle_state.player_grid:
			text += "玩家位置\n"
		else:
			text += "距玩家：%d\n" % grid_board.get_grid_distance(battle_state.player_grid, battle_state.hover_grid)
	else:
		text += "[b]悬停格子或敌人[/b]\n"

	info_label.text = text


func show_battle_result(result_text: String) -> void:
	if result_text == "Victory":
		var challenge_text: String = "挑战完成" if battle_state.turn_count <= battle_state.CHALLENGE_TURN_LIMIT else "挑战失败"
		result_label.text = "胜利\n回合：%d\n%s：%d 回合内获胜" % [battle_state.turn_count, challenge_text, battle_state.CHALLENGE_TURN_LIMIT]
	elif result_text == "Defeat":
		result_label.text = "失败\n回合：%d" % battle_state.turn_count
	else:
		result_label.text = result_text
	result_panel.visible = true
	update_ui()


func hide_battle_result() -> void:
	result_panel.visible = false


func get_skill_buttons() -> Array[Button]:
	return [
		slash_button,
		rend_button,
		charge_button,
		blood_strike_button,
		whirlwind_button,
	]


func get_skill_bar_slot_size() -> Vector2:
	return Vector2(142.0, 64.0)


func get_skill_bar_gap() -> float:
	return 12.0


func _emit_skill_pressed(skill: String) -> void:
	skill_pressed.emit(skill)


func _emit_end_turn_pressed() -> void:
	end_turn_pressed.emit()


func _emit_restart_pressed() -> void:
	restart_pressed.emit()
