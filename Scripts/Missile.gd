extends CharacterBody2D


var parentScene : Node2D

@export var parentXvelocity = 0
@export var parentYvelocity = 0
@export var effect : PackedScene
var xvelocity = 0
var yvelocity = 0

var lifetime = 3
var lifetimer = 0
const drag = 1.0

var damage = 30
var targetAngle
const inaccuracy = 200
var targetOffsetX
var targetOffsetY

var SPEED = 700
var animation

func randomize_target():
	randomize()
	targetOffsetX = randf_range(-inaccuracy, inaccuracy)
	targetOffsetY = randf_range(-inaccuracy, inaccuracy)

func turn_towards(targetDirection, delta, turnrate):
	var deltaDirection = fposmod(((targetDirection - rotation) + PI), 2*PI) - PI
	if abs(deltaDirection) < delta*turnrate:
		rotation = targetDirection
	else:
		rotation = rotation + (deltaDirection/abs(deltaDirection))*delta*turnrate

func _ready():
	randomize_target()
	animation = get_node("AnimatedSprite2D")
	animation.play("default")

func _physics_process(delta):
	parentXvelocity = parentScene.xvelocity
	parentYvelocity = parentScene.yvelocity
	xvelocity += cos(rotation) * SPEED * delta
	yvelocity += sin(rotation) * SPEED * delta
	velocity.x = -parentXvelocity + xvelocity
	velocity.y = -parentYvelocity + yvelocity
	
	xvelocity *= 1 - delta*drag
	yvelocity *= 1 - delta*drag
	
	if global_position.distance_to(Vector2(640, 360)) > 100:
		targetAngle = global_position.direction_to(Vector2(640 + targetOffsetX, 360 + targetOffsetY)).angle()
		turn_towards(targetAngle,delta,1.5)
	
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
