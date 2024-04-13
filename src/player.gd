class_name Player
extends CharacterBody2D

const MAX_SPEED = 170.0
const ACCELERATION = 2000
const FRICTION = 3000

#Carry stuff
@onready var carry_slot: Node2D = $CarrySlot
@onready var pickup_raycast: RayCast2D = $PickUpRaycast
var is_carrying = false

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

func _physics_process(delta):
	handle_inputs(delta)

	_set_blend_position(velocity.x)

	move_and_slide()
	#GameManager.player_position = global_position

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			#If not carrying anything, pick up the object if possible
			if !is_carrying:
				if pickup_raycast.is_colliding():
					var item_to_carry = pickup_raycast.get_collider()
					print(item_to_carry)
					if !(item_to_carry is RawMaterialNode):
						print("ERROR TRIED TO PICK UP SOMETHING THATS NOT RAW MATEIRAL NODE, MAYBE YOUR NODE IS ON THE WRONG LAYER???")
					else:
						is_carrying = true
						item_to_carry.global_position = carry_slot.global_position
						(item_to_carry as RawMaterialNode).reparent(carry_slot)
				else:
					print("no collision")
			#if is carrying, drop the object
			else:
				is_carrying = false
				var item_to_drop = carry_slot.get_child(0) as RawMaterialNode
				item_to_drop.reparent(get_parent())
				var x_force = -100
				var y_force = 10
				if (flipped):
					x_force *= - 1
				item_to_drop.apply_central_impulse(Vector2(x_force, y_force))

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
