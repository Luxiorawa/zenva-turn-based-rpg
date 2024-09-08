class_name Character
extends Node2D

@export var is_player: bool
@export var current_health: int = 100
@export var max_health: int = 100

@export var combat_actions: Array[CombatAction]
@export var opponent: Character

@onready var health_bar: ProgressBar = $HealthBar
@onready var health_text: Label = $HealthBar/HealthText

@onready var turnManager: TurnManager = get_node("/root/BattleScene")
@onready var playerCombatActions: VBoxContainer = get_node("/root/BattleScene/PlayerCombatActions")

@export var visual: Texture2D

func _ready() -> void:
	$Sprite2D.texture = visual
	$Sprite2D.flip_h = !is_player
	health_bar.max_value = max_health
	if is_player:
		opponent = turnManager.enemy_character
	else:
		opponent = turnManager.player_character
	update_health_bar()

func take_damage(damage) -> void:
	current_health -= damage
	update_health_bar()
	if current_health <= 0:
		current_health = 0
		turnManager.character_died(self)
		queue_free()

func heal(heal_amount) -> void:
	current_health += heal_amount
	if current_health > max_health:
		current_health = max_health

	update_health_bar()

func update_health_bar() -> void:
	health_bar.value = current_health
	health_text.text = str(current_health) + " / " + str(max_health)

func cast_combat_action(action: CombatAction) -> void:
	print(action.display_name, " was cast by ", turnManager.current_character_turn.name)

	if action.damage_amount > 0:
		opponent.take_damage(action.damage_amount)
	elif action.heal_amount > 0:
		heal(action.heal_amount)

	turnManager.end_current_turn()

func _decide_combat_action() -> void:
	var health_percentage = float(current_health) / float(max_health)	
	
	for i in combat_actions:
		var action = i as CombatAction

		if action.heal_amount > 0:
			if randf() > health_percentage + 0.2:
				cast_combat_action(action)
				return
		elif action.damage_amount > 0:
			cast_combat_action(action)
			return
		else:
			print("No valid action found for ", name)
			turnManager.end_current_turn()
