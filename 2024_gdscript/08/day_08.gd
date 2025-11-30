extends Node

const PATH: String = "res://08/data.txt"



func part_one() -> int:
	var l_data: PackedStringArray = Data.get_string_array(PATH)
	var l_antennas: Dictionary = _get_antennas(l_data) # [antenna_freq: [Vector2i(positions)]]
	var l_antinodes: Array[Vector2i] = []

	for l_antenna_freq: Array in l_antennas.values():
		for l_antenna_pos: Vector2i in l_antenna_freq:
			_get_anti_pos(l_antinodes, l_antenna_freq, l_antenna_pos, l_data.size(), false)
			
	_clean_antinodes(l_antinodes, l_data.size())
#	_print_map(l_data, l_antinodes)

	return l_antinodes.size()


func part_two() -> int:
	var l_data: PackedStringArray = Data.get_string_array(PATH)
	var l_antennas: Dictionary = _get_antennas(l_data) # [antenna_freq: [Vector2i(positions)]]
	var l_antinodes: Array[Vector2i] = []

	for l_antenna_freq: Array in l_antennas.values():
		for l_antenna_pos: Vector2i in l_antenna_freq:
			_get_anti_pos(l_antinodes, l_antenna_freq, l_antenna_pos, l_data.size(), true)
			
	_clean_antinodes(l_antinodes, l_data.size())
#	_print_map(l_data, l_antinodes)

	return l_antinodes.size()


func _get_antennas(a_data: PackedStringArray) -> Dictionary:
	var l_dic: Dictionary = {}

	for y: int in a_data.size():
		for x: int in a_data.size():
			if a_data[y][x] == '.':
				continue
			if l_dic.has(a_data[y][x]):
				l_dic[a_data[y][x]].append(Vector2i(x,y))
				continue
			l_dic[a_data[y][x]] = [Vector2i(x,y)]

	return l_dic


func _get_anti_pos(a_antinodes: Array[Vector2i], a_freq: Array, a_pos: Vector2i, a_size: int, a_resonant: bool) -> void:
	for l_antenna_pos: Vector2i in a_freq:
		if l_antenna_pos == a_pos:
			continue # Check if antenna is same as pos, continue

		# Needs to be negative incase of actual saving
		var l_antinode_pos: Vector2i = Vector2i.MIN
		var l_difference: Vector2i = (l_antenna_pos - a_pos)
		l_antinode_pos = a_pos - l_difference

		if l_antinode_pos not in a_freq and l_antinode_pos not in a_antinodes:
			a_antinodes.append(l_antinode_pos)
		if !a_resonant:
			continue
		a_antinodes.append(a_pos)

		while true:
			l_antinode_pos -= l_difference
			# Don't add out of map ones
			if l_antinode_pos.x < 0 or l_antinode_pos.y < 0:
				break
			elif l_antinode_pos.x >= a_size or l_antinode_pos.y >= a_size:
				break
			if l_antinode_pos not in a_freq and l_antinode_pos not in a_antinodes:
				a_antinodes.append(l_antinode_pos)


func _clean_antinodes(a_antinodes: Array[Vector2i], a_size: int) -> void:
	var l_reversed_antinodes: Array[Vector2i] = a_antinodes.duplicate()
	l_reversed_antinodes.reverse()

	for l_antinode: Vector2i in l_reversed_antinodes:
		if a_antinodes.count(l_antinode)> 1:
			a_antinodes.remove_at(a_antinodes.find(l_antinode))
		elif l_antinode.x < 0 or l_antinode.y < 0:
			a_antinodes.remove_at(a_antinodes.find(l_antinode))
		elif l_antinode.x >= a_size or l_antinode.y >= a_size:
			a_antinodes.remove_at(a_antinodes.find(l_antinode))


func _print_map(a_data: PackedStringArray, a_antinodes: Array[Vector2i]) -> void:
	var l_data: PackedStringArray = a_data.duplicate()

	for l_antinode: Vector2i in a_antinodes:
		if l_data[l_antinode.y][l_antinode.x] == ".":
			l_data[l_antinode.y][l_antinode.x] = "#"

	for l_line: int in l_data.size():
		print(l_data[l_line])

