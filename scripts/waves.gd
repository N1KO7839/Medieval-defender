extends Node2D

@onready var SceneTransitionAnimation = $SceneTransitionAnimation/AnimationPlayer
@onready var playerCamera = $Player/Camera2D
# Called when the node enters the scene tree for the first time.
func _ready():
	SceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	SceneTransitionAnimation.play("fadeOut")
	playerCamera.enabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:):
	if !Global.playerAlive:
		Global.gameStarted = false
		SceneTransitionAnimation.play("fadeIn")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scene/lobby.tscn")
