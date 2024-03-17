extends CharacterBody2D

@export var animation : AnimatedSprite2D
var parentScene : Node2D
@export var SPEED = 250.0
var xvelocity = 0
var yvelocity = 0
var parentXVelocity = 0
var parentYVelocity = 0
var targetAngle
const drag = 0.3

var targetOffsetX = 0
var targetOffsetY = 0

const matchSpeed = 200*200

const inaccuracy = 30
var timer = 0
var timeMax = 0

var avoidObjects = []

var hp = 700

var firingTimer = 1.5
var reload = 1.5

@export var bullet : PackedScene
@export var effect : PackedScene
@export var missile : PackedScene

var missileFromSide = 50

var attacking = true

var spawnedMore = false

func randomize_target():
	randomize()
	timer = 0
	timeMax = randf_range(2, 3)
	targetOffsetX = randf_range(-inaccuracy, inaccuracy)
	targetOffsetY = randf_range(-inaccuracy, inaccuracy)

func _ready():
	randomize_target()
	animation.play("default")
	parentScene.set_boss_bar(hp)
	
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
	firingTimer = reload/5
	var inst = bullet.instantiate() as CharacterBody2D
	inst.parentScene = parentScene
	inst.position = position
	inst.rotation = rotation
	inst.xvelocity = xvelocity + cos(rotation) * 400
	inst.yvelocity = yvelocity + sin(rotation) * 400
	inst.position.x += cos(rotation) * 120
	inst.position.y += sin(rotation) * 120
	parentScene.add_child(inst)

func fire_missile():
	firingTimer = reload
	var inst = missile.instantiate() as CharacterBody2D
	inst.parentScene = parentScene
	inst.position = position
	inst.rotation = rotation
	inst.xvelocity = xvelocity + cos(rotation) * 150
	inst.yvelocity = yvelocity + sin(rotation) * 150
	inst.position.x += sin(rotation) * missileFromSide
	inst.position.y += cos(rotation) * missileFromSide
	missileFromSide *= -1
	parentScene.add_child(inst)
	

func _physics_process(delta):
	if !spawnedMore and hp < 350:
		spawnedMore = true
		for i in range(5):
			parentScene.spawn_satellite(parentScene.spawn_location(1200))

	if firingTimer >= 0:
		firingTimer -= delta

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
	
	if attacking:
		targetAngle = global_position.direction_to(Vector2(640 + targetOffsetX, 360 + targetOffsetY)).angle()
		var deltaDir = turn_towards(targetAngle,delta,2)
		if firingTimer <= 0 and abs(deltaDir) < 0.2:
			if global_position.distance_to(Vector2(640,360)) < 500:
				fire_bullet()
			else:
				fire_missile()
		if global_position.distance_to(Vector2(640,360)) < 300:
			attacking = false
	else:
		if len(avoidObjects) > 0:
			var avgLocation = Vector2(0,0)
			targetAngle = 0
			for i in avoidObjects:
				avgLocation += i.position
			avgLocation /= len(avoidObjects)
			
			targetAngle = global_position.direction_to(avgLocation).angle() + PI
			turn_towards(targetAngle,delta,2)
		else:
			targetAngle = global_position.direction_to(Vector2(640 + targetOffsetX, 360 + targetOffsetY)).angle() + PI
			turn_towards(targetAngle,delta,2)
		if global_position.distance_to(Vector2(640,360)) > 400:
			attacking = true
		
	
	parentXVelocity = parentScene.xvelocity
	parentYVelocity = parentScene.yvelocity
	xvelocity += cos(rotation) * SPEED * delta
	yvelocity += sin(rotation) * SPEED * delta
	velocity.x = -parentXVelocity + xvelocity
	velocity.y = -parentYVelocity + yvelocity
	xvelocity *= 1 - delta*drag
	yvelocity *= 1 - delta*drag
	
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
