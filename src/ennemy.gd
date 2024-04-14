extends CharacterBody2D


const MAX_SPEED = 45.0
const ACCELERATION = 700
const FRICTION = 3000
const FULL_HEALTH = 3

var knockback_vect = Vector2.ZERO

var health = FULL_HEALTH

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _physics_process(delta):
	navigate(delta)
	var friction_amount = velocity.normalized() * 230 * delta
	if friction_amount.length() <= velocity.length():
		velocity -= friction_amount
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
func _process(delta):
	navigation_agent.target_position = GameManager.player_position
	if health <= 0:
		queue_free()


func navigate(delta):
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = velocity.move_toward(MAX_SPEED * direction, delta * ACCELERATION)
	
func _on_hurt_box_area_entered(area):
	area = area as HitBox
	velocity += area.hit_direction * 350
	health -= 1
