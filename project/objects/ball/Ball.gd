extends RigidBody2D
class_name Ball

var hits = 0
var velocity_per_hit = 75
export(float) var min_speed = 300

var nearby_bodies: Array = []
export(float, 0.5) var slowdown_time_scale_min = 0.5
export(float, 0.5) var slowdown_time_scale_max = 0.05
export(int) var slowdown_time_scale_max_hits = 25

func adjust_timescale(delta):
	
	# Should we slow down?
	var should_slow_down = false
	if $SlowdownTimer.time_left > 0:
		if nearby_bodies.size() > 0:
			# We should be slowing down
			should_slow_down = true
	
	# What should our target be
	var target_timescale = 1
	if should_slow_down:
		target_timescale = lerp(slowdown_time_scale_min, slowdown_time_scale_max, hits / slowdown_time_scale_max_hits)
	
	# Adjust timescale
	Engine.time_scale = lerp(Engine.time_scale, target_timescale, 15.0 * delta)

func _physics_process(delta):
	
	# Make sure the speed of the ball is maintained
	if hits == 0:
		linear_velocity = Vector2.ZERO
	else:
		linear_velocity = linear_velocity.normalized() * ((hits * velocity_per_hit) + min_speed)
	
	# If there are nearby bodies, we want to slow down
	adjust_timescale(delta)

func _on_Ball_body_entered(body:Node2D):
	
	if body.is_in_group("bat"):
		_handle_Bat_collision(body)

func _handle_Bat_collision(bat):
	hits += 1
	print("You hit the ball " + str(hits) + " times!")
	var position_difference = global_position - bat.global_position
	linear_velocity = position_difference.normalized()


func _on_Nearby_body_entered(body):
	
	# If something is nearby we slow down
	if !body.is_in_group("ball"):
		nearby_bodies.append(body)
		
		# New body has entered, restart the timer
		$SlowdownTimer.start()


func _on_Nearby_body_exited(body):
	
	# Return to full speed if there is nothing nearby
	if nearby_bodies.has(body):
		nearby_bodies.erase(body)
