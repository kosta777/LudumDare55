extends Area2D

@onready var ingredient_amount_1: Label = $IngredientAmount1
@onready var ingredient_amount_2: Label = $IngredientAmount2
@onready var ingredient_amount_3: Label = $IngredientAmount3
@onready var ingredient_amount_4: Label = $IngredientAmount4
@onready var ingredient_amount_5: Label = $IngredientAmount5
@onready var sprite: TextureRect = $Sprite



var ingredients_received := {}
var can_summon := false


func _ready() -> void:
	pass
	for ingredient in Ingredients.Type.keys():
		ingredients_received[ingredient] = 0
		
	print(ingredients_received)
	update_labels()


func _on_body_entered(body: RawMaterialNode) -> void:
	for child in body.carried_item.get_children():
		if child is IngredientDrop:
			print("ingredient is %s" % Ingredients.Type.keys()[child.ingredient_type])
			ingredients_received[Ingredients.Type.keys()[child.ingredient_type]] += 1
			body.queue_free()
			print(ingredients_received)
			update_labels()


func update_labels() -> void:
	ingredient_amount_1.text = str(ingredients_received.values()[0])
	ingredient_amount_2.text = str(ingredients_received.values()[1])
	ingredient_amount_3.text = str(ingredients_received.values()[2])
	ingredient_amount_4.text = str(ingredients_received.values()[3])
	ingredient_amount_5.text = str(ingredients_received.values()[4])

	var tween: Tween = create_tween()
	tween.tween_property(sprite, "modulate:v", 1, 0.25).from(15)
