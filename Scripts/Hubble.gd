
extends CharacterBody2D

@export var animation : AnimatedSprite2D
var parentScene : Node2D
@export var SPEED = 100.0
var xvelocity = 0
var yvelocity = 0
var parentXVelocity = 0
var parentYVelocity = 0
var targetAngle

var targetOffsetX = 0
var targetOffsetY = 0

const matchSpeed = 400*400

const inaccuracy = 30
var timer = 0
var timeMax = 0

var avoidObjects = []

var hp = 600

var isfiring = false
var firingTimer = 4
var reload = 4

@export var bullet : PackedScene
@export var effect : PackedScene


func randomize_target():
	randomize()
	timer = 0
	timeMax = randf_range(2, 3)
	targetOffsetX = randf_range(-inaccuracy, inaccuracy)
	targetOffsetY = randf_range(-inaccuracy, inaccuracy)

func _ready():
	randomize_target()
	
	
	
func turn_towards(targetDirection, delta, turnrate):
	var deltaDirection = fposmod(((targetDirection - rotation) + PI), 2*PI) - PI
	if abs(deltaDirection) < delta*turnrate:
		rotation = targetDirection
	else:
		rotation = rotation + (deltaDirection/abs(deltaDirection))*delta*turnrate
	return deltaDirection

func get_total_velocity():
	return (-parentXVelocity + xvelocity) * (-parentXVelocity + xvelocity) + (-parentYVelocity + yvelocity) * (-parentYVelocity + yvelocity)
	
func get_velocity_direction():
	return Vector2(1,0).angle_to(Vector2((-parentXVelocity + xvelocity), (-parentYVelocity + yvelocity)))


func fire_bullet():
	firingTimer = reload
	isfiring = true
	var inst = bullet.instantiate() as CharacterBody2D
	inst.position.x += 700
	#inst.position = position
	add_child(inst)
	

func _physics_process(delta):
	if firingTimer >= 0:
		firingTimer -= delta

	if isfiring and firingTimer <= 0:
		isfiring = false
		firingTimer = reload

	if hp <= 0:
		var inst = effect.instantiate() as CharacterBody2D
		inst.effect = 2
		inst.lifetime = 0.5
		inst.parentScene = parentScene
		inst.position = position
		inst.rotation = rotation
		inst.xvelocity =  xvelocity*0.9
		inst.yvelocity = yvelocity*0.9

		parentScene.add_child(inst)
		queue_free()
	
	if not isfiring:
		animation.play("moving")
		xvelocity += cos(rotation) * SPEED * delta
		yvelocity += sin(rotation) * SPEED * delta
		if len(avoidObjects) > 0:
			var avgLocation = Vector2(0,0)
			targetAngle = 0
			for i in avoidObjects:
				avgLocation += i.position
			avgLocation /= len(avoidObjects)
			
			targetAngle = global_position.direction_to(avgLocation).angle() + PI
			turn_towards(targetAngle,delta,1)
			
		elif get_total_velocity() < matchSpeed:
			targetAngle = global_position.direction_to(Vector2(640 + targetOffsetX, 360 + targetOffsetY)).angle()
			delta = turn_towards(targetAngle,delta,1)
			if firingTimer <= 0 and abs(delta) < 0.2:
				fire_bullet()
			
		else:
			var retrograde = fposmod(get_velocity_direction() + PI, 2*PI)
			turn_towards(retrograde,delta,2)
	else:
		animation.play("idle")
		targetAngle = global_position.direction_to(Vector2(640 + targetOffsetX, 360 + targetOffsetY)).angle()
		turn_towards(targetAngle,delta,0.2)
	
	parentXVelocity = parentScene.xvelocity
	parentYVelocity = parentScene.yvelocity
	
	velocity.x = -parentXVelocity + xvelocity
	velocity.y = -parentYVelocity + yvelocity
	
	timer += delta
	if timer > timeMax:
		randomize_target()
	
	#print(avoidObjects)
	move_and_slide()


func _on_avoid_area_body_entered(body):
	if body != self:
		avoidObjects.append(body)


func _on_avoid_area_body_exited(body):
	avoidObjects.erase(body)

