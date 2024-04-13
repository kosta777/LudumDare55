extends Node2D

@export var spawn_time: int = 2 # seconds
@export var spawn_node: PackedScene
@export var spawn_direction: Vector2 = Vector2.LEFT
@export var spawn_force: float = 250

@onready var portal_text_label = $StateLabel
@onready var portal_detection_area = $PlayerDetectionArea
@onready var progress_bar = $ProgressBar
@onready var timer = $Timer
@onready var animation = $AnimatedSprite2D
@onready var particle = $CPUParticles2D

const off_modulate: Color = Color("9e9e9e")
var stop_scale = .7
var run_scale = 1.5
var turn_on = false
var player_in_range = false
var tween_loading = null
var portal_loading = false
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.speed_scale = stop_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !portal_loading:
		animation.self_modulate = off_modulate
		animation.speed_scale = stop_scale
	else:
		animation.self_modulate = Color.WHITE
		animation.speed_scale = run_scale
	portal_text_label.text = str(portal_loading)
	
	if player_in_range and !portal_loading and Input.is_action_just_pressed("interact"):
		Input.action_release("interact")
		portal_loading = true
		timer.start(spawn_time)
		progress_bar.value = 0
		tween_loading = get_tree().create_tween()
		tween_loading.tween_property(progress_bar, "value", 100, spawn_time)
		animation.speed_scale = run_scale
	
func _spawn_new_node():
	var new_node = spawn_node.instantiate() as Node2D
	get_parent().add_child(new_node)
	new_node.position = position
	(new_node as RawMaterialNode).apply_central_impulse(
		Vector2.RIGHT.rotated(PI / 10 * randf_range( - 1, 1)) * spawn_force
	)
	particle.emitting = true

func _on_player_detection_area_body_entered(body):
	player_in_range = true

func _on_player_detection_area_body_exited(body):
	player_in_range = false

func _on_timer_timeout():
	print("timer is done")
	portal_loading = false
	progress_bar.value = 0
	_spawn_new_node()
