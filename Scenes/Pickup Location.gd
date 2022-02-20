extends StaticBody2D
# ORDER LOGIC CONTROL
var player_inside_pickup_area
var is_player_stopped
var is_order_picked_up

# SIGNALS
signal order_picked_up()


# Eventually, I'd like to avoid checking for pickup every frame, but have been 
# unable to find a nicer way to make sure that the player stops within the zone 
# before being able to perform a pickup. Research later!
func _process(_delta):  
	check_for_order_pickup()




# If we have an order to pickup at this location, check the player is stopped within the pickup area before picking up the order.
func check_for_order_pickup():
	if(player_inside_pickup_area && is_player_stopped && !is_order_picked_up):
		is_order_picked_up = true
		print("Order pickup successful!")
		emit_signal("order_picked_up") # Once the order has been picked up, we should let other nodes know we've done so.


# CONNECTED SIGNALS
func _on_player_stopped():
	is_player_stopped = true
func _on_player_moving():
	is_player_stopped = false

func _on_pickup_area_body_entered(body):
	if (body.name == "Player"):
		player_inside_pickup_area = true

func _on_pickup_area_body_exited(body):
	if (body.name == "Player"):
		player_inside_pickup_area = false


# TODO: I just realized the code for order pickup area and drop-off area are going to be pretty similar. Should make a parent Location class that pick up and drop off locations inherit from.
# I need to learn how Godot handles this sort of thing first!
