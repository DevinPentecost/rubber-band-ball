extends KinematicBody2D

export(bool) var isMouseAndKeyboard = false
export(float) var speed = 10
export(float) var swingSpeedRad = 30
 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _interpret_movement_input():
	if isMouseAndKeyboard:
		raise()
	else:
		var move_north = 0
		if Input.is_action_pressed("move_north"):
			move_north = Input.get_action_strength("move_north")
			
		var move_east = 0
		if Input.is_action_pressed("move_east"):
			move_east = Input.get_action_strength("move_east")
		
		var move_south = 0
		if Input.is_action_pressed("move_south"):
			move_south = Input.get_action_strength("move_south")
		
		var move_west = 0
		if Input.is_action_pressed("move_west"):
			move_west = Input.get_action_strength("move_west")
			
		var look_north = 0
		if Input.is_action_pressed("look_north"):
			look_north = Input.get_action_strength("look_north")
		
		var look_east = 0
		if Input.is_action_pressed("look_east"):
			look_east = Input.get_action_strength("look_east")
		
		var look_south = 0
		if Input.is_action_pressed("look_south"):
			look_south = Input.get_action_strength("look_south")
		
		var look_west = 0
		if Input.is_action_pressed("look_west"):
			look_west = Input.get_action_strength("look_west")
		
		var move_updown = move_north * -1
		if move_south > move_north:
			move_updown = move_south
		var move_leftright = move_east
		if move_west > move_east:
			move_leftright = move_west * -1
		var look_updown = look_north * -1
		if look_south > look_north:
			look_updown = look_south
		var look_leftright = look_east
		if look_west > look_east:
			look_leftright = look_west * -1
	
		return [Vector2(move_leftright, move_updown).normalized(), Vector2(look_leftright, look_updown).normalized()]

var _canSwing = true
var _canDash = true

func _perform_swing():
	if _canSwing == false:
		return
	_canSwing = false
	_canDash = false
	
	# Add the bat to 9
	$Bat.collision_layer = $Bat.collision_layer | 0b000100000000
	var duration = 0.15
	$SwingCooldown.start(duration)
	$SwingTween.interpolate_property($Bat, "rotation_degrees", $Bat.rotation_degrees, $Bat.rotation_degrees-180, duration, Tween.TRANS_LINEAR)
	$SwingTween.start()
	
	
func _perform_dash():
	if _canDash == false:
		return
	_canSwing = false
	_canDash = false

func _process(delta):
	var inputvectors = _interpret_movement_input()
	
	$MoveTarget.position = inputvectors[0] * 10
	
	if inputvectors[1] != Vector2(0,0):
		$LookTarget.position = inputvectors[1] * 10

	move_and_slide($MoveTarget.position * speed)
	
	if _canSwing == true:
		$Bat.look_at($LookTarget.global_position)
		$CharacterSprite.look_at($LookTarget.global_position)
	
	if Input.is_action_just_pressed("swing"):
		_perform_swing()
			
	if Input.is_action_just_pressed("dash"):
		_perform_dash()


func _on_Bat_body_entered(body):
	if body.is_in_group("ball"):
		# We hit the ball, stop collision
		# Remove the bat from 9
		$Bat.collision_layer = $Bat.collision_layer & 0b111011111111
		pass


func _on_DashCooldown_timeout():
	_canSwing = true
	_canDash = true


func _on_SwingCooldown_timeout():
	_canSwing = true
	_canDash = true
	# Remove the bat from 9
	$Bat.collision_layer = $Bat.collision_layer & 0b111011111111
	#$BatPivot/Bat.layers = $Bat.layers & 0xEF
	#$BatPivot/Bat/Sprite.modulate = Color.black
	#$BatPivot.rotation = 0
	pass
