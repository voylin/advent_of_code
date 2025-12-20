extends Day
@warning_ignore_start("RETURN_VALUE_DISCARDED")

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var position: Vector2i = Vector2i.ZERO
var direction: Vector2i = Vector2i.UP



func part_one() -> int:
	var map: PackedStringArray = Data.get_string_array(data_path)

	direction = Vector2i.UP
	position = _get_position(map) # Find starting position

	# Go through map
	while _step(map):
		pass

	return _count_positions(map)


func part_two() -> int:
	var map: PackedStringArray = Data.get_string_array(data_path)
	var copy: PackedStringArray = map.duplicate()
	var saved_pos: Vector2i = _get_position(map) # Find starting position
	var passed: PackedStringArray = []
	var total: int = 0

	direction = Vector2i.UP
	position = saved_pos

	# Go through map
	while _step(map):
		pass

	for x: int in map.size():
		for y: int in copy.size():
			if map[y][x] in ["^", "#", "."]:
				continue

			copy = map.duplicate()
			passed = []

			copy[y][x] = "#"
			direction = Vector2i.UP
			position = saved_pos

			while true:
				if !_step(copy):
					break
				if passed.has("%s_%s" % [position, direction]):
					total += 1
					break
				else:
					passed.append("%s_%s" % [position, direction])
						
	return total


func _get_position(map: PackedStringArray) -> Vector2i:
	for y: int in map.size():
		if map[y].contains('^'):
			return Vector2i(map[y].find('^'), y)
	return Vector2i.ZERO

	
func _step(map: PackedStringArray) -> bool:
	# true = OK, false = Exit
	_draw_map(map)

	# Proceed with walking 
	if map[position.y + direction.y][position.x + direction.x] != "#":
		# Safe to continue
		position += direction
	else:
		# Change direction
		match direction:
			Vector2i.LEFT: direction = Vector2i.UP
			Vector2i.UP: direction = Vector2i.RIGHT
			Vector2i.RIGHT: direction = Vector2i.DOWN
			Vector2i.DOWN: direction = Vector2i.LEFT

	# Check for exit
	if position.x + direction.x in [-1, map.size()] or position.y + direction.y in [-1, map.size()]:
		_draw_map(map)
		return false

	return true


func _draw_map(map: PackedStringArray) -> void:
	if map[position.y][position.x] == ".":
		if direction in [Vector2i.LEFT, Vector2i.RIGHT]:
			map[position.y][position.x] = "-"
		elif direction in [Vector2i.DOWN, Vector2i.UP]:
			map[position.y][position.x] = "|"
	else:
		map[position.y][position.x] = "+"


func _count_positions(map: PackedStringArray) -> int:
	var total: int = 0

	for x: String in map:
		total += x.count("|") + x.count("+") + x.count("-")
	
	return total

