extends Resource
class_name TurnManager


enum TurnState {
	ALLY_TURN, 
	ENEMY_TURN, 
	STARTUP_TURN
}

signal ally_turn_started()
signal ally_turn_ended()
signal enemy_turn_started()
signal enemy_turn_ended()
signal startup_turn_started()
signal startup_turn_ended()

var turn_count = 0

var turn := TurnState.ALLY_TURN:
	get:
		return turn
	set(value):
		turn = value
		match turn:
			TurnState.STARTUP_TURN:
				turn_count = 0
				startup_turn_started.emit()
			TurnState.ALLY_TURN:
				if (turn_count > 1): 
					enemy_turn_ended.emit()
				ally_turn_started.emit()
			TurnState.ENEMY_TURN:
				if (turn_count > 1):
					ally_turn_ended.emit()
				enemy_turn_started.emit()

func start():
	self.turn = TurnState.STARTUP_TURN

func advance_turn():
	turn_count += 1
	if turn_count == 1:
		match randi_range(1, 2):
			1: 
				self.turn = TurnState.ALLY_TURN
			2:
				self.turn = TurnState.ENEMY_TURN
	else:
		self.turn = TurnState.values()[int(self.turn + 1) & 1]
