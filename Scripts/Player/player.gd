class_name Player extends CharacterBody2D

var input_buffer : Timer # Reference to the input queue timer
var coyote_timer : Timer # Reference to the coyote timer
var coyote_jump_available := true
var is_grounded := false
var attacking := false

@export_category("Object References")
@onready var spawn_point = %SpawnPoint
@onready var player_sprite := $Sprite
@onready var sword_collision := $Sword/CollisionShape2D
@onready var anim_player := $AnimationPlayer
@onready var player_stats := $Componenets/Stats
@onready var player_health := $Componenets/Health

@export var direction := Vector2.ZERO

# ---- PLAYER STATES ----
enum {MOVE, JUMP, ATTACK}
var state = MOVE

# --------- BUILT-IN FUNCTIONS ---------- #
func _ready() -> void:
	sword_collision.disabled = true
	# Set up input buffer timer
	input_buffer = Timer.new()
	input_buffer.wait_time = player_stats.INPUT_BUFFER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)

	# Set up coyote timer
	coyote_timer = Timer.new()
	coyote_timer.wait_time = player_stats.COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)

func _physics_process(_delta):
	match state:
		MOVE:
			move_state(_delta)
		ATTACK:
			attack_state()
	
	player_animations()
	flip_player()
	
# --------- CUSTOM FUNCTIONS ---------- #

func get_input():
	direction.x = Input.get_axis("Left", "Right")
	# Shorten jump if jump key is released
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = player_stats.JUMP_VELOCITY / 3
		
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("Dash"):
		var dash_tween = create_tween()
		dash_tween.tween_property(self, "velocity:x", velocity.x + direction.x * player_stats.DASH_MULTIPLIER, 0.2)
		dash_tween.connect("finished", on_dash_finish)
		
	
# <-- Player Movement Code -->
func move_state(_delta):
	# Get inputs
	get_input()
	var jump_attempted := Input.is_action_just_pressed("Jump")
	
	# Add the gravity and handle jumping
	if jump_attempted or input_buffer.time_left > 0:
		if coyote_jump_available: # If jumping on the ground
			velocity.y = player_stats.JUMP_VELOCITY
			coyote_jump_available = false
		elif is_on_wall() and direction.x != 0: # If jumping off a wall
			wall_jump_state()
		elif jump_attempted: # Queue input buffer if jump was attempted
			input_buffer.start()

	# Apply gravity and reset coyote jump
	if is_on_floor():
		coyote_jump_available = true
		coyote_timer.stop()
	else:
		if coyote_jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start()
		velocity.y += get_custom_gravity(direction.y) * _delta

	# Handle horizontal motion and friction
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * player_stats.SPEED, player_stats.ACCELERATION * _delta)
	else:
		velocity.x = move_toward(velocity.x, 0, player_stats.FRICTION * _delta)# * floor_damping
	
	# Apply velocity
	move_and_slide()

func wall_jump_state():
	velocity.y = player_stats.WALL_JUMP_VELOCITY
	velocity.x = player_stats.WALL_JUMP_PUSHBACK * -sign(direction.x)
	velocity.normalized()

func attack_state():
	#print("State: Attack") #debug
	attacking = true

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
			if velocity.x != 0:
				anim_player.play("Move")
			else:
				anim_player.play("Idle")
		ATTACK:
			if not is_on_floor():
				anim_player.play("AirAttack")
			else:
				anim_player.play("Attack")

func respawn():
	print("Respawn")
	await GameManager.frame_freeze(0.08, 0.3)
	GameManager.reset_player(self, spawn_point)
	
## Returns the gravity based on the state of the player
func get_custom_gravity(input_dir : float = 0) -> float:
	if Input.is_action_pressed("Fast_Fall"):
		return player_stats.FAST_FALL_GRAVITY
	if is_on_wall_only() and velocity.y > 0 and input_dir != 0:
		return player_stats.WALL_GRAVITY
	return player_stats.GRAVITY if velocity.y < 0 else player_stats.FALL_GRAVITY

# --------- SIGNALS ---------- #
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "Move":
		state = MOVE
		attacking = false

func coyote_timeout() -> void:
	coyote_jump_available = false

func on_dash_finish():
	velocity.x = move_toward(velocity.x, 0, 800)
	
