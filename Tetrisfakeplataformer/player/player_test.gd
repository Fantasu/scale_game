extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	
	if sign(linear_velocity.x) == sign(get_direction().x):
		self.apply_central_impulse(Vector2(get_direction().x * 10, 0))
	elif not(sign(linear_velocity.x) == sign(get_direction().x)):
		self.apply_central_impulse(Vector2(get_direction().x * 30, 0))
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		self.apply_central_impulse(Vector2(0, -300))
		
	


func get_direction():
	return Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	
func is_on_floor():
	return $RayCast2D.is_colliding() or $RayCast2D2.is_colliding()
