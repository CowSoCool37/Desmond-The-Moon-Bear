extends Node2D
var day = -1

@export var scenes : Array[PackedScene]

var currentScene : Node2D

var totalTimer = 0.0
var sceneTimer = 0.0
var dayState = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	currentScene = scenes[0].instantiate()
	currentScene.gameManager = self
	add_child(currentScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sceneTimer += delta
	totalTimer += delta
	if sceneTimer > 0.8 and day == 8 and dayState == 0:
		currentScene.queue_free()
		currentScene = scenes[4].instantiate()
		currentScene.gameManager = self
		currentScene.day = day
		currentScene.time = ceili(totalTimer)
		add_child(currentScene)
		dayState += 1
		
	if sceneTimer > 0.8 and day < 8:
		match dayState:
			0:
				currentScene.queue_free()
				currentScene = scenes[3].instantiate()
				currentScene.gameManager = self
				currentScene.day = day
				add_child(currentScene)
				dayState += 1
				sceneTimer = 0
			1:
				if sceneTimer > 3:
					currentScene.queue_free()
					currentScene = scenes[2].instantiate()
					currentScene.gameManager = self
					currentScene.day = day
					add_child(currentScene)
					dayState += 1
					sceneTimer = 0
			2:
				currentScene.queue_free()
				currentScene = scenes[1].instantiate()
				currentScene.gameManager = self
				currentScene.day = day
				add_child(currentScene)
				dayState += 1
				sceneTimer = 0

func next_day():
	if day == -1:
		totalTimer = 0
	sceneTimer = 0
	day += 1
	dayState = 0
	
	currentScene.queue_free()
	currentScene = scenes[2].instantiate()
	currentScene.gameManager = self
	currentScene.day = day
	add_child(currentScene)

func restart_day():
	sceneTimer = 0
	dayState = 0

	currentScene.queue_free()
	currentScene = scenes[2].instantiate()
	currentScene.gameManager = self
	currentScene.day = day
	add_child(currentScene)

func end_game():
	day = -1
	totalTimer = 0.0
	sceneTimer = 0.0
	dayState = -1
	currentScene.queue_free()
	currentScene = scenes[0].instantiate()
	currentScene.gameManager = self
	add_child(currentScene)
