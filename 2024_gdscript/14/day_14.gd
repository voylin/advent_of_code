extends Node

const PATH: String = "res://14/data.txt"
const MAP_SIZE: Vector2i = Vector2i(101, 103) # Real data
#const PATH: String = "res://14/test_data.txt"
#const MAP_SIZE: Vector2i = Vector2i(11, 7) # Test data



func part_one() -> int:
	var l_positions: Array[Vector2i]

	for l_line: String in Data.get_string_array(PATH):
		l_positions.append(calculate_position(l_line))

	print_map(l_positions)
	return calculate_quadrants(l_positions)


func part_two() -> int:
	# This does not work with the test code
	var l_robots: Array[Robot] = []
	var l_found: bool = false
	var l_steps: int = 0

	# Create robots
	for l_line: String in Data.get_string_array(PATH):
		l_robots.append(Robot.new(l_line))

	# While loop until christmas tree found
	while !l_found:
		l_steps += 1
		for l_robot: Robot in l_robots:
			one_step(l_robot)

		for l_line: String in get_robot_map(l_robots):
			if l_line.count('#') < 20:
				continue
			for l_part: String in l_line.split(' ', false):
				if l_part.length() > 18:
					l_found = true
					break

	# Print christmas tree for fun
	for l_line: String in get_robot_map(l_robots):
		print(l_line)

	return l_steps


func calculate_position(l_line: String) -> Vector2i:
	var l_position: Vector2i = Vector2i.ZERO
	var l_velocity: Vector2i = Vector2i.ZERO
	
	# Set position
	var l_pos_string: PackedStringArray = l_line.split(' ')[0].trim_prefix('p=').split(',')
	l_position = Vector2i(int(l_pos_string[0]), int(l_pos_string[1]))

	# Set velocity
	var l_vel_string: PackedStringArray = l_line.split(' ')[1].trim_prefix('v=').split(',')
	l_velocity = Vector2i(int(l_vel_string[0]) * 100, int(l_vel_string[1]) * 100)

	# Calculate X and Y from current position and then do % map size and save remainder
	l_position.x = (l_position.x + l_velocity.x) % MAP_SIZE.x
	l_position.y = (l_position.y + l_velocity.y) % MAP_SIZE.y

	# Correct negative values
	if l_position.x < 0:
		l_position.x = MAP_SIZE.x + l_position.x
	if l_position.y < 0:
		l_position.y = MAP_SIZE.y + l_position.y

	return l_position


func calculate_quadrants(a_positions: Array[Vector2i]) -> int:
	var l_quadrant_sizing: Vector2i = Vector2i(floor(MAP_SIZE.x / 2.), floor(MAP_SIZE.y / 2.))
	var l_quadrants: PackedInt64Array = [0, 0, 0, 0]

	for l_pos: Vector2i in a_positions:
		if l_pos.x < l_quadrant_sizing.x: # left half
			if l_pos.y < l_quadrant_sizing.y: # top
				l_quadrants[0] += 1
			elif l_pos.y > l_quadrant_sizing.y: # bottom
				l_quadrants[1] += 1
		elif l_pos.x > l_quadrant_sizing.x: # right half
			if l_pos.y < l_quadrant_sizing.y: # top
				l_quadrants[2] += 1
			elif l_pos.y > l_quadrant_sizing.y: # bottom
				l_quadrants[3] += 1

	for l_id: int in l_quadrants.size():
		if l_quadrants[l_id] == 0:
			l_quadrants[l_id] = 1

	return l_quadrants[0] * l_quadrants[1] * l_quadrants[2] * l_quadrants[3]


func one_step(a_robot: Robot) -> void:
	a_robot.position.x = (a_robot.position.x + a_robot.velocity.x) % MAP_SIZE.x
	a_robot.position.y = (a_robot.position.y + a_robot.velocity.y) % MAP_SIZE.y

	# Correct negative values
	if a_robot.position.x < 0:
		a_robot.position.x = MAP_SIZE.x + a_robot.position.x
	if a_robot.position.y < 0:
		a_robot.position.y = MAP_SIZE.y + a_robot.position.y


func print_map(a_positions: Array[Vector2i]) -> void:
	for y: int in MAP_SIZE.y:
		var l_line: String = ""

		for x: int in MAP_SIZE.x:
			if Vector2i(x, y) in a_positions:
				l_line += '#'
			else:
				l_line += '.'
		print(l_line)


func get_robot_map(a_robots: Array[Robot]) -> PackedStringArray:
	var l_positions: Array[Vector2i]

	for l_robot: Robot in a_robots:
		l_positions.append(l_robot.position)

	var l_map: PackedStringArray = []
	for y: int in MAP_SIZE.y:
		l_map.append("")

		for x: int in MAP_SIZE.x:
			if Vector2i(x, y) in l_positions:
				l_map[-1] += '#'
			else:
				l_map[-1] += ' '
	return l_map


class Robot:
	var position: Vector2i
	var velocity: Vector2i


	func _init(l_line: String) -> void:
		# Set position
		var l_pos_string: PackedStringArray = l_line.split(' ')[0].trim_prefix('p=').split(',')
		position = Vector2i(int(l_pos_string[0]), int(l_pos_string[1]))

		# Set velocity
		var l_vel_string: PackedStringArray = l_line.split(' ')[1].trim_prefix('v=').split(',')
		velocity = Vector2i(int(l_vel_string[0]), int(l_vel_string[1]))

