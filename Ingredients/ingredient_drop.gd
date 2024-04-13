class_name IngredientDrop
extends Node2D

@export var ingredient_type : Ingredients.Type : set = _set_ingredient

@onready var icon: TextureRect = $icon
@onready var name_label: Label = $name


func _ready() -> void:
	if not is_node_ready():
		await ready
		
	update_graphics(ingredient_type)


func _set_ingredient(new_value : Ingredients.Type) -> void:
	ingredient_type = new_value
	update_graphics(ingredient_type)


func update_graphics(new_value : Ingredients.Type):
	icon.texture = Ingredients.INGREDIENT_ICON[new_value]
	name_label.text = Ingredients.INGREDIENT_NAME[new_value]
