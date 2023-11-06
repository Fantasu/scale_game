extends Marker2D

@export var arrow: PackedScene

var initial_position: Vector2 = Vector2(50, 70)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(self.global_position.direction_to(get_global_mouse_position()))
	
	if Input.is_action_just_pressed("left_click") and ($"../RigidBody2D".actual_state != 1):
		var direction: Vector2 = global_position.direction_to(get_global_mouse_position()) * $"../TextureProgressBar".value * 100
		$"../RigidBody2D".add_direction(direction)
		var new_arrow = arrow.instantiate()
		new_arrow.global_position = initial_position
		initial_position.x += 50
		new_arrow.rotation = atan2(direction.normalized().y, direction.normalized().x)
		
		get_tree().current_scene.add_child(new_arrow)
		
	
	
	$Sprite2D2.look_at(get_global_mouse_position())
	
