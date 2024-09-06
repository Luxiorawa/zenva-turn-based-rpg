class_name Character
extends Node2D

@export var is_player: bool
@export var current_health: int = 100
@export var max_health: int = 100

@export var combat_actions: Array
@export var opponent: Node

@onready var health_bar: ProgressBar = $HealthBar
@onready var health_text: Label = $HealthBar/HealthText

@onready var turnManager: TurnManager = get_node("/root/BattleScene")

@export var visual: Texture2D

func _ready() -> void:
	$Sprite2D.texture = visual
	$Sprite2D.flip_h = !is_player
	turnManager.character_begin_turn.connect(_on_character_begin_turn)
	turnManager.character_end_turn.connect(_on_character_end_turn)
	health_bar.max_value = max_health
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

func _on_character_begin_turn(_character: Character) -> void:
	print("It is now ", self.name, "'s turn !")
	pass

func _on_character_end_turn(_character: Character) -> void:
	print(self.name, " has ended their turn.")
	pass