extends RigidBody2D

enum  {STATE_GETTING, STATE_MOVING};

var actual_state: int = STATE_GETTING;
@export var min_length: float = 50.0;
@export var directions_count: int = 5;
var actual_dir: int = 0;
var directions: Array[Vector2] = [];
var positions: Array[Vector2] = [];


func get_mouse_dir() -> Vector2:
	if directions.size():
		printt(get_global_mouse_position(), directions[-1])
		return get_global_mouse_position() - directions[-1]
	
	printt(get_global_mouse_position(), global_position)
	
	return get_global_mouse_position() - global_position


func add_direction(_dir: Vector2) -> void:
	if directions_count > 0:
		directions.append(_dir)
		directions_count -= 1
		if directions_count <= 0:
			apply_direction_impulse()
			actual_state = STATE_MOVING
	


func apply_direction_impulse() -> void:
	if !directions.size():
		return
	self.apply_central_impulse(directions[actual_dir])
	actual_dir += 1


func _physics_process(delta):
	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()
	
	match actual_state:
		STATE_GETTING:
			pass
		
		STATE_MOVING:
			if (linear_velocity.length() < min_length) \
			and (actual_dir < directions.size()):
				apply_direction_impulse()
	
#			printt(self.linear_velocity.length(), actual_dir, min_length)
	apply_central_force(-linear_velocity * 0.5)
	

