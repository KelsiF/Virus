extends CharacterBody2D

var speed = 250 # need speed 250 for move
var health = 10
var damage = 1

var direction = "left"

@onready var player = get_parent().get_node("Player")
@onready var ray_cast: RayCast2D = $Sprite2D/raycast

func _ready() -> void:
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta):
	enemy_falling(delta)
	look_player(delta)
	move_and_slide()

func look_player(delta):
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		
		if collider == player:
			if ray_cast.target_position < Vector2(0, 0):
				direction = "left"
			elif ray_cast.target_position > Vector2(0, 0):
				direction = "right"
			enemy_move(delta, direction)
	else:
		velocity.x = 0
	await get_tree().create_timer(2.0).timeout
	while !ray_cast.is_colliding():
		if ray_cast.target_position < Vector2(0, 0):
			await get_tree().create_timer(2.0).timeout
			if ray_cast.is_colliding():
				pass
			else:
				$Sprite2D.flip_h = true
				$Sprite2D/raycast.target_position = Vector2(320, 0)
		elif ray_cast.target_position > Vector2(0, 0):
			await get_tree().create_timer(2.0).timeout
			if ray_cast.is_colliding():
				pass
			else:
				$Sprite2D.flip_h = false
				$Sprite2D/raycast.target_position = Vector2(-320, 0)

func enemy_falling(delta):
	if !is_on_floor():
		velocity.y += 1000 * delta

func enemy_move(delta, direction: String):
	if direction == "right":
		velocity.x = speed
	elif direction == "left":
		velocity.x = -speed
