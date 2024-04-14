class_name WorldManager extends Node2D

@export var tasks_container: Container
@export var task_scene: PackedScene
@export var recipes: Array[RecipeBase]
@export var time_between_recipes: float = 15
@onready var timer: Timer = $Timer


@export var summoning_circle: Node2D


var ui_to_recipes = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_task()
	timer.start(time_between_recipes)
	summoning_circle.setup(self)
	
	$Portal1.get_spawn_scene = Spawner.new().spawn_portal1
	$Portal2.get_spawn_scene = Spawner.new().spawn_portal2
	$Portal3.get_spawn_scene = Spawner.new().spawn_portal3
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	print("should add task")
	add_task()
	timer.start(time_between_recipes)

func add_task():
	var new_task = task_scene.instantiate()
	var randomIndex = randi() % recipes.size()
	new_task.setup(recipes[randomIndex], tasks_container, self)
	ui_to_recipes[new_task] = recipes[randomIndex]

func on_task_expired(task: Task):
	ui_to_recipes.erase(task)
	task.queue_free()

func on_recipe_completed(recipe):
	for key in ui_to_recipes.keys():
		if ui_to_recipes[key] == recipe:
			ui_to_recipes.erase(key)
			key.queue_free()

func get_current_recipes():
	return ui_to_recipes.values()
