extends Node

const TILE_WIDTH := 96.0
const TILE_HEIGHT := 48.0
const GRID_ORIGIN := Vector2(640.0, 120.0)

var battle_state


func configure(next_battle_state) -> void:
	battle_state = next_battle_state


func grid_to_world(grid: Vector2i) -> Vector2:
	return Vector2(
		(float(grid.x) - float(grid.y)) * TILE_WIDTH * 0.5,
		(float(grid.x) + float(grid.y)) * TILE_HEIGHT * 0.5
	) + GRID_ORIGIN


func world_to_grid(world_position: Vector2) -> Vector2i:
	var local: Vector2 = world_position - GRID_ORIGIN
	var grid_x: float = (local.x / (TILE_WIDTH * 0.5) + local.y / (TILE_HEIGHT * 0.5)) * 0.5
	var grid_y: float = (local.y / (TILE_HEIGHT * 0.5) - local.x / (TILE_WIDTH * 0.5)) * 0.5
	var candidate: Vector2i = Vector2i(floori(grid_x), floori(grid_y))

	if is_inside_grid(candidate) and point_in_tile(world_position, candidate):
		return candidate

	var best: Vector2i = Vector2i(-1, -1)
	var best_distance: float = INF
	for y in range(maxi(0, candidate.y - 1), mini(battle_state.GRID_HEIGHT, candidate.y + 3)):
		for x in range(maxi(0, candidate.x - 1), mini(battle_state.GRID_WIDTH, candidate.x + 3)):
			var grid: Vector2i = Vector2i(x, y)
			if point_in_tile(world_position, grid):
				var distance: float = world_position.distance_squared_to(grid_to_world(grid))
				if distance < best_distance:
					best_distance = distance
					best = grid

	return best


func point_in_tile(point: Vector2, grid: Vector2i) -> bool:
	var center: Vector2 = grid_to_world(grid)
	var local: Vector2 = point - center
	return absf(local.x) / (TILE_WIDTH * 0.5) + absf(local.y) / (TILE_HEIGHT * 0.5) <= 1.0


func get_tile_points(center: Vector2) -> PackedVector2Array:
	return PackedVector2Array([
		center + Vector2(0.0, -TILE_HEIGHT * 0.5),
		center + Vector2(TILE_WIDTH * 0.5, 0.0),
		center + Vector2(0.0, TILE_HEIGHT * 0.5),
		center + Vector2(-TILE_WIDTH * 0.5, 0.0),
	])


func close_points(points: PackedVector2Array) -> PackedVector2Array:
	var closed: PackedVector2Array = PackedVector2Array(points)
	if points.size() > 0:
		closed.append(points[0])
	return closed


func is_inside_grid(grid: Vector2i) -> bool:
	return grid.x >= 0 and grid.y >= 0 and grid.x < battle_state.GRID_WIDTH and grid.y < battle_state.GRID_HEIGHT


func is_blocked(grid: Vector2i) -> bool:
	return battle_state.blocked_tiles.has(grid)


func can_player_move_to(grid: Vector2i) -> bool:
	if battle_state.battle_state != battle_state.BATTLE_STATE_PLAYER_TURN:
		return false
	if not is_inside_grid(grid):
		return false
	if is_blocked(grid):
		return false
	if grid == battle_state.player_grid:
		return false
	if battle_state.get_enemy_index_at(grid) != -1:
		return false

	return get_grid_distance(battle_state.player_grid, grid) <= battle_state.player_mp


func can_enemy_move_to(enemy_index: int, grid: Vector2i) -> bool:
	if not is_inside_grid(grid):
		return false
	if is_blocked(grid):
		return false
	if grid == battle_state.player_grid:
		return false

	var occupant: int = battle_state.get_enemy_index_at(grid)
	return occupant == -1 or occupant == enemy_index


func is_straight_line(from_grid: Vector2i, to_grid: Vector2i) -> bool:
	return from_grid.x == to_grid.x or from_grid.y == to_grid.y


func get_grid_direction(from_grid: Vector2i, to_grid: Vector2i) -> Vector2i:
	var delta: Vector2i = to_grid - from_grid
	if delta.x != 0:
		return Vector2i(1 if delta.x > 0 else -1, 0)
	if delta.y != 0:
		return Vector2i(0, 1 if delta.y > 0 else -1)
	return Vector2i.ZERO


func is_adjacent(from_grid: Vector2i, to_grid: Vector2i) -> bool:
	return get_grid_distance(from_grid, to_grid) == 1


func get_grid_distance(from_grid: Vector2i, to_grid: Vector2i) -> int:
	return absi(to_grid.x - from_grid.x) + absi(to_grid.y - from_grid.y)
