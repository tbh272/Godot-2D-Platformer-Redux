extends CharacterBody2D

#todo spawn some coins after death
var gravity : float = 30
@onready var sprite = $Sprite
@onready var anim_player = $AnimationPlayer

enum enemy_states {MOVE, DEATH, ATTACK}
var states = enemy_states.MOVE

var dead = false

var hp : int = 100 : set = _on_hp_set
var max_hp : int = 100
var defense : int = 2
var weapon_damage : int = 15

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
	var base_damage = weapon_damage
	var damage_taken = Math.calculate_damage(base_damage, weapon_damage, defense)
	hp -= damage_taken
	print(hp)
	if hp <= 0:
		print("Dead")
		queue_free()
			
func _on_hp_set(new_value : int):
	hp = new_value
	#progress bar update
