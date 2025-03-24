extends Node

var enemy_scene = preload("res://scenes/Enemy.tscn")
var max_waves = 10
var elapsedTime = 0.0
var enemyCount = 1
var enemy_position = Vector2.ZERO
var player: CharacterBody2D
var time_next_wave = 10
var wave = 0
var spawning_boss = false
var spawn_wave_order = [
	[1,5], [5,10], [10,15], [15,20], [20,25], 
	[25,30], [30,35], [35,40], [40,45], [45,50]
]
const spawn_distance = 200

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
		await get_tree().create_timer(time_next_wave).timeout
		_spawn_wave()
	else:
		pass

func spawn_enemy():
	var new_enemy = enemy_scene.instantiate()
	new_enemy.name = "Enemy" + str(enemyCount)
	var angle = randf() * TAU
	enemy_position = player.position + Vector2(cos(angle), sin(angle)) * spawn_distance
	new_enemy.position = enemy_position
	new_enemy.player = player
	get_parent().add_child.call_deferred(new_enemy)
	enemyCount += 1
