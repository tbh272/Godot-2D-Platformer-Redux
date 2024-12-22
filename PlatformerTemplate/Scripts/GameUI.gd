extends Control

@export var player : Player
@onready var totaltxt = $DebugTotal

func _process(_delta: float) -> void:
	totaltxt.text = "Coin: " + str(GameManager.score)
