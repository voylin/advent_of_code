extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var lowest_value: int

var cache: Dictionary = {} # { position: points }
var saved_maps: Array[PackedStringArray] = []



func part_one() -> int:
	var map: PackedStringArray = Data.get_string_array(data_path)

	lowest_value = map.size() * 1000 * 3
	_follow_path(Move.new(0, Vector2i(1, map.size() - 2), Vector2i.RIGHT), map)

	return lowest_value


func part_two() -> int:
	var positions: Array[Vector2i] = []

	for map: PackedStringArray in saved_maps:
		for y: int in map.size():
			for x: int in map[y].length():
				var pos: Vector2i = Vector2i(x, y)

				if _get_char(pos, map) in ['0', 'E'] and !positions.has(pos):
					positions.append(pos)

	return positions.size()


func _follow_path(move: Move, map: PackedStringArray) -> void:
	# Check if we are at a higher or lower value
	if move.position in cache and cache[move.position] + 1001 < move.points:
		return

	cache[move.position] = move.points

	# Check if points aren't too high
	if move.points > lowest_value:
		return

	var surrounding: String = _get_surrounding(move, map)
	map[move.position.y][move.position.x] = '0'

	# If end reached, replace current value
	if surrounding.contains('E'):
		if surrounding[1] != 'E':
			move.turn_left()
		move.step_forward()

		if lowest_value >= move.points:
			if lowest_value == move.points:
				saved_maps.append(map)
			else:
				saved_maps = [map]
			lowest_value = move.points
			#print(lowest_value)
		return
    
	# Left turn
	if surrounding[0] == '.':
		var new_move: Move = move.duplicate()

		new_move.turn_left()
		_follow_path(new_move, map.duplicate())

	# Right turn
	if surrounding[2] == '.':
		var new_move: Move = move.duplicate()

		new_move.turn_right()
		_follow_path(new_move, map.duplicate())

	# Forward
	if surrounding[1] == '.':
		var new_move: Move = move.duplicate()
		new_move.step_forward()

		while true:
			var new_surrounding: String = _get_surrounding(new_move, map)

			if new_surrounding.count('.') != 1:
				break

			map[new_move.position.y][new_move.position.x] = '0'
			if new_surrounding[1] == '.':
				new_move.step_forward()
			elif new_surrounding[0] == '.':
				new_move.turn_left()
			elif new_surrounding[2] == '.':
				new_move.turn_right()

		_follow_path(new_move, map)


func _get_char(pos: Vector2i, map: PackedStringArray) -> String:
	return map[pos.y][pos.x]


func _get_surrounding(move: Move, map: PackedStringArray) -> String:
	var surrounding: String = ""
	var pos: Vector2i = move.position

	match move.direction:
		Vector2i.UP:
			surrounding += _get_char(pos + Vector2i.LEFT, map)
			surrounding += _get_char(pos + Vector2i.UP, map)
			surrounding += _get_char(pos + Vector2i.RIGHT, map)
		Vector2i.LEFT:
			surrounding += _get_char(pos + Vector2i.DOWN, map)
			surrounding += _get_char(pos + Vector2i.LEFT, map)
			surrounding += _get_char(pos + Vector2i.UP, map)
		Vector2i.DOWN:
			surrounding += _get_char(pos + Vector2i.RIGHT, map)
			surrounding += _get_char(pos + Vector2i.DOWN, map)
			surrounding += _get_char(pos + Vector2i.LEFT, map)
		Vector2i.RIGHT:
			surrounding += _get_char(pos + Vector2i.UP, map)
			surrounding += _get_char(pos + Vector2i.RIGHT, map)
			surrounding += _get_char(pos + Vector2i.DOWN, map)

	return surrounding
			

class Move:
	var points: int
	var position: Vector2i
	var direction: Vector2i


	func _init(a_points: int, a_position: Vector2i, a_direction: Vector2i) -> void:
		points = a_points
		position = a_position
		direction = a_direction


	func duplicate() -> Move:
		return Move.new(points, position, direction)

	
	func step_forward() -> void:
		points += 1
		position += direction


	func turn_left() -> void:
		points += 1000
		direction = Vector2i(direction.y, -direction.x)
		step_forward()


	func turn_right() -> void:
		points += 1000
		direction = Vector2i(-direction.y, direction.x)
		step_forward()

