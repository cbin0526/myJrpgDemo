extends Node2D

@onready var battle_state = $BattleState
@onready var battle_ui = $BattleUI
@onready var battle_input = $BattleInput
@onready var grid_board = $GridBoard
@onready var battle_renderer = $BattleRenderer
@onready var battle_animator = $BattleAnimator
@onready var combat_controller = $CombatController
@onready var enemy_ai = $EnemyAI


func _ready() -> void:
	configure_components()
	connect_component_signals()
	battle_animator.reset()
	battle_ui.setup()
	battle_state.add_battle_log("绵羊地下城第 1 房间开始。%d 回合内获胜可完成挑战。" % battle_state.CHALLENGE_TURN_LIMIT)
	refresh_view()


func configure_components() -> void:
	grid_board.configure(battle_state)
	battle_animator.configure(battle_state, grid_board)
	combat_controller.configure(battle_state, grid_board, battle_animator)
	enemy_ai.configure(battle_state, grid_board, battle_animator, combat_controller)
	battle_ui.configure(battle_state, grid_board, combat_controller)
	battle_input.configure(battle_state, grid_board)
	battle_renderer.configure(battle_state, grid_board, battle_animator, combat_controller, self, battle_ui.chinese_font)


func connect_component_signals() -> void:
	battle_state.battle_log_changed.connect(battle_ui.update_battle_log)
	battle_state.state_changed.connect(refresh_view)
	battle_ui.skill_pressed.connect(combat_controller.select_skill)
	battle_ui.end_turn_pressed.connect(end_player_turn)
	battle_ui.restart_pressed.connect(restart_battle)
	battle_input.hover_changed.connect(_on_hover_changed)
	battle_input.tile_clicked.connect(_on_tile_clicked)
	battle_input.skill_key_pressed.connect(combat_controller.select_skill)
	battle_input.end_turn_pressed.connect(end_player_turn)
	battle_animator.redraw_requested.connect(queue_redraw)
	combat_controller.battle_result_requested.connect(show_battle_result)
	combat_controller.player_action_finished.connect(refresh_view)
	combat_controller.redraw_requested.connect(queue_redraw)
	enemy_ai.enemy_turn_finished.connect(_on_enemy_turn_finished)
	enemy_ai.battle_result_requested.connect(show_battle_result)
	enemy_ai.redraw_requested.connect(queue_redraw)


func _process(delta: float) -> void:
	battle_ui.position_ui()
	battle_animator.update_floating_texts(delta)
	battle_animator.update_attack_effects(delta)
	battle_input.process_pointer(get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	battle_input.handle_unhandled_input(event)


func _draw() -> void:
	battle_renderer.draw_battle()


func refresh_view() -> void:
	battle_ui.update_ui()
	queue_redraw()


func _on_hover_changed(grid: Vector2i) -> void:
	battle_state.set_hover_grid(grid)


func _on_tile_clicked(grid: Vector2i) -> void:
	if battle_state.input_locked:
		return
	if battle_state.battle_state != battle_state.BATTLE_STATE_PLAYER_TURN:
		battle_state.add_battle_log("输入已忽略。当前状态：%s" % battle_state.get_battle_state_display_name())
		return

	if not grid_board.is_inside_grid(grid):
		battle_state.player_selected = false
		battle_state.add_battle_log("点击了地图外。")
		refresh_view()
		return

	print("点击格子：", grid)
	var enemy_index: int = battle_state.get_enemy_index_at(grid)

	if grid == battle_state.player_grid:
		battle_state.player_selected = not battle_state.player_selected
		battle_state.skill_targeting = false
		refresh_view()
		return

	if enemy_index != -1 and (battle_state.player_selected or battle_state.skill_targeting):
		combat_controller.try_use_selected_skill_on_enemy(enemy_index)
		refresh_view()
		return

	if battle_state.player_selected and grid_board.can_player_move_to(grid):
		move_player_to_grid(grid)
		return

	if grid_board.is_blocked(grid):
		battle_state.add_battle_log("格子被阻挡：%s" % grid)
	elif enemy_index != -1:
		battle_state.add_battle_log("这里有敌人。请先点击技能，或选中玩家。")
	elif battle_state.player_selected:
		battle_state.add_battle_log("格子超出移动范围：%s" % grid)

	refresh_view()


func move_player_to_grid(target_grid: Vector2i) -> void:
	var from_grid: Vector2i = battle_state.player_grid
	var distance: int = grid_board.get_grid_distance(from_grid, target_grid)
	battle_state.player_selected = false
	battle_state.skill_targeting = false
	battle_state.set_input_locked(true)
	await battle_animator.animate_player_move(from_grid, target_grid, battle_state.MOVE_ANIMATION_DURATION)
	battle_state.player_mp -= distance
	battle_state.add_battle_log("玩家移动到 %s。剩余移动点：%d" % [battle_state.player_grid, battle_state.player_mp])
	battle_state.set_input_locked(false)
	refresh_view()


func show_battle_result(result_text: String) -> void:
	battle_ui.show_battle_result(result_text)
	refresh_view()


func restart_battle() -> void:
	battle_state.reset_battle()
	battle_animator.reset()
	battle_ui.hide_battle_result()
	battle_state.add_battle_log("战斗已重新开始。%d 回合内获胜可完成挑战。" % battle_state.CHALLENGE_TURN_LIMIT)
	refresh_view()


func end_player_turn() -> void:
	if battle_state.battle_state != battle_state.BATTLE_STATE_PLAYER_TURN or battle_state.enemy_turn_running or battle_state.input_locked:
		return

	battle_state.player_selected = false
	battle_state.skill_targeting = false
	battle_state.set_input_locked(true)
	battle_state.battle_state = battle_state.BATTLE_STATE_ENEMY_TURN
	battle_state.add_battle_log("玩家回合结束。")
	refresh_view()
	enemy_ai.perform_enemy_turns()


func _on_enemy_turn_finished() -> void:
	if battle_state.battle_state != battle_state.BATTLE_STATE_BATTLE_OVER:
		begin_player_turn()
	else:
		battle_state.set_input_locked(false)
		refresh_view()


func begin_player_turn() -> void:
	battle_state.battle_state = battle_state.BATTLE_STATE_PLAYER_TURN
	battle_state.turn_count += 1
	battle_state.player_ap = battle_state.PLAYER_MAX_AP
	battle_state.player_mp = battle_state.PLAYER_MAX_MP
	battle_state.add_battle_log("第 %d 回合开始。行动点：%d 移动点：%d" % [battle_state.turn_count, battle_state.player_ap, battle_state.player_mp])
	battle_state.set_input_locked(false)
	refresh_view()
