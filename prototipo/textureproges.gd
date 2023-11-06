extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	self.step = 10 * get_process_delta_time()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if value < 10:
		self.value += 10 * delta
	else:
		self.value = 0
	
