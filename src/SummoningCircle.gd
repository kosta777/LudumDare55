extends Area2D

@onready var ingredient_amount_1: Label = $IngredientAmount1
@onready var ingredient_amount_2: Label = $IngredientAmount2
@onready var ingredient_amount_3: Label = $IngredientAmount3
@onready var ingredient_amount_4: Label = $IngredientAmount4
@onready var ingredient_amount_5: Label = $IngredientAmount5
@onready var sprite: Sprite2D = $SpriteContainer/Sprite
@onready var light: PointLight2D = $SpriteContainer/PointLight2D
@onready var player_key_indication = $PlayerKeyIndication
@onready var sfx_absorb_ingredient: AudioStreamPlayer2D = $SFXAbsorbIngredient
@onready var sfx_summoning: AudioStreamPlayer2D = $SFXSummoning


@export var world_manager: WorldManager

var player_inside = false

var moving_ingredient := false
var ingredients_received := {}
var can_summon := false
var tween_key: Tween
var original_light_energy: float
var type_to_label= {} 

func _ready() -> void:
	reset_ingredients_received()
	update_labels()
	original_light_energy = light.energy

func setup(_world_manager):
	world_manager = _world_manager
	type_to_label = {
		Ingredients.Type.BLACK_SOUL: ingredient_amount_1,
		Ingredients.Type.HORNS: ingredient_amount_4,
		Ingredients.Type.WINGS: ingredient_amount_5
	}

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		_key_appear()
	else:
		for child in body.carried_item.get_children():
			if child is IngredientDrop:
				ingredients_received[child.ingredient_type] += 1
				call_deferred("disable_collision", body)
				get_tree().create_timer(1).timeout.connect(
					func():move_absorbed_ingredient(body, child.ingredient_type)
				)
				update_labels()

func disable_collision(on_what):
	on_what.find_child("CollisionShape2D").disabled = true

func move_absorbed_ingredient(node_to_move, type):

	sfx_absorb_ingredient.play()
	var tween: Tween = create_tween()
	var tween_duration = 0.5
	print(type_to_label)
	tween.set_parallel(true)
	tween.tween_property(node_to_move, "position", type_to_label[type].global_position, tween_duration)
	tween.tween_property(node_to_move, "modulate:a", 0, tween_duration)
	await tween.finished
	print("finished tween")
	sfx_absorb_ingredient.stop()
	node_to_move.queue_free()


func update_labels() -> void:
	ingredient_amount_1.text = str(ingredients_received.values()[0])
	ingredient_amount_2.text = str(ingredients_received.values()[1])
	ingredient_amount_3.text = str(ingredients_received.values()[2])
	ingredient_amount_4.text = str(ingredients_received.values()[3])
	ingredient_amount_5.text = str(ingredients_received.values()[4])


var carry = false
func _process(delta):


	if Input.is_action_just_pressed("interact") and player_inside and !carry:
		summon_demon()
	
	carry = get_parent().get_node("player").is_carrying if get_parent().get_node("player") != null else false

func animate():
	var tween: Tween = create_tween()
	tween.tween_property(light, "energy", 8, .1)
	tween.chain().tween_property(light, "energy", original_light_energy, .4)
	print("called")

func summon_demon() -> void:
	if not is_node_ready():
		await ready
	animate()
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
			sfx_summoning.play()
			break

	if recipes.size() > 0 and !can_summon_anything && has_any_ingredients():
		print('ere')
		var player = get_parent().find_child("player").take_damage(1)

	reset_ingredients_received()
	update_labels()

func has_any_ingredients() -> bool:
	var sum = 0

	for stuff in ingredients_received.values():
		sum += stuff

	return sum > 0

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
