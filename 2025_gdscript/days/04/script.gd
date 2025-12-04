extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)



func part_one() -> int:
	var size: Vector2i = Vector2i(data[0].length(), data.size())
	var taken: Array[Vector2i] = []
	var count: int = 0

	for y: int in size.y:
		for x: int in size.x:
			if data[y][x] != '.' and _check_sides(Vector2i(x, y), size) < 4:
				taken.append(Vector2i(x, y))
				count += 1

	return count


## Scan every block if an @ is present. Put them into an array.
## Then check if
func part_two() -> int:
	var size: Vector2i = Vector2i(data[0].length(), data.size())
	var count: int = 0

	while true:
		var taken: Array[Vector2i] = []

		for y: int in size.y:
			for x: int in size.x:
				if data[y][x] != '.' and _check_sides(Vector2i(x, y), size) < 4:
					taken.append(Vector2i(x, y))

		for pos: Vector2i in taken:
			data[pos.y][pos.x] = '.'
			count += 1

		if taken.size() == 0:
			break

	return count


func _check_sides(pos: Vector2i, size: Vector2i) -> int:
	var count: int = 0

	for y: int in range(-1, 2, 1):
		for x: int in range(-1, 2, 1):
			var new_y: int = pos.y + y
			var new_x: int =  pos.x + x

			if new_y == -1 or new_y >= size.y:
				continue
			if new_x == -1 or new_x >= size.x:
				continue
			if Vector2i(x, y) == Vector2i(0, 0):
				continue

			if data[new_y][new_x] == '@':
				count += 1

	return count
