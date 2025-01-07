extends Node

#const PATH: String = "res://16/test_data.txt"
const PATH: String = "res://16/data.txt"


var lowest_value: int

var cache: Dictionary = {} # { position: points }
var saved_maps: Array[PackedStringArray] = []



func part_one() -> int:
	var l_map: PackedStringArray = Data.get_string_array(PATH)

	lowest_value = l_map.size() * 1000 * 3
	_follow_path(Move.new(0, Vector2i(1, l_map.size() - 2), Vector2i.RIGHT), l_map)

	return lowest_value


func part_two() -> int:
	var l_positions: Array[Vector2i] = []

	for l_map: PackedStringArray in saved_maps:
		for y: int in l_map.size():
			for x: int in l_map[y].length():
				var l_pos: Vector2i = Vector2i(x, y)

				if _get_char(l_pos, l_map) in ['0', 'E'] and !l_positions.has(l_pos):
					l_positions.append(l_pos)

	return l_positions.size()


func _follow_path(a_move: Move, a_map: PackedStringArray) -> void:
	# Check if we are at a higher or lower value
	if a_move.position in cache and cache[a_move.position] + 1001 < a_move.points:
		return

	cache[a_move.position] = a_move.points

	# Check if points aren't too high
	if a_move.points > lowest_value:
		return

	var l_surrounding: String = _get_surrounding(a_move, a_map)
	a_map[a_move.position.y][a_move.position.x] = '0'

	# If end reached, replace current value
	if l_surrounding.contains('E'):
		if l_surrounding[1] != 'E':
			a_move.turn_left()
		a_move.step_forward()

		if lowest_value >= a_move.points:
			if lowest_value == a_move.points:
				saved_maps.append(a_map)
			else:
				saved_maps = [a_map]
			lowest_value = a_move.points
			#print(lowest_value)
		return
    
	# Left turn
	if l_surrounding[0] == '.':
		var l_new_move: Move = a_move.duplicate()

		l_new_move.turn_left()
		_follow_path(l_new_move, a_map.duplicate())

	# Right turn
	if l_surrounding[2] == '.':
		var l_new_move: Move = a_move.duplicate()

		l_new_move.turn_right()
		_follow_path(l_new_move, a_map.duplicate())

	# Forward
	if l_surrounding[1] == '.':
		var l_new_move: Move = a_move.duplicate()
		l_new_move.step_forward()

		while true:
			var l_new_surrounding: String = _get_surrounding(l_new_move, a_map)

			if l_new_surrounding.count('.') != 1:
				break

			a_map[l_new_move.position.y][l_new_move.position.x] = '0'
			if l_new_surrounding[1] == '.':
				l_new_move.step_forward()
			elif l_new_surrounding[0] == '.':
				l_new_move.turn_left()
			elif l_new_surrounding[2] == '.':
				l_new_move.turn_right()

		_follow_path(l_new_move, a_map)


func _get_char(a_pos: Vector2i, a_map: PackedStringArray) -> String:
	return a_map[a_pos.y][a_pos.x]


func _get_surrounding(a_move: Move, a_map: PackedStringArray) -> String:
	var l_surrounding: String = ""
	var l_pos: Vector2i = a_move.position

	match a_move.direction:
		Vector2i.UP:
			l_surrounding += _get_char(l_pos + Vector2i.LEFT, a_map)
			l_surrounding += _get_char(l_pos + Vector2i.UP, a_map)
			l_surrounding += _get_char(l_pos + Vector2i.RIGHT, a_map)
		Vector2i.LEFT:
			l_surrounding += _get_char(l_pos + Vector2i.DOWN, a_map)
			l_surrounding += _get_char(l_pos + Vector2i.LEFT, a_map)
			l_surrounding += _get_char(l_pos + Vector2i.UP, a_map)
		Vector2i.DOWN:
			l_surrounding += _get_char(l_pos + Vector2i.RIGHT, a_map)
			l_surrounding += _get_char(l_pos + Vector2i.DOWN, a_map)
			l_surrounding += _get_char(l_pos + Vector2i.LEFT, a_map)
		Vector2i.RIGHT:
			l_surrounding += _get_char(l_pos + Vector2i.UP, a_map)
			l_surrounding += _get_char(l_pos + Vector2i.RIGHT, a_map)
			l_surrounding += _get_char(l_pos + Vector2i.DOWN, a_map)

	return l_surrounding


func _print_map(a_map: PackedStringArray) -> void:
	for y: int in a_map.size():
		print(a_map[y])
			

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

