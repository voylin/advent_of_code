extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: Array[Vector2i] = []
var boundaries: Array[Vector2i] = [] # x = left, y = right
var max_size: int = 0

var answers: PackedInt64Array = [0, 0]



func _init() -> void:
	# Get data
	var temp_data: PackedStringArray = Data.get_string_array(data_path)

	for line: String in temp_data:
		var coords: PackedStringArray = line.split(',')

		data.append(Vector2i(int(coords[0]), int(coords[1])))
		max_size = maxi(maxi(max_size, data[-1].y), data[-1].x)

	# Create boundaries
	boundaries.resize(max_size)
	boundaries.fill(Vector2i(-1, -1))

	# Creating the boundaries for each line
	for i: int in data.size():
		var point_a: Vector2i = data[i]
		var point_b: Vector2i = data[wrapi(i + 1, 0, data.size())]

		var min_side: int = min(point_a.x, point_b.x)
		var max_side: int = max(point_a.x, point_b.x)

		if point_a.y == point_b.y: # Horizontal (same line)
			if boundaries[point_a.y].x == -1:
				boundaries[point_a.y] = Vector2i(min_side, max_side)
			else:
				boundaries[point_a.y].x = min(boundaries[point_a.y].x, min_side)
				boundaries[point_a.y].y = max(boundaries[point_a.y].y, max_side)
		else: # Vertical (so we need to check all other lines)
			for y: int in range(min(point_a.y, point_b.y), max(point_a.y, point_b.y)):
				if boundaries[y][0] == -1:
					boundaries[y] = Vector2i(min_side, max_side)
				else:
					boundaries[y].x = min(boundaries[y].x, min_side)
					boundaries[y].y = max(boundaries[y].y, max_side)

	# We can sort the data now to.
	# Sorting helps due to the slicing of the array.
	data.sort_custom(_sort_coords)


func part_one() -> int:
	for i: int in data.size():
		var top: Vector2i = data[i]

		for x: int in range(i, data.size()):
			var bottom: Vector2i = data[x]

			var height: int = absi(top.y - bottom.y) + 1
			var width: int = absi(top.x - bottom.x) + 1
			
			answers[0] = maxi(answers[0], height * width)

	return answers[0]


func part_two() -> int:
	# Check rectangles
	for i: int in data.size():
		var top: Vector2i = data[i]

		for x: int in range(i, data.size()):
			var bottom: Vector2i = data[x]
			var height: int = absi(top.y - bottom.y) + 1
			var width: int = absi(top.x - bottom.x) + 1

			if answers[1] > height * width:
				continue
			
			# Check if rectangle fits in boundaries
			var fits: bool = true
			var left: int = min(top.x, bottom.x)
			var right: int = max(top.x, bottom.x)
			var middle_y: int = int((top.y + bottom.y) / 2.0)

			# Quick check
			if boundaries[top.y].x > left or boundaries[top.y].y < right:
				continue
			if boundaries[bottom.y].x > left or boundaries[bottom.y].y < right:
				continue
			if boundaries[middle_y].x > left or boundaries[middle_y].y < right:
				continue

			# Long check
			for y: int in range(min(top.y, bottom.y), max(top.y, bottom.y) + 1):
				if boundaries[y].x > left or boundaries[y].y < right:
					fits = false
					break

			if fits:
				answers[1] = maxi(answers[1], height * width)

	return answers[1]


func _sort_coords(a: Vector2i, b: Vector2i) -> bool:
	return a.x < b.x
	
