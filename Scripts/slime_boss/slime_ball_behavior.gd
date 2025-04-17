extends CharacterBody2D

var enemy_scene = preload("res://Scenes/Enemies/Enemy.tscn")
var target: Vector2
var fire = false
var damage = 20
var player

func _physics_process(delta):
	if fire:
		var direction = (target - global_position).normalized()
		velocity = direction * 450
		move_and_slide()

func fire_ball(position):
	target = position
	fire = true

func _on_slime_ball_sensor_body_entered(body):
	if body.is_in_group("player"):
		body.receive_damage(damage)
		get_node("../target").visible = false
		explode()

func _on_slime_ball_sensor_area_entered(area):
	if area.is_in_group("target"):
		area.visible = false
		explode()
		
func explode():
	for i in 5:
		var enemy = enemy_scene.instantiate()
		var angle = randf() * TAU
		enemy.position = position + Vector2(cos(angle), sin(angle)) * 100
		enemy.player = player
		get_parent().add_child.call_deferred(enemy)
	queue_free()
