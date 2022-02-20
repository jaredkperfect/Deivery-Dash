extends Area2D
var order_id # to be compared with the drop_off_id in drop off location to check if this is a valid delivery.
var picked_up = false




func _ready():
	order_id = 1; # eventually want to create this after enumerating orders


func give_order():
	print("Give order ran")
	if(!picked_up):
		print("Order " + order_id + " picked up!")
		picked_up = true
	


func _on_Player_player_stopped():
	pass # Replace with function body.
