extends Node
## Autoload singleton: shared enums and constants for Shellstrike2D.

enum Team { NONE, TORTOISE, RABBIT }

enum RoundPhase { WARMUP, BUY, ACTION, PLANTED, ROUND_END }

enum RoundEndReason {
	CHARGE_EXPLODED,      # Rabbits win
	CHARGE_DEFUSED,       # Tortoises win
	TEAM_ELIMINATED,      # winning team set separately
	TIME_OUT_NO_PLANT,    # Tortoises win
}

const BUY_PHASE_SECONDS := 0.0 # MVP: skip buy phase (set > 0 to enable later)
const ROUND_SECONDS := 115.0
const PLANT_FUSE_SECONDS := 35.0
const DEFUSE_SECONDS := 7.0
const PLANT_SECONDS := 3.0

const STARTING_HP := 100

static func opposite(team: Team) -> Team:
	return Team.RABBIT if team == Team.TORTOISE else Team.TORTOISE

static func team_name(team: Team) -> String:
	match team:
		Team.TORTOISE:
			return "Tortoises"
		Team.RABBIT:
			return "Rabbits"
		_:
			return "None"
