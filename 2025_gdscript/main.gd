extends Control


@export_range(1, 12) var day: int = Time.get_date_dict_from_system().day

@export_group("Nodes")
@export var day_label: Label

@export var part_one_answer: LineEdit
@export var part_two_answer: LineEdit
@export var part_one_time_label: Label
@export var part_two_time_label: Label


const PRINT_STYLE: String = "[color=dim_gray][i]"


var current_day: Day
var running: bool = false



func _ready() -> void:
	run_day()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("re-run"):
		if running:
			printerr("Still running")
			return

		# Reset labels.
		part_one_answer.text = ""
		part_two_answer.text = ""
		part_one_time_label.text = "0 msec "
		part_two_time_label.text = "0 msec "

		run_day()


func run_day() -> void:
	running = true
	@warning_ignore("UNSAFE_METHOD_ACCESS")
	current_day = load("res://days/%02d/script.gd" % day).new()
	day_label.text =  "Day %02d" % day

	await _run(part_one_answer, part_one_time_label, current_day.part_one)
	await _run(part_two_answer, part_two_time_label, current_day.part_two)

	print_rich(PRINT_STYLE, "Part one: ", part_one_time_label.text)
	print_rich(PRINT_STYLE, "Part two: ", part_two_time_label.text)
	print()
	print_rich(PRINT_STYLE, "Answer part one: ", part_one_answer.text)
	print_rich(PRINT_STYLE, "Answer part two: ", part_two_answer.text)
	running = false


func _run(answer_box: LineEdit, time_label: Label, callable: Callable) -> int:
	# Quick await so screen can update
	await RenderingServer.frame_post_draw

	var now: int = Time.get_ticks_msec()
	var answer: int = callable.call()
	var total_time: int = Time.get_ticks_msec() - now

	answer_box.text = str(answer)
	time_label.text = "%s msec " % total_time

	return total_time
