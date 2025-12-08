extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: String = Data.get_full_string(data_path)
var answers: PackedInt64Array = [0, 0]



func part_one() -> int:
	for entry: String in _get_muls(data):
		answers[0] += int(entry.split(',')[0]) * int(entry.split(',')[1])
	
	return answers[0]


func part_two() -> int:
	for entry: String in _get_muls(_do_dont_cleanup(data)):
		answers[1] += int(entry.split(',')[0]) * int(entry.split(',')[1])
	
	return answers[1]


func _get_muls(line: String) -> PackedStringArray:
	var temp_data: PackedStringArray = []
	var regex: RegEx = RegEx.new()

	regex.compile("mul\\([0-9]+\\,[0-9]+\\)")

	for result: RegExMatch in regex.search_all(line):
		temp_data.append(result.get_string())

	return temp_data


func _do_dont_cleanup(entry: String) -> String:
	var string: String = ""
	var enabled: bool = true

	for i: int in entry.length():
		if entry[i] == 'd' and entry.substr(i, "don't()".length()) == "don't()":
			enabled = false
		elif entry[i] == 'd' and entry.substr(i, "do()".length()) == "do()":
			enabled = true
		
		if enabled:
			string += entry[i]

	return string
	
