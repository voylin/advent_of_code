extends Control

@export_range(0, 25) var day: int
@export_range(0,2) var part: int

@onready var day_label: Label = find_child("DayLabel")

@onready var day_one_box: PanelContainer = find_child("PartOneBox")
@onready var day_one_label: RichTextLabel = find_child("PartOneValue")

@onready var day_two_box: PanelContainer = find_child("PartTwoBox")
@onready var day_two_label: RichTextLabel = find_child("PartTwoValue")


func _ready() -> void:
	if day == 0: # Select current day
		day = Time.get_date_dict_from_system().day
	
	var l_print_string: String = "Part %s result: %s"
	
	day_label.text = "Day %02d" % day
	print_rich("[b]Day %02d[/b]" % day)

	if part == 1 or part == 0:
		var l_value: String = str(find_child("%02d" % day).call("part_one"))

		day_one_label.text = "[center]%s" % l_value
		print(l_print_string % ["one", l_value])
	else:
		day_one_box.visible = false


	if part == 2 or part == 0:
		var l_value: String = str(find_child("%02d" % day).call("part_two"))

		day_two_label.text = "[center]%s" % l_value
		print(l_print_string % ["two", l_value])
	else:
		day_two_box.visible = false

