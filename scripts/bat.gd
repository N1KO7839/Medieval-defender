extends CharacterBody2D

class_name BatEnemy

const speed = 65
var dir: Vector2

var isBatChase: bool

var player: CharacterBody2D

var health = 50
var MaxHealth = 50
var MinHealth = 50
var dead = false
var takingDamage = false
var isRoaming: bool
var damageToDeal = 20



func _process(delta):
	
	Global.batDamageAmout = damageToDeal
	Global.batDamageZone = $BatDamageArea
	if Global.playerAlive:
		isBatChase = true
	elif !Global.playerAlive:
		isBatChase = false
		
	
	if is_on_floor() and dead:
		await get_tree().create_timer(2.5).timeout
		self.queue_free()
	
	move(delta)
	handleAnimation()

func move_collision_shape_down():
	var collisionShape = $CollisionShape2D
	var hitbox = $Hitbox/CollisionShape2D
	collisionShape.position.y += 0.08
	hitbox.position.y += 0.08

func move(delta):
	player = Global.playerBody
	if !dead:
		isRoaming = true
		if !takingDamage and isBatChase and Global.playerAlive:
			velocity = position.direction_to(player.position) * speed
			dir.x = abs(velocity.x)/velocity.x
		elif takingDamage:
			var knocbackDir = position.direction_to(player.position) * -50
			velocity = knocbackDir
		else:
			velocity += dir * speed * delta
	elif dead:
		move_collision_shape_down()
		velocity.y += 100 * delta
		velocity.x = 0
		
	move_and_slide()



func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 0.8])
	if !isBatChase:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		
func handleAnimation():
	var animatedSprite = $AnimatedSprite2D
	if !dead and !takingDamage:
		animatedSprite.play("fly")
		if dir.x == -1:
			animatedSprite.flip_h = true
		elif dir.x == 1:
			animatedSprite.flip_h = false
	elif !dead and takingDamage:
		animatedSprite.play("hurt")
		await get_tree().create_timer(0.33).timeout
		takingDamage = false
	elif dead and isRoaming:
		isRoaming = false
		animatedSprite.play("death")
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)
	
	
func choose(array):
	array.shuffle()
	return array.front()
	
		


func _on_hitbox_area_entered(area):
	if area == Global.playerDamageZone:
		var damage = Global.playerDamageAmount
		takeDamage(damage)

func takeDamage(damage):
	health -= damage
	takingDamage = true
	if health <= 0:
		health = 0
		dead = true
	print(str(self), "health: ", health)
	
func _ready():
	isBatChase = true
	
