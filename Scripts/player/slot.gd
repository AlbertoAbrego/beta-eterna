extends Node2D

var item: Item
@onready var item_sprite = $item_sprite

func add_item(new_item):
	item = new_item
	print(item.sprite.resource_name)
	item_sprite.texture = item.sprite
	
func remove_item():
	item = null
	item_sprite.texture = null
	
