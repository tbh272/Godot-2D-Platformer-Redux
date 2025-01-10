extends Control

@onready var totaltxt = $DebugTotal

func _process(_delta: float) -> void:
	totaltxt.text = "Coin: " + str(GameManager.score)
	#$Health_UI/Label.text = str(player.player_health)
