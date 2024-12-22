extends CharacterBody2D

#todo spawn some coins after death
var gravity : float = 30
@onready var sprite = $Sprite
@onready var anim_player = $AnimationPlayer

enum enemy_states {MOVE, DEATH, ATTACK}
var states = enemy_states.MOVE

var dead = false

func _ready() -> void:
	states = enemy_states.MOVE

func _physics_process(_delta: float) -> void:
	match states:
		enemy_states.MOVE:
			move_state()
		enemy_states.DEATH:
			pass
		enemy_states.ATTACK:
			pass
	
	play_animation()

func move_player():
	move_and_slide()

func move_state():
	# Gravity
	if !is_on_floor():
		velocity.y += gravity
		
	move_player()


func play_animation():
	#particle_trails.emitting = false
	match states:
		enemy_states.MOVE:
			if is_on_floor() and abs(velocity.x) > 0:
				#anim_player.play("BaseAnimations/Move")
				pass
			else:
				#anim_player.play("BaseAnimations/Idle")
				pass
				
				#if velocity.y < 0 and !is_on_floor():

# ---- COLLISIONS WITH PLAYER ----

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "Sword":
		dead = true
		if dead:
			print("dead")
			queue_free()
			GameManager.add_score(5)
		else:
			print("Not dead")
