extends Node

const PATH: String = "res://09/data.txt"



func part_one() -> int:
	var l_result: PackedStringArray = _get_initial_results(Data.get_full_string(PATH))

	for i: int in l_result.size():
		if l_result[i] == ".":
			var l_index: int = _get_last_num_pos(l_result.slice(i))

			if l_index == -1:
				break
			l_result[i] = l_result[i + l_index - 1]
			l_result[i + l_index - 1] = "."

	#_check_results(l_result)
	return _calculate_results(l_result)


func part_two() -> int:
	var l_string: String = Data.get_full_string(PATH)
	var l_result: PackedStringArray = _get_initial_results(l_string)

	var l_id: String = ""
	var l_id_size: int = 0

	var l_free_size: int = 0
	var l_free_index: int = -1

	for i: int in range(1, l_result.size()):
		var l_char: String = l_result[l_result.size() - i]

		# Start counting id
		if l_char != "." and l_id == "":
			l_id = l_char

		# Count id
		if l_id != "" and l_char == l_id:
			l_id_size += 1
		if l_result[l_result.size() - i - 1] == l_char:
			continue

		# end of id
		# Check for free spaces
		for x: int in l_result.size():
			if l_result[x] == ".":
				if l_free_index == -1:
					l_free_index = x
				l_free_size += 1
				continue

			if l_free_index == -1:
				continue

			if l_id_size > l_free_size:
				l_free_index = -1
				l_free_size = 0
				continue

			if l_id_size <= l_free_size and l_result.size() - i - l_id_size + 1 > l_free_index:
				# Remove old entries
				for y: int in l_result.size():
					if l_result[y] == l_id:
						l_result[y] = "."
				# Add new entries
				for y: int in l_id_size:
					l_result[l_free_index + y] = l_id
			l_free_index = -1
			l_free_size = 0
			l_id = ""
			l_id_size = 0
			break

		l_id = ""
		l_id_size = 0
		l_free_index = -1
		l_free_size = 0

	#_check_results(l_result)
	return _calculate_results(l_result)


func _get_last_num_pos(a_array: PackedStringArray) -> int:
	a_array.reverse()

	for i: int in a_array.size():
		if a_array[i] != ".":
			return a_array.size() - i
	
	return -1


func _get_initial_results(a_string: String) -> PackedStringArray:
	var l_result: PackedStringArray = []
	var l_files: String = ""
	var l_free: String = ""

	for i: int in a_string.length():
		if i % 2 == 0: # File length
			l_files += a_string[i]
		else: # free length
			l_free += a_string[i]

	for i: int in l_files.length():
		for x: int in int(l_files[i]):
			l_result.append(str(i))

		if l_free.length() != i:
			for x: int in int(l_free[i]):
				l_result.append(".")

	return l_result
	

func _check_results(a_result: PackedStringArray) -> void:
	var l_string: String = ""

	for l_char: String in a_result:
		l_string += l_char

	# print("0099811188827773336446555566..............") # Part 1
	print("00992111777.44.333....5555.6666.....8888..") # Part 2
	print(l_string)
	

func _calculate_results(a_results: PackedStringArray) -> int:
	var l_value: int = 0

	for i: int in a_results.size():
		if a_results[i] == ".":
			continue

		l_value += int(a_results[i]) * i

	return l_value
