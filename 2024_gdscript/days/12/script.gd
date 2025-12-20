extends Day
# Calculate total price of fences
# Calculate area of plot + calculate sides(fences)
# Total is all plots counted together after doing (area * fences)

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var answers: PackedInt64Array = [0, 0]



func part_one() -> int:
	var ground: PackedStringArray = Data.get_string_array(data_path)

	# Go over y, then x.
	# if new letter got found, send map with position to count function
	# Skip '.'
	# Count function returns the total
	# Count all results together and done
	for y: int in ground.size():
		for x: int in ground.size():
			if ground[y][x] != '.':
				answers[0] += measure_land(ground, Vector2i(x,y))

	return answers[0]


func part_two() -> int:
	var ground: PackedStringArray = Data.get_string_array(data_path)

	for y: int in ground.size():
		for x: int in ground.size():
			if ground[y][x] != '.':
				answers[1] += measure_land_bulk(ground, Vector2i(x,y))

	return answers[1]


func measure_land(ground: PackedStringArray, pos: Vector2i) -> int:
	var field: String = ground[pos.y][pos.x]

	var visited_fields: Array[Vector2i] = []
	var to_visit_fields: Array[Vector2i] = [pos]
	var fence_count: int = 0

	# Check neighbouring fields, if same as letter on pos, add to
	# check_later_array. Else +1 fences
	while to_visit_fields.size() != 0:
		for field_pos: Vector2i in to_visit_fields.duplicate():
			var positions: Dictionary = {
				UP = Vector2i(field_pos.x, field_pos.y - 1),
				DOWN = Vector2i(field_pos.x, field_pos.y + 1),
				LEFT = Vector2i(field_pos.x - 1, field_pos.y),
				RIGHT = Vector2i(field_pos.x + 1, field_pos.y),
			}

			# Check up
			if positions.UP.y < 0 or ground[positions.UP.y][positions.UP.x] != field:
				fence_count += 1
			elif positions.UP not in visited_fields and positions.UP not in to_visit_fields:
				to_visit_fields.append(positions.UP)

			# Check down
			if positions.DOWN.y >= ground.size() or ground[positions.DOWN.y][positions.DOWN.x] != field:
				fence_count += 1
			elif positions.DOWN not in visited_fields and positions.DOWN not in to_visit_fields:
				to_visit_fields.append(positions.DOWN)

			# Check left
			if positions.LEFT.x < 0 or ground[positions.LEFT.y][positions.LEFT.x] != field:
				fence_count += 1
			elif positions.LEFT not in visited_fields and positions.LEFT not in to_visit_fields:
				to_visit_fields.append(positions.LEFT)

			# Check right
			if positions.RIGHT.x >= ground.size() or ground[positions.RIGHT.y][positions.RIGHT.x] != field:
				fence_count += 1
			elif positions.RIGHT not in visited_fields and positions.RIGHT not in to_visit_fields:
				to_visit_fields.append(positions.RIGHT)

			visited_fields.append(field_pos)
			to_visit_fields.remove_at(to_visit_fields.find(field_pos))

	for field_pos: Vector2i in visited_fields:
		ground[field_pos.y][field_pos.x] = '.'

	return fence_count * visited_fields.size()


func measure_land_bulk(ground: PackedStringArray, pos: Vector2i) -> int:
	var field: String = ground[pos.y][pos.x]

	var visited_fields: Array[Vector2i] = []
	var to_visit_fields: Array[Vector2i] = [pos]
	var fences_0: Array[Vector2i] = [] # UP
	var fences_1: Array[Vector2i] = [] # DOWN
	var fences_2: Array[Vector2i] = [] # LEFT
	var fences_3: Array[Vector2i] = [] # RIGHT

	var fence_count: int = 0

	# Check neighbouring fields, if same as letter on pos, add to
	# check_later_array. Else +1 fences

	while to_visit_fields.size() != 0:
		for field_pos: Vector2i in to_visit_fields.duplicate():
			var positions: Dictionary = {
				UP = Vector2i(field_pos.x, field_pos.y - 1),
				DOWN = Vector2i(field_pos.x, field_pos.y + 1),
				LEFT = Vector2i(field_pos.x - 1, field_pos.y),
				RIGHT = Vector2i(field_pos.x + 1, field_pos.y),
			}

			# Check up
			@warning_ignore_start("UNSAFE_CAST")

			if positions.UP.y < 0 or ground[positions.UP.y][positions.UP.x] != field:
				fences_0.append(Vector2i(positions.UP.x as int, positions.UP.y as int))
			elif positions.UP not in visited_fields and positions.UP not in to_visit_fields:
				to_visit_fields.append(positions.UP)

			# Check down
			if positions.DOWN.y >= ground.size() or ground[positions.DOWN.y][positions.DOWN.x] != field:
				fences_1.append(Vector2i(positions.DOWN.x as int, positions.DOWN.y as int))
			elif positions.DOWN not in visited_fields and positions.DOWN not in to_visit_fields:
				to_visit_fields.append(positions.DOWN)

			# Check left
			if positions.LEFT.x < 0 or ground[positions.LEFT.y][positions.LEFT.x] != field:
				fences_2.append(Vector2i(positions.LEFT.x as int, positions.LEFT.y as int))
			elif positions.LEFT not in visited_fields and positions.LEFT not in to_visit_fields:
				to_visit_fields.append(positions.LEFT)

			# Check right
			if positions.RIGHT.x >= ground.size() or ground[positions.RIGHT.y][positions.RIGHT.x] != field:
				fences_3.append(Vector2i(positions.RIGHT.x as int, positions.RIGHT.y as int))
			elif positions.RIGHT not in visited_fields and positions.RIGHT not in to_visit_fields:
				to_visit_fields.append(positions.RIGHT)

			@warning_ignore_restore("UNSAFE_CAST")

			visited_fields.append(field_pos)
			to_visit_fields.remove_at(to_visit_fields.find(field_pos))

	for field_pos: Vector2i in visited_fields:
		ground[field_pos.y][field_pos.x] = '.'

	# Checking horizontal fences
	var up_found: bool = false
	var down_found: bool = false
	var left_found: bool = false
	var right_found: bool = false

	for y: int in range(-1, ground.size() + 1):
		up_found = false
		down_found = false
		left_found = false
		right_found = false

		for x: int in range(-1, ground.size() + 1):
			if Vector2i(x, y) in fences_0: # UP
				if !up_found:
					up_found = true
					fence_count += 1
			else:
				up_found = false

			if Vector2i(x, y) in fences_1: # DOWN
				if !down_found:
					down_found = true
					fence_count += 1
			else:
				down_found = false

			if Vector2i(y, x) in fences_2: # LEFT
				if !left_found:
					left_found = true
					fence_count += 1
			else:
				left_found = false

			if Vector2i(y, x) in fences_3: # RIGHT
				if !right_found:
					right_found = true
					fence_count += 1
			else:
				right_found = false

	return fence_count * visited_fields.size()

