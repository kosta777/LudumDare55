class_name Task extends Panel

@export var demon_icon: TextureRect
@export var ingredients_container: Container

@export var ingredients_window_scene: PackedScene

@export var timer:Timer
@export var progress_bar : ProgressBar

var recipe: RecipeBase

var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate= Color(1, 1, 1, 0)
	pass # Replace with function body.

func setup(_recipe, parent, _game_manager):
	game_manager = _game_manager
	recipe = _recipe
	recipe.ingredient_list()

	demon_icon.texture = recipe.demon_texture

	for ingredient in recipe.ingredients_needed.keys():
		if recipe.ingredients_needed[ingredient] > 0:
			var new_ingredient_ui = ingredients_window_scene.instantiate()
			new_ingredient_ui.setup(ingredient, recipe.ingredients_needed[ingredient])
			ingredients_container.add_child(new_ingredient_ui)
	parent.add_child(self)
	var tween= get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1)

	timer.start(recipe.recipe_time_limit)
	var tween_progress= get_tree().create_tween()
	tween_progress.tween_property(progress_bar, "value", 0, recipe.recipe_time_limit)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	game_manager.on_task_expired(self)
