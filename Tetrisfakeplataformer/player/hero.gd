extends Actor
class_name Hero

#onready var animation_playback = $AnimationTree.get("parameters/playback")
#onready var jump_sfx = $JumpSound

var forbidden_animations = ["attack"]


func _ready():
#	$Flip/TorchHitBox.connect("body_entered", self, "torch_action")
#	$ShakeCamera.current = active
	pass


#func manage_animations() -> void:
#	return;
#	if _actual_state == STATE_STAND:
##		animation_playback.travel("stand")
#		$Flip/WalkParticle.emitting = false
#
#	elif _actual_state == STATE_MOVE:
#		animation_playback.travel("walk")
#		$Flip/WalkParticle.emitting = true
#
#	elif _actual_state == STATE_AIR:
#		if (_velocity.y > 0 and _was_jumped) or (_fall_distance > min_jump_size):
#			animation_playback.travel('fall')
#			damage_colliding()
#		elif _velocity.y < 0 :
#			animation_playback.travel('jump')
#
#
#		$Flip/WalkParticle.emitting = false
#
#	elif _actual_state == STATE_CLIMBING:
#		animation_playback.travel('climbing')
#		$Flip/WalkParticle.emitting = false
#

#func pause_animation():
#	$AnimationTree.active = false


#func start_animation():
#	$AnimationTree.active = true


#func damage_colliding() -> void:
#	for child in $DamageRays.get_children():
#		if child.is_colliding():
#			var hand = child.get_collider().owner
#			if hand.has_method("on_damage_taken"):
#				hand.on_damage_taken(self)


func jump() -> void:
#	if (not animation_playback.get_current_node() in forbidden_animations) and active:
#		jump_sfx.play()
		velocity.y = -jump_force
		_was_jumped = true


func torch_action(body) -> void:
	if body.is_in_group("spiderweb"):
		#body.playanimation.....
		body.queue_free()
#		GameEvents.emit_signal("call_shake", 0.25)


func _get_direction() -> float:
#	if (not animation_playback.get_current_node() in forbidden_animations) and active:
	return sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
#	return 0.0


#func _input(event):
#	if event.is_action_pressed("ui_up") and _inside_ladder and is_instance_valid(_ladder) and _actual_state != STATE_CLIMBING and active:
#		enter_in_ladder()
	
#	if event.is_action_pressed("ui_down") and one_way_colliding():
#		self.global_position.y += 1

#		if one_way_colliding() is Ladder:
#			_ladder = one_way_colliding()
#			_inside_ladder = true
#			enter_in_ladder()


func setting_active_property(new_value) -> void:
#	active = new_value
#	$ShakeCamera.current = active
	return
	

func one_way_colliding():
#	for child in $OneWayRays.get_children():
#		if child.is_colliding():
#			return child.get_collider().owner
	pass


func enter_in_ladder() -> void:
	velocity.x = 0
	global_position.x = _ladder.global_position.x
	gravity = 0
	_actual_state = STATE_CLIMBING


#func climbing_state(_delta) -> void:
##	var _climb_direc = up_down()
#	self._velocity.y = _climb_direc * climb_speed
#
#	if (_direction and not _climb_direc) or not _inside_ladder:
#		_velocity.y = 0
#		gravity = _default_gravity
##		if not _inside_ladder:
##			jump()
#		_actual_state = STATE_MOVE


#func up_down() -> float:
#	if active:
#		return sign(Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
#	return 0.0

