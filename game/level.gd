class_name Level
extends Node2D


const Player = preload("res://game/player/player.gd")

@export var warp: Area2D
@export_file("*.tscn") var path_to_next_level: String

signal level_completed
signal level_paused


func _ready() -> void:
	warp.body_entered.connect(_on_warp_touched)


func _physics_process(_delta: float) -> void:
	var players: Array[Player] = []
	
	for child in get_children():
		if child is Player:
			players.push_back(child)
	
	while players.size() > 1:
		var current_player: Player = players.pop_back()
		current_player.queue_free()
	
	if Input.is_action_just_pressed("pause"):
		level_paused.emit()


func _on_warp_touched(_body: Node2D) -> void:
	level_completed.emit()
