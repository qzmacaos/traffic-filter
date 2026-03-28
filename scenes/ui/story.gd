extends Control

func load_menu():
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
	


func _ready() -> void:
	
	var tween = get_tree().create_tween()
	tween.tween_property($MarginContainer/VBoxContainer/Label, 'visible_ratio', 1, 30)
	await get_tree().create_timer(31.0).timeout
	load_menu()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		load_menu()
	
