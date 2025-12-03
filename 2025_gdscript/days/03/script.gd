extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)
var answers: PackedInt64Array = [0, 0]



func part_one() -> int:
	for entry: String in data:
		answers[0] += get_highest_number(entry, 2)
	return answers[0]


func part_two() -> int:
	for entry: String in data:
		answers[1] += get_highest_number(entry, 12)
	return answers[1]


func get_highest_number(entry: String, nums_left: int) -> int:
	var total: String = ""

	while nums_left != 0:
		var highest_pos: int = 0

		for current_pos: int in entry.length() + highest_pos - nums_left + 1:
			var current_number: int = int(entry[current_pos])

			if current_number > int(entry[highest_pos]):
				highest_pos = current_pos

		total += entry[highest_pos]
		entry = entry.substr(highest_pos + 1)
		nums_left -= 1

	return int(total)
