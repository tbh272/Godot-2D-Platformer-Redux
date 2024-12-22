# This script is an autoload, that can be accessed from any other script!

extends Node2D

var score : int = 0

# Adds 1 to score variable
func add_score(value : int):
	score += value

# Loads next level
func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)
	
func frame_freeze(timescale, duration):
	Engine.time_scale = timescale
	await(get_tree().create_timer(duration * timescale).timeout)
	Engine.time_scale = 1.0
