extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()



func part_one() -> int:
	var result: PackedStringArray = _get_initial_results(Data.get_full_string(data_path))

	for i: int in result.size():
		if result[i] == ".":
			var index: int = _get_last_num_pos(result.slice(i))

			if index == -1:
				break
			result[i] = result[i + index - 1]
			result[i + index - 1] = "."

	return _calculate_results(result)


func part_two() -> int:
	var string: String = Data.get_full_string(data_path)
	var result: PackedStringArray = _get_initial_results(string)

	var id: String = ""
	var id_size: int = 0

	var free_size: int = 0
	var free_index: int = -1

	for i: int in range(1, result.size()):
		var character: String = result[result.size() - i]

		# Start counting id
		if character != "." and id == "":
			id = character

		# Count id
		if id != "" and character == id:
			id_size += 1
		if result[result.size() - i - 1] == character:
			continue

		# end of id
		# Check for free spaces
		for x: int in result.size():
			if result[x] == ".":
				if free_index == -1:
					free_index = x
				free_size += 1
				continue

			if free_index == -1:
				continue

			if id_size > free_size:
				free_index = -1
				free_size = 0
				continue

			if id_size <= free_size and result.size() - i - id_size + 1 > free_index:
				# Remove old entries
				for y: int in result.size():
					if result[y] == id:
						result[y] = "."
				# Add new entries
				for y: int in id_size:
					result[free_index + y] = id

			free_index = -1
			free_size = 0
			id = ""
			id_size = 0
			break

		id = ""
		id_size = 0
		free_index = -1
		free_size = 0

	return _calculate_results(result)


func _get_last_num_pos(array: PackedStringArray) -> int:
	array.reverse()

	for i: int in array.size():
		if array[i] != ".":
			return array.size() - i
	
	return -1


func _get_initial_results(string: String) -> PackedStringArray:
	var result: PackedStringArray = []
	var files: String = ""
	var free: String = ""

	for i: int in string.length():
		if i % 2 == 0: # File length
			files += string[i]
		else: # free length
			free += string[i]

	for i: int in files.length():
		for x: int in int(files[i]):
			result.append(str(i))

		if free.length() != i:
			for x: int in int(free[i]):
				result.append(".")

	return result
	

func _calculate_results(results: PackedStringArray) -> int:
	var value: int = 0

	for i: int in results.size():
		if results[i] == ".":
			continue

		value += int(results[i]) * i

	return value

