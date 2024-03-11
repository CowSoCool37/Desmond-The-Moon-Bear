extends CharacterBody2D


var parentScene : Node2D

@export var parentXvelocity = 0
@export var parentYvelocity = 0
var xvelocity = 0
var yvelocity = 0

var lifetime = 1.5
var lifetimer = 0
const drag = 0.4

var damage = 20

func _ready():
	pass

func _physics_process(delta):
	parentXvelocity = parentScene.xvelocity
	parentYvelocity = parentScene.yvelocity
	velocity.x = -parentXvelocity + xvelocity
	velocity.y = -parentYvelocity + yvelocity
	
	xvelocity *= 1 - delta*drag
	yvelocity *= 1 - delta*drag
	
	lifetimer += delta
	if lifetimer > lifetime:
		queue_free()
	move_and_slide()

func _on_area_2d_body_entered(body):
	body.hp -= damage
	print("desmond hit")
	queue_free()
