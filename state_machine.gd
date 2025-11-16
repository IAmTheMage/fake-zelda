extends Node
class_name StateMachine;

var current_state: State;
var states: Dictionary = {};

@export var initial_state: State;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child;
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state:
		current_state.Update();
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update();

func on_state_transition(state, new_state_name):
	if state == !current_state:
		return;
		
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		return
	
	if current_state:
		current_state.Exit();
		
	new_state.Enter();
	
	current_state = new_state;
	
