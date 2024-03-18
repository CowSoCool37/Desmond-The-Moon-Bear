extends Node2D

var day = 0
var gameManager : Node2D
var label : Label
var time = 130
var timer = 0.0
var flagvelocity = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_node("Label")
	var minutes = time / 60
	var seconds = time % 60
	if seconds < 10:
		label.text = "Mission Accomplished!\nYou made it to the moon in: " + str(minutes) + ":0" + str(seconds)
	else:
		label.text = "Mission Accomplished!\nYou made it to the moon in: " + str(minutes) + ":" + str(seconds)


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_ok_pressed():
	gameManager.end_game()
