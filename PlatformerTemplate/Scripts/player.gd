extends CharacterBody2D

# --------- VARIABLES ---------- #

@export_category("Movement") # You can tweak these changes according to your likings
@export var move_speed : float = 300
@export var jump_force : float = 600
var gravity : float = 30

var is_grounded : bool = false
var attacking : bool = false

@onready var player_sprite = $Sprite
@onready var spawn_point = %SpawnPoint
@onready var particle_trails = $ParticleTrails
@onready var death_particles = $DeathParticles
@onready var sword_collision = $Sword/CollisionShape2D
@onready var anim_player = $AnimationPlayer

@export_category("Dash")
@onready var dash_timer = 0.0
@export var dash_speed = 500
@export var dash_duration = 0.2
@onready var dash_direction = Vector2.ZERO
@export var dash_cooldown = 0.8
var is_dashing : bool = false


# ---- PLAYER STATES ----
enum player_states {MOVE, DASH,ATTACK}
var state = player_states.MOVE

# --------- BUILT-IN FUNCTIONS ---------- #
func _ready() -> void:
	sword_collision.disabled = true

func _process(delta: float) -> void:
	if dash_timer > 0:
		dash_timer -= delta

func _physics_process(delta):
	match state:
		player_states.MOVE:
			move_state()
		player_states.ATTACK:
			attack_state()
		player_states.DASH:
			dash_state()
	
	#dashing logic
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			stop_dash()
	
	player_animations()
	flip_player()
	
# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func move_state():
	#print("State: Move") #debug
	# Gravity
	
	if !is_on_floor():
		velocity.y += gravity
		
	# Move Player
	var inputAxis = Input.get_axis("Left", "Right")
	velocity = Vector2(inputAxis * move_speed, velocity.y)
	move_and_slide()
	
	# --- CUSTOM INPUT ----
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			jump()
			
	if Input.is_action_just_pressed("Attack"):
		state = player_states.ATTACK
		
	if Input.is_action_just_pressed("Dash"):
		if is_on_floor() and velocity.x != 0:
			state = player_states.DASH
		else:
			print("cant dash while jumping or standing still")
	
	
func attack_state():
	#print("State: Attack") #debug
	attacking = true

func dash_state():
	print("Dashing")
	is_dashing = true
	dash_timer = dash_duration
	
	dash_direction = Vector2.ZERO
	var dash_axis = Input.get_axis("Left", "Right")
	velocity = Vector2(dash_axis * dash_speed, velocity.y) 
	move_and_slide()


func stop_dash():
	print("Stop dashing")
	is_dashing = false
	dash_timer = dash_cooldown
	velocity = Vector2.ZERO

# Player jump
func jump():
	velocity.y = -jump_force

# Handle Player Animations
func player_animations():
	particle_trails.emitting = false
	match state:
		player_states.MOVE:
			if is_on_floor() and abs(velocity.x) > 0:
				anim_player.play("Move")
			else:
				anim_player.play("Idle")
				
				#if velocity.y < 0 and !is_on_floor():
		player_states.ATTACK:
			if is_on_floor():
				anim_player.play("Attack")
			else:
				pass
		player_states.DASH:
			if is_on_floor():
				anim_player.play("Dash")
			else:
				pass
			

# Flip player sprite based on X velocity
func flip_player():
	if velocity.x < 0: 
		player_sprite.flip_h = true #player sprite
		sword_collision.position = Vector2(-42, 15) #collision sword
	elif velocity.x > 0:
		player_sprite.flip_h = false
		sword_collision.position = Vector2(42, 15)

# Tween Animations
func respawn():
	global_position = spawn_point.global_position

# --------- SIGNALS ---------- #
# Reset the player's position to the current level spawn point if collided with any trap
func _on_collision_body_entered(_body):
	if _body.is_in_group("Traps"):
		death_particles.emitting = true
		await GameManager.frame_freeze(0.05, 0.85)
		respawn()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack" or "Dash":
		state = player_states.MOVE
		attacking = false
