extends Node2D
@export var xvelocity = 0
@export var yvelocity = 0

@export var star : PackedScene
@export var background : Sprite2D
@export var satellite : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in range(200):
		var inst = star.instantiate() as CharacterBody2D
		inst.parentScene = self
		background.add_child(inst)
	
	for i in range(1):
		var inst = satellite.instantiate() as CharacterBody2D
		inst.parentScene = self
		inst.position.x = randf_range(500, 500)
		inst.position.y = randf_range(500, 500)
		background.add_child(inst)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(xvelocity)
	#print(yvelocity)
	pass
