extends CharacterBody2D

@export var damage = 2
@onready var damage_timer = $DamageTimer
@onready var xp_ball = preload("res://Scenes/xp.tscn")
var xp_ammount = 100
var speed = 100
var health = 10
var player: CharacterBody2D
var stop_distance = 1
var player_in_contact: CharacterBody2D = null

func _physics_process(delta):
	if player:
		var distance_to_player = position.distance_to(player.position)
		if distance_to_player > stop_distance:
			var direction = (player.position - position).normalized()
			var motion = direction * speed * delta
			move_and_collide(motion)
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
		#move_and_slide()

func _on_player_sensor_body_entered(body):
	if body.is_in_group("player"):
		player_in_contact = body
		damage_timer.start()
		_apply_damage()

func _on_player_sensor_body_exited(body):
	if body == player_in_contact:
		player_in_contact = null
		damage_timer.stop()
		
func damage_player(player):
	player.receive_damage(damage)

func _apply_damage():
	if player_in_contact:
		player_in_contact.receive_damage(damage)

func receive_damage(amount: int):
	health -= amount
	#print("vida del enemigo", health)
	if health <= 0:
		die()
		
func die():
	#drop xp ball
	var xp = xp_ball.instantiate()
	xp.position = self.position
	xp._spawn_xp(xp_ammount)
	get_parent().add_child.call_deferred(xp)
	queue_free()
