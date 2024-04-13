extends Area2D

@export var recipes : Array[RecipeBase]

@onready var ingredient_amount_1: Label = $IngredientAmount1
@onready var ingredient_amount_2: Label = $IngredientAmount2
@onready var ingredient_amount_3: Label = $IngredientAmount3
@onready var ingredient_amount_4: Label = $IngredientAmount4
@onready var ingredient_amount_5: Label = $IngredientAmount5
@onready var sprite: TextureRect = $Sprite


var ingredients_received := {}
var can_summon := false

func _ready() -> void:
	reset_ingredients_received()
	update_labels()


func _on_body_entered(body: RawMaterialNode) -> void:
	for child in body.carried_item.get_children():
		if child is IngredientDrop:
			print("ingredient is %s" % Ingredients.Type.keys()[child.ingredient_type])
			ingredients_received[child.ingredient_type] += 1
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


func _process(delta):
	if Input.is_action_just_pressed("summon"):
		summon_demon()


func summon_demon() -> void:
	if not is_node_ready():
		await ready
		
	if recipes.size() == 0:
		return
		
	print("here are the %s recipes" % recipes.size())
	print("here are your ingredients: %s" % ingredients_received)
	
	for recipe in recipes:
		var can_summon := true
		recipe.ingredient_list()
		print("%s: %s" % [recipe.recipe_name, recipe.ingredients_needed])
		for ingredient in ingredients_received.keys():
			if ingredients_received.values()[ingredient] != recipe.ingredients_needed[ingredient]:
				can_summon = false
				print("%s failed" % [recipe.recipe_name])
				break
		if can_summon:
			print("%s worked" % [recipe.recipe_name])
	reset_ingredients_received()
	update_labels()
	
	


func reset_ingredients_received() -> void:
	ingredients_received = {
		Ingredients.Type.BLACK_SOUL : 0,
		Ingredients.Type.RED_SOUL : 0,
		Ingredients.Type.PURPLE_SOUL : 0,
		Ingredients.Type.HORNS : 0,
		Ingredients.Type.WINGS : 0
	}
