extends Node

const PATH: String = "res://12/data.txt"


# Calculate total price of fences
# Calculate area of plot + calculate sides(fences)
# Total is all plots counted together after doing (area * fences)

func part_one() -> int:
	var l_ground: PackedStringArray = Data.get_string_array(PATH)
	var l_total: int = 0

	#check_map(l_ground)

	# Go over y, then x.
	# if new letter got found, send map with position to count function
	# Skip '.'
	# Count function returns the total
	# Count all results together and done
	for y: int in l_ground.size():
		for x: int in l_ground.size():
			if l_ground[y][x] != '.':
				l_total += measure_land(l_ground, Vector2i(x,y))
				#check_map(l_ground)

	return l_total


func part_two() -> int:
	var l_ground: PackedStringArray = Data.get_string_array(PATH)
	var l_total: int = 0

	check_map(l_ground)

	for y: int in l_ground.size():
		for x: int in l_ground.size():
			if l_ground[y][x] != '.':
				l_total += measure_land_bulk(l_ground, Vector2i(x,y))
				check_map(l_ground)

	return l_total


func measure_land(a_ground: PackedStringArray, a_pos: Vector2i) -> int:
	var l_field: String = a_ground[a_pos.y][a_pos.x]

	var l_visited_fields: Array[Vector2i] = []
	var l_to_visit_fields: Array[Vector2i] = [a_pos]
	var l_fence_count: int = 0

	# Check neighbouring fields, if same as letter on pos, add to
	# check_later_array. Else +1 fences

	while l_to_visit_fields.size() != 0:
		for l_field_pos: Vector2i in l_to_visit_fields.duplicate():
			var l_pos: Dictionary = {
				UP = Vector2i(l_field_pos.x, l_field_pos.y - 1),
				DOWN = Vector2i(l_field_pos.x, l_field_pos.y + 1),
				LEFT = Vector2i(l_field_pos.x - 1, l_field_pos.y),
				RIGHT = Vector2i(l_field_pos.x + 1, l_field_pos.y),
			}

			# Check up
			if l_pos.UP.y < 0 or a_ground[l_pos.UP.y][l_pos.UP.x] != l_field:
				l_fence_count += 1
			elif l_pos.UP not in l_visited_fields and l_pos.UP not in l_to_visit_fields:
				l_to_visit_fields.append(l_pos.UP)

			# Check down
			if l_pos.DOWN.y >= a_ground.size() or a_ground[l_pos.DOWN.y][l_pos.DOWN.x] != l_field:
				l_fence_count += 1
			elif l_pos.DOWN not in l_visited_fields and l_pos.DOWN not in l_to_visit_fields:
				l_to_visit_fields.append(l_pos.DOWN)

			# Check left
			if l_pos.LEFT.x < 0 or a_ground[l_pos.LEFT.y][l_pos.LEFT.x] != l_field:
				l_fence_count += 1
			elif l_pos.LEFT not in l_visited_fields and l_pos.LEFT not in l_to_visit_fields:
				l_to_visit_fields.append(l_pos.LEFT)

			# Check right
			if l_pos.RIGHT.x >= a_ground.size() or a_ground[l_pos.RIGHT.y][l_pos.RIGHT.x] != l_field:
				l_fence_count += 1
			elif l_pos.RIGHT not in l_visited_fields and l_pos.RIGHT not in l_to_visit_fields:
				l_to_visit_fields.append(l_pos.RIGHT)

			l_visited_fields.append(l_field_pos)
			l_to_visit_fields.remove_at(l_to_visit_fields.find(l_field_pos))

	for l_field_pos: Vector2i in l_visited_fields:
		a_ground[l_field_pos.y][l_field_pos.x] = '.'

	return l_fence_count * l_visited_fields.size()


