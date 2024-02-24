extends CharacterBody2D


var parentScene : Node2D

@export var xvelocity = 0
@export var yvelocity = 0

func _ready():
	randomize()
	var size = randf_range(0.5, 1.0)
	self.scale.x = size
	self.scale.y = size
	position.x = randf_range(0, 2000)
	position.y = randf_range(0, 2000)

func _physics_process(delta):
	xvelocity = parentScene.xvelocity
	yvelocity = parentScene.yvelocity
	velocity.x = -xvelocity
	velocity.y = -yvelocity
	
	if position.x > 2000:
		position.x -= 2000
	if position.x < 0:
		position.x += 2000

	if position.y > 2000:
		position.y -= 2000
	if position.y < 0:
		position.y += 2000
	move_and_slide()
