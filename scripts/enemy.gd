extends CharacterBody2D

var speed = 250 # need speed 250 for move
var health = 5
var damage = 1
var direction = "left"


@onready var player = get_parent().get_node("Player")
@onready var ray_cast: RayCast2D = $Sprite2D/raycast

signal onAttack

func _ready() -> void:
	#Main.enemy_attack_signal.connect(_on_attack)
	pass

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


func _on_attack_radius_body_entered(body: Node2D) -> void:
	if body == player:
		onAttack.emit(damage)
		await get_tree().create_timer(0.25).timeout


func _on_detect_player_attack_body_entered(body: Node2D) -> void:
	if body.name == "PlayerAttack":
		if health > 0:
			health -= 2
		elif health <= 0:
			await call_deferred("queue_free")
