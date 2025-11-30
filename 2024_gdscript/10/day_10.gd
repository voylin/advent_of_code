extends Node

const PATH: String = "res://10/data.txt"



# We start finding the 9's
# We check every possible route from the nines
	# Check surroundings at each square, calculate all possible solutions
# When ending on a 0 we add +1 in dictionary with as key position
func part_one() -> int:
	var l_data: PackedStringArray = Data.get_string_array(PATH)
	var l_total: int = 0
 
	for y: int in l_data.size():
		for x: int in l_data.size():
			if l_data[y][x] == "9":
				var l_trailheads: Array[Vector2i] = []

				l_total += check_path(l_data, Vector2i(x, y), l_trailheads, 9, false)

	return l_total


func part_two() -> int:
	var l_data: PackedStringArray = Data.get_string_array(PATH)
	var l_total: int = 0
 
	for y: int in l_data.size():
		for x: int in l_data.size():
			if l_data[y][x] == "9":
				var l_trailheads: Array[Vector2i] = []

				l_total += check_path(l_data, Vector2i(x, y), l_trailheads, 9, true)

	return l_total


func check_path(a_data: PackedStringArray, a_pos: Vector2i, l_trailheads: Array[Vector2i], a_height: int, a_all: bool) -> int:
	var l_value: int = 0

	if int(a_data[a_pos.y][a_pos.x]) == 0:
		if !a_all and a_pos in l_trailheads:
			return 0
		l_trailheads.append(a_pos)
		return 1

	# Check up
	if a_pos.y - 1 >= 0 and int(a_data[a_pos.y - 1][a_pos.x]) == a_height - 1:
		l_value += check_path(a_data, Vector2i(a_pos.x, a_pos.y - 1), l_trailheads, a_height - 1, a_all)

	# Check down
	if a_pos.y + 1 < a_data.size() and int(a_data[a_pos.y + 1][a_pos.x]) == a_height - 1:
		l_value += check_path(a_data, Vector2i(a_pos.x, a_pos.y + 1), l_trailheads, a_height - 1, a_all)

	# Check left
	if a_pos.x - 1 >= 0 and int(a_data[a_pos.y][a_pos.x - 1]) == a_height - 1:
		l_value += check_path(a_data, Vector2i(a_pos.x - 1, a_pos.y), l_trailheads, a_height - 1, a_all)

	# Check right
	if a_pos.x + 1 < a_data.size() and int(a_data[a_pos.y][a_pos.x + 1]) == a_height - 1:
		l_value += check_path(a_data, Vector2i(a_pos.x + 1, a_pos.y), l_trailheads, a_height - 1, a_all)

	return l_value
	
