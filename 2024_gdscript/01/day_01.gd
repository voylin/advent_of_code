extends Control



func part_one() -> int:
	var data: Array[PackedInt64Array] = _get_split_data()
	var total: int = 0

	for id: int in data[0].size():
		total += abs(data[0][id] - data[1][id])

	return total
	

func part_two() -> int:
	var data: Array[PackedInt64Array] = _get_split_data()
	var total: int = 0 # Similarity score 

	for number: int in data[0]:
		total += number * data[1].count(number)

	return total


func _get_split_data() -> Array[PackedInt64Array]:
	var data: Array[PackedInt64Array] = Data.get_packed_int_array("res://01/data.txt", "   ")
	var left: PackedInt64Array = []
	var right: PackedInt64Array = []

	for entry: PackedInt64Array in data:
		left.append(entry[0])
		right.append(entry[1])

	left.sort()
	right.sort()

	return [left, right]

