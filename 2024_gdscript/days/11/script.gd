extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var total: int = 0
var cache: Dictionary = {}



# ORDERS OF STONES DOESN'T MATTER
func part_one() -> int:
	var stones: PackedInt32Array = Data.get_packed_int32_array(data_path, ' ')[0]

	for i: int in 25:
		blink(stones)

	return stones.size()


func part_two() -> int:
	var stones: PackedInt32Array = Data.get_packed_int32_array(data_path, ' ')[0]

	for stone: int in stones:
		total += blink_ultra_optimized(stone, 75)
	return total


func blink(stones: PackedInt32Array) -> void:
	var extra: PackedInt32Array = []

	for i: int in stones.size():
		if stones[i] == 0:
			stones[i] = 1
		elif str(stones[i]).length() >= 2 and str(stones[i]).length() % 2 == 0:
			var string: String = str(stones[i])

			@warning_ignore("integer_division")
			stones[i] = int(string.left(string.length() / 2))
			@warning_ignore("integer_division")
			extra.append(int(string.right(string.length() / 2)))
		else:
			stones[i] *= 2024

	stones.append_array(extra)


func blink_ultra_optimized(stone: int, run: int) -> int:
	var result: int = 0

	if cache.has(Vector2i(stone, run)):
		return cache[Vector2i(stone, run)]
	if run == 0:
		return 1
	elif stone == 0:
		result = blink_ultra_optimized(1, run - 1)
	elif str(stone).length() % 2 == 0:
		@warning_ignore("integer_division")
		var length: int = str(stone).length() / 2

		result = blink_ultra_optimized(int(str(stone).left(length)), run - 1)
		result += blink_ultra_optimized(int(str(stone).right(length)), run - 1)
	else:
		result = blink_ultra_optimized(stone * 2024, run -1)

	cache[Vector2i(stone, run)] = result
	return result

