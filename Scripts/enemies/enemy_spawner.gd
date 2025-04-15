extends Node

@onready var timer = $Timer
var enemy_scene = preload("res://scenes/Enemy.tscn")
var boss_scene = preload("res://Scenes/Boss_Slime.tscn")
var max_waves = 1
var elapsedTime = 0.0
var enemyCount = 1
var enemy_position = Vector2.ZERO
var boss_position = Vector2.ZERO
var player: CharacterBody2D
var time_next_wave = 10
var wave = 0
var spawning_boss = false
var spawn_wave_order = [
	[3,5], [5,10], [10,15], [15,20], [20,25], 
	[25,30], [30,35], [35,40], [40,45], [45,50]
]
const spawn_distance = 400

func _ready():
	player = get_parent().find_child("Player")
	_start_wave_system()

func _start_wave_system():
	wave = 0
	spawning_boss = false
	_spawn_wave()

func _spawn_wave():
	if spawning_boss:
		return
	if wave < max_waves:
		for i in range(randi_range(spawn_wave_order[wave][0], spawn_wave_order[wave][1])):
			spawn_enemy()
		wave += 1
		timer.start()
		print("wave: ",wave)
		await timer.timeout
		_spawn_wave()
	else:
		_spawn_boss()

func spawn_enemy():
	var new_enemy = enemy_scene.instantiate()
	new_enemy.name = "Enemy" + str(enemyCount)
	var angle = randf() * TAU
	enemy_position = player.position + Vector2(cos(angle), sin(angle)) * spawn_distance
	new_enemy.position = enemy_position
	new_enemy.player = player
	get_parent().add_child.call_deferred(new_enemy)
	enemyCount += 1

func _spawn_boss():
	var new_boss = boss_scene.instantiate()
	var angle = randf() * TAU
	boss_position = player.position + Vector2(cos(angle), sin(angle)) * spawn_distance
	new_boss.position = boss_position
	new_boss.player = player
	get_parent().add_child.call_deferred(new_boss)
	
