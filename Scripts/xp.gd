extends Area2D

var xp_amount

func _spawn_xp(amount):
	xp_amount = amount

func _on_body_entered(body):
	if body.is_in_group("player"):
		body._add_xp(xp_amount)
		queue_free()
