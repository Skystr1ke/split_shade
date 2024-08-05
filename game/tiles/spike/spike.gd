extends Area2D


const Player = preload("res://game/player/player.gd")


func _on_body_entered(body: Node2D) -> void:
	var new_player: Player = (load("res://game/player/player.tscn") as PackedScene).instantiate()
	
	var dead_player: Player = body.get_parent()
	var level: Level = dead_player.get_parent()
	dead_player.queue_free()
	
	level.warp.add_sibling.call_deferred(new_player)
	new_player.position = dead_player.starting_position
