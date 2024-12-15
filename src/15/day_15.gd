extends Node

const PATH: String = "res://15/data.txt"



func part_one() -> int:
	var l_file: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	var l_map: PackedStringArray = get_map_data(l_file)
	var l_moves: Array[Vector2i] = get_movement_data(l_file)
	var l_pos: Vector2i = get_robot_init_pos(l_map)

	# Go over all moves in for loop
	# WE CAN move multiple boxes
	for l_move: Vector2i in l_moves:
		var l_next: Vector2i = l_pos + l_move

		if l_map[l_next.y][l_next.x] == '.':
			l_pos = l_next
		elif l_map[l_next.y][l_next.x] == 'O':
			var l_target: Vector2i = l_next + l_move
			while true:
				if l_map[l_target.y][l_target.x] == '#':
					break
				elif l_map[l_target.y][l_target.x] == 'O':
					l_target += l_move
				else: # Empty slot found
					l_map[l_target.y][l_target.x] = 'O'
					l_map[l_next.y][l_next.x] = '.'
					l_pos = l_next
					#print_map(l_map)
					break

	return calculate_positions(l_map, 'O')


func part_two() -> int:
	return 0
	var l_file: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	var l_map: PackedStringArray = get_map_data(l_file)
	var l_moves: Array[Vector2i] = get_movement_data(l_file)
	var l_pos: Vector2i = get_robot_init_pos(l_map)

	convert_to_wide_map(l_map)
	print_map(l_map)
	l_pos.x *= 2

	# Go over all moves in for loop
	# WE CAN move multiple boxes
	for l_move: Vector2i in l_moves:
		var l_next: Vector2i = l_pos + l_move

		if l_map[l_next.y][l_next.x] == '.':
			l_pos = l_next
		elif l_map[l_next.y][l_next.x] in ['[', ']'] and l_move in [Vector2i.LEFT, Vector2i.RIGHT]:
			var l_target: Vector2i = l_next + (l_move * 2)
			var l_count: int = 1

			while true:
				if l_map[l_target.y][l_target.x] == '#':
					break
				elif l_map[l_target.y][l_target.x] in ['[', ']']:
					l_target += l_move * 2
					l_count += 1
				else: # Empty slot found
					for i: int in l_count:
						if l_move == Vector2i.LEFT:
							l_map[l_target.y][l_target.x] = '['
							l_map[l_target.y][l_target.x + 1] = ']'
						else:
							l_map[l_target.y][l_target.x] = ']'
							l_map[l_target.y][l_target.x - 1] = '['
						l_target -= l_move * 2
					l_map[l_next.y][l_next.x] = '.'
					l_pos = l_next
					break
		elif l_map[l_next.y][l_next.x] in ['[', ']']: # UP and DOWN
			var l_boxes: Array[Vector2i] = []
			var l_target: Vector2i = l_pos

			# Add first box
			l_boxes.append(Vector2i(l_next.x, l_next.y))
			if l_map[l_boxes[0].y][l_boxes[0].x] == '[':
				l_boxes.append(Vector2i(l_next.x + 1, l_next.y))
			else:
				l_boxes.append(Vector2i(l_next.x - 1, l_next.y))

			var l_possible: bool = true
			while l_possible:
				var l_move_possible: bool = true
				l_target += l_move

				for l_box: Vector2i in l_boxes:
					if l_box.y == l_target.y - l_move.y:
						continue

					# WALL CHECK
					if l_map[l_box.y + l_move.y][l_box.x] == '#':
						l_possible = false
						break

					# ADD BOX CHECK
					var l_new_box: Vector2i = Vector2i.ZERO
					if l_map[l_box.y + l_move.y][l_box.x] in ['[',']']:
						l_move_possible = false
						l_new_box = Vector2i(l_box.x, l_box.y + l_move.y)
						if !l_boxes.has(l_new_box):
							l_boxes.append(l_new_box)

						if l_map[l_new_box.y][l_new_box.x] == '[' and !l_boxes.has(Vector2i(l_new_box.x + 1, l_new_box.y)):
							l_boxes.append(Vector2i(l_new_box.x + 1, l_new_box.y))
						elif !l_boxes.has(Vector2i(l_new_box.x - 1, l_new_box.y)):
							l_boxes.append(Vector2i(l_new_box.x - 1, l_new_box.y))

				# MOVE BOXES
				if l_possible and l_move_possible:
					var l_blocks: Dictionary = {}

					for l_block: Vector2i in l_boxes:
						l_blocks[l_block] = l_map[l_block.y][l_block.x]
					for l_block: Vector2i in l_boxes: # Against duplicates new for loop
						l_map[l_block.y][l_block.x] = '.'
					for l_block: Vector2i in l_blocks:
						l_map[l_block.y + l_move.y][l_block.x] = l_blocks[l_block]

					l_pos = l_next
					break

	print_map(l_map)
	return calculate_positions(l_map, '[')


func get_map_data(a_file: FileAccess) -> PackedStringArray:
	var l_data: PackedStringArray = []

	# Get lines up until an empty line
	a_file.seek(0)
	while true:
		var l_line: String = a_file.get_line()
		
		if l_line.length() <= 0:
			break
		else:
			l_data.append(l_line)

	return l_data


func convert_to_wide_map(a_map: PackedStringArray) -> void:
	for y: int in a_map.size():
		var l_new_line: String = ""
		for a_char: String in a_map[y]:
			if a_char == '.':
				l_new_line += ".."
			elif a_char == '#':
				l_new_line += "##"
			elif a_char == 'O':
				l_new_line += "[]"

		a_map[y] = l_new_line


func get_movement_data(a_file: FileAccess) -> Array[Vector2i]:
	var l_data: Array[Vector2i] = []

	# Get the rest of the lines, and add each arrow to array
	while !a_file.eof_reached():
		var l_line: String = a_file.get_line()

		for l_char: String in l_line:
			match l_char:
				'^': l_data.append(Vector2i.UP)
				'v': l_data.append(Vector2i.DOWN)
				'<': l_data.append(Vector2i.LEFT)
				'>': l_data.append(Vector2i.RIGHT)
		
	return l_data


func get_robot_init_pos(a_map: PackedStringArray) -> Vector2i:
	for y: int in a_map.size():
		for x: int in a_map[0].length():
			if a_map[y][x] == '@':
				a_map[y][x] = '.'
				return Vector2i(x,y)
	return Vector2i.ZERO


func calculate_positions(a_map: PackedStringArray, a_char: String) -> int:
	var l_total: int = 0
	print_map(a_map)

	for y: int in a_map.size():
		for x: int in a_map[0].length():
			# Y * 100 + X
			if a_map[y][x] == a_char:
				l_total += y * 100 + x

	return l_total


func print_map(a_map: PackedStringArray) -> void:
	print()
	for l_line: String in a_map:
		print(l_line)
	print()

