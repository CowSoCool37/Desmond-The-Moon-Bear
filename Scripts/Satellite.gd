extends CharacterBody2D

@export var animation : AnimatedSprite2D
var parentScene : Node2D
@export var SPEED = 100.0
var xvelocity = 0
var yvelocity = 0
var parentXVelocity = 0
var parentYVelocity = 0
var angleToPlayer

func _ready():
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
	if(-parentYVelocity + yvelocity) != 0:
		return atan((-parentXVelocity + xvelocity) / (-parentYVelocity + yvelocity))
	else:
		if (-parentXVelocity + xvelocity) > 0:
			return 2*PI
		return 0
	

func _physics_process(delta):
	if get_total_velocity() < 0:
		angleToPlayer = global_position.direction_to(Vector2(640, 360)).angle()
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
	

	move_and_slide()
