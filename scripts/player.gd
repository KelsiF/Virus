extends CharacterBody2D

var health = 20
var speed = 300
var speedMultiplier = 1.0
var damage = 2

var attack_player = preload("res://scenes/playerAttack.tscn")


func _ready():
	pass

func _physics_process(delta):
	player_falling(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()

func _process(delta: float) -> void:
	attack()

func player_falling(delta):
	if !is_on_floor():
		velocity.y += 1000 * delta
		

@warning_ignore("unused_parameter")
func player_run(delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed*speedMultiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed*speedMultiplier)
	if Input.is_action_just_pressed("left"):
		$Sprite2D.flip_h = false
	elif Input.is_action_just_pressed("right"):
		$Sprite2D.flip_h = true

@warning_ignore("unused_parameter")
func player_jump(delta):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -400


func _on_character_body_2d_on_attack(damage) -> void:
	if health > 0:
		health = health - damage
		print(health)
	elif health <= 0:
		get_tree().reload_current_scene()

func attack():
	if Input.is_action_just_pressed("attack"):
		var instance = attack_player.instantiate()
		if $Sprite2D.flip_h == true:
			instance.position = Vector2(position.x + 30, position.y)
			instance.get_child(0).flip_h = true
		elif $Sprite2D.flip_h == false:
			instance.position = Vector2(position.x - 30, position.y)
			instance.get_child(0).flip_h = false
		get_parent().add_child(instance)
