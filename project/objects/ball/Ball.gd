extends RigidBody2D
class_name Ball

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity_score: int setget , _get_velocity_score
var _velocity_score: int

var hits = 0
var velocity_per_hit = 75

func _get_velocity_score():
	return _velocity_score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	_velocity_score = int(linear_velocity.length())

func _on_Ball_body_entered(body:Node2D):
	
	if body.is_in_group("bat"):
		_handle_Bat_collision(body)

func _handle_Bat_collision(bat):
	hits += 1
	var direction = linear_velocity.angle()
	var speed = Vector2.UP * (hits * velocity_per_hit)
	linear_velocity = speed.rotated(direction)
