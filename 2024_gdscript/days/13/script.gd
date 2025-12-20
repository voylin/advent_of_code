extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()


var machines: Array[Machine] = []
var total: int = 0



func part_one() -> int:
	machines = get_machines(0)
	total = 0

	WorkerThreadPool.wait_for_group_task_completion(
		WorkerThreadPool.add_group_task(calculate_machine, machines.size()))

	return total


func part_two() -> int:
	machines = get_machines(10000000000000)
	total = 0

	WorkerThreadPool.wait_for_group_task_completion(
		WorkerThreadPool.add_group_task(calculate_machine, machines.size(), 8, true))

	return total


func get_machines(prize_pos_addition: int) -> Array[Machine]:
	var data: PackedStringArray = Data.get_string_array(data_path)
	var arr: Array[Machine] = []

	for line: String in data:
		if "Button A" in line:
			arr.append(Machine.new())
			arr[-1].a_button = Vector2i(
				int(line.split(' ')[-2].trim_prefix('X+').trim_suffix(',')),
				int(line.split(' ')[-1].trim_prefix('Y+')))
		elif "Button B" in line:
			arr[-1].b_button = Vector2i(
				int(line.split(' ')[-2].trim_prefix('X+').trim_suffix(',')),
				int(line.split(' ')[-1].trim_prefix('Y+')))
		elif "Prize:" in line:
			arr[-1].prize = Vector2i(
				int(line.split(' ')[-2].trim_prefix('X=').trim_suffix(',')) + prize_pos_addition,
				int(line.split(' ')[-1].trim_prefix('Y=')) + prize_pos_addition)

	return arr


func calculate_machine(machine_id: int) -> void:
	var machine: Machine = machines[machine_id]
	var max_a: int = max((machine.prize.x as float / machine.a_button.x) + 1, (machine.prize.y as float / machine.a_button.y) + 1)
	var max_b: int = max((machine.prize.x as float / machine.b_button.x) + 1, (machine.prize.y as float / machine.b_button.y) + 1)
	var x: int = 0
	var y: int = 0

	var coins: PackedInt64Array = []

	# Testing X and Y are possible
	for test: Vector3i in [
				Vector3i(machine.a_button.x, machine.b_button.x, machine.prize.x),
				Vector3i(machine.a_button.y, machine.b_button.y, machine.prize.y)]:
		var temp: int = 0

		while test.y != 0:
			temp =  test.y
			test.y = test.x % test.y
			test.x = temp
		if test.z % test.x != 0:
			print("DONE")
			return # Not valid!
	
	for x_pos: int in range(0, max(max_a, max_b)):
		x = machine.prize.x - x_pos * machine.a_button.x
		if x < 0:
			continue

		y = machine.prize.y - x_pos * machine.a_button.y
		if y < 0:
			continue

		# Check if the rest can be divided by b_button
		if x % machine.b_button.x == 0 and y % machine.b_button.y == 0:
			var new_b: int = int(x as float / machine.b_button.x)
			if new_b >= 0:
				coins.append(machine.get_coins(x_pos, new_b))
		
	coins.sort()

	if coins.size() != 0:
		total += coins[0]

 
class Machine:
	var a_button: Vector2i: set = set_a_button
	var b_button: Vector2i: set = set_b_button
	var prize: Vector2i: set = set_price

	var quick_a_button: int
	var quick_b_button: int
	var quick_prize: int



	func set_a_button(value: Vector2i) -> void:
		a_button = value
		quick_a_button = value.x + value.y


	func set_b_button(value: Vector2i) -> void:
		b_button = value
		quick_b_button = value.x + value.y


	func set_price(value: Vector2i) -> void:
		prize = value
		quick_prize = value.x + value.y


	func check_win(a_times: int, b_times: int) -> bool:
		return (a_times * a_button) + (b_times * b_button) == prize


	func get_coins(a_times: int, b_times: int) -> int:
		return (a_times * 3) + b_times
