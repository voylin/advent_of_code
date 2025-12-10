extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)



func part_one() -> int:
	var box_circuit_ids: PackedInt64Array = []
	var boxes: Array[Vector3i] = []

	var distances: Array = [] # [ distance, main_box, best_box ]
	var circuits: Array[Array] = []

	# Create boxes
	for key: String in data:
		var coords: PackedStringArray = key.split(',')

		boxes.append(Vector3i(int(coords[0]), int(coords[1]), int(coords[2])))
		box_circuit_ids.append(-1)

	# Get distances
	for i: int in boxes.size():
		for x: int in range(i + 1, boxes.size()):
			distances.append([boxes[i].distance_to(boxes[x]), boxes[i], boxes[x]])

	# We sort and only get the amount needed
	distances.sort_custom(_sort_distance)
	distances = distances.slice(0, boxes.size() if boxes.size() == 1000 else 10)

	# Go over the closest pairs
	for i: int in distances.size():
		var main_box_id: int = boxes.find(distances[i][1])
		var best_box_id: int = boxes.find(distances[i][2])
	
		# Create new circuit if needed
		if box_circuit_ids[main_box_id] == -1 and box_circuit_ids[best_box_id] == -1:
			box_circuit_ids[main_box_id] = circuits.size()
			box_circuit_ids[best_box_id] = circuits.size()
			circuits.append([distances[i][1], distances[i][2]])
			continue
	
		# Add main_box to best_box circuit
		if box_circuit_ids[main_box_id] != -1 and box_circuit_ids[best_box_id] == -1:
			circuits[box_circuit_ids[main_box_id]].append(distances[i][2])
			box_circuit_ids[best_box_id] = box_circuit_ids[main_box_id]
			continue
	
		# Add best_box to main_box circuit
		if box_circuit_ids[best_box_id] != -1 and box_circuit_ids[main_box_id] == -1:
			circuits[box_circuit_ids[best_box_id]].append(distances[i][1])
			box_circuit_ids[main_box_id] = box_circuit_ids[best_box_id]
			continue
	
		# Check for same circuit
		if box_circuit_ids[main_box_id] == box_circuit_ids[best_box_id]:
			continue

		# So we've checked if they belonged to the same circuit, or if they
		# didn't have a circuit. But it's possible that we need to merge
		# circuits as one could be closer to another one which is already in
		# a different circuit.
	
		# Merge circuits if needed
		var old_circuit_id: int = box_circuit_ids[best_box_id]

		for box: Vector3i in circuits[box_circuit_ids[best_box_id]]:
			circuits[box_circuit_ids[main_box_id]].append(box)
			box_circuit_ids[boxes.find(box)] = box_circuit_ids[main_box_id]

		circuits[old_circuit_id] = []

	# Find the largest circuits
	circuits.sort_custom(_sort_size)

	print(circuits)

	return circuits[0].size() * circuits[1].size() * circuits[2].size()


func part_two() -> int:
	return 0


func _sort_distance(a: Array, b: Array) -> bool:
	return a[0] < b[0]


func _sort_size(a: Array, b: Array) -> bool:
	return a.size() > b.size()

