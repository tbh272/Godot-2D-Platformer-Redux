extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_01.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
