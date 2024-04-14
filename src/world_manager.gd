class_name WorldManager extends Node2D

@export var tasks_container: Container
@export var task_scene: PackedScene
@export var recipes: Array[RecipeBase]
@export var time_between_recipes: float = 15
@onready var timer: Timer = $Timer


var ui_to_recipes = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_task()
	timer.start(time_between_recipes)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	add_task()
	timer.start(time_between_recipes)

func add_task():
	var new_task = task_scene.instantiate()
	new_task.setup(recipes[1], tasks_container, self)
	ui_to_recipes[new_task] = recipes[1]

func on_task_expired(task: Task):
	ui_to_recipes.erase(task)
	task.queue_free()