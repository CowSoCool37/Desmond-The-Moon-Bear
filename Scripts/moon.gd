extends CharacterBody2D
var xpos = 0
var ypos = 360
@export var speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	xpos -= speed * delta
	if xpos < -1280:
		xpos += 1280
	self.position.x = xpos
	move_and_slide()
