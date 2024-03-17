extends Node2D
var audio : AudioStreamPlayer
var gameManager : Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	audio = get_node("AudioStreamPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	gameManager.next_day()


func _on_audio_stream_player_finished():
	audio.play()
