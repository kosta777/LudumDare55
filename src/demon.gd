class_name Demon
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var animation: AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _physics_process(delta):
	velocity = Vector2(0, 25)
	move_and_slide()

func setup(recipe):
	animation.sprite_frames = recipe.demon_sprite_frames
	animation.play()
	var timer = Timer.new()
	add_child(timer)
	timer.start(5)
	timer.timeout.connect(func(): kill())

func kill():
	queue_free()