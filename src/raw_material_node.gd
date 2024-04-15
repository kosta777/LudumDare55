class_name RawMaterialNode extends RigidBody2D

@onready var carried_item: Node2D = %CarriedItem


func set_ingredient(ing: Ingredients.Type):
	$CarriedItem/Ingredient.ingredient_type = ing
