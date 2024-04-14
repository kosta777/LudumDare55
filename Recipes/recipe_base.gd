class_name RecipeBase
extends Resource

@export var recipe_name : String
@export var recipe_time_limit : int

@export var demon_texture: Texture2D
@export var demon_sprite_frames: SpriteFrames
@export var demon_scene: PackedScene
@export var score: int

@export_category("Ingredients amount")

@export_range(0,10,1) var black_souls : int
@export_range(0,10,1) var red_souls : int
@export_range(0,10,1) var purple_souls : int
@export_range(0,10,1) var horns : int
@export_range(0,10,1) var wings : int

var ingredients_needed := {}

func ingredient_list() -> void:
	ingredients_needed = {
		Ingredients.Type.BLACK_SOUL : black_souls,
		Ingredients.Type.RED_SOUL : red_souls,
		Ingredients.Type.PURPLE_SOUL : purple_souls,
		Ingredients.Type.HORNS : horns,
		Ingredients.Type.WINGS : wings
	}