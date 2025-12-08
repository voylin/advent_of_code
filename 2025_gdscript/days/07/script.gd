extends Day

#var data_path: String = get_test_data_path()
var data_path: String = get_data_path()

var data: PackedStringArray = Data.get_string_array(data_path)
var answers: PackedInt64Array = [0, 1]



func part_one() -> int:
	var beams: Array = [data[0].find('S')]

	for i: int in (data.size() / 2.0) - 1:
		var line: String = data[2+i*2]
		var new_beams: Array = []
		
		for beam: int in beams:
			if line[beam] == '^':
				answers[0] += 1

				if !new_beams.has(beam-1): new_beams.append(beam-1)
				if !new_beams.has(beam+1): new_beams.append(beam+1)
			elif !new_beams.has(beam):
				new_beams.append(beam)

		beams = new_beams

	return answers[0]


func part_two() -> int:
	var beams: Dictionary = { data[0].find('S'): 1 }

	for i: int in (data.size() / 2.0) - 1:
		for beam: int in beams:
			if data[2+i*2][beam] == '^':
				var value: int = beams[beam]

				beams[beam - 1] = beams.get(beam - 1, 0) + value
				beams[beam + 1] = beams.get(beam + 1, 0) + value
				beams[beam] = 0
				answers[1] += value

	return answers[1]
