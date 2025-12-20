extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)



func part_one() -> int:
	var antennas: Dictionary = _get_antennas() # [antenna_freq: [Vector2i(positions)]]
	var antinodes: Array[Vector2i] = []

	for antenna_freq: Array in antennas.values():
		for antenna_pos: Vector2i in antenna_freq:
			_get_anti_pos(antinodes, antenna_freq, antenna_pos, data.size(), false)
			
	_clean_antinodes(antinodes, data.size())
#	_print_map(data, antinodes)

	return antinodes.size()


func part_two() -> int:
	var antennas: Dictionary = _get_antennas() # [antenna_freq: [Vector2i(positions)]]
	var antinodes: Array[Vector2i] = []

	for antenna_freq: Array in antennas.values():
		for antenna_pos: Vector2i in antenna_freq:
			_get_anti_pos(antinodes, antenna_freq, antenna_pos, data.size(), true)
			
	_clean_antinodes(antinodes, data.size())
#	_print_map(data, antinodes)

	return antinodes.size()


func _get_antennas() -> Dictionary:
	var dic: Dictionary = {}

	for y: int in data.size():
		for x: int in data.size():
			if data[y][x] == '.':
				continue
			if dic.has(data[y][x]):
				@warning_ignore("UNSAFE_METHOD_ACCESS")
				dic[data[y][x]].append(Vector2i(x,y))
				continue
			dic[data[y][x]] = [Vector2i(x,y)]

	return dic


func _get_anti_pos(antinodes: Array[Vector2i], freq: Array, pos: Vector2i, size: int, resonant: bool) -> void:
	for antenna_pos: Vector2i in freq:
		if antenna_pos == pos:
			continue # Check if antenna is same as pos, continue

		# Needs to be negative incase of actual saving
		var antinode_pos: Vector2i = Vector2i.MIN
		var difference: Vector2i = Vector2i(antenna_pos - pos)
		antinode_pos = pos - difference

		if antinode_pos not in freq and antinode_pos not in antinodes:
			antinodes.append(antinode_pos)
		if !resonant:
			continue
		antinodes.append(pos)

		while true:
			antinode_pos -= difference
			# Don't add out of map ones
			if antinode_pos.x < 0 or antinode_pos.y < 0:
				break
			elif antinode_pos.x >= size or antinode_pos.y >= size:
				break
			if antinode_pos not in freq and antinode_pos not in antinodes:
				antinodes.append(antinode_pos)


func _clean_antinodes(antinodes: Array[Vector2i], size: int) -> void:
	var reversed_antinodes: Array[Vector2i] = antinodes.duplicate()
	reversed_antinodes.reverse()

	for antinode: Vector2i in reversed_antinodes:
		if antinodes.count(antinode)> 1:
			antinodes.remove_at(antinodes.find(antinode))
		elif antinode.x < 0 or antinode.y < 0:
			antinodes.remove_at(antinodes.find(antinode))
		elif antinode.x >= size or antinode.y >= size:
			antinodes.remove_at(antinodes.find(antinode))

