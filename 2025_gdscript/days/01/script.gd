extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var answer_one: int = 0
var answer_two: int = 0



func part_one() -> int:
	var data: PackedStringArray = Data.get_string_array(data_path)
	var dial: int = 50

	for turn: String in data:
		var addition: int = -1 if turn[0] == "L" else 1

		for _i: int in int(turn.substr(1)):
			dial = wrapi(dial + addition, 0 , 100)

			if dial == 0:
				answer_two += 1

		if dial == 0:
			answer_one += 1

	return answer_one


func part_two() -> int:
	return answer_two
