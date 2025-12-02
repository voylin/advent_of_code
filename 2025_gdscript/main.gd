extends Control


@export_range(1, 12) var day: int = Time.get_date_dict_from_system().day

@export_group("Nodes")
@export var day_label: Label

@export var part_one_answer: LineEdit
@export var part_two_answer: LineEdit


var current_day: Day



func _ready() -> void:
	@warning_ignore("UNSAFE_METHOD_ACCESS")
	current_day = load("res://days/%02d/script.gd" % day).new()
	day_label.text =  "Day %02d" % day
	await RenderingServer.frame_post_draw

	# Part one + time measuring.
	var now: int = Time.get_ticks_msec()
	part_one_answer.text = str(current_day.part_one())
	print_rich("[color=dim_gray][i]Part one finished: ", Time.get_ticks_msec() - now, " msec")
	print_rich("[color=dim_gray][i]Answer part one: ", part_one_answer.text)

	await RenderingServer.frame_post_draw

	# Part two + time measuring.
	now = Time.get_ticks_msec()
	part_two_answer.text = str(current_day.part_two())
	print_rich("[color=dim_gray][i]Part two finished: ", Time.get_ticks_msec() - now, " msec")
	print_rich("[color=dim_gray][i]Answer part two: ", part_two_answer.text)
