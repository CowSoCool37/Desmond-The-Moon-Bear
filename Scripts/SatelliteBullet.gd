extends CharacterBody2D


var parentScene : Node2D

@export var parentXvelocity = 0
@export var parentYvelocity = 0
@export var effect : PackedScene
var xvelocity = 0
var yvelocity = 0

var lifetime = 1.5
var lifetimer = 0
const drag = 0.4

var damage = 20

var fire: AudioStreamPlayer

func _ready():
	fire = get_node("fire")
	if global_position.distance_to(Vector2(640,360)) < 800:
		fire.play()

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
	var inst = effect.instantiate() as CharacterBody2D
	inst.effect = 1
	inst.lifetime = 0.5
	inst.parentScene = parentScene
	inst.position = position
	inst.rotation = rotation
	inst.xvelocity =  xvelocity*0.2
	inst.yvelocity = yvelocity*0.2
	parentScene.add_child(inst)
	#print("desmond hit")
	queue_free()