func measure_land_bulk(a_ground: PackedStringArray, a_pos: Vector2i) -> int:
	var l_field: String = a_ground[a_pos.y][a_pos.x]

	var l_visited_fields: Array[Vector2i] = []
	var l_to_visit_fields: Array[Vector2i] = [a_pos]
	var l_fences_0: Array[Vector2i] = [] # UP
	var l_fences_1: Array[Vector2i] = [] # DOWN
	var l_fences_2: Array[Vector2i] = [] # LEFT
	var l_fences_3: Array[Vector2i] = [] # RIGHT

	var l_fence_count: int = 0

	# Check neighbouring fields, if same as letter on pos, add to
	# check_later_array. Else +1 fences

	while l_to_visit_fields.size() != 0:
		for l_field_pos: Vector2i in l_to_visit_fields.duplicate():
			var l_pos: Dictionary = {
				UP = Vector2i(l_field_pos.x, l_field_pos.y - 1),
				DOWN = Vector2i(l_field_pos.x, l_field_pos.y + 1),
				LEFT = Vector2i(l_field_pos.x - 1, l_field_pos.y),
				RIGHT = Vector2i(l_field_pos.x + 1, l_field_pos.y),
			}

			# Check up
			if l_pos.UP.y < 0 or a_ground[l_pos.UP.y][l_pos.UP.x] != l_field:
				l_fences_0.append(Vector2i(l_pos.UP.x as int, l_pos.UP.y as int))
			elif l_pos.UP not in l_visited_fields and l_pos.UP not in l_to_visit_fields:
				l_to_visit_fields.append(l_pos.UP)

			# Check down
			if l_pos.DOWN.y >= a_ground.size() or a_ground[l_pos.DOWN.y][l_pos.DOWN.x] != l_field:
				l_fences_1.append(Vector2i(l_pos.DOWN.x as int, l_pos.DOWN.y as int))
			elif l_pos.DOWN not in l_visited_fields and l_pos.DOWN not in l_to_visit_fields:
				l_to_visit_fields.append(l_pos.DOWN)

			# Check left
			if l_pos.LEFT.x < 0 or a_ground[l_pos.LEFT.y][l_pos.LEFT.x] != l_field:
				l_fences_2.append(Vector2i(l_pos.LEFT.x as int, l_pos.LEFT.y as int))
			elif l_pos.LEFT not in l_visited_fields and l_pos.LEFT not in l_to_visit_fields:
				l_to_visit_fields.append(l_pos.LEFT)

			# Check right
			if l_pos.RIGHT.x >= a_ground.size() or a_ground[l_pos.RIGHT.y][l_pos.RIGHT.x] != l_field:
				l_fences_3.append(Vector2i(l_pos.RIGHT.x as int, l_pos.RIGHT.y as int))
			elif l_pos.RIGHT not in l_visited_fields and l_pos.RIGHT not in l_to_visit_fields:
				l_to_visit_fields.append(l_pos.RIGHT)

			l_visited_fields.append(l_field_pos)
			l_to_visit_fields.remove_at(l_to_visit_fields.find(l_field_pos))

	for l_field_pos: Vector2i in l_visited_fields:
		a_ground[l_field_pos.y][l_field_pos.x] = '.'

	# Checking horizontal fences
	var l_up_found: bool = false
	var l_down_found: bool = false
	var l_left_found: bool = false
	var l_right_found: bool = false

	for y: int in range(-1, a_ground.size() + 1):
		l_up_found = false
		l_down_found = false
		l_left_found = false
		l_right_found = false

		for x: int in range(-1, a_ground.size() + 1):
			if Vector2i(x, y) in l_fences_0: # UP
				if !l_up_found:
					l_up_found = true
					l_fence_count += 1
			else:
				l_up_found = false

			if Vector2i(x, y) in l_fences_1: # DOWN
				if !l_down_found:
					l_down_found = true
					l_fence_count += 1
			else:
				l_down_found = false

			if Vector2i(y, x) in l_fences_2: # LEFT
				if !l_left_found:
					l_left_found = true
					l_fence_count += 1
			else:
				l_left_found = false

			if Vector2i(y, x) in l_fences_3: # RIGHT
				if !l_right_found:
					l_right_found = true
					l_fence_count += 1
			else:
				l_right_found = false

	#print(l_field, "  ",l_visited_fields.size() , "*", l_fence_count)

	return l_fence_count * l_visited_fields.size()


func check_map(a_ground: PackedStringArray) -> void:
	if "/data.txt" in PATH:
		return
	for string: String in a_ground:
		print(string)
	print()
