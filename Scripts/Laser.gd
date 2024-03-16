extends CharacterBody2D


var parentScene : Node2D


@export var effect : PackedScene

var lifetime = 4
var lifetimer = 0

var damage = 80

var orb1 = preload("res://Assets/Hubble/laser2.png")
var orb2 = preload("res://Assets/Hubble/laser4.png")
var beam1 = preload("res://Assets/Hubble/laser1.png")
var beam2 = preload("res://Assets/Hubble/laser3.png")

var beam : CharacterBody2D
var orbsprite : Sprite2D
var beamsprite : Sprite2D

var hitting = false
var target : Node2D
var beamscale = 0

func _ready():
	beam = get_node("beam")
	orbsprite = get_node("orbsprite")
	beamsprite = get_node("beam/beamsprite")
	orbsprite.texture = orb1
	beamsprite.texture = beam1

func _process(delta):
	lifetimer += delta
	if lifetimer < 1.4:
		orbsprite.scale = Vector2(lifetimer/2,lifetimer/2)
		beam.scale = Vector2(100,lifetimer/2)
	else:
		orbsprite.texture = orb2
		beamsprite.texture = beam2
		beamscale = 0.7 + sin(lifetimer*20) * 0.1
		orbsprite.scale = Vector2(beamscale,beamscale)
		beam.scale = Vector2(100,beamscale)
		if hitting:
			target.hp -= delta * damage
	
	if lifetimer > lifetime:
		queue_free()

func _on_area_2d_body_entered(body):
	target = body
	hitting = true


func _on_beamarea_body_exited(body):
	hitting = false
