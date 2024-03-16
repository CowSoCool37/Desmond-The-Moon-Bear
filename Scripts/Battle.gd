extends Node2D
@export var xvelocity = 0
@export var yvelocity = 0

@export var star : PackedScene
@export var background : Sprite2D
@export var enemies : Array[PackedScene]
var gameManager : Node2D
var deathTimer = 0
var desmond : CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	desmond = get_node("Desmond Ship")
	randomize()
	for i in range(200):
		var inst = star.instantiate() as CharacterBody2D
		inst.parentScene = self
		background.add_child(inst)
	
	for i in range(3):
		var inst = enemies[0].instantiate() as CharacterBody2D
		inst.parentScene = self
		inst.position.x = randf_range(500, 800)
		inst.position.y = randf_range(500, 800)
		background.add_child(inst)
	for i in range(1):
		var inst = enemies[1].instantiate() as CharacterBody2D
		inst.parentScene = self
		inst.position.x = randf_range(500, 800)
		inst.position.y = randf_range(500, 800)
		background.add_child(inst)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if desmond.dead:
		deathTimer += delta
	if deathTimer > 2:
		gameManager.restart_day()
