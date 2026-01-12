extends PlayerStateInterface

##handles the player falling through the air
class_name PlayerFallState

var op: Player

func enter(_prev_state: String = "") -> void:
	op = state_machine.owner
	Debug.player_state = "fall"


func physics_update(delta: float) -> void:
	#apply gravity and movement while in the air
	op.velocity.y -= op.gravity * delta
	op.move(delta, op.SPEED, op.AIR_DECCEL_SPEED)
	
	#transition to idle or move state when landing
	if op.is_on_floor():
		if op.is_moving:
			state_machine.change_state("player_move")
		else:
			state_machine.change_state("player_idle")
