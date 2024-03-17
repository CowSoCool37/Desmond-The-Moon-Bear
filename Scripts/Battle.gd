extends Node2D
@export var xvelocity = 0
@export var yvelocity = 0

@export var star : PackedScene
@export var background : Sprite2D
@export var enemies : Array[PackedScene]
var gameManager : Node2D
var endTimer = 0
var desmond : CharacterBody2D

var objectiveReached = false

var boss : CharacterBody2D

var enemiesKilled = 0
var gameTimer = 0

var day

var textLabel : Label
var bossHealthBar : ProgressBar

var rumble : AudioStreamPlayer

func increment_enemies_killed():
	enemiesKilled += 1
	match day:
		3,6:
			spawn_satellite(spawn_location(1200))

func spawn_location(distance):
	var angle = randf_range(0,2*PI)
	return Vector2(sin(angle) * distance + 640, cos(angle) * distance + 360)

func check_win():
	match day:
		0:
			if enemiesKilled > 0:
				objectiveReached = true
		1:
			if enemiesKilled > 4:
				objectiveReached = true
		3:
			if gameTimer > 110:
				objectiveReached = true
		4:
			if enemiesKilled > 19:
				objectiveReached = true
		6:
			if gameTimer > 140:
				objectiveReached = true
		_:
			if boss == null:
				objectiveReached = true

func set_initial_label():
	match day:
		0:
			textLabel.text = "Welcome to the space program, Desmond.\nUse SPACE to move and MOUSE to aim and shoot."
		1:
			textLabel.text = "More capitalist satellies. Destroy them."
		2:
			textLabel.text = "Capitalist superweapon disguised as a telescope. Eliminate it."
		3:
			textLabel.text = "Capitalists are mad at us for destroying their superweapon.\nPrepare to defend yourself."
		4:
			textLabel.text = "More satellies incoming. Destroy them all."
		5:
			textLabel.text = "Space fighter incoming. Try to dodge the missiles."
		6:
			textLabel.text = "You are getting close to the moon, Desmond.\nEvade these next few satellites."
		7:
			textLabel.text = "This is the final showdown, Desmond.\nBecome the first moon bear."

func set_dynamic_label():
	match day:
		0:
			textLabel.text = "Use SPACE to move and MOUSE to aim and shoot.\nDestroy the capitalist satellite to advance."
		1:
			textLabel.text = "Destroy " + str(5-enemiesKilled) + " more satellites" 
		2:
			textLabel.text = "BOSS BATTLE: Hubble Space Laser"
		3:
			textLabel.text = "Survive: " + str(max(110 - roundi(gameTimer), 0))
		4:
			textLabel.text = "Destroy " + str(20-enemiesKilled) + " more satellites" 
		5:
			textLabel.text = "BOSS BATTLE: Space Shuttle"
		6:
			textLabel.text = "Survive: " + str(max(140 - roundi(gameTimer), 0))
		7:
			if boss != null:
				if boss.stage == 1:
					textLabel.text = "BOSS BATTLE: Apollo 11"
				elif boss.stage == 2:
					textLabel.text = "Apollo 11: Stage 2"
				else:
					textLabel.text = "Apollo 11: Stage 3"

func set_boss_bar(hp):
	bossHealthBar.max_value = hp

func spawn_satellite(location):
	var inst = enemies[0].instantiate() as CharacterBody2D
	inst.parentScene = self
	inst.rotation = randf_range(0,2*PI)
	inst.position = location
	background.add_child(inst)

func spawn_initial_enemies():
	match day:
		0:
			spawn_satellite(Vector2(1000,0))
		1:
			for i in range(5):
				spawn_satellite(spawn_location(800))
		2:
			for i in range(3):
				spawn_satellite(spawn_location(800))
			boss = enemies[1].instantiate() as CharacterBody2D
			boss.parentScene = self
			boss.position = Vector2(0, 600)
			background.add_child(boss)
		3:
			for i in range(5):
				spawn_satellite(spawn_location(800))
		4:
			for i in range(20):
				spawn_satellite(spawn_location(randf_range(800,2000)))
		5:
			for i in range(4):
				spawn_satellite(spawn_location(800))
			boss = enemies[2].instantiate() as CharacterBody2D
			boss.parentScene = self
			boss.position = Vector2(200, 1000)
			background.add_child(boss)
		6:
			for i in range(8):
				spawn_satellite(spawn_location(800))
		7:
			for i in range(4):
				spawn_satellite(spawn_location(800))
			boss = enemies[3].instantiate() as CharacterBody2D
			boss.parentScene = self
			boss.position = Vector2(-400, 600)
			background.add_child(boss)

# Called when the node enters the scene tree for the first time.
func _ready():
	textLabel = get_node("Label")
	desmond = get_node("Desmond Ship")
	bossHealthBar = get_node("Boss Health Bar")
	rumble = get_node("rumble")
	bossHealthBar.visible = false
	randomize()
	for i in range(200):
		var inst = star.instantiate() as CharacterBody2D
		inst.parentScene = self
		background.add_child(inst)
	
	spawn_initial_enemies()
	set_initial_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gameTimer += delta
	check_win()
	
	if gameTimer > 4:
		set_dynamic_label()
		if boss != null:
			bossHealthBar.value = boss.hp
			bossHealthBar.visible = true
		else:
			bossHealthBar.value = 0
	
	if desmond.dead or objectiveReached:
		endTimer += delta
	if endTimer > 2:
		if desmond.dead:
			gameManager.restart_day()
		else:
			gameManager.next_day()


func _on_rumble_finished():
	rumble.play()
