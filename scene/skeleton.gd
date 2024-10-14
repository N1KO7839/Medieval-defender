extends CharacterBody2D

class_name Skeleton
	
const speed = 50
var isFrogChase: bool

var health = 80
var maxHealth = 80
var minHealth = 0
	
var dead: bool = false
var takingDamage: bool = false
var attack = 20
var isDealingDamage: bool = false

var dir: Vector2
const  gravity = 900
var knockbackForce = -20
var isRoaming: bool = true

var player: CharacterBody2D
var playerInArea = false

func _process(delta):
	player = Global.playerBody
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
		
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
			velocity.x = knockbackDir
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
		isRoaming = false
		animatedSprite.play("Death")
		await get_tree().create_timer(2.0).timeout
		handleDeath()
func handleDeath():
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
