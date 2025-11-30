extends Node

func get_full_string(a_file_path: String) -> String:
	var l_string: String = ""

	for l_line: String in get_string_array(a_file_path):
		l_string += l_line

	return l_string



func get_string_array(a_file_path: String) -> PackedStringArray:
	var data: PackedStringArray = []
	var file: FileAccess = FileAccess.open(a_file_path, FileAccess.READ)
	var line: String = file.get_line()

	while !file.eof_reached():
		data.append(line)
		line = file.get_line()

	return data


func get_packed_string_array(a_file_path: String, a_split: String) -> Array[PackedStringArray]:
	var data: PackedStringArray = get_string_array(a_file_path)
	var new_data: Array[PackedStringArray] = []

	for line: String in data:
		new_data.append(line.split(a_split))

	return new_data
	

func get_int_array(a_file_path: String) -> PackedInt64Array:
	var data: PackedStringArray = get_string_array(a_file_path)
	var new_data: PackedInt64Array = []

	for line: String in data:
		new_data.append(int(line))

	return new_data


func get_packed_int_array(a_file_path: String, a_split: String) -> Array[PackedInt64Array]:
	var data: Array[PackedStringArray] = get_packed_string_array(a_file_path, a_split)
	var new_data: Array[PackedInt64Array] = []

	for line: PackedStringArray in data:
		var new_line: PackedInt64Array = []

		for entry: String in line:
			new_line.append(int(entry))
				
		new_data.append(new_line)

	return new_data


func get_packed_int32_array(a_file_path: String, a_split: String) -> Array[PackedInt32Array]:
	var data: Array[PackedStringArray] = get_packed_string_array(a_file_path, a_split)
	var new_data: Array[PackedInt32Array] = []

	for line: PackedStringArray in data:
		var new_line: PackedInt32Array = []

		for entry: String in line:
			new_line.append(int(entry))
				
		new_data.append(new_line)

	return new_data


func get_float_array(a_file_path: String) -> PackedFloat64Array:
	var data: PackedStringArray = get_string_array(a_file_path)
	var new_data: PackedFloat64Array = []

	for line: String in data:
		new_data.append(float(line))

	return new_data


func get_packed_float_array(a_file_path: String, a_split: String) -> Array[PackedFloat64Array]:
	var data: Array[PackedStringArray] = get_packed_string_array(a_file_path, a_split)
	var new_data: Array[PackedFloat64Array] = []

	for line: PackedStringArray in data:
		var new_line: PackedFloat64Array = []

		for entry: String in line:
			new_line.append(float(entry))
				
		new_data.append(new_line)

	return new_data

