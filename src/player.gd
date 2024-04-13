class_name Player
extends CharacterBody2D


const MAX_SPEED = 170.0
const ACCELERATION = 2000
const FRICTION = 3000

@export var attacking = false
var flipped = false
@onready var animation_tree = $AnimationTree
func get_direction():
	var direction_x = Input.get_axis("move-left", "move-right")
	var direction_y = Input.get_axis("move-up", "move-down")
	return Vector2(direction_x, direction_y)

func move_player(delta):
	var direction = get_direction()
	
	if direction == Vector2.ZERO:
		var amount = velocity.normalized() *  FRICTION * delta
		
		if velocity.length() - amount.length() > 0:
			velocity -= amount
		else:
			velocity = Vector2.ZERO

	else:
		velocity += direction.normalized() * ACCELERATION * delta
		velocity = velocity.limit_length(MAX_SPEED)
		
	if velocity.is_zero_approx():
		velocity = Vector2.ZERO

func handle_inputs(delta):
	move_player(delta)
	
	if Input.is_action_pressed("attack") and !attacking:
		animation_tree["parameters/conditions/attacking"] = true
	else:
		animation_tree["parameters/conditions/attacking"] = false

func _physics_process(delta):
	handle_inputs(delta)

	_set_blend_position(velocity.x)

	move_and_slide()
	#GameManager.player_position = global_position


func _set_animation_state_walking(walking):
	animation_tree["parameters/conditions/idle"] = !walking
	animation_tree["parameters/conditions/walking"] = walking

func _set_blend_position(x):
	if x != 0:
		flipped = x < 0
		animation_tree["parameters/idle/blend_position"] = x
		animation_tree["parameters/walking/blend_position"] = x
		if !attacking:
			animation_tree["parameters/attacking/blend_position"] = x
