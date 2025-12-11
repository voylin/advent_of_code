extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)

var connections: Dictionary[String, PackedStringArray] = {}
var answers: PackedInt64Array = [0, 0] 

var cache: Dictionary[String, int] = {}



func _init() -> void:
	for line: String in data:
		var parts: PackedStringArray = line.split(": ")
		var values: PackedStringArray = parts[1].split(' ') 

		connections[parts[0]] = values


func part_one(next: String = "you") -> int:
	var total: int = 0

	for connection: String in connections[next]:
		total += 1 if connection == "out" else part_one(connection)

	return total


func part_two(next: String = "svr", has_dac: int = 0, has_fft: int = 0) -> int:
	var key: String = "%s%s%s" % [next, has_dac, has_fft]
	var new_dac: int = has_dac
	var new_fft: int = has_fft
	var total: int = 0

	if key in cache.keys():
		return cache[key]

	if next == "dac": new_dac = 1
	if next == "fft": new_fft = 1


	for connection: String in connections[next]:
		if connection == "out":
			if new_dac == 1 and new_fft == 1:
				total += 1
		else:
			total += part_two(connection, new_dac, new_fft)

	cache[key] = total
	return total
