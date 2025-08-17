# Manages the loading and setup of game levels.
extends Node2D

## The size of the grid in pixels.
@export var grid_size: int = 16

## A dictionary that preloads all the necessary game object scenes.
const GAME_PROPS = {
	"player": preload("res://Assets/Props/player.tscn"),
	"block": preload("res://Assets/Props/block.tscn"),
	"key_block": preload("res://Assets/Props/key_block.tscn"),
	"lock_block": preload("res://Assets/Props/lock_block.tscn"),
	"finish_block": preload("res://Assets/Props/finish_block.tscn")
}

# UI element references
@onready var pre_game_ui = $PreGameUI
@onready var screen_text = $PreGameUI/ScreenText
@onready var skip_text = $PreGameUI/SkipText
@onready var fade_animation = $PreGameUI/Fade
@onready var letter_sound = $PreGameUI/LetterSound
@onready var level_container = $Level

# State variables
var _is_text_skippable: bool = false
var _is_level_ready_to_start: bool = false
var _is_level_loading: bool = false
var _opening_text: String = "%% Placeholder text %%"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.currentLevel:
		_load_level_text()
		fade_animation.fade_out()
		await _play_opening_text()

# Called every frame.
func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		if not _is_level_ready_to_start:
			_is_text_skippable = true
			screen_text.text = _opening_text
			skip_text.visible = true
			await get_tree().create_timer(0.5).timeout
			_is_level_ready_to_start = true
		elif Globals.currentLevel and not _is_level_loading:
			_is_level_loading = true
			await fade_animation.fade_in()
			_load_level()
			await fade_animation.fade_out()
			Globals.gameRunning = true

## Animates the display of the opening text.
func _play_opening_text() -> void:
	for char in _opening_text:
		if not _is_text_skippable:
			await get_tree().create_timer(0.04).timeout
			letter_sound.play()
			screen_text.text += char
	
	await get_tree().create_timer(0.5).timeout
	_is_level_ready_to_start = true
	skip_text.visible = true

## Hides the pre-game loading screen elements.
func _hide_load_screen() -> void:
	screen_text.visible = false
	skip_text.visible = false

## Loads the opening text from the current level's data file.
func _load_level_text() -> void:
	var level_data = _get_level_data()
	if level_data and level_data.has("openingText"):
		_opening_text = level_data.openingText

## Loads and instantiates the objects for the current level.
func _load_level() -> void:
	print("load level")
	_hide_load_screen()
	var level_data = _get_level_data()
	if not level_data:
		return

	for item in level_data.get("contents", []):
		var new_node = GAME_PROPS[item.type].instantiate()

		if item.type in ["key_block", "lock_block"]:
			new_node.id = int(item.id)
		
		if item.type == "finish_block":
			if item.get("nextLevel"):
				new_node.nextLevel = item.get("nextLevel") # Assumes nextLevel is in JSON

		new_node.position = Vector2(int(item.x) * grid_size, int(item.y) * grid_size)
		level_container.add_child(new_node)

## Reloads the current level.
func reload_level() -> void:
	await fade_animation.fade_in()
	await _clear_level()
	await _load_level()
	await fade_animation.fade_out()

## Removes all child nodes from the level container.
func _clear_level() -> void:
	print("clear level")
	for child in level_container.get_children():
		child.queue_free()

## Transitions to the main menu scene.
func load_main_menu() -> void:
	#await fade_animation.fade_in()
	get_tree().change_scene_to_file("res://Assets/Scenes/menu.tscn");

## Retrieves level data from the JSON file.
func _get_level_data() -> Dictionary:
	if not Globals.currentLevel:
		return {}
	
	var file = FileAccess.open(Globals.currentLevel, FileAccess.READ)
	if not file:
		return {}
		
	var json_as_text = file.get_as_text()
	var level_obj = JSON.parse_string(json_as_text)
	return level_obj if typeof(level_obj) == TYPE_DICTIONARY else {}
