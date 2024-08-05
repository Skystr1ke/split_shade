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
@onready var ui: CanvasLayer = $UI
@onready var music_player: AudioStreamPlayer = $MusicPlayer


func _ready() -> void:
	ui.add_child(_start_menu)
	_start_menu.start_button.pressed.connect(_on_game_started)
	_start_menu.quit_button.pressed.connect(_on_game_quit)
	_start_menu.music_button.pressed.connect(_on_music_played)
	
	ui.add_child(_pause_menu)
	ui.remove_child(_pause_menu)
	_pause_menu.resume_button.pressed.connect(_on_level_paused)
	_pause_menu.quit_to_menu_button.pressed.connect(_on_quit_to_menu)
	_pause_menu.quit_game_button.pressed.connect(_on_game_quit)


func _setup_level(path_to_level: String) -> void:
	_current_level = (load(path_to_level) as PackedScene).instantiate()
	_current_level.level_completed.connect(_on_level_completed)
	_current_level.level_paused.connect(_on_level_paused)
	game.add_child.call_deferred(_current_level)


func _on_level_completed() -> void:
	_current_level.queue_free()
	
	if _current_level.path_to_next_level:
		_setup_level(_current_level.path_to_next_level)
	else:
		ui.add_child(_start_menu)


#region Start menu signals
func _on_game_started() -> void:
	ui.remove_child(_start_menu)
	_setup_level(path_to_first_level)


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
	_current_level.queue_free()
	ui.remove_child(_pause_menu)
	ui.add_child(_start_menu)
	get_tree().paused = false
#endregion


func _on_game_quit() -> void:
	get_tree().quit()
