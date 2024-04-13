extends Area2D

@onready var ingredient_required_1: Label = $IngredientRequired1
@onready var ingredient_obtained_1: Label = $IngredientObtained1
@onready var ingredient_required_2: Label = $IngredientRequired2
@onready var ingredient_obtained_2: Label = $IngredientObtained2
@onready var ingredient_required_3: Label = $IngredientRequired3
@onready var ingredient_obtained_3: Label = $IngredientObtained3
@onready var ingredient_required_4: Label = $IngredientRequired4
@onready var ingredient_obtained_4: Label = $IngredientObtained4
@onready var ingredient_required_5: Label = $IngredientRequired5
@onready var ingredient_obtained_5: Label = $IngredientObtained5



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
