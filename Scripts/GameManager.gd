extends Node2D

var score : int = 0

# Adds 1 to score variable
func add_score(value : int):
	score += value

# Loads next level
func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)
	
func reset_player(_player : Player, _spawn_point : Marker2D):
	_player.global_position = _spawn_point.global_position

#hit stop
func frame_freeze(timescale, duration):
	Engine.time_scale = timescale
	await(get_tree().create_timer(duration * timescale).timeout)
	Engine.time_scale = 1.0
