class_name Player extends CharacterBody2D

# --------- PLAYER VARIABLES ---------- #
const SPEED = 350.0 # Base horizontal movement speed
const ACCELERATION = 1200.0 # Base acceleration
const FRICTION = 1400.0 # Base friction
const GRAVITY = 2000.0 # Gravity when moving upwards
const FALL_GRAVITY = 3000.0 # Gravity when falling downwards
const FAST_FALL_GRAVITY = 5000.0 # Gravity while holding "fast_fall"
const WALL_GRAVITY = 25.0 # Gravity while sliding on a wall
const JUMP_VELOCITY = -700.0 # Maximum jump strength
const WALL_JUMP_VELOCITY = -700.0 # Maximum wall jump strength
const WALL_JUMP_PUSHBACK = 300.0 # Horizontal push strength off walls
const INPUT_BUFFER_PATIENCE = 0.1 # Input queue patience time
const COYOTE_TIME = 0.08 # Coyote patience time

var input_buffer : Timer # Reference to the input queue timer
var coyote_timer : Timer # Reference to the coyote timer
var coyote_jump_available := true

var is_grounded : bool = false
var attacking : bool = false

@export_category("Object References")
@onready var player_sprite = $Sprite
@onready var spawn_point = %SpawnPoint
@onready var particle_trails = $"Particle Effects/ParticleTrails"
@onready var death_particles = $"Particle Effects/DeathParticles"
@onready var sword_collision = $Sword/CollisionShape2D
@onready var anim_player = $AnimationPlayer

# ---- PLAYER STATES ----
enum {MOVE, ATTACK}
var state = MOVE

# --------- BUILT-IN FUNCTIONS ---------- #
func _ready() -> void:
	sword_collision.disabled = true
	# Set up input buffer timer
	input_buffer = Timer.new()
	input_buffer.wait_time = INPUT_BUFFER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)

	# Set up coyote timer
	coyote_timer = Timer.new()
	coyote_timer.wait_time = COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
	
	player_animations()
	flip_player()
	
# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func move_state(_delta):
	# Get inputs
	var horizontal_input := Input.get_axis("Left", "Right")
	var jump_attempted := Input.is_action_just_pressed("Jump")

	# Add the gravity and handle jumping
	if jump_attempted or input_buffer.time_left > 0:
		if coyote_jump_available: # If jumping on the ground
			velocity.y = JUMP_VELOCITY
			coyote_jump_available = false
		elif is_on_wall() and horizontal_input != 0: # If jumping off a wall
			velocity.y = WALL_JUMP_VELOCITY
			velocity.x = WALL_JUMP_PUSHBACK * -sign(horizontal_input)
		elif jump_attempted: # Queue input buffer if jump was attempted
			input_buffer.start()

	# Shorten jump if jump key is released
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4

	# Apply gravity and reset coyote jump
	if is_on_floor():
		coyote_jump_available = true
		coyote_timer.stop()
	else:
		if coyote_jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start()
		velocity.y += get_custom_gravity(horizontal_input) * _delta

	# HYandle horizontal motion and friction
	var floor_damping := 1.0 if is_on_floor() else 0.2 # Set floor damping, friction is less when in air
	var dash_multiplier := 2 if Input.is_action_pressed("Dash") else 1
	if horizontal_input:
		velocity.x = move_toward(velocity.x, horizontal_input * SPEED * dash_multiplier, ACCELERATION * _delta)
	else:
		velocity.x = move_toward(velocity.x, 0, (FRICTION * _delta) * floor_damping)
	
	if Input.is_action_pressed("Attack"):
		state = ATTACK
	
	# Apply velocity
	move_and_slide()

func attack_state():
	#print("State: Attack") #debug
	attacking = true

# Flip player sprite based on X velocity
func flip_player():
	if velocity.x < 0: 
		player_sprite.flip_h = true #player sprite
		sword_collision.position = Vector2(-42, 15) #collision sword
	elif velocity.x > 0:
		player_sprite.flip_h = false
		sword_collision.position = Vector2(42, 15)

func player_animations():
	match state:
		MOVE:
			if velocity.x > 0 or velocity.x < 0:
				anim_player.play("BaseAnimations/Move")
			else:
				anim_player.play("BaseAnimations/Idle")
		ATTACK:
			if is_on_floor():
				anim_player.play("BaseAnimations/Attack")
			else:
				anim_player.play("BaseAnimations/Air_Attack")

# Tween Animations
func respawn():
	global_position = spawn_point.global_position
	
## Returns the gravity based on the state of the player
func get_custom_gravity(input_dir : float = 0) -> float:
	if Input.is_action_pressed("Fast_Fall"):
		return FAST_FALL_GRAVITY
	if is_on_wall_only() and velocity.y > 0 and input_dir != 0:
		return WALL_GRAVITY
	return GRAVITY if velocity.y < 0 else FALL_GRAVITY

# --------- SIGNALS ---------- #
# Reset the player's position to the current level spawn point if collided with any trap
func _on_collision_body_entered(_body):
	if _body.is_in_group("Traps"):
		death_particles.emitting = true
		velocity = Vector2.ZERO
		await GameManager.frame_freeze(0.05, 0.85)
		respawn()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack" or "Dash":
		state = MOVE
		attacking = false

## Reset coyote jump
func coyote_timeout() -> void:
	coyote_jump_available = false
