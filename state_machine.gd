extends Node
class_name StateMachine;


var states: Dictionary = {};

@export var initial_state: State;
@export var StatesLocation: Node;

var current_state: State = initial_state;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in StatesLocation.get_children():
		if child is State:
			states[child.name.to_lower()] = child;
			child.Transition.connect(on_state_transition)
	if initial_state:
		current_state = initial_state;
		initial_state.Enter()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print_debug(states)
	if current_state:
		current_state.Update();
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update();

func on_state_transition(state, new_state_name):
	if state != current_state:
		return;
		
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		
		return

	if current_state:
		current_state.Exit();
		
	current_state = new_state;
	new_state.Enter();
