extends State
class_name Mob1DecisionState

func Enter():
	var n: int = randi_range(1, 10)
	
	if n > 5:
		Transition.emit(self, 'statesideidle')
	else:
		Transition.emit(self, 'stateupdownidle')
