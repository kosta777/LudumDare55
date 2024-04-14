extends Area2D

@onready var ingredient_amount_1: Label = $IngredientAmount1
@onready var ingredient_amount_2: Label = $IngredientAmount2
@onready var ingredient_amount_3: Label = $IngredientAmount3
@onready var ingredient_amount_4: Label = $IngredientAmount4
@onready var ingredient_amount_5: Label = $IngredientAmount5
@onready var sprite: TextureRect = $Sprite
@onready var player_key_indication = $PlayerKeyIndication

@export var world_manager: WorldManager

var player_inside = false

var ingredients_received := {}
var can_summon := false
var tween_key: Tween

func _ready() -> void:
	reset_ingredients_received()
	update_labels()

func setup(_world_manager):
	world_manager = _world_manager

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		_key_appear()
	else:
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
	if Input.is_action_just_pressed("interact") and player_inside:
		summon_demon()


func summon_demon() -> void:
	if not is_node_ready():
		await ready
		
	var recipes = world_manager.get_current_recipes()
	#print("here are the %s recipes" %  recipes)
	#print("here are your ingredients: %s" % ingredients_received)
	
	var can_summon_anything = false
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

			can_summon_anything = true
			print("%s worked" % [recipe.recipe_name])
			var demon = recipe.demon_scene.instantiate()
			add_child(demon)

			demon.setup(recipe)
			world_manager.on_recipe_completed(recipe)
			break

	if recipes.size() > 0 and !can_summon_anything:
		print('ere')
		var player = get_parent().find_child("player").take_damage(1)

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


func _on_body_exited(body:Node2D):
	if body.is_in_group("player"):
		player_inside = false
		_key_dissapear()

func _on_summon_action_area_body_entered(body):
	print("player_in")



func _key_appear():
	if tween_key != null and tween_key.is_running():
		tween_key.stop()
	tween_key = get_tree().create_tween()
	tween_key.tween_property(player_key_indication, "modulate", Color(1, 1, 1, 1), .25)

func _key_dissapear():
	if tween_key != null and tween_key.is_running():
		tween_key.stop()
	tween_key = get_tree().create_tween()
	tween_key.tween_property(player_key_indication, "modulate", Color(1, 1, 1, 0), .25)
