extends Node

const PATH: String = "res://13/data.txt"

var machines: Array[Machine] = []
var total: int = 0
var mutex: Mutex = Mutex.new()


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


func get_machines(a_prize_pos_addition: int) -> Array[Machine]:
	var l_data: PackedStringArray = Data.get_string_array(PATH)
	var l_arr: Array[Machine] = []

	for l_line: String in l_data:
		if "Button A" in l_line:
			l_arr.append(Machine.new())
			l_arr[-1].a_button = Vector2i(
				int(l_line.split(' ')[-2].trim_prefix('X+').trim_suffix(',')),
				int(l_line.split(' ')[-1].trim_prefix('Y+')))
		elif "Button B" in l_line:
			l_arr[-1].b_button = Vector2i(
				int(l_line.split(' ')[-2].trim_prefix('X+').trim_suffix(',')),
				int(l_line.split(' ')[-1].trim_prefix('Y+')))
		elif "Prize:" in l_line:
			l_arr[-1].prize = Vector2i(
				int(l_line.split(' ')[-2].trim_prefix('X=').trim_suffix(',')) + a_prize_pos_addition,
				int(l_line.split(' ')[-1].trim_prefix('Y=')) + a_prize_pos_addition)

	return l_arr


func calculate_machine(a_machine_id: int) -> void:
	var l_machine: Machine = machines[a_machine_id]
	var l_max_a: int = max((l_machine.prize.x as float / l_machine.a_button.x) + 1, (l_machine.prize.y as float / l_machine.a_button.y) + 1)
	var l_max_b: int = max((l_machine.prize.x as float / l_machine.b_button.x) + 1, (l_machine.prize.y as float / l_machine.b_button.y) + 1)
	var l_x: int = 0
	var l_y: int = 0

	var l_coins: PackedInt64Array = []

	# Testing X and Y are possible
	for l_test: Vector3i in [
				Vector3i(l_machine.a_button.x, l_machine.b_button.x, l_machine.prize.x),
				Vector3i(l_machine.a_button.y, l_machine.b_button.y, l_machine.prize.y)]:
		var l_temp: int = 0

		while l_test.y != 0:
			l_temp =  l_test.y
			l_test.y = l_test.x % l_test.y
			l_test.x = l_temp
		if l_test.z % l_test.x != 0:
			print("DONE")
			return # Not valid!
	
	for x: int in range(0, max(l_max_a, l_max_b)):
		l_x = l_machine.prize.x - x * l_machine.a_button.x
		if l_x < 0:
			continue

		l_y = l_machine.prize.y - x * l_machine.a_button.y
		if l_y < 0:
			continue

		# Check if the rest can be divided by b_button
		if l_x % l_machine.b_button.x == 0 and l_y % l_machine.b_button.y == 0:
			var l_new_b: int = int(l_x as float / l_machine.b_button.x)
			if l_new_b >= 0:
				l_coins.append(l_machine.get_coins(x, l_new_b))
		
	l_coins.sort()
	if l_coins.size() != 0:
		total += l_coins[0]
	print("DONE")

#	mutex.lock()
#	var l_machine: Machine = machines[a_machine_id]
#	mutex.unlock()
#	var l_a_times: int = 0
#	var l_b_times: int = 0
#
#	var l_quick: int = 0
#	var l_a_value: int = l_machine.quick_a_button
#	var l_b_value: int = l_machine.quick_b_button
#	var l_quick_prize: int = l_machine.quick_prize
#	var l_step: int = 0
#
#	# Set l_a_times to maximum possible
#	mutex.lock()
#	l_a_times = mini((l_machine.prize.x / l_machine.a_button.x) + 1,
#					 (l_machine.prize.y / l_machine.a_button.y) + 1)
#	mutex.unlock()
#	l_quick = l_a_times * l_a_value
#
#	while true:
#		if l_quick == l_quick_prize:
#			mutex.lock()
#			if l_machine.check_win(l_a_times, l_b_times):
#				mutex.unlock()
#				total += l_machine.get_coins(l_a_times, l_b_times)
#				print("DONE")
#				return
#			mutex.unlock()
#		if l_quick > l_quick_prize:
#			l_step = maxi(1, (l_quick - l_quick_prize) / l_a_value - 1)
#			l_a_times -= l_step
#			l_quick -= l_a_value * l_step
#			if l_a_times == -1:
#				break
#		else:
#			l_step = maxi(1, (l_quick_prize - l_quick) / l_b_value)
#			l_b_times += l_step
#			l_quick += l_b_value * l_step
#
#	print("DONE")

 
class Machine:
	var a_button: Vector2i: set = set_a_button
	var b_button: Vector2i: set = set_b_button
	var prize: Vector2i: set = set_price

	var quick_a_button: int
	var quick_b_button: int
	var quick_prize: int



	func set_a_button(a_value: Vector2i) -> void:
		a_button = a_value
		quick_a_button = a_value.x + a_value.y


	func set_b_button(a_value: Vector2i) -> void:
		b_button = a_value
		quick_b_button = a_value.x + a_value.y


	func set_price(a_value: Vector2i) -> void:
		prize = a_value
		quick_prize = a_value.x + a_value.y


	func check_win(a_times: int, b_times: int) -> bool:
		return (a_times * a_button) + (b_times * b_button) == prize


	func get_coins(a_times: int, b_times: int) -> int:
		return (a_times * 3) + b_times
