extends Control


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Tutorial/tutorial.tscn")


func _on_level_one_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
