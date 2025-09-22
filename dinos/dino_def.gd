class_name DinoDef extends Resource

@export_custom(PROPERTY_HINT_LOCALIZABLE_STRING, "") var name: String
@export var sprite: Texture2D

@export_group("Battle Stats")
@export var health: int = 100
@export var attack: int = 100
@export var defense: int = 100
@export var accuracy: int = 100
@export var evasion: int = 100
@export var crit: int = 100
@export var status: int = 100
@export var speed: int = 100
