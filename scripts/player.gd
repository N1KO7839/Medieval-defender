extends CharacterBody2D

@onready var AnimatedSprite = $AnimatedSprite2D

const speed = 200
const jump_power  = -385.0

var gravity = 900


func _ready():
	Global.playerBody = self


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power


	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	handleMovementAnimation(direction)
	
func handleMovementAnimation(dir):
	if !velocity:
		AnimatedSprite.play("idle")
	if velocity:
		AnimatedSprite.play("run")
		toggleFlipSprite(dir)

func toggleFlipSprite(dir):
	if dir>0:
		AnimatedSprite.flip_h = false
	if dir<0:
		AnimatedSprite.flip_h = true
		
		
