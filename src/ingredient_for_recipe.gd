extends HBoxContainer

@export var icon: TextureRect
@export var textbox:Label 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(ingredient_type, ingredient_amount):
	icon.texture = Ingredients.INGREDIENT_ICON[ingredient_type]
	textbox.text = str(ingredient_amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
