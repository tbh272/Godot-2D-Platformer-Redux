extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("win")
		await GameManager.frame_freeze(0.5, 0.2)
		get_tree().change_scene_to_file("res://UI/Menus/win_screen.tscn")
