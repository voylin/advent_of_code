extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: Array[PackedStringArray] = Data.get_packed_string_array(data_path, ':')
var answers: PackedInt64Array = [0, 1]



func part_one() -> int:
	var numbers: PackedInt64Array = []

	for entry: PackedStringArray in data:
		var temp_total: int = int(entry[0])
		var nums: PackedInt64Array = entry[1].strip_edges().split(' ') as Array
		numbers.append(_total_possible(temp_total, nums, ['+', '*']))

	return _sum_array(numbers)


func part_two() -> int:
	var numbers: PackedInt64Array = []

	for entry: PackedStringArray in data:
		var total: int = int(entry[0])
		var nums: PackedInt64Array = entry[1].strip_edges().split(' ') as Array

		numbers.append(_total_possible(total, nums, ['+', '*', '||']))

	return _sum_array(numbers)


func _total_possible(total: int, nums: PackedInt64Array, symbols: PackedStringArray) -> int:
	# Return 0 if not possible, else total
	for combination: PackedStringArray in _get_combinations_array(nums.size() - 1, symbols):
		var temp_total: int = nums[0]

		for i: int in combination.size():
			match combination[i]:
				'+': temp_total += nums[i+1]
				'*': temp_total *= nums[i+1]
				'||': temp_total = int("".join([temp_total, nums[i+1]]))

		if temp_total == total:
			return total

	return 0


func _sum_array(arr: PackedInt64Array) -> int:
	var total: int = 0

	for i: int in arr:
		total += i

	return total


# Generate all possible combinations of input which corresponds to length to
# an Array.
# Example:
# length = 2, a_input = ["+", "test"]
# Result = ["++", "testx", "xtest", "testtest"]
func _get_combinations_array(a_length: int, a_input: PackedStringArray) -> Array[PackedStringArray]:
	var l_combinations: Array[PackedStringArray] = []

	for i: int in a_input.size() ** a_length:
		var l_combination: PackedStringArray = []
		var l_value: int = i

		for x: int in a_length:
			l_combination.append(a_input[l_value % a_input.size()])
			l_value /= a_input.size()

		l_combinations.append(l_combination)

	return l_combinations
