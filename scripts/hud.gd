extends CanvasLayer
## Minimal HUD: round timer, score, phase/status text.

@onready var timer_label: Label = $TopBar/TimerLabel
@onready var score_label: Label = $TopBar/ScoreLabel
@onready var status_label: Label = $StatusLabel
@onready var jump_button: Button = $JumpButton

func _ready() -> void:
	GameManager.round_time_changed.connect(_on_time_changed)
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.phase_changed.connect(_on_phase_changed)
	GameManager.round_ended.connect(_on_round_ended)
	jump_button.button_down.connect(func(): Input.action_press("jump"))
	jump_button.button_up.connect(func(): Input.action_release("jump"))
	_on_score_changed(0, 0)
	_on_phase_changed(Global.RoundPhase.WARMUP)

func _on_time_changed(seconds_left: float) -> void:
	var s := int(ceil(seconds_left))
	timer_label.text = "%d:%02d" % [s / 60, s % 60]

func _on_score_changed(tortoise_score: int, rabbit_score: int) -> void:
	score_label.text = "Tortoises %d - %d Rabbits" % [tortoise_score, rabbit_score]

func _on_phase_changed(phase: int) -> void:
	match phase:
		Global.RoundPhase.BUY:
			status_label.text = "Buy phase"
		Global.RoundPhase.ACTION:
			status_label.text = "Plant the Carrot Charge!"
		Global.RoundPhase.PLANTED:
			status_label.text = "Charge planted - defuse it!"
		Global.RoundPhase.ROUND_END:
			pass
		_:
			status_label.text = ""

func _on_round_ended(reason: int, winner: int) -> void:
	var winner_name := Global.team_name(winner)
	var reason_text := ""
	match reason:
		Global.RoundEndReason.CHARGE_EXPLODED:
			reason_text = "Carrot Charge exploded"
		Global.RoundEndReason.CHARGE_DEFUSED:
			reason_text = "Charge defused"
		Global.RoundEndReason.TEAM_ELIMINATED:
			reason_text = "Enemy team eliminated"
		Global.RoundEndReason.TIME_OUT_NO_PLANT:
			reason_text = "Time ran out"
	status_label.text = "%s win - %s" % [winner_name, reason_text]
