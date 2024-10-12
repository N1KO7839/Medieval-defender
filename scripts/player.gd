extends CharacterBody2D

@onready var AnimatedSprite = $AnimatedSprite2D
@onready var dealDamageZone = $DealDamageZone
const speed = 200
const jump_power  = -385.0

var attackType: String
var currentAttack: bool

var gravity = 900


func _ready():
	Global.playerBody = self
	currentAttack = false


func _physics_process(delta: float) -> void:
	
	Global.playerDamageZone = dealDamageZone
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
	
	if !currentAttack:
		if Input.is_action_just_pressed("leftMouse") or Input.is_action_just_pressed("rightMouse"):
			currentAttack = true
			if Input.is_action_just_pressed("leftMouse") and is_on_floor():
				attackType = "singleAttack"
			elif Input.is_action_just_pressed("rightMouse") and is_on_floor():
				attackType = "doubleAttack"
			else:
				attackType = "airAttack"
			setDamage(attackType)
			handleAttackAnimation(attackType) 
	
	move_and_slide()
	handleMovementAnimation(direction)
	
func handleMovementAnimation(dir):
	if !currentAttack:
		if !velocity:
			AnimatedSprite.play("idle")
		if velocity:
			AnimatedSprite.play("run")
		toggleFlipSprite(dir)

func toggleFlipSprite(dir):
	if dir>0:
		AnimatedSprite.flip_h = false
		dealDamageZone.scale.x = 1
	if dir<0:
		AnimatedSprite.flip_h = true
		dealDamageZone.scale.x = -1
		
func handleAttackAnimation(attackType):
	if currentAttack:
		var animation = str(attackType)
		AnimatedSprite.play(animation)
		toggleDamageCollisions(attackType)

func toggleDamageCollisions(attackType):
	var damageZoneCollision = dealDamageZone.get_node("CollisionShape2D")
	var waitTime: float
	if attackType == "airAttack":
		waitTime = 0.33
	elif attackType == "singleAttack":
		waitTime = 0.5
	elif attackType == "doubleAttack":
		waitTime = 1
	damageZoneCollision.disabled = false
	await get_tree().create_timer(waitTime).timeout
	damageZoneCollision.disabled = true



func _on_animated_sprite_2d_animation_finished() -> void:
	currentAttack = false

func setDamage(attackType):
	var currentDamageToDeal: int
	if attackType == "singleAttack":
		currentDamageToDeal = 8
	elif attackType == "doubleAttack":
		currentDamageToDeal = 16
	elif attackType == "airAttack":
		currentDamageToDeal = 5
	Global.playerDamageAmount = currentDamageToDeal
