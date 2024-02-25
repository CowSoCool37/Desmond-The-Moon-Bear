extends CharacterBody2D


var parentScene : Node2D

@export var parentXvelocity = 0
@export var parentYvelocity = 0
var xvelocity = 0
var yvelocity = 0

var lifetime = 1
var lifetimer = 0

func _ready():
	pass

func _physics_process(delta):
	parentXvelocity = parentScene.xvelocity
	parentYvelocity = parentScene.yvelocity
	velocity.x = -parentXvelocity + xvelocity
	velocity.y = -parentYvelocity + yvelocity
	
	lifetimer += delta
	if lifetimer > lifetime:
		queue_free()
	move_and_slide()

func _on_area_2d_body_entered(body):
	print("hit")
	queue_free()
