extends Control


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/menu.tscn")


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value/5)
