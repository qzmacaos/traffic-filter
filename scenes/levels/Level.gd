extends Control

@onready var _display = $DisplayContainter/Display

@onready var _stats = $StatsContainer/Stats
@onready var _conditions = $ConditionContainer/Conditions
@onready var _game_status = $GameStatusContainer/GameStatus

@onready var _pass_btn = $Buttons/HBoxContainer/Pass
@onready var _block_btn = $Buttons/HBoxContainer/Block
@onready var _to_menu_btn = $Buttons/HBoxContainer/ToMenu
@onready var _restart_btn = $Buttons/HBoxContainer/Restart

var game_began = false
var timer = 10

var conditions
var is_passable

var total_count = 0
var wrong_pass = 0
var wrong_block = 0

const GAME_BEGAN= "Left Arrow to Block\nRight Arrow to Pass\nEsc to Pause"
const GAME_PAUSE = "Game paused\nPress Enter to resume"

func next():
	if game_began:
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
				
			_display.text = header + "\n\n" + body
			
			_display.visible_ratio = 0
			var tween = get_tree().create_tween()
			tween.tween_property(_display, 'visible_ratio', 1, 0.2)
		
func brief():
	_display.text = "\n".join(conditions["brief"])
	
	_display.visible_ratio = 0
	var tween = get_tree().create_tween()
	tween.tween_property(_display, 'visible_ratio', 1, 2)
	
	
	
func end():
	_pass_btn.hide()
	_block_btn.hide()
	_display.visible_ratio = 0
	_stats.text = ""
	
	var end_text = ""
	var grade = 10
	var grade_sym = "F"
	
	if wrong_pass :
		grade -= 10
	
	if wrong_block :
		grade -= wrong_block
		
	if total_count /10 < conditions["end"]["metrics"]["rps"]:
		grade  -= 1
	
	if grade > 3:
		grade_sym = "E"
	if grade > 5:
		grade_sym = "D"
	if grade > 6:
		grade_sym = "C"
	if grade >7:
		grade_sym = "B"
	if grade >8:
		grade_sym = "A"
	if grade == 10:
		grade_sym = "S+"
		
	end_text += "\n\nGRADE: "+grade_sym
	
	_display.text = end_text
	
	var tween = get_tree().create_tween()
	tween.tween_property(_display, 'visible_ratio', 1, 2)
	
	
	await get_tree().create_timer(2.0).timeout
	var news = "\n".join(conditions["end"]["news"]["fail"])
	if grade > 6:
		news = "\n".join(conditions["end"]["news"]["success"])
	
	_display.text = end_text+"\n\nNEWS\n\n"+news
	
	_to_menu_btn.show()
	_restart_btn.show()
		
		
func _process(delta: float) -> void:
	if timer>0 and game_began:
		timer -=delta
	update_counters()
	

func _on_ready() -> void:
	_pass_btn.hide()
	_block_btn.hide()
	_to_menu_btn.hide()
	_restart_btn.hide()
	
	var file = FileAccess.open(Meta.level, FileAccess.READ)
	if file == null:
		push_error("Cannot open file: "+Meta.level)
	conditions = JSON.parse_string(file.get_as_text())
	file.close()
	
	brief()
	

func update_counters():
	_stats.text = "Time: " + str(snapped(timer, 0.01)) + \
	"\nRPS: " + str(snapped(total_count/(10 - timer+1), 0.01))  + \
	"\nTotal: "+str(total_count)+\
	"\nWrong pass: "+str(wrong_pass)+\
	"\nWrong blocked: "+str(wrong_block)

func  _pass():
	if game_began:
		if is_passable == 0:
			wrong_pass+=1
			$BlockFail.play()
		total_count+=1
		next()
	

func  _block():
	if game_began:
		if is_passable == 1:
			wrong_block+=1
			$PassFail.play()
		total_count+=1
		next()
		

func _on_block_pressed() -> void:
	_block()

func _on_pass_pressed() -> void:
	_pass()
	
func _on_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/Menu.tscn")

func _input(event):
	if event.is_action_pressed("Block"):
		_block()
	if event.is_action_pressed("Pass"):
		_pass()
	if event.is_action_pressed("Begin") and not game_began:
		game_began = true
		_block_btn.show()
		_pass_btn.show()
		_conditions.text = "\n".join(conditions["conditions"])
		_game_status.text = GAME_BEGAN
		next()
	if event.is_action_pressed("Stop"):
		if game_began:
			game_began = false
			_pass_btn.hide()
			_block_btn.hide()
			_restart_btn.show()
			_to_menu_btn.show()
			_game_status.text  = GAME_PAUSE
		else:
			game_began = true
			_block_btn.show()
			_pass_btn.show()
			_restart_btn.hide()
			_to_menu_btn.hide()
			_game_status.text  = GAME_BEGAN


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene() 
