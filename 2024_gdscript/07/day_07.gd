extends Node

const PATH: String = "res://07/data.txt"

# l_data is made up of array's in this shape
# [Total, numbers]


func part_one() -> int:
	var l_data: Array[PackedStringArray] = Data.get_packed_string_array(PATH, ':')
	var l_numbers: PackedInt64Array = []

	for l_entry: PackedStringArray in l_data:
		var l_total: int = int(l_entry[0])
		var l_nums: PackedInt64Array = l_entry[1].strip_edges().split(' ') as Array
		l_numbers.append(_total_possible(l_total, l_nums, ['+', '*']))

	return Utils.sum_array(l_numbers)


func part_two() -> int:
	var l_data: Array[PackedStringArray] = Data.get_packed_string_array(PATH, ':')
	var l_numbers: PackedInt64Array = []

	for l_entry: PackedStringArray in l_data:
		var l_total: int = int(l_entry[0])
		var l_nums: PackedInt64Array = l_entry[1].strip_edges().split(' ') as Array

		l_numbers.append(_total_possible(l_total, l_nums, ['+', '*', '||']))

	return Utils.sum_array(l_numbers)


func _total_possible(a_total: int, a_nums: PackedInt64Array, a_symbols: PackedStringArray) -> int:
	# Return 0 if not possible, else total
	for l_combination: PackedStringArray in Utils.get_combinations_array(a_nums.size() - 1, a_symbols):
		var l_total: int = a_nums[0]

		for i: int in l_combination.size():
			match l_combination[i]:
				'+': l_total += a_nums[i+1]
				'*': l_total *= a_nums[i+1]
				'||': l_total = int("".join([l_total, a_nums[i+1]]))

		if l_total == a_total:
			return a_total

	return 0

