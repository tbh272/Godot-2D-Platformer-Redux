extends CharacterBody2D

#spawn some coins after death
var gravity : float = 30
@onready var sprite = $AnimatedSprite2D

var dead = false

func _process(_delta: float) -> void:
	movement()
	play_animation()

func movement():
	# Gravity
	if !is_on_floor():
		velocity.y += gravity
		
	move_and_slide()


func play_animation():
	#particle_trails.emitting = false
	if is_on_floor():
		if abs(velocity.x) > 0:
			#particle_trails.emitting = true
			sprite.play("Walk")
		else:
			sprite.play("Idle")
	else:
		if velocity.y < 0:
			sprite.play("Jump")
		else:
			sprite.play("Fall")

# ---- COLLISIONS WITH PLAYER ----

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "Sword":
		dead = true
		if dead == true:
			print("dead")
			queue_free()
			
		else:
			print("Not dead")
