extends Node2D

var data
var task_num = 0

func display():
	$Display.text = data[task_num].message
		

func _on_ready() -> void:
	var file = FileAccess.open("res://scenes/levels/level1/level1.json", FileAccess.READ)
	if file == null:
		push_error("Cannot open file: res://scenes/levels/level1/level1.json")
	data = JSON.parse_string(file.get_as_text())
	file.close()
	
	display()
	
