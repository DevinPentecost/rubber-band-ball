extends RigidBody2D
class_name Ball

var hits = 0
var velocity_per_hit = 75
export(float) var min_speed = 300
var stop = false

export(float) var slowmo_time_scale = 0.2
export(float) var slowmo_duration = 3.0

func start_slowmo():
	
	# Stop current tweens
	$SlowMoTween.stop_all()
	
	# Run a tween for the slowdown
	$SlowMoTween.interpolate_property(Engine, "time_scale", slowmo_time_scale, 1.0, slowmo_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$SlowMoTween.start()

func _physics_process(delta):
	
	# Make sure the speed of the ball is maintained
	if hits == 0 or stop:
		linear_velocity = Vector2.ZERO
	else:
		linear_velocity = linear_velocity.normalized() * ((hits * velocity_per_hit) + min_speed)
	
func _on_Ball_body_entered(body:Node2D):
	
	if body.is_in_group("slowmo"):
		start_slowmo()
		$BounceSFX.play()
	
	if body.is_in_group("bat"):
		_handle_Bat_collision(body)
		
	if body.is_in_group("player") and hits > 0:
		#Player takes damage
		body.take_damage()
		$PlayerSFX.play()
		
		if body.lives == 0:
			stop = true

func _handle_Bat_collision(bat):
	hits += 1
	print("You hit the ball " + str(hits) + " times!")
	var position_difference = global_position - bat.global_position
	linear_velocity = position_difference.normalized()
	$BatSFX.play()
