extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var machines: Array[Machine] = []
var answers: PackedInt64Array = [0, 0]



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
	for machine: Machine in machines:
		var value: int = machine.calculate_joltage()

		print(value)
		answers[1] += value
		#answers[1] += machine.calculate_joltage()

	return answers[1]


class Machine:
	var desired_state: PackedInt32Array = [] # 0000
	var buttons: Array[PackedInt32Array] = []
	var joltage: PackedInt32Array = []


	func _init(lights: PackedInt32Array, b: Array[PackedInt32Array], j: PackedInt32Array) -> void:
		desired_state = lights
		buttons = b
		joltage = j


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
		var state: PackedInt32Array = []
		var button_presses: Array[PackedInt32Array] = []
		var history: Dictionary = { state: 0 }
		var turn: int = 0

		state.resize(joltage.size())
		state.fill(0)
		button_presses.append(state)
		history[state] = 0

		while turn < button_presses.size():
			var current_state: PackedInt32Array = button_presses[turn].duplicate()
			var depth: int = history[current_state]

			for button_group: PackedInt32Array in buttons:
				var next_state: PackedInt32Array = current_state.duplicate()
				var valid: bool = true

				for i: int in button_group:
					next_state[i] += 1

					if next_state[i] > joltage[i]:
						valid = false
						break

				if not valid:
					continue
				elif next_state == joltage:
					return depth + 1

				# New state so add to list
				if not history.has(next_state):
					history[next_state] = depth + 1
					button_presses.append(next_state)

			turn += 1

		return 0
