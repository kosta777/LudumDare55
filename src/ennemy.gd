extends CharacterBody2D


const MAX_SPEED = 45.0
const ACCELERATION = 700
const FRICTION = 1000
const FULL_HEALTH = 3

var knockback_vect = Vector2.ZERO

var health = FULL_HEALTH
var dying = false

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation = $AnimatedSprite2D
@onready var hitbox = $HitBox

var nav_velocity = Vector2.ZERO
var push_velocity = Vector2.ZERO
var friction_velocity = Vector2.ZERO
var want_to_move_direction  = Vector2.LEFT

func _ready():
	navigation_agent.velocity_computed.connect(func(v): nav_velocity= v)

func _physics_process(delta):

	if !dying:
		want_to_move_direction = navigate(delta)
	
	

	#if friction_amount.length() <= push_velocity.length():
		#push_velocity -= friction_amount
	#else:
		#push_velocity = Vector2.ZERO
	var friction =  push_velocity.normalized() * FRICTION * delta
	push_velocity = push_velocity 
	if friction.length() <= push_velocity.length():
		push_velocity -= friction
	else:
		push_velocity = Vector2.ZERO
	
	velocity = (nav_velocity if !dying else Vector2.ZERO) + push_velocity
	
	
	
	animation.flip_h = want_to_move_direction.x < 0
	hitbox.hit_direction = velocity.normalized()


	move_and_slide()
	
func _process(delta):
	navigation_agent.target_position = GameManager.player_position
	if health <= 0 and !dying:
		dying = true
		hitbox.monitorable = false
		animation.stop()
		collision_layer = 0
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0), .5)

		var tween_scale = get_tree().create_tween()
		var effect_time = .15
		tween_scale.tween_property(animation, "scale", Vector2(.5, 1), effect_time)
		tween_scale = tween_scale.chain()
		tween_scale.tween_property(animation, "scale", Vector2(1, 1), effect_time)
		tween_scale.set_loops()
		tween.finished.connect(func(): queue_free())

func navigate(delta):
	
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	navigation_agent.velocity = nav_velocity.move_toward(MAX_SPEED * direction, delta * ACCELERATION)
	return direction
	
func _on_hurt_box_area_entered(area):
	area = area as HitBox
	push_velocity = area.hit_direction * 350
	health -= area.damage

