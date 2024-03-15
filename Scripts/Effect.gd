extends CharacterBody2D


var parentScene : Node2D

@export var parentXvelocity = 0
@export var parentYvelocity = 0
var xvelocity = 0
var yvelocity = 0

var lifetime = 0.5
var lifetimer = 0
var effect = 1

var damage = 30

var animations : AnimatedSprite2D


func _ready():
	animations = get_node("AnimatedSprite2D")

func _physics_process(delta):
	parentXvelocity = parentScene.xvelocity
	parentYvelocity = parentScene.yvelocity
	velocity.x = -parentXvelocity + xvelocity
	velocity.y = -parentYvelocity + yvelocity
	
	if effect == 1:
		animations.play("smoke")
	if effect == 2:
		animations.play("sparks")
		self.scale = Vector2(1,1)
	
	lifetimer += delta
	if lifetimer > lifetime:
		queue_free()
	move_and_slide()
