extends CharacterBody2D

class_name Player

@onready var AnimatedSprite = $AnimatedSprite2D
@onready var dealDamageZone = $DealDamageZone
const speed = 200
const jump_power  = -385.0

var attackType: String
var currentAttack: bool

var gravity = 900

var health = 100
var maxHealth = 100
var minHealth = 0
var canTakeDamage: bool
var dead: bool


func _ready():
	Global.playerBody = self
	currentAttack = false
	dead = false
	canTakeDamage = true
	Global.playerAlive = true


func _physics_process(delta):
	Global.playerDamageZone = dealDamageZone
	Global.playerHitbox = $PlayerHitbox
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !dead:
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
		handleMovementAnimation(direction)
		chceckHitbox()
	move_and_slide()
	
func chceckHitbox():
	var hitboxAreas = $PlayerHitbox.get_overlapping_areas()
	var damage: int
	if hitboxAreas:
		var hitbox = hitboxAreas.front()
		if hitbox.get_parent() is BatEnemy:
			damage = Global.batDamageAmout
		elif hitbox.get_parent() is Skeleton:
			damage = Global.skeletonDamageAmount
	if canTakeDamage:
		takeDamage(damage)
	
func takeDamage(damage):
	if damage != 0:
		if health > minHealth:
			health -= damage
			print("health: ", health)
			if health <= minHealth:
				health = minHealth
				dead = true
				velocity.x = 0
				handleDeathAnimation()
			takeDamageCooldown(1.0)
			
func handleDeathAnimation():
	AnimatedSprite.play("death")
	await get_tree().create_timer(0.5).timeout
	$Camera2D.zoom.x = 4
	$Camera2D.zoom.y = 4
	await get_tree().create_timer(2.5).timeout
	Global.playerAlive = false
	await get_tree().create_timer(0.5).timeout
	self.queue_free()
	
func takeDamageCooldown(wait_time):
	canTakeDamage = false
	await get_tree().create_timer(wait_time).timeout
	canTakeDamage = true 
	
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
		currentDamageToDeal = 10
	elif attackType == "doubleAttack":
		currentDamageToDeal = 20
	elif attackType == "airAttack":
		currentDamageToDeal = 7
	Global.playerDamageAmount = currentDamageToDeal
