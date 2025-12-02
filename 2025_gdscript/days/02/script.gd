@warning_ignore_start("INTEGER_DIVISION")
extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_full_string(data_path).split(',')
var answers: PackedInt64Array = [0, 0]



func part_one() -> int:
	for entry: String in data:
		var nums: PackedInt64Array = Array(entry.split("-"))

		for num: String in PackedStringArray(range(nums[0], nums[1] + 1)):
			if test_num(num, num.length()):
				answers[0] += int(num)if num == num.left(num.length() / 2).repeat(2) else 0
				answers[1] += int(num)

	return answers[0]


func part_two() -> int:
	return answers[1]


func test_num(num: String, length: int) -> bool:
	for x: int in range(1, (length / 2) + 1):
		if length % x == 0 and num.count(num.left(x)) * x  == length:
			return true

	return false
