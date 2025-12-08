extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_full_string(data_path, true).split('\n\n')
var rules: Array[PackedInt64Array]= _get_rules()
var pages: Array[PackedInt64Array] = _get_pages()



func part_one() -> int:
	return _calculate_middles(_get_updates(pages, true))


func part_two() -> int:
	var updates: Array[PackedInt64Array] = _get_updates(pages, false)

	for i: int in updates.size():
		while _get_updates([updates[i]], false).size() == 1:
			updates[i] = _attempt_fix(updates[i])

	return _calculate_middles(updates)


func _get_rules() -> Array[PackedInt64Array]:
	var temp_data: Array[PackedInt64Array] = []

	for line: String in data[0].split('\n'):
		if line != "":
			temp_data.append(line.split('|') as Array as PackedInt64Array)

	return temp_data


func _get_pages() -> Array[PackedInt64Array]:
	var temp_data: Array[PackedInt64Array] = []

	for line: String in data[1].split('\n'):
		var entry: PackedInt64Array = []

		for string: String in line.split(','):
			entry.append(int(string))

		if entry.size() != 1:
			temp_data.append(entry)

	return temp_data


func _get_updates(new_pages: Array[PackedInt64Array], correct: bool) -> Array[PackedInt64Array]:
	var updates: Array[PackedInt64Array] = []

	for i: int in new_pages.size():
		var check: PackedInt64Array = []
		var stop: bool = false

		for page: int in new_pages[i]:
			check.append(page)

			for rule: PackedInt64Array in rules:
				if rule[0] == page and rule[1] in check:
					stop = true
					break

		if (correct and !stop) or (!correct and stop):
			updates.append(new_pages[i])

	return updates


func _calculate_middles(updates: Array[PackedInt64Array]) -> int:
	var total: int = 0

	for update: PackedInt64Array in updates:
		total += update[ceil(update.size()/2.) - 1]

	return total


func _attempt_fix(update: PackedInt64Array) -> PackedInt64Array:
	var check: PackedInt64Array = update

	for i: int in check.size():
		for rule: PackedInt64Array in rules:
			if rule[0] == check[i] and rule[1] in check.slice(0, i):
				check.remove_at(check.find(rule[1]))
				check.push_back(rule[1])
				break

	return check
