extends Control


@export_range(1, 12) var day: int = Time.get_date_dict_from_system().day

@export_group("Nodes")
@export var day_label: Label

@export var part_one_answer: LineEdit
@export var part_two_answer: LineEdit


var current_day: Day



func _ready() -> void:
	@warning_ignore("unsafe_method_access")
	current_day = load("res://days/%02d/script.gd" % day).new()

	day_label.text =  "Day %02d" % day
	part_one_answer.text = str(current_day.part_one())
	part_two_answer.text = str(current_day.part_two())
