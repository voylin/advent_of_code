extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var machines: Array[Machine] = []
var answers: PackedInt64Array = [0, 0]

var mutex: Mutex = Mutex.new()



func _init() -> void:
	for line: String in Data.get_string_array(data_path):
		machines.append(Machine.new(line))


func part_one() -> int:
	for machine: Machine in machines:
		answers[0] += machine.calculate_lights()

	return answers[0]


# Correct answer = 17133
func part_two() -> int:
	var tasks: PackedInt64Array = []
	var remaining: int = machines.size()

	for machine: Machine in machines:
		tasks.append(WorkerThreadPool.add_task(_run_part_two.bind(machine)))

	print("Start handling ", machines.size(), " machines...")

	while tasks.size() != 0:
		await RenderingServer.frame_pre_draw
		for task_id: int in tasks:
			if WorkerThreadPool.is_task_completed(task_id):
				remaining -= 1
				print("remaining: ", remaining, "/", machines.size(), "\tCurrent total: ", answers[1])
				WorkerThreadPool.wait_for_task_completion(task_id)
				tasks.remove_at(tasks.find(task_id))

	return answers[1]


func _run_part_two(machine: Machine) -> void:
	var value: int = machine.calculate_joltage()
	mutex.lock()
	#print(value)

	if value == 0:
		printerr("machine returned 0!!")
		printerr(machine.joltage)

	answers[1] += value
	mutex.unlock()	


