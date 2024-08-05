extends Sprite2D


@onready var animations: AnimationPlayer = $AnimationPlayer


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("flip") and not animations.is_playing():
		if rotation == 0:
			animations.play("flip_black")
		else:
			animations.play("flip_white")
