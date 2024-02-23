extends Node2D
@export var xvelocity = 0
@export var yvelocity = 0

@export var star : PackedScene
@export var background : Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(200):
		var inst = star.instantiate() as CharacterBody2D
		inst.parentScene = self
		background.add_child(inst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(xvelocity)
	#print(yvelocity)
	pass
