class_name TurnManager
extends Node2D

@export var player_character: Character
@export var enemy_character: Character
var current_character_turn: Character

@export var starting_delay: float = 0.5
@export var next_turn_delay: float = 1.0

@onready var playerCombatActions: VBoxContainer = get_node("/root/BattleScene/PlayerCombatActions")

var game_over: bool = false

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
	print("\nIt's ", current_character_turn.name, "'s turn !")

	if(current_character_turn.is_player):
		playerCombatActions.show()

	if current_character_turn.is_player == false:
		current_character_turn._decide_combat_action()

func end_current_turn() -> void:
	if(current_character_turn.is_player):
		playerCombatActions.hide()

	await get_tree().create_timer(next_turn_delay).timeout

	if game_over == false:
		begin_next_turn()

func character_died(character: Character) -> void:
	game_over = true

	if character.is_player == true:
		print("\nYou lose !")
	else:
		print("\nYou win !")
