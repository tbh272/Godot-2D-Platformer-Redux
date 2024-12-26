extends CharacterBody2D

#todo spawn some coins after death
var gravity : float = 30
@onready var sprite = $Sprite
@onready var anim_player = $AnimationPlayer
@onready var Enemy_health = $Health

enum {MOVE, DEATH, ATTACK}
var states = MOVE

var dead = false

var weapon_damage : int = 25

func _ready() -> void:
	states = MOVE

func _physics_process(_delta: float) -> void:
	match states:
		MOVE:
			move_state()
		DEATH:
			pass
		ATTACK:
			pass
	
	play_animation()

func move_state():
	# Gravity
	if !is_on_floor():
		velocity.y += gravity
		
	move_and_slide()

func play_animation():
	match states:
		MOVE:
			pass
		DEATH:
			pass
		ATTACK:
			pass

# ---- COLLISIONS WITH PLAYER ----

func _on_hitbox_area_entered(area: Area2D) -> void:
	var base_damage = weapon_damage
	var damage_taken = Math.calculate_damage(base_damage, weapon_damage, Enemy_health.defense)
	Enemy_health.health -= damage_taken
	#health = Enemy_health.health
	print(Enemy_health.health)
	if Enemy_health.health <= 0:
		print("Dead")
		GameManager.add_score(5)
		queue_free() #todo add a death anim

func _on_health_health_changed(diff: int) -> void:
	$ProgressBar.value = Enemy_health.health
