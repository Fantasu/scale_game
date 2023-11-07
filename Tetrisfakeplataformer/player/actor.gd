extends CharacterBody2D

class_name Actor


enum {STATE_MOVE, STATE_STAND, STATE_AIR, STATE_CLIMBING, STATE_STUNED}


const TILE_SIZE = 16

@export var ground_maxvelocity: float = 7.0 * TILE_SIZE
@export var ground_turn_time: float = 0.15
@export var ground_accel_time: float = 0.2
@export var ground_fric_time: float = 0.15

@export var air_maxvelocity: float = 7.5 * TILE_SIZE
@export var air_turn_time: float = 0.25
@export var air_accel_time: float = 0.55
@export var air_fric_time: float = 0.75


@export var climb_speed: float = 100
@export var jump_size: float = 2.2 * TILE_SIZE
@export var min_jump_size: float = 1.1 * TILE_SIZE
@export var fall_time: float = 0.65
@onready var gravity = 2 * jump_size / (pow(fall_time, 2)/2) 
@onready var jump_force = sqrt(2 * gravity * jump_size)

@export var buffering_time: float = 0.20
@export var coyote_time: float = 0.20
var flip_time: float = 0.1
@export var stuned_time: float = 3.0
var default_stuned: float = stuned_time

#var active = false setget setting_active_property

@onready var _default_gravity = 2 * jump_size / (pow(fall_time, 2)/2) 
@onready var _gravity_multiplier = jump_size/min_jump_size
@onready var _ground_fric = ground_maxvelocity / (ground_fric_time * 60) #fps
@onready var _ground_accel = ground_maxvelocity / (ground_accel_time * 60) #fps
@onready var _ground_turn_accel = ground_maxvelocity / (ground_turn_time * 60) #fps
@onready var _air_fric = air_maxvelocity / (air_fric_time * 60) #fps
@onready var _air_accel = air_maxvelocity / (air_accel_time * 60) #fps
@onready var _air_turn_accel = air_maxvelocity / (air_turn_time * 60) #fps

@onready var _default_buffering_time = buffering_time
@onready var _default_coyote_time = coyote_time
var snap = Vector2.ZERO
var _inside_wind := false
var _initial_fall_pos := 2.0
var _fall_distance := 0.0
var _g_multiplier := 1.0
var _direction := 0.0
var _actual_state = STATE_STAND
#var velocity := Vector2.ZERO
var _first_fall: bool = false
var _jump_pressed: bool = false
var _was_jumped: bool = false
#var _engine_fps = Engine.iterations_per_second

var _inside_ladder = false
var _ladder


func _physics_process(delta):
	_direction = _get_direction()
	manage_animations()
	print(_actual_state)
	match _actual_state:
		STATE_STAND:
			stand_state(delta)
		
			
		STATE_MOVE:
			move_state(delta)
		
		
		STATE_AIR:
			air_state(delta)
		
		
		STATE_CLIMBING:
			climbing_state(delta)

		
		STATE_STUNED:
			stuned_state(delta)
	
	
	snap = Vector2.ZERO if _was_jumped or not is_on_floor() or _actual_state == STATE_CLIMBING or gravity == 0 else Vector2.DOWN * 8
	
	velocity.y += gravity * delta * _g_multiplier
	
	move_and_slide()
#	velocity = move_and_slide_with_snap(velocity, snap,Vector2.UP, true, 4 , deg_to_rad(45))


func stand_state(delta):
	flip_nodes()
	
	if not _inside_wind:
		velocity.x = max(abs(velocity.x) - _ground_fric, 0.0) * sign(velocity.x)
	
	velocity.x = clamp(velocity.x, -ground_maxvelocity, ground_maxvelocity)
	
	if _direction != 0:
		_actual_state = STATE_MOVE
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
	if not is_on_floor():
		_actual_state = STATE_AIR


func move_state(delta):
	flip_nodes()
	movement(_ground_accel, _ground_turn_accel, ground_maxvelocity)
		
	if _direction == 0.0:
		flip_time -= delta
		if flip_time < 0:
			_actual_state = STATE_STAND
	
	else:
		flip_time = 0.1
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
	if not is_on_floor():
		_actual_state = STATE_AIR


func air_state(delta):
	flip_nodes()
	movement(_air_accel, _air_turn_accel, air_maxvelocity)
	calculate_fall_distance()
	
	if _direction == 0.0:
		velocity.x = max(abs(velocity.x) - _air_fric, 0.0) * sign(velocity.x)
	
	if Input.is_action_just_pressed("jump"):
		_jump_pressed = true
	
	if Input.is_action_just_pressed("jump") and coyote_time > 0 and not _was_jumped:
		_g_multiplier = 1
		buffering_time = _default_buffering_time
		_jump_pressed = false
		jump()
		
	if (not Input.is_action_pressed("jump") and _was_jumped) or velocity.y > 0:
		_g_multiplier = _gravity_multiplier
	
	coyote_time -= delta
	
	if _jump_pressed:
		buffering_time -= delta
	
	
	if is_on_floor():
		_was_jumped = false
		if _jump_pressed and buffering_time > 0:
			jump()
		_jump_pressed = false
		buffering_time = _default_buffering_time
		coyote_time = _default_coyote_time
		_g_multiplier = 1
		_fall_distance = 0.0
		_actual_state = STATE_MOVE

func stuned_state(delta):
	pause_animation()
#	self.modulate = Color.rebeccapurple
	if not _inside_wind:
		velocity.x = max(abs(velocity.x) - _ground_fric, 0.0) * sign(velocity.x)
	
	velocity.x = clamp(velocity.x, -ground_maxvelocity, ground_maxvelocity)
	stuned_time -= delta
	if stuned_time < 0:
		stuned_time = default_stuned
#		self.modulate = Color.white
		start_animation()
		_actual_state = STATE_MOVE


func pause_animation():
	pass


func start_animation():
	pass


func setting_active_property(new_value):
#	active = new_value
	return


func calculate_fall_distance() -> void:
	if velocity.y > 0 and not _first_fall:
		_initial_fall_pos = self.global_position.y
		_first_fall = true
	
	elif velocity.y > 0 and _first_fall:
		_fall_distance = (self.global_position.y - _initial_fall_pos)
	
	else:
		_first_fall = false
		_fall_distance = 0.0


func climbing_state(_delta):
	pass


func _get_direction() -> float:
#	if active:
	return sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
#	return 0.0


func jump():
#	inside if active
	velocity.y = -jump_force
	_was_jumped = true


func movement(accel:float, turn_accel:float, maxvelocity:float) -> void:
	if _direction != 0.0:
		if _direction == sign(velocity.x) or is_equal_approx(velocity.x, 0):
			velocity.x += accel * _direction
		
		else:
			velocity.x += turn_accel * _direction
		
		velocity.x = clamp(velocity.x, -maxvelocity, maxvelocity)


func manage_animations():
	pass


func flip_nodes():
	return
#	if _direction:
#		$Flip.scale.x = _direction



