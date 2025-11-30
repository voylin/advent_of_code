extends Node

const PATH: String = "res://06/data.txt"

var position: Vector2i = Vector2i.ZERO
var direction: Vector2i = Vector2i.UP



func part_one() -> int:
	var l_map: PackedStringArray = Data.get_string_array(PATH)

	direction = Vector2i.UP
	position = _get_position(l_map) # Find starting position

	# Go through map
	while true:
		if !_step(l_map):
			break

	return _count_positions(l_map)


func part_two() -> int:
	var l_map: PackedStringArray = Data.get_string_array(PATH)
	var l_copy: PackedStringArray = l_map.duplicate()
	var l_saved_pos: Vector2i = _get_position(l_map) # Find starting position
	var l_total: int = 0

	direction = Vector2i.UP
	position = l_saved_pos

	# Go through map
	while true:
		if !_step(l_map):
			break

	var l_passed: PackedStringArray = []
	for x: int in l_map.size():
		for y: int in l_copy.size():
			if l_map[y][x] in ["^", "#", "."]:
				continue

			l_copy = l_map.duplicate()
			l_passed = []

			l_copy[y][x] = "#"
			direction = Vector2i.UP
			position = l_saved_pos

			while true:
				if !_step(l_copy):
					break
				if l_passed.has("%s_%s" % [position, direction]):
					l_total += 1
					break
				else:
					l_passed.append("%s_%s" % [position, direction])
						
	return l_total


func _get_position(a_map: PackedStringArray) -> Vector2i:
	for l_y: int in a_map.size():
		if a_map[l_y].contains('^'):
			return Vector2i(a_map[l_y].find('^'), l_y)
	return Vector2i.ZERO

	
func _step(a_map: PackedStringArray) -> bool:
	# true = OK, false = Exit
	_draw_map(a_map)

	# Proceed with walking 
	if a_map[position.y + direction.y][position.x + direction.x] != "#":
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
	if position.x + direction.x in [-1, a_map.size()] or position.y + direction.y in [-1, a_map.size()]:
		_draw_map(a_map)
		return false

	return true


func _draw_map(a_map: PackedStringArray) -> void:
	if direction in [Vector2i.LEFT, Vector2i.RIGHT] and a_map[position.y][position.x] == ".":
		a_map[position.y][position.x] = "-"
	elif direction in [Vector2i.DOWN, Vector2i.UP] and a_map[position.y][position.x] == ".":
		a_map[position.y][position.x] = "|"
	else:
		a_map[position.y][position.x] = "+"


func _count_positions(a_map: PackedStringArray) -> int:
	var l_total: int = 0

	for l_x: String in a_map:
		l_total += l_x.count("|")
		l_total += l_x.count("+")
		l_total += l_x.count("-")
	
	return l_total

