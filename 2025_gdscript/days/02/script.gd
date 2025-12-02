extends Day

var data_path: String = get_test_data_path()
#var data_path: String = get_data_path()



func part_one() -> int:
	var data: PackedStringArray = Data.get_full_string(data_path).split(',')
	var invalid_ids: PackedInt64Array = []
	var amount: int = 0

	for entry: String in data:
		var num_1: String = entry.split("-")[0]
		var num_2: String = entry.split("-")[1]

		if num_1.length() == num_2.length() and num_1.length() % 2 != 0:
			continue

		for i: int in range(int(num_1), int(num_2) + 1):
			var num: String = str(i)

			if num.length() % 2 != 0:
				continue

			@warning_ignore("NARROWING_CONVERSION")
			var length: int = num.length() / 2.0

			if str(i).left(length) == num.right(length):
				@warning_ignore("return_value_discarded")
				invalid_ids.append(i)
		
	for i: int in invalid_ids:
		amount += i

	return amount


# 4174379265
func part_two() -> int:
	var data: PackedStringArray = Data.get_full_string(data_path).split(',')
	var invalid_ids: PackedInt64Array = []
	var amount: int = 0

	for entry: String in data:
		var num_1: String = entry.split("-")[0]
		var num_2: String = entry.split("-")[1]

		for i: int in range(int(num_1), int(num_2) + 1):
			for x: int in range(1, str(i).length()):
				var num: String = str(i)
				var occurances: int = num.count(num.left(x))

				if occurances * x  == num.length():
					@warning_ignore("return_value_discarded")
					invalid_ids.append(i)
					break
		
	for i: int in invalid_ids:
		amount += i

	return amount
