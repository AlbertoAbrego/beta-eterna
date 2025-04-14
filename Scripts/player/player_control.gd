extends CharacterBody2D

@onready var attackTimer = $AttackTimer
@onready var healthbar = $health
@onready var levelup_label = $levelup_label
var skill_points_buttons
var skill_points_label 
var inventory 
var dead_screen

const base_health = 10
const base_attack_speed = 0.1
const base_move_speed = 10

#player stats
var level = 1
var xp = 0
var next_level
var health = 100
var max_health = health
var damage = 10
var armor = 0
var dexterity = 5
var magic = 0
var magic_resist = 0
var attack_speed = 1
var move_speed = 100
var skill_points = 0

var doingAttack = false
var xp_factor = 1.5 #1.2-easy 1.5-medium 2-hard
const base_xp = 100

func _ready():
	next_level = _get_xp_required_next_level()
	inventory = get_node("../GameManager/Inventory")
	dead_screen = get_node("../GameManager/dead_screen")
	skill_points_buttons = inventory.get_node("skill_points_buttons")
	skill_points_label = inventory.get_node("skill_points_label")
	healthbar.visible = false
	levelup_label.visible = false

func _physics_process(delta):
	var direction = Vector2(0,0)
	if Input.is_action_pressed("up") and Input.is_action_pressed("left"):
		direction = Vector2(-move_speed,-move_speed)
	elif Input.is_action_pressed("up") and Input.is_action_pressed("right"):
		direction = Vector2(move_speed,-move_speed)
	elif Input.is_action_pressed("down") and Input.is_action_pressed("left"):
		direction = Vector2(-move_speed,move_speed)
	elif Input.is_action_pressed("down") and Input.is_action_pressed("right"):
		direction = Vector2(move_speed,move_speed)
	elif Input.is_action_pressed("up"):
		direction.y = -move_speed
	elif Input.is_action_pressed("down"):
		direction.y = move_speed
	elif Input.is_action_pressed("left"):
		direction.x = -move_speed
	elif Input.is_action_pressed("right"):
		direction.x = move_speed
	
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
		levelup_label.visible = true
		skill_points += 1
		skill_points_label.text = "Skill points: " + str(skill_points)
		skill_points_buttons.visible = true
		skill_points_label.visible = true
		next_level = _get_xp_required_next_level()

func receive_damage(amount: int):
	health -= amount
	healthbar.visible = true
	update_healthbar()
	if(health <= 0):
		die()

func update_healthbar():
	healthbar.get_node("healthbar_fill").scale.x = (float(health)/max_health)

func die():
	move_speed = 0
	get_tree().paused = true
	dead_screen.show()
	get_node("../GameManager").set_player_death()

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

func _level_up_skill(skill_name):
	match skill_name:
		"health":
			#health += base_health
			max_health += base_health
			update_healthbar()
		"damage":
			damage += 1
		"armor":
			armor += 1
		"dexterity":
			dexterity += 1
		"magic":
			magic += 1
		"magic_resist":
			magic_resist +=1
		"attack_speed":
			attack_speed += base_attack_speed
		"move_speed":
			move_speed += base_move_speed
	inventory._update_stats()
	skill_points -= 1
	skill_points_label.text = "Skill points: " + str(skill_points)
	if skill_points == 0:
		levelup_label.visible = false
		_hide_skill_points()

func _hide_skill_points():
	skill_points_label.text = ""
	skill_points_buttons.visible = false

func _on_skill_point_added(button_name):
	_level_up_skill(button_name)
