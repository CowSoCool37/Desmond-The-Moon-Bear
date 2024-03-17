extends Node2D
var day = -1

@export var scenes : Array[PackedScene]

var currentScene : Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	currentScene = scenes[0].instantiate()
	currentScene.gameManager = self
	add_child(currentScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next_day():
	day += 1
	currentScene.queue_free()
	currentScene = scenes[1].instantiate()
	currentScene.gameManager = self
	currentScene.day = day
	add_child(currentScene)

func restart_day():
	currentScene.queue_free()
	currentScene = scenes[1].instantiate()
	currentScene.gameManager = self
	currentScene.day = day
	add_child(currentScene)
