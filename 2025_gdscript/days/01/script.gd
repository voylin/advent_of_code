extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()



func part_one() -> int:
	var data: PackedStringArray = Data.get_string_array(data_path)
	var dial: int = 50
	var amount: int = 0

	for turn: String in data:
		var num: int = int(turn.substr(1))

		# Decide which way to turn & add/subtract from dial.
		if turn[0] == "L": # Left.
			dial = (dial - num) % 100
		else: # Right.
			dial = (dial + num) % 100

		if dial < 0:
			dial += 100

		if dial == 0:
			amount += 1

	return amount


func part_two() -> int:
	var data: PackedStringArray = Data.get_string_array(data_path)
	var dial: int = 50
	var amount: int = 0

	for turn: String in data:
		var left: bool = turn[0] == "L"

		for i: int in int(turn.substr(1)):
			if left:
				dial -= 1
			else:
				dial += 1

			if dial < 0:
				dial = 99
			elif dial > 99:
				dial = 0

			if dial == 0:
				amount += 1

	return amount

