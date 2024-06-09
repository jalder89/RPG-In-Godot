extends Resource
class_name TurnManager


enum {ALLY_TURN, ENEMY_TURN, STARTUP_TURN}

signal ally_turn_started()
signal ally_turn_ended()
signal enemy_turn_started()
signal enemy_turn_ended()
signal startup_turn_started()
signal startup_turn_ended()

var turn_count = 0

var turn := ALLY_TURN:
	get:
		return turn
	set(value):
		turn = value
		match turn:
			STARTUP_TURN:
				turn_count = 0
				startup_turn_started.emit()
				print("Turn Count: " + str(turn_count))
				turn_count += 1
				startup_turn_ended.emit()
			ALLY_TURN:
				if (turn_count > 1): 
					enemy_turn_ended.emit()
				print("Turn Count: " + str(turn_count))
				ally_turn_started.emit()
			ENEMY_TURN:
				if (turn_count > 1):
					ally_turn_ended.emit()
				print("Turn Count: " + str(turn_count))
				enemy_turn_started.emit()

func start():
	self.turn = STARTUP_TURN

func advance_turn():
	turn_count += 1
	self.turn = int(self.turn + 1) & 1

func force_ally_turn():
	self.turn = ALLY_TURN

func force_enemy_turn():
	self.turn = ENEMY_TURN
