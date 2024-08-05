@tool
extends Node2D


@export var size := Vector2.ONE:
	get:
		if Engine.is_editor_hint():
			_set_children_to_size()
		
		return _size
	set(value):
		if not Engine.is_editor_hint():
			await ready
		
		_size = value
		_set_children_to_size()

var _size := Vector2.ONE

@onready var camera: Camera2D = $Camera
@onready var background: Control = $Background
@onready var ground_collider: CollisionShape2D = $Ground/Collider
@onready var left_boundary: CollisionShape2D = $Boundaries/Left
@onready var right_boundary: CollisionShape2D = $Boundaries/Right


func _set_children_to_size() -> void:
	camera.zoom = Vector2.ONE/_size
	background.scale = _size
	var ground_segment_collider: SegmentShape2D = ground_collider.shape
	ground_segment_collider.a.x = _size.x * -480
	ground_segment_collider.b.x  = _size.x * 480
	left_boundary.position.x = _size.x * -480
	right_boundary.position.x = _size.x * 480
