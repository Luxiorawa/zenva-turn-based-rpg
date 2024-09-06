class_name TurnManager
extends Node2D

@export var player_character: Character
@export var enemy_character: Character
var current_character_turn: Character

@export var starting_delay: float = 0.5
@export var next_turn_delay: float = 1.0

var game_over: bool = false

signal character_begin_turn(character: Character)
signal character_end_turn(character: Character)

func _ready() -> void:
	await get_tree().create_timer(starting_delay).timeout
	print("Starting the fight...")
	begin_next_turn()

func begin_next_turn() -> void: 
	if current_character_turn == player_character:
		current_character_turn = enemy_character
	elif current_character_turn == enemy_character:
		current_character_turn = player_character
	else:
		current_character_turn = player_character

	character_begin_turn.emit(current_character_turn)

func end_current_turn() -> void:
	await get_tree().create_timer(next_turn_delay).timeout
	character_end_turn.emit(current_character_turn)

	if game_over == false:
		begin_next_turn()

func character_died(character: Character) -> void:
	game_over = true

	if character.is_player == true:
		print("You lose !")
	else:
		print("You win !")