extends Node2D

@export var spawn_time: int = 2 #seconds


@onready var portal_text_label = $StateLabel
@onready var portal_detection_area = $PlayerDetectionArea
@onready var progress_bar = $ProgressBar
@onready var timer = $Timer
@onready var animation = $AnimatedSprite2D

const off_modulate: Color = Color("9e9e9e")
var turn_on = false
var player_in_range = false
var tween_loading = null
var portal_loading = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !portal_loading:
		modulate = off_modulate
	else:
		modulate = Color.WHITE
	portal_text_label.text = str(portal_loading)
	
	if player_in_range and !portal_loading and Input.is_action_just_pressed("interact"):
		portal_loading = true
		timer.start(spawn_time)
		progress_bar.value = 0
		tween_loading = get_tree().create_tween()
		tween_loading.tween_property(progress_bar, "value", 100, spawn_time)
		animation.play()
	

func _on_player_detection_area_body_entered(body):
	player_in_range = true


func _on_player_detection_area_body_exited(body):
	player_in_range = false


func _on_timer_timeout():
	print("timer is done")
	portal_loading = false
	animation.stop()
