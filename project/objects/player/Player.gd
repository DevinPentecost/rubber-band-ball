extends KinematicBody2D

export(float) var moveSpeed = 1
export(bool) var isMouseAndKeyboard = false
export(float) var speed = 10
 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	pass
func _perform_dash():
	pass

func _process(delta):
	var inputvectors = _interpret_movement_input()
	
	#print(inputvectors)
	$MoveTarget.position = inputvectors[0] * 10
	$LookTarget.position = inputvectors[1] * 10

	move_and_slide($MoveTarget.position * speed)
	$Bat.look_at($LookTarget.global_position)
	
	if Input.is_action_just_pressed("swing"):
		_perform_swing()
		$Bat/CollisionShape2D.disabled = !$Bat/CollisionShape2D.disabled
		if $Bat/CollisionShape2D.disabled:
			$Bat/CollisionShape2D/Sprite.modulate = Color.black
		else:
			$Bat/CollisionShape2D/Sprite.modulate = Color.white
	if Input.is_action_just_pressed("dash"):
		_perform_dash()


func _on_Bat_body_entered(body):
	if body.is_in_group("ball"):
		# We hit the ball, stop collision
		$Bat/CollisionShape2D.disabled = true