class Machine:
	var data_line: String = ""
	var desired_state: PackedInt32Array = [] # 0000
	var buttons: Array[PackedInt32Array] = []
	var matrix: Array[PackedInt32Array] = [] # Button matrix
	var matrix_sum: PackedInt32Array = []
	var joltage: PackedInt32Array = []

	var min_joltage_presses: int = -1
	var joltage_column_map: Array[Array] = []



	func _init(line: String) -> void:
		data_line = line

		# Get the light indicators
		for light: String in line.substr(1, line.find(']') - 1).replace('.', '0').replace('#', '1').split():
			desired_state.append(int(light))			
			
		# Get the joltage
		for j: String in line.substr(line.find('{') + 1).left(-1).split(','):
			joltage.append(int(j))

		# Get the buttons
		var raw_buttons: String = line.substr(line.find(' ') + 1)
		raw_buttons = raw_buttons.substr(0, raw_buttons.find('{') - 1)

		for group: String in raw_buttons.split(' '):
			var button_group: PackedInt32Array = []
			var entries: PackedStringArray = group.trim_prefix('(').trim_suffix(')').split(',')

			for entry: String in entries:
				button_group.append(int(entry))

			buttons.append(button_group)

		buttons.sort_custom(_sort_buttons)

		# Create button matrix
		for button_group: PackedInt32Array in buttons:
			var matrix_row: PackedInt32Array = []

			matrix_row.resize(joltage.size())
			matrix_row.fill(0)

			for i: int in button_group:
				matrix_row[i] = 1

			matrix.append(matrix_row)

		# Getting the sum of the matrix for 2 quick checks when getting joltage
		matrix_sum.resize(joltage.size())

		for matrix_row: PackedInt32Array in matrix:
			for i: int in matrix_row.size():
				matrix_sum[i] += matrix_row[i]


	# use %2 = 0 is off and 1 is on	
	func calculate_lights() -> int: # Binary approach
		var state: PackedInt32Array = []
		var presses: int = buttons.size()
		var button_presses: PackedInt32Array = []

		state.resize(desired_state.size())
		button_presses.resize(buttons.size())
		button_presses.fill(false)

		while true:
			button_presses[0] += 1
			state.fill(0)

			for i: int in button_presses.size():
				if button_presses[i] == 2:
					if i + 1 == buttons.size():
						break

					button_presses[i] = 0
					button_presses[i + 1] += 1

			var count: int = button_presses.count(1)

			if count >= presses:
				if count == buttons.size():
					break
				continue
				
			# Create button group
			for i: int in button_presses.size():
				if button_presses[i] == 1:
					for x: int in buttons[i]:
						state[x] ^= 1

			if state == desired_state:
				presses = min(button_presses.count(1), presses)

		return presses # Failed


	func calculate_joltage() -> int:
		var presses: int = 0
				
		# Search if there's only one button which can fullfil a joltage number.
		while matrix_sum.has(1):
			var position: int = matrix_sum.find(1)
			var amount: int = joltage[position]
			var button_index: int = 0

			# Get correct button
			for row_id: int in matrix.size():
				if matrix[row_id][position] == 1:
					button_index = row_id
					break

			for i: int in matrix[button_index].size():
				if matrix[button_index][i] == 1:
					matrix_sum[i] -= 1
					joltage[i] -= amount

			matrix.remove_at(button_index)
			buttons.remove_at(button_index)
			presses += amount	

		# Next up, check if button_sum can solve the joltage
		for i: int in joltage.size():
			if matrix_sum[i] != 0 and joltage[i] % matrix_sum[i] != 0: break
			elif i == joltage.size() - 1:
				return presses + _joltage_even_quick_solve()

		# WARN: From here it gets messy
		# We still need to get the result from the others here.
		var temp_joltage: PackedInt32Array = []

		temp_joltage.resize(joltage.size())

		# Check if there is only one button group which can access a certain
		# joltage number.
		var button_ids: PackedInt32Array = []
		for group: PackedInt32Array in buttons:
			button_ids += group

		var lonely_ids: PackedInt32Array = []
		for x: int in joltage.size():
			if button_ids.count(x) == 1:
				lonely_ids.append(x)

		# If found, we count the presses to joltage_presses and remove the
		# presses from joltage.
		if lonely_ids.size() != 0:
			for lonely_id: int in lonely_ids:
				for group: PackedInt32Array in buttons:
					if group.has(lonely_id):
						var total_presses: int = joltage[lonely_id]

						for x: int in group:
							joltage[x] -= total_presses

						presses += total_presses

		var result: int = _bloody_joltage(0, temp_joltage) # Start recursion

		if result == -1:
			printerr("Something went wrong")
			return presses

		return presses + result


	func _bloody_joltage(index: int, temp_joltage: PackedInt32Array) -> int:
		var left_overs: PackedInt32Array = joltage.duplicate()
		var last_node: bool = index == buttons.size() - 1
		var presses: int = 0

		# Calculate left over values
		for i: int in temp_joltage.size():
			presses = max(presses, left_overs[i])
			left_overs[i] -= temp_joltage[i]

		# Calculate maximum amount of presses possible
		for button_index: int in buttons[index]:
			presses = min(presses, left_overs[button_index])

		# Calculate new temp_joltage
		for i: int in buttons[index]:
			temp_joltage[i] += presses
			left_overs[i] -= presses

		# Early exit, we should skip the loop since deducting won't make
		# a difference when it comes to the last number.
		if last_node and temp_joltage != joltage:
			return false

		# Check if the following buttons give the updates to each int necessary.
		var button_ids: PackedInt32Array = []

		for i: int in buttons.size() - index:
			button_ids += buttons[index + i]
		for i: int in temp_joltage.size():
			if left_overs[i] != 0 and !button_ids.has(i):
				return -1

		while temp_joltage != joltage:
			# Check if equal
			if !last_node and _bloody_joltage(index + 1, temp_joltage.duplicate()) != -1:
				break
			elif presses == 0:
				return -1

			presses -= 1

			# Calculate new temp_joltage
			for i: int in buttons[index]:
				temp_joltage[i] -= 1

		return presses


	func _joltage_even_quick_solve() -> int:
		for x: int in joltage.size():
			if joltage[x] != 0:
				@warning_ignore("INTEGER_DIVISION")
				return joltage[x] / matrix_sum[x]
		return 0 # Should not happen


	func _sort_buttons(a: PackedInt32Array, b: PackedInt32Array) -> bool:
			return a.size() > b.size()

