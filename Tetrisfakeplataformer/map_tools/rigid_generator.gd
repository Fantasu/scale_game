extends Node2D


@export var square: PackedScene
@export var camera: Camera2D
var direction: int = 1
# Called when the node enters the scene tree for the first time.


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print((get_viewport().size.x) / 2)
	global_position.x += 100 * delta * direction
	if (global_position.x > (get_viewport().size.x) / 2) or (global_position.x < 0):
		direction *= -1
		
	if Input.is_action_just_pressed("create"):
		var square_instance = square.instantiate()
		square_instance.global_position = global_position
		get_tree().current_scene.add_child(square_instance)


