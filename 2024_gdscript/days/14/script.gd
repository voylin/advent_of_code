extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

# NOTE: this shouldn't be like this ...
const MAP_SIZE: Vector2i = Vector2i(101, 103) # Real data
#const MAP_SIZE: Vector2i = Vector2i(11, 7) # Test data



func part_one() -> int:
	var positions: Array[Vector2i]

	for line: String in Data.get_string_array(data_path):
		positions.append(calculate_position(line))

	return calculate_quadrants(positions)


func part_two() -> int:
	# This does not work with the test code
	var robots: Array[Robot] = []
	var found: bool = false
	var steps: int = 0

	# Create robots
	for line: String in Data.get_string_array(data_path):
		robots.append(Robot.new(line))

	# While loop until christmas tree found
	while !found:
		steps += 1
		for robot: Robot in robots:
			one_step(robot)

		for line: String in get_robot_map(robots):
			if line.count('#') < 20:
				continue
			for part: String in line.split(' ', false):
				if part.length() > 18:
					found = true
					break

	# Print christmas tree for fun
	for line: String in get_robot_map(robots):
		print(line)

	return steps


func calculate_position(line: String) -> Vector2i:
	var position: Vector2i = Vector2i.ZERO
	var velocity: Vector2i = Vector2i.ZERO
	
	# Set position
	var pos_string: PackedStringArray = line.split(' ')[0].trim_prefix('p=').split(',')
	position = Vector2i(int(pos_string[0]), int(pos_string[1]))

	# Set velocity
	var vel_string: PackedStringArray = line.split(' ')[1].trim_prefix('v=').split(',')
	velocity = Vector2i(int(vel_string[0]) * 100, int(vel_string[1]) * 100)

	# Calculate X and Y from current position and then do % map size and save remainder
	position.x = (position.x + velocity.x) % MAP_SIZE.x
	position.y = (position.y + velocity.y) % MAP_SIZE.y

	# Correct negative values
	if position.x < 0:
		position.x = MAP_SIZE.x + position.x
	if position.y < 0:
		position.y = MAP_SIZE.y + position.y

	return position


func calculate_quadrants(a_positions: Array[Vector2i]) -> int:
	var quadrant_sizing: Vector2i = Vector2i(floor(MAP_SIZE.x / 2.), floor(MAP_SIZE.y / 2.))
	var quadrants: PackedInt64Array = [0, 0, 0, 0]

	for pos: Vector2i in a_positions:
		if pos.x < quadrant_sizing.x: # left half
			if pos.y < quadrant_sizing.y: # top
				quadrants[0] += 1
			elif pos.y > quadrant_sizing.y: # bottom
				quadrants[1] += 1
		elif pos.x > quadrant_sizing.x: # right half
			if pos.y < quadrant_sizing.y: # top
				quadrants[2] += 1
			elif pos.y > quadrant_sizing.y: # bottom
				quadrants[3] += 1

	for id: int in quadrants.size():
		if quadrants[id] == 0:
			quadrants[id] = 1

	return quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3]


func one_step(robot: Robot) -> void:
	robot.position.x = (robot.position.x + robot.velocity.x) % MAP_SIZE.x
	robot.position.y = (robot.position.y + robot.velocity.y) % MAP_SIZE.y

	# Correct negative values
	if robot.position.x < 0:
		robot.position.x = MAP_SIZE.x + robot.position.x
	if robot.position.y < 0:
		robot.position.y = MAP_SIZE.y + robot.position.y


func get_robot_map(a_robots: Array[Robot]) -> PackedStringArray:
	var positions: Array[Vector2i]
	for robot: Robot in a_robots:
		positions.append(robot.position)

	var map: PackedStringArray = []
	for y: int in MAP_SIZE.y:
		map.append("")

		for x: int in MAP_SIZE.x:
			if Vector2i(x, y) in positions:
				map[-1] += '#'
			else:
				map[-1] += ' '
	return map


class Robot:
	var position: Vector2i
	var velocity: Vector2i


	func _init(line: String) -> void:
		# Set position
		var pos_string: PackedStringArray = line.split(' ')[0].trim_prefix('p=').split(',')
		position = Vector2i(int(pos_string[0]), int(pos_string[1]))

		# Set velocity
		var vel_string: PackedStringArray = line.split(' ')[1].trim_prefix('v=').split(',')
		velocity = Vector2i(int(vel_string[0]), int(vel_string[1]))

