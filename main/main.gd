extends Node


const StartMenu = preload("res://ui/start_menu/start_menu.gd")
const PauseMenu = preload("res://ui/pause_menu/pause_menu.gd")
const START_MENU = preload("res://ui/start_menu/start_menu.tscn")
const PAUSE_MENU = preload("res://ui/pause_menu/pause_menu.tscn")

@export_file("*.tscn") var path_to_first_level: String

var _current_level: Level
var _start_menu: StartMenu = START_MENU.instantiate()
var _pause_menu: PauseMenu = PAUSE_MENU.instantiate()

@onready var game: Node2D = $Game
@onready var ui: Control = $UI
@onready var animations: AnimationPlayer = $Animations
@onready var music_player: AudioStreamPlayer = $MusicPlayer


func _ready() -> void:
	ui.add_child(_start_menu)
	_start_menu.start_button.pressed.connect(_on_level_changed)
	_start_menu.quit_button.pressed.connect(_on_game_quit)
	_start_menu.music_button.pressed.connect(_on_music_played)
	
	ui.add_child(_pause_menu)
	ui.remove_child(_pause_menu)
	_pause_menu.resume_button.pressed.connect(_on_level_paused)
	_pause_menu.quit_to_menu_button.pressed.connect(_on_quit_to_menu)
	_pause_menu.quit_game_button.pressed.connect(_on_game_quit)


func _on_level_changed() -> void:
	get_tree().paused = true
	animations.play("fade_out")
	await animations.animation_finished
	
	var path_to_next_level: String
	
	if _current_level:
		_current_level.queue_free()
		path_to_next_level = _current_level.path_to_next_level
		_current_level = null
	else:
		ui.remove_child(_start_menu)
		path_to_next_level = path_to_first_level
	
	if not path_to_next_level:
		ui.add_child(_start_menu)
		
		animations.play("fade_in")
		await animations.animation_finished
		get_tree().paused = false
		
		return
	
	_current_level = (load(path_to_next_level) as PackedScene).instantiate()
	_current_level.level_completed.connect(_on_level_changed)
	_current_level.level_paused.connect(_on_level_paused)
	game.add_child.call_deferred(_current_level)
	
	animations.play("fade_in")
	await animations.animation_finished
	get_tree().paused = false


#region Start menu signals
func _on_music_played() -> void:
	music_player.playing = true
#endregion


#region Pause menu signals
func _on_level_paused() -> void:
	get_tree().paused = not get_tree().paused
	
	if get_tree().paused:
		ui.add_child(_pause_menu)
	else:
		ui.remove_child(_pause_menu)


func _on_quit_to_menu() -> void:
	get_tree().paused = true
	_pause_menu.fade_out_animation.play("fade_out")
	animations.play("fade_out")
	await animations.animation_finished
	
	_current_level.queue_free()
	_current_level = null
	ui.remove_child(_pause_menu)
	ui.add_child(_start_menu)
	
	_pause_menu.fade_out_animation.play("RESET")
	animations.play("fade_in")
	await animations.animation_finished
	get_tree().paused = false
#endregion


func _on_game_quit() -> void:
	get_tree().quit()
