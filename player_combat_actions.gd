extends VBoxContainer

@onready var playerCharacter: Character = get_node("/root/BattleScene/Player")

func _ready() -> void:
	if playerCharacter and playerCharacter.combat_actions.size() > 0:
		dynamically_create_player_combat_actions()

func dynamically_create_player_combat_actions() -> void: 
	print("Creating ", playerCharacter.combat_actions.size(), " actions for the player.")
	for i in playerCharacter.combat_actions.size():
		var combat_action = playerCharacter.combat_actions[i]
		var combat_action_button = CombatActionButton.new()
		combat_action_button.combat_action = combat_action
		combat_action_button.text = combat_action.display_name
		add_child(combat_action_button)