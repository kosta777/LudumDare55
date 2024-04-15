extends Node2D

@export var texture_light: Texture2D
@export var size: float
@export var energy: float
@export var color: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	var lights = [$LightShadow]
	for l in lights:
		l.texture = texture_light
		l.energy = energy
		l.texture_scale = size
		l.color = color
	
	var tween = get_tree().create_tween()
	var time = .1
	var scale = .96
	tween.tween_property(self, "size", size* scale, time)
	tween.tween_property(self, "energy", energy * scale, time)
	tween.tween_interval(.5)
	tween = tween.chain()
	tween.tween_property(self, 'size', size, time)
	tween.tween_property(self, 'energy', energy, time)
	tween.set_loops()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var lights = [$LightShadow]
	for l in lights:
		l.texture = texture_light
		l.energy = energy
		l.texture_scale = size
		l.color = color
