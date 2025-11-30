extends Node

const PATH: String = "res://05/data.txt"



func part_one() -> int:
	return _calculate_middles(_get_updates(_get_rules(), _get_pages(), true))


func part_two() -> int:
	var l_rules: Array[PackedInt64Array] = _get_rules()
	var l_updates: Array[PackedInt64Array] = _get_updates(l_rules, _get_pages(), false)

	for l_id: int in l_updates.size():
		while _get_updates(l_rules, [l_updates[l_id]], false).size() == 1:
			l_updates[l_id] = _attempt_fix(l_updates[l_id], l_rules)

	return _calculate_middles(l_updates)


func _get_rules() -> Array[PackedInt64Array]:
	var l_data: Array[PackedInt64Array] = []
	var l_file: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	var l_text: String = l_file.get_as_text(true)

	l_text = l_text.split('\n\n')[0]
	for l_line: String in l_text.split('\n'):
		if l_line != "":
			l_data.append(l_line.split('|') as Array as PackedInt64Array)

	return l_data


func _get_pages() -> Array[PackedInt64Array]:
	var l_data: Array[PackedInt64Array] = []
	var l_file: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	var l_text: String = l_file.get_as_text(true)

	l_text = l_text.split('\n\n')[1]
	for l_line: String in l_text.split('\n'):
		var l_entry: PackedInt64Array = []
		for l_string: String in l_line.split(','):
				l_entry.append(int(l_string))

		if l_entry.size() != 1:
			l_data.append(l_entry)

	return l_data


func _get_updates(a_rules: Array[PackedInt64Array], a_pages: Array[PackedInt64Array], a_correct: bool) -> Array[PackedInt64Array]:
	var l_updates: Array[PackedInt64Array] = []

	for l_id: int in a_pages.size():
		var l_check: PackedInt64Array = []
		var l_break: bool = false

		for l_page: int in a_pages[l_id]:
			l_check.append(l_page)

			for l_rule: PackedInt64Array in a_rules:
				if l_rule[0] == l_page and l_rule[1] in l_check:
					l_break = true
					break

		if (a_correct and !l_break) or (!a_correct and l_break):
			l_updates.append(a_pages[l_id])

	return l_updates


func _calculate_middles(a_updates: Array[PackedInt64Array]) -> int:
	var l_total: int = 0

	for l_update: PackedInt64Array in a_updates:
		l_total += l_update[ceil(l_update.size()/2.) - 1]

	return l_total


func _attempt_fix(a_update: PackedInt64Array, a_rules: Array[PackedInt64Array]) -> PackedInt64Array:
	var l_check: PackedInt64Array = a_update

	for l_page_id: int in l_check.size():
		for l_rule: PackedInt64Array in a_rules:
			if l_rule[0] == l_check[l_page_id] and l_rule[1] in l_check.slice(0, l_page_id):
				l_check.remove_at(l_check.find(l_rule[1]))
				l_check.push_back(l_rule[1])
				break

	return l_check
