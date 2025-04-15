extends Area2D

var xp_amount
@onready var xp_sprite:Sprite2D = $xp_sprite
var xp_texture

func _ready():
	xp_sprite.texture = xp_texture

func _spawn_xp(amount):
	xp_amount = amount

func _on_body_entered(body):
	if body.is_in_group("player"):
		body._add_xp(xp_amount)
		queue_free()

func set_sprite(texture):
	xp_texture = texture
