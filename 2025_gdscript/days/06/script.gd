extends Day
@warning_ignore_start("RETURN_VALUE_DISCARDED")

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)
var answers: PackedInt64Array = [0, 0]



func part_one() -> int:
	var symbols: PackedStringArray = data[-1].split(' ', false)
	var nums: Array[PackedStringArray] = []
	var num_amount: int = data.size() - 1
	var temp_value: int = 0

	for i: int in num_amount:
		nums.append(data[i].split(' ', false))

	for i: int in symbols.size():
		if symbols[i] == '+':
			for x: int in num_amount:
				answers[0] += int(nums[x][i])
		else: # *
			temp_value = int(nums[0][i])
			for x: int in num_amount - 1:
				temp_value *= int(nums[x + 1][i])
			answers[0] += temp_value
	
	return answers[0]


func part_two() -> int:
	var data_size: int = data.size() - 1
	var symbol: String = data[data_size][0]
	var nums: Array = []

	for i: int in data[0].length():
		var temp_num: String = ""
		
		for x: int in data_size:
			temp_num += data[x][i]

		if int(temp_num) != 0:
			nums.append(int(temp_num))
			continue

		answers[1] += nums.slice(1).reduce(_sum if symbol == "+" else _product, nums[0])
		symbol = data[data_size][i + 1]
		nums.clear()

	answers[1] += nums.slice(1).reduce(_sum if symbol == "+" else _product, nums[0])

	return answers[1]


func _sum(accum: int, number: int) -> int: return accum + number
func _product(accum: int, number: int) -> int: return accum * number
