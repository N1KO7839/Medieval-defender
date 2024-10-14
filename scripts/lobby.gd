extends Node2D

@onready var SceneTransitionAnimation = $SceneTransitionAnimation/AnimationPlayer
@onready var playerCamera = $Player/Camera2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	SceneTransitionAnimation.play("fadeOut")
	playerCamera.enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_game_detection_body_entered(body):
	if body is Player:
		Global.gameStarted = true
		SceneTransitionAnimation.play("fadeIn")
		await get_tree().create_timer(0.75).timeout
		get_tree().change_scene_to_file("res://scene/waves.tscn")
	
