extends Node2D


var turn_on = false

@onready var portal_text_label = $StateLabel
@onready var portal_detection_area = $PlayerDetectionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	portal_text_label.text = str(turn_on)


func _on_player_detection_area_area_entered(area):
	print("player")


func _on_player_detection_area_body_entered(body):
	print(body)
