extends RigidBody2D

@export var accel: float = 30.0
@export var turn_accel: float = 60.0
@export var max_velocity: float = 200.0
@export var jump_velocity: float = 300.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	
	if (sign(linear_velocity.x) == sign(get_direction().x)):
		linear_velocity.x += get_direction().x * accel
	elif not(sign(linear_velocity.x) == sign(get_direction().x)):
		linear_velocity.x += get_direction().x * turn_accel
	
	if sign(get_direction().x) == 0:
		linear_velocity.x = max(abs(linear_velocity.x) - 60, 0) * sign(linear_velocity.x)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		linear_velocity.y = -jump_velocity
	
	linear_velocity.x = clamp(linear_velocity.x, -max_velocity, max_velocity)
	
	print(linear_velocity.x)


func get_direction():
	return Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	
func is_on_floor():
	return $RayCast2D.is_colliding() or $RayCast2D2.is_colliding()
