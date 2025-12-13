extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)



func part_one() -> int:
	var present_sizes: PackedInt32Array = []

	var total_possible: int = 0

	for line: String in data:
		# Get all presents in size
		if line.length() == 2: present_sizes.append(0) # New package
		elif line.length() < 5: present_sizes[-1] += line.count('#') # Package data
		else: # Region handling
			var parts: PackedStringArray = line.split(': ')
			var size: PackedStringArray = parts[0].split('x')
			var packages: PackedStringArray = parts[1].split(' ')

			var total_package_size: int = 0

			for i: int in packages.size():
				total_package_size += int(present_sizes[i] * (int(packages[i]) + 0.2))

			if total_package_size < int(size[0]) * int(size[1]):
				total_possible += 1

	return total_possible


func part_two() -> int:
	return 0

