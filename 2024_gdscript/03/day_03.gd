extends Node

const PATH: String = "res://03/data.txt"



func part_one() -> int:
	var l_total: int = 0

	for l_entry: String in _get_muls(Data.get_full_string(PATH)):
		l_total += _multiply(l_entry)
	
	return l_total


func part_two() -> int:
	var l_total: int = 0

	for l_entry: String in _get_muls(_do_dont_cleanup(Data.get_full_string(PATH))):
		l_total += _multiply(l_entry)
	
	return l_total


func _get_muls(a_line: String) -> PackedStringArray:
	var l_data: PackedStringArray = []
	var l_regex: RegEx = RegEx.new()

	l_regex.compile("mul\\([0-9]+\\,[0-9]+\\)")

	for l_result: RegExMatch in l_regex.search_all(a_line):
		l_data.append(l_result.get_string())

	return l_data


func _multiply(a_entry: String) -> int:
	return int(a_entry.split(',')[0]) * int(a_entry.split(',')[1])


func _do_dont_cleanup(a_entry: String) -> String:
	var l_string: String = ""
	var l_enabled: bool = true

	for i: int in a_entry.length():
		if a_entry[i] == 'd' and a_entry.substr(i, "don't()".length()) == "don't()":
			l_enabled = false
		elif a_entry[i] == 'd' and a_entry.substr(i, "do()".length()) == "do()":
			l_enabled = true
		
		if l_enabled:
			l_string += a_entry[i]

	return l_string
	
