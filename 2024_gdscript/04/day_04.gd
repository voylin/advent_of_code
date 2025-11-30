extends Node

const PATH: String = "res://04/data.txt"



func part_one() -> int:
	var l_data: PackedStringArray = Data.get_string_array(PATH)
	var l_total: int = 0

	for l_row: String in l_data:
		l_total += _get_xmass_instances(l_row)

	l_total += _get_vertical_count(l_data)
	l_total += _get_vertical_count(_get_diagonal_arr(l_data.duplicate(), false))
	l_total += _get_vertical_count(_get_diagonal_arr(l_data.duplicate(), true))
	
	return l_total


func part_two() -> int:
	var l_data: PackedStringArray = Data.get_string_array(PATH)
	var l_chars: PackedStringArray = ["MM", "MS", "SM", "SS"]

	var l_total: int = 0

	# We skip the first and second row/column as X is not possible
	for l_row_id: int in range(1, l_data.size()-1):      # Find A positions in the data
		var l_row: String = l_data[l_row_id]
		var l_top: String = l_data[l_row_id - 1]
		var l_bot: String = l_data[l_row_id + 1]

		for i: int in range(1, l_data.size()-1):                # Checking the X patern
			var l_check: String = l_top[i-1]+l_top[i+1] + l_bot[i-1]+l_bot[i+1]

			if l_row[i] != "A":
				continue
			elif l_check.left(2) not in l_chars or l_check.right(2) not in l_chars:
				continue # Invalid data in the corners
			elif l_check[0] != l_check[3] and l_check.count("M") == 2:
				l_total += 1

	return l_total


func _get_xmass_instances(a_line: String) -> int:
	return a_line.count("XMAS") + a_line.reverse().count("XMAS")


func _get_diagonal_arr(a_data: PackedStringArray, a_reverse: bool) -> PackedStringArray:
	var l_new_data: PackedStringArray = []
	l_new_data.resize(a_data.size())

	for l_id: int in a_data.size():
		if a_reverse:
			a_data[l_id] = a_data[l_id].reverse()

		l_new_data[l_id] = " ".repeat(l_id)
		l_new_data[l_id] += a_data[l_id]
		l_new_data[l_id] += " ".repeat(a_data.size() - l_id)
		
	return l_new_data


func _get_vertical_count(a_data: PackedStringArray) -> int:
	var l_line: String = ""
	var l_total: int = 0

	for l_column: int in a_data[0].length():
		for l_row: int in a_data.size():
			l_line += a_data[l_row][l_column]

		l_total += _get_xmass_instances(l_line)
		l_line = ""

	return l_total

