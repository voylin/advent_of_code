extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: Array[PackedInt64Array] = [[], []]
var answers: PackedInt64Array = [0, 0]



func _init() -> void:
	for entry: PackedInt64Array in Data.get_packed_int_array(data_path, "   "):
		data[0].append(entry[0])
		data[1].append(entry[1])

	data[0].sort()
	data[1].sort()


func part_one() -> int:
	for id: int in data[0].size():
		answers[0] += abs(data[0][id] - data[1][id])

	return answers[0]
	

func part_two() -> int:
	for number: int in data[0]:
		answers[1] += number * data[1].count(number)

	return answers[1]

