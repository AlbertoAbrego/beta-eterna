extends CanvasLayer

@onready var level = $skills_labels/level
@onready var health = $skills_labels/health
@onready var damage = $skills_labels/damage
@onready var armor = $skills_labels/armor
@onready var dexterity = $skills_labels/dexterity
@onready var magic = $skills_labels/magic
@onready var magic_resist = $skills_labels/magic_resist
@onready var attack_speed = $skills_labels/attack_speed
@onready var move_speed = $skills_labels/move_speed
@onready var inventory_sprite = $inventory_sprite
var player

func _update_stats():
	level.text = "Level: " + str(player.level)
	health.text = "Health: " + str(player.health) + "/" + str(player.max_health)
	damage.text = "Damage: " + str(player.damage)
	armor.text = "Armor: " + str(player.armor)
	dexterity.text = "Dexterity: " + str(player.dexterity)
	magic.text = "Magic: " + str(player.magic)
	magic_resist.text = "Magic Resist: " + str(player.magic_resist)
	attack_speed.text = "Attack Speed: " + str(player.attack_speed)
	move_speed.text = "Move Speed: " + str(player.move_speed)

func _ready():
	player = get_node("../../Player")
	hide()

func _toggle_show_inventory():
	if get_tree().paused:
		get_tree().paused = false
		hide()
	else:
		_update_stats()
		get_tree().paused = true
		show()

func _on_exit_inventory_pressed():
	_toggle_show_inventory()
	get_parent().onInventory = false
