extends Area2D

var ingredients_needed := {}
var ingredients_received := {}
var can_summon = := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for ingredient in Ingredients.Type:
		ingredients_received[ingredients_received] = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if not body.ingredient:
		return
	
