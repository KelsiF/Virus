extends CharacterBody2D

var health = 20
var speed = 300
var speedMultiplier = 1.0


func _ready():
	pass

func _physics_process(delta):
	player_falling(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()

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
