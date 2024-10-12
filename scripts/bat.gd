extends CharacterBody2D

const speed = 65
var dir: Vector2

var isBatChase: bool

var player: CharacterBody2D

func _ready():
	isBatChase = true

func _process(delta):
	move(delta)
	handleAnimation()

func move(delta):
	if isBatChase:
		player = Global.playerBody
		velocity = position.direction_to(player.position) * speed
		dir.x = abs(velocity.x)/velocity.x
	elif !isBatChase:
		velocity += dir * speed * delta
	move_and_slide()



func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 0.8])
	if !isBatChase:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
	
func handleAnimation():
	var animatedSprite = $AnimatedSprite2D
	animatedSprite.play("fly")
	if dir.x == -1:
		animatedSprite.flip_h = true
	elif dir.x == 1:
		animatedSprite.flip_h = false
	
func choose(array):
	array.shuffle()
	return array.front()
	
		
