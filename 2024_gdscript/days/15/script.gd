extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()



func part_one() -> int:
	var file: FileAccess = FileAccess.open(data_path, FileAccess.READ)
	var map: PackedStringArray = get_map_data(file)
	var moves: Array[Vector2i] = get_movement_data(file)
	var pos: Vector2i = get_robot_init_pos(map)

	# Go over all moves in for loop
	# WE CAN move multiple boxes
	for move: Vector2i in moves:
		var next: Vector2i = pos + move

		if map[next.y][next.x] == '.':
			pos = next
		elif map[next.y][next.x] == 'O':
			var target: Vector2i = next + move
			while true:
				if map[target.y][target.x] == '#':
					break
				elif map[target.y][target.x] == 'O':
					target += move
				else: # Empty slot found
					map[target.y][target.x] = 'O'
					map[next.y][next.x] = '.'
					pos = next
					#print_map(map)
					break

	return calculate_positions(map, 'O')


func part_two() -> int:
	var file: FileAccess = FileAccess.open(data_path, FileAccess.READ)
	var map: PackedStringArray = get_map_data(file)
	var moves: Array[Vector2i] = get_movement_data(file)
	var pos: Vector2i = get_robot_init_pos(map)

	convert_to_wide_map(map)
	pos.x = pos.x * 2
	print(pos)
	print(moves.size())

	# Go over all moves in for loop
	# WE CAN move multiple boxes
	for move: Vector2i in moves:
		var next: Vector2i = pos + move

		if map[next.y][next.x] == '.':
			pos = next
		elif map[next.y][next.x] in ['[', ']'] and move in [Vector2i.LEFT, Vector2i.RIGHT]:
			var target: Vector2i = next + (move * 2)
			var count: int = 1

			while true:
				if map[target.y][target.x] == '#':
					break
				elif map[target.y][target.x] in ['[', ']']:
					target += move * 2
					count += 1
				else: # Empty slot found
					for i: int in count:
						if move == Vector2i.LEFT:
							map[target.y][target.x] = '['
							map[target.y][target.x + 1] = ']'
						else:
							map[target.y][target.x] = ']'
							map[target.y][target.x - 1] = '['
						target += move * 2
					map[next.y][next.x] = '.'
					pos = next
					break
		elif map[next.y][next.x] in ['[', ']']: # UP and DOWN
			var boxes: Array[Vector2i] = []
			var target: Vector2i = pos

			# Add first box
			boxes.append(Vector2i(next.x, next.y))
			if map[boxes[0].y][boxes[0].x] == '[':
				boxes.append(Vector2i(next.x + 1, next.y))
			else:
				boxes.append(Vector2i(next.x - 1, next.y))

			var possible: bool = true
			while possible:
				var move_possible: bool = true
				target += move

				for box: Vector2i in boxes:
					if box.y == target.y - move.y:
						continue

					# WALL CHECK
					if map[box.y + move.y][box.x] == '#':
						possible = false
						break

					# ADD BOX CHECK
					var new_box: Vector2i = Vector2i.ZERO
					if map[box.y + move.y][box.x] in ['[',']']:
						move_possible = false
						new_box = Vector2i(box.x, box.y + move.y)
						if !boxes.has(new_box):
							boxes.append(new_box)

						if map[new_box.y][new_box.x] == '[' and !boxes.has(Vector2i(new_box.x + 1, new_box.y)):
							boxes.append(Vector2i(new_box.x + 1, new_box.y))
						elif !boxes.has(Vector2i(new_box.x - 1, new_box.y)):
							boxes.append(Vector2i(new_box.x - 1, new_box.y))

				# MOVE BOXES
				if possible and move_possible:
					var blocks: Dictionary = {}

					for block: Vector2i in boxes:
						blocks[block] = map[block.y][block.x]
					for block: Vector2i in boxes: # Against duplicates new for loop
						map[block.y][block.x] = '.'
					for block: Vector2i in blocks:
						map[block.y + move.y][block.x] = blocks[block]

					pos = next
					break

	return calculate_positions(map, '[')


func get_map_data(file: FileAccess) -> PackedStringArray:
	var data: PackedStringArray = []

	# Get lines up until an empty line
	file.seek(0)
	while true:
		var line: String = file.get_line()
		
		if line.length() <= 0:
			break
		else:
			data.append(line)

	return data


func convert_to_wide_map(map: PackedStringArray) -> void:
	for y: int in map.size():
		var new_line: String = ""
		for character: String in map[y]:
			if character == '.':
				new_line += ".."
			elif character == '#':
				new_line += "##"
			elif character == 'O':
				new_line += "[]"

		map[y] = new_line


func get_movement_data(file: FileAccess) -> Array[Vector2i]:
	var data: Array[Vector2i] = []

	# Get the rest of the lines, and add each arrow to array
	while !file.eof_reached():
		var line: String = file.get_line()

		for character: String in line:
			match character:
				'^': data.append(Vector2i.UP)
				'v': data.append(Vector2i.DOWN)
				'<': data.append(Vector2i.LEFT)
				'>': data.append(Vector2i.RIGHT)
		
	return data


func get_robot_init_pos(map: PackedStringArray) -> Vector2i:
	for y: int in map.size():
		for x: int in map[0].length():
			if map[y][x] == '@':
				map[y][x] = '.'
				return Vector2i(x,y)
	return Vector2i.ZERO


func calculate_positions(map: PackedStringArray, character: String) -> int:
	var total: int = 0

	for y: int in map.size():
		for x: int in map[0].length():
			# Y * 100 + X
			if map[y][x] == character:
				total += y * 100 + x

	return total

