extends Node2D

var timer = 60

var conditions
var is_passable

var total_count = 0
var wrong_pass = 0
var wrong_block = 0

func next():
	if timer <= 0:
		end()
	else:
		is_passable = randi_range(0,1)
		var header = ""
		var body = ""
		if is_passable:
			header = conditions["passable"]["headers"][randi_range(0, len(conditions["passable"]["headers"])-1)]
			body = conditions["passable"]["bodys"][randi_range(0, len(conditions["passable"]["bodys"])-1)]
		else:
			header = conditions["blockable"]["headers"][randi_range(0, len(conditions["blockable"]["headers"])-1)]
			body = conditions["blockable"]["bodys"][randi_range(0, len(conditions["blockable"]["bodys"])-1)]
			
		$DisplayContainer/VBoxContainer/Display.text = header + "\n\n" + body
		
		$DisplayContainer/VBoxContainer/Display.visible_ratio = 0
		var tween = get_tree().create_tween()
		tween.tween_property($DisplayContainer/VBoxContainer/Display, 'visible_ratio', 1, 0.5)
		
func brief():
	$DisplayContainer/VBoxContainer/Display.text = conditions["brief"]
	
	$DisplayContainer/VBoxContainer/Display.visible_ratio = 0
	var tween = get_tree().create_tween()
	tween.tween_property($DisplayContainer/VBoxContainer/Display, 'visible_ratio', 1, 0.5)
	
func end():
	$StatsContainer/VBoxContainer/Stats.text = ""
	$DisplayContainer/VBoxContainer/Display.text = "Congratulations!"
		
func _process(delta: float) -> void:
	if timer>0:
		timer -=delta
	update_counters()
	

func _on_ready() -> void:
	var file = FileAccess.open("res://scenes/levels/level1/conditions.json", FileAccess.READ)
	if file == null:
		push_error("Cannot open file: res://scenes/levels/level1/conditions.json")
	conditions = JSON.parse_string(file.get_as_text())
	file.close()
	
	brief()
	

func update_counters():
	$Stats.text = "Time: "+str(int(timer))+\
	"\nLatency: 0" +\
	"\nTotal: "+str(total_count)+\
	"\nWrong pass: "+str(wrong_pass)+\
	"\nWrong blocked: "+str(wrong_block)

func  _pass():
	print("pass")
	if is_passable == 0:
		wrong_pass+=1
	total_count+=1
	next()
	

func  _block():
	print("block")
	if is_passable == 1:
		wrong_block+=1
	total_count+=1
	next()
		

func _on_block_pressed() -> void:
	_block()

func _on_pass_pressed() -> void:
	_pass()
	
func _on_to_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/Levels.tscn")

func _input(event):
	if event.is_action_pressed("Block"):
		_block()
	if event.is_action_pressed("Pass"):
		_pass()
