extends Day

const CHARS: PackedStringArray = ["MM", "MS", "SM", "SS"]


#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)
var answers: PackedInt32Array = [0, -1]



func part_one() -> int:
	for row: String in data:
		answers[0] += row.count("XMAS") + row.reverse().count("XMAS")

	answers[0] += _get_vertical_count(data)
	answers[0] += _get_vertical_count(_get_diagonal_arr(data.duplicate(), false))
	answers[0] += _get_vertical_count(_get_diagonal_arr(data.duplicate(), true))
	
	return answers[0]


func part_two() -> int:
	# We skip the first and second row/column as X is not possible
	for i: int in range(1, data.size()-1):      # Find A positions in the data
		for x: int in range(1, data.size()-1):                # Checking the X patern
			var check: String = data[i-1][x-1] + data[i-1][x+1] + data[i+1][x-1] + data[i+1][x+1]

			if data[i][x] != "A":
				continue
			elif check.left(2) not in CHARS or check.right(2) not in CHARS:
				continue # Invalid data in the corners
			elif check[0] != check[3] and check.count("M") == 2:
				answers[1] += 1

	return answers[1]


func _get_diagonal_arr(temp_data: PackedStringArray, reverse: bool) -> PackedStringArray:
	var new_data: PackedStringArray = []
	new_data.resize(temp_data.size())

	for i: int in temp_data.size():
		if reverse:
			temp_data[i] = temp_data[i].reverse()

		new_data[i] = " ".repeat(i)
		new_data[i] += temp_data[i]
		new_data[i] += " ".repeat(temp_data.size() - i)
		
	return new_data


func _get_vertical_count(temp_data: PackedStringArray) -> int:
	var total: int = 0

	for column: int in temp_data[0].length():
		var line: String = ""

		for row: int in temp_data.size():
			line += temp_data[row][column]

		total += line.count("XMAS") + line.reverse().count("XMAS")

	return total

