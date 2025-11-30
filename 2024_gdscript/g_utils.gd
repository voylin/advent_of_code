extends Node


# Generate all possible combinations of input which corresponds to length.
# Example:
# length = 2, a_input = ["+", "test"]
# Result = ["++", "testx", "xtest", "testtest"]
func get_combinations(a_length: int, a_input: PackedStringArray) -> PackedStringArray:
	var l_combinations: PackedStringArray = []

	for i: int in a_input.size() ** a_length:
		var l_combination: String = ""
		var l_value: int = i

		for x: int in a_length:
			l_combination += a_input[l_value % a_input.size()]
			l_value /= a_input.size()

		l_combinations.append(l_combination)

	return l_combinations


# Generate all possible combinations of input which corresponds to length to
# an Array.
# Example:
# length = 2, a_input = ["+", "test"]
# Result = ["++", "testx", "xtest", "testtest"]
func get_combinations_array(a_length: int, a_input: PackedStringArray) -> Array[PackedStringArray]:
	var l_combinations: Array[PackedStringArray] = []

	for i: int in a_input.size() ** a_length:
		var l_combination: PackedStringArray = []
		var l_value: int = i

		for x: int in a_length:
			l_combination.append(a_input[l_value % a_input.size()])
			l_value /= a_input.size()

		l_combinations.append(l_combination)

	return l_combinations


# Sum up all value's inside an array.
func sum_array(a_array: PackedInt64Array) -> int:
	var l_total: int = 0
	for i: int in a_array:
		l_total += i

	return l_total

