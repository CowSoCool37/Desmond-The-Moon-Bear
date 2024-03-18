
extends CharacterBody2D

@export var animation : AnimatedSprite2D
var parentScene : Node2D
@export var SPEED = 100.0
var xvelocity = 0
var yvelocity = 0
var parentXVelocity = 0
var parentYVelocity = 0
var targetAngle
var drag = 0.0

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
var laserReload = 4
var missileReload = 1.5
var bulletReload = 0.4

@export var bullet : PackedScene
@export var laser : PackedScene
@export var missile : PackedScene
@export var effect : PackedScene

var collisionShape : CollisionShape2D
const hitbox1 = Vector2(1,1)
const hitbox2 = Vector2(0.6,1)
const hitbox3 = Vector2(0.4,0.7)

var stage = 1

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
	collisionShape = get_node("CollisionShape2D")
	collisionShape.scale = hitbox1
	randomize()
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


func fire_laser():
	firingTimer = laserReload
	isfiring = true
	var inst = laser.instantiate() as CharacterBody2D
	inst.position.x += 850
	inst.damage = 40
	#inst.position = position
	add_child(inst)
	
func fire_missile():
	firingTimer = missileReload
	var inst = missile.instantiate() as CharacterBody2D
	inst.parentScene = parentScene
	inst.position = position
	inst.rotation = rotation
	inst.xvelocity = xvelocity + cos(rotation) * 150
	inst.yvelocity = yvelocity + sin(rotation) * 150
	inst.position.x += sin(rotation) * missileFromSide
	inst.position.y += cos(rotation) * missileFromSide
	missileFromSide *= -1
	inst.damage = 20
	parentScene.add_child(inst)

func fire_bullet_helper(angle):
	var inst = bullet.instantiate() as CharacterBody2D
	inst.parentScene = parentScene
	inst.position = position
	inst.rotation = angle
	inst.xvelocity = xvelocity + cos(angle) * 300
	inst.yvelocity = yvelocity + sin(angle) * 300
	inst.position.x += cos(angle) * 40
	inst.position.y += sin(angle) * 40
	inst.damage = 10
	parentScene.add_child(inst)

func fire_bullet():
	firingTimer = bulletReload
	fire_bullet_helper(rotation + randf_range(-0.5,0.5))

func _physics_process(delta):
	if !spawnedMore and hp < 250:
		spawnedMore = true
		for i in range(5):
			parentScene.spawn_satellite(parentScene.spawn_location(1200))
	
	if firingTimer >= 0:
		firingTimer -= delta

	if isfiring and firingTimer <= 0:
		isfiring = false
		firingTimer = laserReload

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
		
		if stage == 3:
			queue_free()
		else:
			hp = 400
			parentScene.set_boss_bar(hp)
			drag += 0.15
			stage += 1
			if stage == 2:
				SPEED += 80
				collisionShape.scale = hitbox2
				spawnedMore = false
				for i in range(5):
					parentScene.spawn_satellite(parentScene.spawn_location(1200))
			else:
				collisionShape.scale = hitbox3
	
	if stage == 1:
		if not isfiring:
			animation.play("moving1")
			xvelocity += cos(rotation) * SPEED * delta
			yvelocity += sin(rotation) * SPEED * delta
			if len(avoidObjects) > 0:
				var avgLocation = Vector2(0,0)
				targetAngle = 0
				for i in avoidObjects:
					avgLocation += i.position
				avgLocation /= len(avoidObjects)
				
				targetAngle = global_position.direction_to(avgLocation).angle() + PI
				turn_towards(targetAngle,delta,1.5)
				
			elif get_total_velocity() < matchSpeed:
				targetAngle = global_position.direction_to(Vector2(640 + targetOffsetX, 360 + targetOffsetY)).angle()
				var deltaDir = turn_towards(targetAngle,delta,1.5)
				if firingTimer <= 0 and abs(deltaDir) < 0.1:
					fire_laser()
				
			else:
				var retrograde = fposmod(get_velocity_direction() + PI, 2*PI)
				turn_towards(retrograde,delta,2)
		else:
			animation.play("idle1")
			targetAngle = global_position.direction_to(Vector2(640 + targetOffsetX, 360 + targetOffsetY)).angle()
			turn_towards(targetAngle,delta,0.3)

	elif stage == 2:
		if attacking:
			if global_position.distance_to(Vector2(640,360)) < 500:
				animation.play("idle2")
			else:
				xvelocity += cos(rotation) * SPEED * delta
				yvelocity += sin(rotation) * SPEED * delta
				animation.play("moving2")
			targetAngle = global_position.direction_to(Vector2(640 + targetOffsetX, 360 + targetOffsetY)).angle()
			var deltaDir = turn_towards(targetAngle,delta,2)
			if firingTimer <= 0 and abs(deltaDir) < 0.2:
					fire_missile()
			if global_position.distance_to(Vector2(640,360)) < 300:
				attacking = false
		else:
			xvelocity += cos(rotation) * SPEED * delta
			yvelocity += sin(rotation) * SPEED * delta
			animation.play("moving2")
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
	else:
		xvelocity += cos(rotation) * SPEED * delta
		yvelocity += sin(rotation) * SPEED * delta
		animation.play("moving3")
		if len(avoidObjects) > 0:
			var avgLocation = Vector2(0,0)
			targetAngle = 0
			for i in avoidObjects:
				avgLocation += i.position
			avgLocation /= len(avoidObjects)
			
			targetAngle = global_position.direction_to(avgLocation).angle() + PI
			turn_towards(targetAngle,delta,2.5)
			
		elif get_total_velocity() < matchSpeed:
			targetAngle = global_position.direction_to(Vector2(640 + targetOffsetX, 360 + targetOffsetY)).angle()
			turn_towards(targetAngle,delta,2.5)
			if firingTimer <= 0:
				fire_bullet()
			
		else:
			var retrograde = fposmod(get_velocity_direction() + PI, 2*PI)
			turn_towards(retrograde,delta,2.5)
	
	
	parentXVelocity = parentScene.xvelocity
	parentYVelocity = parentScene.yvelocity
	
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

