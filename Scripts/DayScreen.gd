extends Node2D

var day = 0
var animation : AnimatedSprite2D
var gameManager : Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animation = get_node("AnimatedSprite2D")
	animation.play(str(day))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
