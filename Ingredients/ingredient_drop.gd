class_name IngredientDrop
extends Node2D

@export var ingredient_type : Ingredients.Type

@onready var icon: TextureRect = $icon
@onready var name_label: Label = $name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_node_ready():
		await ready
	icon.texture = Ingredients.INGREDIENT_ICON[ingredient_type]
	name_label.text = Ingredients.INGREDIENT_NAME[ingredient_type]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
