extends CharacterBody2D
@export var parentScene : Node2D
@export var animations : AnimatedSprite2D
@export var bullet : PackedScene

var thrust = 0
const SPEED = 200
const playerDrag = 0.2

var hp = 100

const firingCoolDown = 0.3
var firingTimer = 0

@export var healthbar : ProgressBar
@export var effect : PackedScene
var dead = false

var rocket : AudioStreamPlayer

func _ready():
	rocket = get_node("rocket")

func fire_bullet():
	firingTimer = 0
	var inst = bullet.instantiate() as CharacterBody2D
	inst.parentScene = parentScene
	inst.position = position
	inst.rotation = rotation
	inst.xvelocity = parentScene.xvelocity + cos(rotation) * 400
	inst.yvelocity = parentScene.yvelocity + sin(rotation) * 400
	inst.position.x += cos(rotation) * 30
	inst.position.y += sin(rotation) * 30
	parentScene.add_child(inst)

func get_input():
	if Input.is_action_pressed("thrust"):
		thrust = 1
		animations.play("moving")
		rocket.stream_paused = false
	else:
		thrust = 0
		animations.play("idle")
		rocket.stream_paused = true
		
	if Input.is_action_pressed("fire"):
		if firingTimer > firingCoolDown:
			fire_bullet()

func _physics_process(delta):
	healthbar.value = hp
	if hp <= 0 and not dead:
		var inst = effect.instantiate() as CharacterBody2D
		inst.effect = 2
		inst.lifetime = 0.5
		inst.parentScene = parentScene
		inst.position = position
		inst.rotation = rotation
		inst.xvelocity =  parentScene.xvelocity*0.9
		inst.yvelocity = parentScene.yvelocity*0.9

		parentScene.add_child(inst)
		print("rip bozo")
		self.scale = Vector2.ZERO
		dead = true
	
	if not dead:
		get_input()
		look_at(get_global_mouse_position())
		parentScene.xvelocity += cos(rotation) * thrust * SPEED * delta
		parentScene.yvelocity += sin(rotation) * thrust * SPEED * delta
		
		parentScene.xvelocity *= 1 - delta*playerDrag
		parentScene.yvelocity *= 1 - delta*playerDrag
	
	firingTimer += delta
	move_and_slide()


func _on_rocket_finished():
	rocket.play()
