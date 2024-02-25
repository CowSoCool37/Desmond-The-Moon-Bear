extends CharacterBody2D

@export var animation : AnimatedSprite2D
var parentScene : Node2D
@export var SPEED = 100.0
var xvelocity = 0
var yvelocity = 0
var parentXVelocity = 0
var parentYVelocity = 0
var angleToPlayer

var targetOffsetX = 0
var targetOffsetY = 0

const matchSpeed = 200*200

const inaccuracy = 30
var timer = 0
var timeMax = 0

func randomize_target():
	randomize()
	timer = 0
	timeMax = randf_range(2, 3)
	targetOffsetX = randf_range(-inaccuracy, inaccuracy)
	targetOffsetY = randf_range(-inaccuracy, inaccuracy)

func _ready():
	randomize_target()
	animation.play("default")
	
func turn_towards(targetDirection, delta, turnrate):
	var deltaDirection = fposmod(((targetDirection - rotation) + PI), 2*PI) - PI
	if abs(deltaDirection) < delta*turnrate:
		rotation = targetDirection
	else:
		rotation = rotation + (deltaDirection/abs(deltaDirection))*delta*turnrate

func get_total_velocity():
	return (-parentXVelocity + xvelocity) * (-parentXVelocity + xvelocity) + (-parentYVelocity + yvelocity) * (-parentYVelocity + yvelocity)
	
func get_velocity_direction():
	return Vector2(1,0).angle_to(Vector2((-parentXVelocity + xvelocity), (-parentYVelocity + yvelocity)))
	

func _physics_process(delta):
	if get_total_velocity() < matchSpeed:
		angleToPlayer = global_position.direction_to(Vector2(640 + targetOffsetX, 360 + targetOffsetY)).angle()
		turn_towards(angleToPlayer,delta,1)
	else:
		var retrograde = fposmod(get_velocity_direction() + PI, 2*PI)
		turn_towards(retrograde,delta,2)
	
	parentXVelocity = parentScene.xvelocity
	parentYVelocity = parentScene.yvelocity
	xvelocity += cos(rotation) * SPEED * delta
	yvelocity += sin(rotation) * SPEED * delta
	velocity.x = -parentXVelocity + xvelocity
	velocity.y = -parentYVelocity + yvelocity
	
	timer += delta
	if timer > timeMax:
		randomize_target()
	

	move_and_slide()
