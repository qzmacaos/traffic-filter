extends Control


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level1/Level1.tscn")
