extends State
class_name Mob1DecisionState

var increment: int = 0

func Enter():
	var n: int = randi_range(1, 10)
	
	if n + increment > 5:
		Transition.emit(self, 'statesideidle')
		increment -= 2
	else:
		Transition.emit(self, 'stateupdownidle')
		increment += 2
