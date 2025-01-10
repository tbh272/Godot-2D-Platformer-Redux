extends Area2D

# Define the next scene to load in the inspector
@export var next_scene : PackedScene
@onready var show_ui = $Panel
var entered := false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		entered = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		entered = false
	
func _process(_delta: float) -> void:
	if entered == true:
		#print("entered")
		if Input.is_action_just_pressed("Interact"):	
			get_tree().change_scene_to_packed(next_scene)
			entered = false
		
		#show ui
		show_ui.visible = true
	else:
		show_ui.visible = false
