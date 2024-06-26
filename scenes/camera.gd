class_name CustomCamera extends Camera2D

@export var movement_bounding_box: ColorRect
@onready var color_rect = $ColorRect
@onready var tween_rect = get_tree().create_tween()

var shake_strength:float = 0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, 5*delta)

		offset = random_offset()

func apply_shake(strength = 6.0):
	shake_strength = strength
	tween_rect = get_tree().create_tween()
	tween_rect.tween_property(color_rect, "color:a", .4, .1)
	tween_rect.chain().tween_property(color_rect, "color:a", 0, .3)

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
