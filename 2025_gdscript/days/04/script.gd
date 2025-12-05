extends Day

const POSITIONS: Array[Vector2i] = [
	Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1),
	Vector2i(1, -1),  Vector2i(1, 0),  Vector2i(1, 1),
	Vector2i(0, -1),  Vector2i(0, 1)]


#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)
var paper: Dictionary[int, PackedInt32Array] = {}

var answers: PackedInt32Array = [0, -1]



func _init() -> void:
	for y: int in data[0].length():
		paper[y] = PackedInt32Array()

		for x: int in data.size():
			if data[y][x] == '@':
				var _err: bool = paper[y].append(x)


func part_one() -> int:
	for y: int in paper:
		for x: int in paper[y]:
			if _check_sides(x, y) < 4:
				answers[0] += 1

	return answers[0]


func part_two() -> int:
	var count: int = 0

	while answers[1] != count:
		var taken: Array[Vector2i] = []
		answers[1] = count

		for y: int in paper:
			for x: int in paper[y]:
				if _check_sides(x, y) < 4:
					taken.append(Vector2i(x, y))
					count += 1

		for pos: Vector2i in taken:
			paper[pos.y].remove_at(paper[pos.y].find(pos.x))

	return answers[1]


func _check_sides(x_pos: int, y_pos: int) -> int:
	var count: int = 0

	for pos: Vector2i in POSITIONS:
		var new_y: int = pos.y + y_pos

		if paper.has(new_y) and paper[new_y].has(pos.x + x_pos):
			count += 1
		if count == 4:
			return 4

	return count
