extends Node

const PATH: String = "res://11/data.txt"


var total: int = 0
var cache: Dictionary = {}



# ORDERS OF STONES DOESN'T MATTER
func part_one() -> int:
	var l_stones: PackedInt32Array = Data.get_packed_int32_array(PATH, ' ')[0]

	for i: int in 25:
		blink(l_stones)

	return l_stones.size()


func part_two() -> int:
	var l_stones: PackedInt32Array = Data.get_packed_int32_array(PATH, ' ')[0]

	for l_stone: int in l_stones:
		total += blink_ultra_optimized(l_stone, 75)
	return total


func blink(a_stones: PackedInt32Array) -> void:
	var l_extra: PackedInt32Array = []

	for i: int in a_stones.size():
		if a_stones[i] == 0:
			a_stones[i] = 1
		elif str(a_stones[i]).length() >= 2 and str(a_stones[i]).length() % 2 == 0:
			var l_string: String = str(a_stones[i])

			@warning_ignore("integer_division")
			a_stones[i] = int(l_string.left(l_string.length() / 2))
			@warning_ignore("integer_division")
			l_extra.append(int(l_string.right(l_string.length() / 2)))
		else:
			a_stones[i] *= 2024

	a_stones.append_array(l_extra)


func blink_ultra_optimized(a_stone: int, a_run: int) -> int:
	var l_result: int = 0

	if cache.has(Vector2i(a_stone, a_run)):
		return cache[Vector2i(a_stone, a_run)]
	if a_run == 0:
		return 1
	elif a_stone == 0:
		l_result = blink_ultra_optimized(1, a_run - 1)
	elif str(a_stone).length() % 2 == 0:
		@warning_ignore("integer_division")
		var l_length: int = str(a_stone).length() / 2

		l_result = blink_ultra_optimized(int(str(a_stone).left(l_length)), a_run - 1)
		l_result += blink_ultra_optimized(int(str(a_stone).right(l_length)), a_run - 1)
	else:
		l_result = blink_ultra_optimized(a_stone * 2024, a_run -1)

	cache[Vector2i(a_stone, a_run)] = l_result
	return l_result

