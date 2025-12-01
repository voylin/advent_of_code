@abstract
class_name Day
extends Node
## Use get_data_path() and get_test_data_path() to get the correct paths.


func get_data_path() -> String:
	@warning_ignore("UNSAFE_METHOD_ACCESS")
	return self.get_script().resource_path.get_base_dir() + "/data.txt"


func get_test_data_path() -> String:
	@warning_ignore("UNSAFE_METHOD_ACCESS")
	return self.get_script().resource_path.get_base_dir() + "/data_test.txt"


@abstract func part_one() -> int
@abstract func part_two() -> int
