extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)
var answers: PackedInt64Array = [0, 0]



# We start finding the 9's
# We check every possible route from the nines
	# Check surroundings at each square, calculate all possible solutions
# When ending on a 0 we add +1 in dictionary with as key position
func part_one() -> int:
	for y: int in data.size():
		for x: int in data.size():
			if data[y][x] == "9":
				var trailheads: Array[Vector2i] = []

				answers[0] += check_path(Vector2i(x, y), trailheads, 9, false)

	return answers[0]


func part_two() -> int:
	for y: int in data.size():
		for x: int in data.size():
			if data[y][x] == "9":
				var trailheads: Array[Vector2i] = []

				answers[1] += check_path(Vector2i(x, y), trailheads, 9, true)

	return answers[1]


func check_path(pos: Vector2i, trailheads: Array[Vector2i], height: int, all: bool) -> int:
	var value: int = 0

	if int(data[pos.y][pos.x]) == 0:
		if !all and pos in trailheads:
			return 0
		trailheads.append(pos)
		return 1

	# Check up
	if pos.y - 1 >= 0 and int(data[pos.y - 1][pos.x]) == height - 1:
		value += check_path(Vector2i(pos.x, pos.y - 1), trailheads, height - 1, all)

	# Check down
	if pos.y + 1 < data.size() and int(data[pos.y + 1][pos.x]) == height - 1:
		value += check_path(Vector2i(pos.x, pos.y + 1), trailheads, height - 1, all)

	# Check left
	if pos.x - 1 >= 0 and int(data[pos.y][pos.x - 1]) == height - 1:
		value += check_path(Vector2i(pos.x - 1, pos.y), trailheads, height - 1, all)

	# Check right
	if pos.x + 1 < data.size() and int(data[pos.y][pos.x + 1]) == height - 1:
		value += check_path(Vector2i(pos.x + 1, pos.y), trailheads, height - 1, all)

	return value
	
