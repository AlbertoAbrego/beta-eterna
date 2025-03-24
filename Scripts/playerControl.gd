extends CharacterBody2D

@onready var attackTimer = $AttackTimer

#player stats
var level = 1
var xp = 0
var next_level
var health = 100
var damage = 10
var armor = 0
var dexterity = 5
var magic = 0
var magic_resist = 0
var speed = 110
var attack_speed = 1

var doingAttack = false
var xp_factor = 1.5 #1.2-easy 1.5-medium 2-hard
const base_xp = 100

func _ready():
	next_level = _get_xp_required_next_level()

func _physics_process(delta):
	var direction = Vector2(0,0)
	if Input.is_action_pressed("up") and Input.is_action_pressed("left"):
		direction = Vector2(-speed,-speed)
	elif Input.is_action_pressed("up") and Input.is_action_pressed("right"):
		direction = Vector2(speed,-speed)
	elif Input.is_action_pressed("down") and Input.is_action_pressed("left"):
		direction = Vector2(-speed,speed)
	elif Input.is_action_pressed("down") and Input.is_action_pressed("right"):
		direction = Vector2(speed,speed)
	elif Input.is_action_pressed("up"):
		direction.y = -speed
	elif Input.is_action_pressed("down"):
		direction.y = speed
	elif Input.is_action_pressed("left"):
		direction.x = -speed
	elif Input.is_action_pressed("right"):
		direction.x = speed
	
	velocity = direction 
	move_and_slide()

func _get_xp_required_next_level():
	return int(base_xp * pow(level, xp_factor))

func _add_xp(amount):
	xp += amount
	_check_level_up()

func _check_level_up():
	while xp > next_level:
		xp -= next_level
		level += 1
		print("level up", level)
		next_level = _get_xp_required_next_level()

func receive_damage(amount: int):
	health -= amount
	print("Vida del player: ", health)
	if(health <= 0):
		die()

func die():
	print("Muelto")

func _attack():
	$Animation.play("attack")
	_apply_damage()

func _apply_damage():
	while doingAttack:
		await get_tree().create_timer(0.05).timeout
		for enemy in $AttackArea.get_overlapping_bodies():
			if enemy.is_in_group("enemy"):
				enemy.receive_damage(damage)

func _on_animation_animation_started(anim_name):
	if anim_name == "attack":
		doingAttack = true

func _on_animation_animation_finished(anim_name):
	if anim_name == "attack":
		doingAttack = false
