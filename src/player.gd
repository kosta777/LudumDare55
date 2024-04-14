class_name Player
extends CharacterBody2D

const MAX_SPEED = 170.0
const ACCELERATION = 2000
const FRICTION = 3000

#Carry stuff
@onready var carry_slot: Node2D = $CarrySlot
@onready var pickup_raycast: ShapeCast2D = $Sprite2D/PickUpRaycast
@onready var player_collision: CollisionShape2D = $player_collision
@onready var hitbox: HitBox = $Hitbox
@onready var hurtbox: Area2D = $HurtBox
@onready var animation_tree = $AnimationTree

@export var attacking = false
@export var starting_health: int

var health:float = 0
var flipped = false
var direction_wanted = Vector2.LEFT

var is_carrying = false
var just_hitted = false

func _ready():
	health = starting_health

func get_direction():
	var direction_x = Input.get_axis("move-left", "move-right")
	var direction_y = Input.get_axis("move-up", "move-down")
	return Vector2(direction_x, direction_y)

func move_player(delta):
	var direction = get_direction()
	direction_wanted = Vector2(direction.x, 0).normalized()
	if direction == Vector2.ZERO:
		var amount = velocity.normalized() * FRICTION * delta
		
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
	if velocity.length() > 0:
		_set_animation_state_walking(true)

	else:
		_set_animation_state_walking(false)
	
	if Input.is_action_pressed("attack") and !attacking:

		animation_tree["parameters/conditions/attacking"] = true
	else:
		animation_tree["parameters/conditions/attacking"] = false

func _physics_process(delta):
	handle_inputs(delta)

	_set_blend_position(direction_wanted.x)

	move_and_slide()
	
	if !attacking: 
		if !velocity.is_zero_approx():
			hitbox.hit_direction = velocity.normalized()
		else:
			hitbox.hit_direction = Vector2.RIGHT if !flipped else Vector2.LEFT
	
	#Dont allow player to leave camera rect
	#var bounding_area = get_viewport_rect()
	var bounding_area = (get_viewport().get_camera_2d() as CustomCamera).movement_bounding_box
	global_position = global_position.clamp(Vector2(bounding_area.position.x + player_collision.shape.get_rect().size.x / 2, bounding_area.position.y + player_collision.shape.get_rect().size.y / 2),
		Vector2(bounding_area.position.x + bounding_area.size.x - player_collision.shape.get_rect().size.x / 2, bounding_area.position.y + bounding_area.size.y - player_collision.shape.get_rect().size.y / 2))
	GameManager.player_position = global_position
	

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.is_action("interact"):
			#If not carrying anything, pick up the object if possible
			if !is_carrying:
				if pickup_raycast.is_colliding():
					var item_to_carry = pickup_raycast.get_collider(0)
					print(item_to_carry)
					if !(item_to_carry is RawMaterialNode):
						print("ERROR TRIED TO PICK UP SOMETHING THATS NOT RAW MATEIRAL NODE, MAYBE YOUR NODE IS ON THE WRONG LAYER???")
					else:
						is_carrying = true
						(item_to_carry as RawMaterialNode).freeze = true
						item_to_carry.global_position = carry_slot.global_position
						(item_to_carry as RawMaterialNode).reparent(carry_slot)
				else:
					print("no collision")
			#if is carrying, drop the object
			else:
				is_carrying = false
				var item_to_drop = carry_slot.get_child(0) as RawMaterialNode
				(item_to_drop as RawMaterialNode).freeze = false
				item_to_drop.reparent(get_parent())
				var x_force = 500
				var y_force = 300
				if (flipped):
					x_force *= - 1
				var force_vect = Vector2(x_force, y_force) + velocity * 3
				item_to_drop.apply_central_impulse(force_vect)

func _set_animation_state_walking(walking):
	animation_tree["parameters/conditions/idle"] = !walking
	animation_tree["parameters/conditions/walking"] = walking

func _set_blend_position(x):
	if x != 0:
		flipped = x < 0
		pickup_raycast.scale.x = 1 if flipped else - 1

		animation_tree["parameters/idle/blend_position"] = x
		animation_tree["parameters/walking/blend_position"] = x
		if !attacking:
			animation_tree["parameters/attacking/blend_position"] = x

func _on_hurt_box_area_entered(area):
	print("player hit")
	area = area as HitBox
	velocity += area.hit_direction * 380
	just_hitted = true
	_player_hit()
	
func _player_hit():
	var effect_time = .12
	var tween = get_tree().create_tween().bind_node(self)
	
	tween.tween_property(self, "modulate", Color(1,1,1,0), effect_time)
	tween = tween.chain()
	tween.tween_property(self, "modulate", Color(1,1,1,1), effect_time)
	tween.set_loops(5)
	tween.finished.connect(func(): _invincibility_finished())

	hurtbox.set_deferred("monitoring", false)
	take_damage(0.5)
	#set_collision_mask_value(3, false)

func _invincibility_finished():
	hurtbox.set_deferred("monitoring", true)
	set_collision_mask_value(3, true)
	just_hitted = false

func take_damage(amount):
	health -= amount

	var camera = get_parent().find_child("Camera2D")

	camera.apply_shake()

	if health <=0:
		get_parent().on_player_death()
