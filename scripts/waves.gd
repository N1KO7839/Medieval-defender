extends Node2D

@onready var SceneTransitionAnimation = $SceneTransitionAnimation/AnimationPlayer
@onready var playerCamera = $Player/Camera2D

var currentWave: int
@export var batScene: PackedScene
@export var skeletonScene: PackedScene

var startingNodes: int
var CurrentNodes: int
var waveSpawnEnded
# Called when the node enters the scene tree for the first time.
func _ready():
	SceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	SceneTransitionAnimation.play("fadeOut")
	playerCamera.enabled = true
	currentWave = 0
	Global.currentWave = currentWave
	startingNodes = get_child_count()
	CurrentNodes = get_child_count()
	positionToNextWave()
func positionToNextWave():
	if CurrentNodes == startingNodes:
		if currentWave != 0:
			Global.movingToNextWave = true
			waveSpawnEnded = false
		SceneTransitionAnimation.play("betweenWaves")
		currentWave += 1
		Global.currentWave = currentWave
		await get_tree().create_timer(0.5).timeout
		prepareSpawn("bats", 4.0, 4.0)
		prepareSpawn("skeletons", 1.5, 2.0)
		print(currentWave)
func prepareSpawn(type, multiplier, mobSpawns):
	var mobAmount = float(currentWave) * multiplier
	var mobWaitTime: float = 2.0
	print("mobsAmount:", mobAmount)
	var mobSpawnRounds = mobAmount/mobSpawns
	spawnType(type, mobSpawnRounds, mobWaitTime)
	
func spawnType(type, mobSpawnRounds, mobWaitTime):
	if type == "bats":
		var batSpawn1 = $BatSpawn1
		var batSpawn2 = $BatSpawn2
		var batSpawn3 = $BatSpawn3
		var batSpawn4 = $BatSpawn4
		if mobSpawnRounds >= 1:
			for i in mobSpawnRounds:
				var bat1 = batScene.instantiate()
				bat1.global_position = batSpawn1.global_position
				var bat2 = batScene.instantiate()
				bat2.global_position = batSpawn2.global_position
				var bat3 = batScene.instantiate()
				bat3.global_position = batSpawn3.global_position
				var bat4 = batScene.instantiate()
				bat4.global_position = batSpawn4.global_position
				add_child(bat1)
				add_child(bat2)
				add_child(bat3)
				add_child(bat4)
				mobSpawnRounds -= 1
				await get_tree().create_timer(mobWaitTime).timeout
	elif type == "skeletons":
		var skeletonSpawn1 = $SkeletonSpawn1
		var skeletonSpawn2= $SkeletonSpawn2
		if mobSpawnRounds >= 1:
			for i in mobSpawnRounds:
				var skeleton1 = skeletonScene.instantiate()
				skeleton1.global_position = skeletonSpawn1.global_position
				var skeleton2 = skeletonScene.instantiate()
				skeleton2.global_position = skeletonSpawn2.global_position
				add_child(skeleton1)
				add_child(skeleton2)
				mobSpawnRounds -= 1
				await get_tree().create_timer(mobWaitTime).timeout
	waveSpawnEnded = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:):
	if !Global.playerAlive:
		Global.gameStarted = false
		SceneTransitionAnimation.play("fadeIn")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scene/lobby.tscn")
	
	CurrentNodes = get_child_count()
	
	if waveSpawnEnded:
		positionToNextWave()
		
