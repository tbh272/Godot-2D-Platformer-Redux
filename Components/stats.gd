extends Node

@export_category("Weapon")
@export var weapon_damage = 25
var base_damage : float
var attack : float
@export var defense : float = 10

@export_category("Player Movement")
@export var SPEED = 400.0 # Base horizontal movement speed
@export var ACCELERATION = 1800.0 # Base acceleration
@export var FRICTION = 2500.0 # Base friction
@export var GRAVITY = 2000.0 # Gravity when moving upwards
@export var FALL_GRAVITY = 3000.0 # Gravity when falling downwards
@export var FAST_FALL_GRAVITY = 5000.0 # Gravity while holding "fast_fall"
@export var WALL_GRAVITY = 25.0 # Gravity while sliding on a wall
@export var JUMP_VELOCITY = -700.0 # Maximum jump strength
@export var INPUT_BUFFER_PATIENCE = 0.1 # Input queue patience time
@export var COYOTE_TIME = 0.06 # Coyote patience time
@export var DASH_MULTIPLIER = 650.0

#not used will implement later
const WALL_JUMP_VELOCITY = -800.0 # Maximum wall jump strength
const WALL_JUMP_PUSHBACK = 400.0 # Horizontal push strength off walls
