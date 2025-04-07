extends CharacterBody2D

@onready var damage_timer = $DamageTimer
@onready var nav_agent = $NavigationAgent2D
@onready var target_sprite_scene = preload("res://Scenes/target_sprite.tscn")

var slime_ball = preload("res://Scenes/slime_ball.tscn")
var damage = 15
var speed = 80
var health = 200
var onFollowPlayer = true
var onAttack = false
var time_spent = 0.0
var time_following = 8
var time_attacking = 3
var player
var target_sprite
var player_in_contact: CharacterBody2D = null

func _ready():
	target_sprite = target_sprite_scene.instantiate()
	get_parent().add_child(target_sprite)
	target_sprite.visible = false

func _physics_process(delta):
	if player:
		if onFollowPlayer:
			nav_agent.target_position = player.global_position
			if nav_agent.is_navigation_finished():
				return  # Evita hacer cálculos innecesarios
			var next_position = nav_agent.get_next_path_position()
			if next_position != global_position:
				var direction = (next_position - global_position).normalized()
				velocity = direction * speed
			else:
				velocity = Vector2.ZERO
			move_and_slide()
			time_spent += delta
			if time_spent > time_following:
				onFollowPlayer = false
				time_spent = 0.0
				onAttack = true
				target_sprite.visible = true
		if onAttack:
			target_sprite.global_position = player.position + Vector2(0,16)
			time_spent += delta
			if time_spent > time_attacking:
				_attack()
				onAttack = false
				time_spent = 0.0
				onFollowPlayer = true

func _attack():
	var slime_ball_attack = slime_ball.instantiate()
	slime_ball_attack.position = position
	slime_ball_attack.player = player
	get_parent().add_child(slime_ball_attack)
	slime_ball_attack.fire_ball(player.position + Vector2(0,16))

func target_hit():
	target_sprite.visible = false

func receive_damage(amount: int):
	health -= amount
	print("vida del boss: ", health)
	if health <= 0:
		die()

func die():
	queue_free()

func _on_player_sensor_body_entered(body):
	if body.is_in_group("player"):
		player_in_contact = body
		damage_timer.start()
		_apply_damage()

func _on_player_sensor_body_exited(body):
	if body == player_in_contact:
		player_in_contact = null
		damage_timer.stop()
		
func _apply_damage():
	if player_in_contact:
		player_in_contact.receive_damage(damage)
