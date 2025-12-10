extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)
var boxes: Array[Vector3i] = []
var distances: Array = [] # [ distance, main_box, best_box ]



func _init() -> void:
	# Create boxes
	for i: int in data.size():
		var coords: PackedStringArray = data[i].split(',')

		boxes.append(Vector3i(int(coords[0]), int(coords[1]), int(coords[2])))

	# Get distances
	var box_a: Vector3i = Vector3i.ZERO
	var box_b: Vector3i = Vector3i.ZERO

	for i: int in boxes.size():
		for x: int in range(i + 1, boxes.size()):
			box_a = boxes[i]
			box_b = boxes[x]

			distances.append([box_a.distance_squared_to(box_b), box_a, box_b])

	distances.sort_custom(_sort_distance)


func part_one() -> int:
	var parents: Array = range(0, boxes.size())
	var sizes: PackedInt32Array = []

	sizes.resize(parents.size())
	sizes.fill(1)

	# Go over the closest pairs
	for i: int in boxes.size() if boxes.size() == 1000 else 10:
		var root_a: int = _find_root(parents, boxes.find(distances[i][1]))
		var root_b: int = _find_root(parents, boxes.find(distances[i][2]))

		# Different circuits == merge them
		if root_a != root_b:
			parents[root_b] = root_a
			sizes[root_a] += sizes[root_b]
			sizes[root_b] = 0

	for i: int in parents.size():
		sizes.append(parents.count(i))

	sizes.sort()
	return sizes[-1] * sizes[-2] * sizes[-3]


func part_two() -> int:
	var parents: PackedInt32Array = range(0, boxes.size())
	var single_boxes: int = boxes.size() # DSU (Union-find)

	# Go through all distances
	for entry: Array in distances:
		var root_a: int = _find_root(parents, boxes.find(entry[1]))
		var root_b: int = _find_root(parents, boxes.find(entry[2]))

		# Different roots == different circuits so connect
		if root_a != root_b:
			# Merging circuits
			parents[root_a] = root_b
			single_boxes -= 1

			if single_boxes == 1:
				return entry[1].x * entry[2].x

	return 0 # Something went wrong


func _sort_distance(a: Array, b: Array) -> bool:
	return a[0] < b[0]


func _find_root(parents: PackedInt32Array, i: int) -> int:
	# Finding the root
	var root: int = i
	
	while parents[root] != root:
		root = parents[root]
	
	# Path compression (point all nodes along path to root - flattening tree)
	var current: int = i

	while current != root:
		var next: int = parents[current]

		parents[current] = root
		current = next

	return root

