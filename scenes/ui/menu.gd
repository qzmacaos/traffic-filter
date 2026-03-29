extends Control

@onready var _Levels= $Levels
@onready var _Credits= $Credits
@onready var _Main= $MarginContainer


func _on_ready() -> void:
	_Levels.hide()
	_Credits.hide()

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	_Main.hide()
	_Levels.show()


func _on_credits_pressed() -> void:
	_Main.hide()
	_Credits.show()


func _on_back_pressed() -> void:
	_Main.show()
	_Credits.hide()
	_Levels.hide()


func _on_level_1_pressed() -> void:
	Meta.level = "res://scenes/levels/level1/conditions.json"
	get_tree().change_scene_to_file("res://scenes/levels/Level.tscn")


func _on_level_2_pressed() -> void:
	Meta.level = "res://scenes/levels/level2/conditions.json"
	get_tree().change_scene_to_file("res://scenes/levels/Level.tscn")


func _on_level_3_pressed() -> void:
	Meta.level = "res://scenes/levels/level3/conditions.json"
	get_tree().change_scene_to_file("res://scenes/levels/Level.tscn")
