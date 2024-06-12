extends Node


var turnManager := TurnManager.new()
var asyncTurnPool := AsyncTurnPool.new()

var elizabethStats : PlayerClassStats = load("res://Scripts/CharacterClasses/ElizabethClassStats.tres")
var inventory : Inventory = load("res://Scenes/Prefabs/Items/Inventory.tres")
