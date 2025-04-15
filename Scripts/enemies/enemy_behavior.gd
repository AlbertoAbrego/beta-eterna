extends CharacterBody2D

@export var damage = 2
@onready var damage_timer = $DamageTimer
@onready var xp_ball = preload("res://Scenes/xp.tscn")
@onready var xp_sprite = preload("res://Sprites/xp.png")
@onready var nav_agent = $NavigationAgent2D

var xp_ammount = 100
var speed = 60
var health = 10
var player: CharacterBody2D
var player_in_contact: CharacterBody2D = null

func _ready():
	nav_agent.radius = 11.0  # Ajusta según el tamaño del enemigo

func _physics_process(delta):
	if player:
		nav_agent.target_position = player.global_position  # Asegura que siempre siga al jugador
		if nav_agent.is_navigation_finished():
			return  # Evita hacer cálculos innecesarios
		var next_position = nav_agent.get_next_path_position()
		if next_position != global_position:
			var direction = (next_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
		move_and_slide()

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

func receive_damage(amount: int):
	health -= amount
	#print("vida del enemigo", health)
	if health <= 0:
		die()
		
func die():
	#drop xp ball
	var xp = xp_ball.instantiate()
	xp.set_sprite(xp_sprite)
	xp.position = self.position
	xp._spawn_xp(xp_ammount)
	get_parent().add_child.call_deferred(xp)
	queue_free()
