extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var machines: Array[Machine] = []
var answers: PackedInt64Array = [0, 0]

var mutex: Mutex = Mutex.new()



func _init() -> void:
	for line: String in Data.get_string_array(data_path):
		# Get the light indicators
		var lights: String = line.substr(1, line.find(']') - 1)
		var lights_array: PackedInt32Array = []

		lights = lights.replace('.', '0')
		lights = lights.replace('#', '1')

		for light: String in lights.split():
			lights_array.append(int(light))			

		# Get the buttons
		var buttons: String = line.substr(line.find(' ') + 1)
		var button_groups: Array[PackedInt32Array] = []

		buttons = buttons.substr(0, buttons.find('{') - 1)
		for group: String in buttons.split(' '):
			var button_group: PackedInt32Array = []
			var entries: PackedStringArray = group.trim_prefix('(').trim_suffix(')').split(',')

			for entry: String in entries:
				button_group.append(int(entry))

			button_groups.append(button_group)
			
		# Get the joltage
		var joltage: String = line.substr(line.find('{') + 1).left(-1)
		var joltage_array: PackedInt32Array = []

		for j: String in joltage.split(','):
			joltage_array.append(int(j))

		machines.append(Machine.new(lights_array, button_groups, joltage_array))


func part_one() -> int:
	for machine: Machine in machines:
		answers[0] += machine.calculate_lights()

	return answers[0]


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
				print("remaining: ", remaining, "/", machines.size())
				WorkerThreadPool.wait_for_task_completion(task_id)
				tasks.remove_at(tasks.find(task_id))

	return answers[1]


func _run_part_two(machine: Machine) -> void:
	var value: int = machine.calculate_joltage()
	mutex.lock()

	if value == 0:
		printerr("machine returned 0!!")
		printerr(machine.joltage)

	answers[1] += value
	mutex.unlock()
	


class Machine:
	var desired_state: PackedInt32Array = [] # 0000
	var buttons: Array[PackedInt32Array] = []
	var joltage: PackedInt32Array = []
	var joltage_presses: int = 0


	func _init(lights: PackedInt32Array, b: Array[PackedInt32Array], j: PackedInt32Array) -> void:
		desired_state = lights
		buttons = b
		joltage = j

		buttons.sort_custom(_sort_buttons)


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
		# Use recursion. Start with the maximum amount.
		# Reverse button array according to size.
		# For each button in button group, we check the maximum and take the minimum.
		# Check if all values are below, if up, we continue to do -1 till we get
		# a combination which fits.
		# Like this we loop over all numbers till we got a perfect fit.
		# Return value should be "false" didn't fit, try again or "true" for fit.
		# We store the correct button_presses in a new class variable called,
		# Joltage button presses.
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

						joltage_presses += total_presses

		_bloody_joltage(0, temp_joltage) # Start recursion
		return joltage_presses


	func _bloody_joltage(index: int, temp_joltage: PackedInt32Array) -> bool:
		var left_overs: PackedInt32Array = joltage.duplicate()
		var last_node: bool = index == buttons.size() - 1
		var presses: int = 0

		# Calculate left over values
		for i: int in temp_joltage.size():
			left_overs[i] -= temp_joltage[i]
			presses = max(presses, left_overs[i])

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
				return false
#			elif left_overs[i] == 0 and button_ids.has(i):
#				if !buttons[index].has(i) and button_ids.count(i) == buttons.size() - index - 1:
#					return false

		while temp_joltage != joltage:
			# Check if equal
			if !last_node and _bloody_joltage(index + 1, temp_joltage.duplicate()):
				break
			elif presses == 0:
				return false

			presses -= 1

			# Calculate new temp_joltage
			for i: int in buttons[index]:
				temp_joltage[i] -= 1

		joltage_presses += presses
		return true


	func _sort_buttons(a: PackedInt32Array, b: PackedInt32Array) -> bool:
			return a.size() > b.size()

