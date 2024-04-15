extends Node2D

@export var spawn_time: int = 2 # seconds
@export var spawn_node: PackedScene
@export var spawn_direction: Vector2 = Vector2.LEFT
@export var spawn_force: float = 250
@export var icon_texture: Texture

@onready var portal_text_label = $StateLabel
@onready var portal_detection_area = $PlayerDetectionArea
@onready var progress_bar = $ProgressBar
@onready var timer = $Timer
@onready var animation = $AnimatedSprite2D
@onready var particle = $CPUParticles2D
@onready var player_key_indication = $PlayerKeyIndication
@onready var light = $PointLight2D

var get_spawn_scene: Callable

const off_modulate: Color = Color("9e9e9e")
var stop_scale = .7
var run_scale = 1.5
var turn_on = false
var player_in_range = false
var tween_loading = null
var portal_loading = false
var tween_key: Tween
var original_light_energy: float
var original_light_size: float

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/ItemLogo.texture = icon_texture
	original_light_energy = light.energy
	original_light_size = light.texture_scale
	animation.speed_scale = stop_scale
	particle.direction = spawn_direction

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
		_key_dissapear()
		Input.action_release("interact")
		portal_loading = true
		timer.start(spawn_time)
		progress_bar.value = 0
		tween_loading = get_tree().create_tween()
		tween_loading.tween_property(progress_bar, "value", 100, spawn_time)
		animation.speed_scale = run_scale
	
func _spawn_new_node():
	light_animation()
	var new_node = get_spawn_scene.call().instantiate() as Node2D
	get_parent().add_child(new_node)
	new_node.position = position
	if new_node is RawMaterialNode:

		(new_node as RawMaterialNode).apply_central_impulse(
			spawn_direction.rotated(PI / 10 * randf_range(-1, 1)) * spawn_force
		)
	else:
		new_node.position = position + spawn_direction * 2
		new_node.velocity = spawn_direction * 50
	particle.emitting = true
	
func light_animation():
	var light_tween = get_tree().create_tween()
	light_tween.tween_property(light, "energy", original_light_energy * 3, .1)
	light_tween.tween_property(light, "texture_scale", original_light_size * 1.2, .1)
	light_tween = light_tween.chain()
	light_tween.tween_property(light, "energy", original_light_energy , .7)
	light_tween.tween_property(light, "texture_scale", original_light_size , .3)
func _on_player_detection_area_body_entered(body):
	player_in_range = true
	if !portal_loading:
		_key_appear()

func _key_appear():
	if tween_key != null and tween_key.is_running():
		tween_key.stop()
	tween_key = get_tree().create_tween()
	tween_key.tween_property(player_key_indication, "modulate", Color(1, 1, 1, 1), .25)

func _key_dissapear():
	if tween_key != null and tween_key.is_running():
		tween_key.stop()
	tween_key = get_tree().create_tween()
	tween_key.tween_property(player_key_indication, "modulate", Color(1, 1, 1, 0), .25)

	

func _on_player_detection_area_body_exited(body):
	player_in_range = false
	_key_dissapear()

func _on_timer_timeout():
	print("timer is done")
	portal_loading = false
	progress_bar.value = 0
	_spawn_new_node()
	if player_in_range:
		_key_appear()
