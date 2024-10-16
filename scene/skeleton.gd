extends CharacterBody2D

class_name Skeleton
	
const speed = 50
var isFrogChase: bool

var health = 80
var maxHealth = 80
var minHealth = 0
	
var dead: bool = false
var takingDamage: bool = false
var damageToDeal = 20
var isDealingDamage: bool = false

var dir: Vector2
const  gravity = 900
var knockbackForce = -20
var isRoaming: bool = true

var player: CharacterBody2D
var playerInArea = false

var addScore = 50

func _process(delta):
	player = Global.playerBody
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
		
		if Global.playerAlive:
			isFrogChase = true
		elif !Global.playerAlive:
			isFrogChase = false
		
		Global.skeletonDamageAmount = damageToDeal
		Global.skeletonDamageZone = $DealDamageArea
		
	move(delta)
	handleAnimation()
	move_and_slide()
	
func move(delta):
	if !dead:
		if !isFrogChase:
			velocity += dir * speed * delta
		elif isFrogChase and !takingDamage:
			var dirToPlayer = position.direction_to(player.position) * speed
			velocity.x = dirToPlayer.x
			dir.x = abs(velocity.x)/velocity.x
		elif takingDamage:
			var knockbackDir = position.direction_to(player.position) * knockbackForce
			velocity.x = knockbackDir.x
		isRoaming = true
		
	elif dead:
		velocity.x = 0

func handleAnimation():
	var animatedSprite = $AnimatedSprite2D
	if !dead and !takingDamage and !isDealingDamage:
		animatedSprite.play("Walk")
		if dir.x == -1:
			animatedSprite.flip_h = true
		elif dir.x == 1:
			animatedSprite.flip_h = false
	elif !dead and takingDamage and !isDealingDamage:
		animatedSprite.play("Hurt")
		await get_tree().create_timer(0.33).timeout
		takingDamage = false
	elif dead and isRoaming:
		damageToDeal = 0
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		damageToDeal = 0
		isRoaming = false
		animatedSprite.play("Death")
		await get_tree().create_timer(2.0).timeout
		handleDeath()
	elif !dead and !takingDamage and isDealingDamage:
		animatedSprite.play("Attack")
func handleDeath():
	damageToDeal = 0
	Global.currentScore += addScore
	print("score", Global.currentScore)
	self.queue_free()	
	

func _on_timer_timeout():
	$DirTimer.wait_time = choose([1.5, 2.0, 2.5])
	if !isFrogChase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
	
func  choose(array):
	array.shuffle()
	return array.front()

func _ready():
	isFrogChase = true


func _on_hitbox_area_entered(area):
	var damage = Global.playerDamageAmount
	if area == Global.playerDamageZone:
		takeDamage(damage)
		
func takeDamage(damage):
	takingDamage = true
	health -= damage
	if health <= minHealth:
		minHealth = minHealth
		dead = true
	print(str(self), "health: ", health)


func _on_deal_damage_area_area_entered(area):
	if area == Global.playerHitbox:
		isDealingDamage = true
		await get_tree().create_timer(1.0).timeout
		isDealingDamage = false
