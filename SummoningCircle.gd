extends Area2D

var ingredients_needed := {}
var ingredients_received := {}
var can_summon := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	for ingredient in Ingredients.Type.keys():
		ingredients_received[ingredient] = 0
		
	print(ingredients_received)

func _on_body_entered(body: RawMaterialNode) -> void:
	for child in body.carried_item.get_children():
		if child is IngredientDrop:
			print("ingredient is %s" % Ingredients.Type.keys()[child.ingredient_type])
			ingredients_received[Ingredients.Type.keys()[child.ingredient_type]] += 1
			body.queue_free()
			print(ingredients_received)
