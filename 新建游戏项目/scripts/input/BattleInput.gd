extends Node

signal hover_changed(grid: Vector2i)
signal tile_clicked(grid: Vector2i)
signal skill_key_pressed(skill: String)
signal end_turn_pressed

var battle_state
var grid_board


func configure(next_battle_state, next_grid_board) -> void:
	battle_state = next_battle_state
	grid_board = next_grid_board


func process_pointer(mouse_position: Vector2) -> void:
	var next_hover: Vector2i = grid_board.world_to_grid(mouse_position)
	if next_hover != battle_state.hover_grid:
		hover_changed.emit(next_hover)


func handle_unhandled_input(event: InputEvent) -> void:
	if battle_state.input_locked:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		tile_clicked.emit(battle_state.hover_grid)
	elif event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1:
				skill_key_pressed.emit(battle_state.SKILL_SLASH)
			KEY_2:
				skill_key_pressed.emit(battle_state.SKILL_REND)
			KEY_3:
				skill_key_pressed.emit(battle_state.SKILL_CHARGE)
			KEY_4:
				skill_key_pressed.emit(battle_state.SKILL_BLOOD_STRIKE)
			KEY_5:
				skill_key_pressed.emit(battle_state.SKILL_WHIRLWIND)
			KEY_SPACE:
				end_turn_pressed.emit()
