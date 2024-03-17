extends CharacterBody2D


var parentScene : Node2D

@export var parentXvelocity = 0
@export var parentYvelocity = 0
@export var effect : PackedScene
var xvelocity = 0
var yvelocity = 0

var lifetime = 1
var lifetimer = 0

var damage = 30


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
	body.hp -= damage
	var inst = effect.instantiate() as CharacterBody2D
	inst.effect = 1
	inst.lifetime = 0.5
	inst.parentScene = parentScene
	inst.position = position
	inst.rotation = rotation
	inst.xvelocity =  xvelocity*0.2
	inst.yvelocity = yvelocity*0.2

	parentScene.add_child(inst)
	#print("hit")
	queue_free()
