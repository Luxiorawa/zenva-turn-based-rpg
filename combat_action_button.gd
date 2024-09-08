class_name CombatActionButton
extends Button

var combat_action: CombatAction

@onready var turnManager: TurnManager = get_node("/root/BattleScene")

func _ready():
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	turnManager.current_character_turn.cast_combat_action(combat_action)
