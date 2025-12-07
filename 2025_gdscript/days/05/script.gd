extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)
var ranges: Array[PackedInt64Array] = []
var ids: PackedInt64Array = []



func _init() -> void:
	for line: String in data:
		if line.contains('-'): # ID range
			var temp_nums: PackedStringArray = line.split('-')
			ranges.append(PackedInt64Array([temp_nums[0], temp_nums[1]]))
		elif line == "":
			continue
		elif !ids.has(int(line)): # ID
			@warning_ignore("RETURN_VALUE_DISCARDED")
			ids.append(int(line))

	ranges.sort_custom(_sort_ranges)


func part_one() -> int:
	var fresh: int = 0

	for i: int in ids:
		for id_range: PackedInt64Array in ranges:
			if i >= id_range[0] and i <= id_range[1]:
				fresh += 1
				break

	return fresh


func part_two() -> int:
	var count: int = 1
	var current_num: int = ranges[0][0]
	
	for id_range: PackedInt64Array in ranges:
		if current_num >= id_range[0] and current_num <= id_range[1]:
			count += id_range[1] - current_num
			current_num = id_range[1]
		elif id_range[0] >= current_num:
			count += id_range[1] - id_range[0] + 1
			current_num = id_range[1]

	return count


func _sort_ranges(a: PackedInt64Array, b: PackedInt64Array) -> bool:
	if a[0] < b[0]:
		return true
	return false
