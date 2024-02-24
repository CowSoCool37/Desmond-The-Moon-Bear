extends CharacterBody2D
@export var parentScene : Node2D
@export var animations : AnimatedSprite2D

var thrust = 0
const SPEED = 200

func get_input():
	if Input.is_action_pressed("thrust"):
		thrust = 1
		animations.play("moving")
	else:
		thrust = 0
		animations.play("idle")

func _physics_process(delta):
	get_input()
	look_at(get_global_mouse_position())
	parentScene.xvelocity += cos(rotation) * thrust * SPEED * delta
	parentScene.yvelocity += sin(rotation) * thrust * SPEED * delta

	move_and_slide()
