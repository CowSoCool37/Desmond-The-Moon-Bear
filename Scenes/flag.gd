extends CharacterBody2D
var timer = 0.0
var flagvelocity = 0.0
var pipeFalling : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pipeFalling = get_node("pipefalling")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	timer += delta
	if timer > 2 and timer < 8:
		flagvelocity += delta*0.01
	if timer <= 3.7 and timer+delta >= 3.7:
		flagvelocity *= -0.4
		pipeFalling.play()
	
	rotation += flagvelocity
	rotation = min(PI/2, rotation)
	move_and_slide()
