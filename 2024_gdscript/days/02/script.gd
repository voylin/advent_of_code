@warning_ignore_start("INTEGER_DIVISION")
extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: Array[PackedInt64Array] = Data.get_packed_int_array(data_path, " ")
var answers: PackedInt64Array = [0, 0]



func part_one() -> int:
	for entry: PackedInt64Array in data:
		if _check_normal(entry):
			answers[0] += 1
	
	return answers[0]


func part_two() -> int:
	for array: PackedInt64Array in data:
		if _check_normal(array):
			answers[1] += 1
			continue

		for i:int in array.size():
			var temp_array: PackedInt64Array = array.duplicate()
			temp_array.remove_at(i)

			if _check_normal(temp_array):
				answers[1] += 1
				break

	return answers[1]


func _check_normal(array: PackedInt64Array) -> bool:
	var positive: bool = array[0] < array[1]

	for i: int in array.size() - 1:
		var value: int = array[i + 1] - array[i]

		if (positive and value < 1) or (!positive and value > -1):
			return false
		elif  value == 0 or absi(value) > 3:
			return false

	return true

