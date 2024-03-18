extends Node

var day

var tutorial : AudioStreamPlayer
var battle1 : AudioStreamPlayer
var battle1a : AudioStreamPlayer
var battle2 : AudioStreamPlayer
var battle2a : AudioStreamPlayer

var musicStarted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	tutorial = get_node("tutorial")
	battle1 = get_node("battle1")
	battle1a = get_node("battle1a")
	battle2 = get_node("battle2")
	battle2a = get_node("battle2a")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !musicStarted and day != null:
		match day:
			0:
				tutorial.play()
			1, 3, 4, 6:
				battle2.play()
			_:
				battle1.play()
		musicStarted = true

func _on_tutorial_finished():
	tutorial.play()


func _on_battle_1_finished():
	battle1a.play()


func _on_battle_1a_finished():
	battle1a.play()


func _on_battle_2_finished():
	battle2a.play()


func _on_battle_2a_finished():
	battle2a.play()
