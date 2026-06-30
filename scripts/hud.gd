extends CanvasLayer
## Minimal HUD: round timer, score, phase/status text.

@onready var timer_label: Label = $TopBar/TimerLabel
@onready var score_label: Label = $TopBar/ScoreLabel
@onready var status_label: Label = $StatusLabel
@onready var jump_button: Button = $JumpButton
@onready var shield_button: Button = $ShieldButton
@onready var kill_feed: VBoxContainer = $KillFeed

func _ready() -> void:
	GameManager.round_time_changed.connect(_on_time_changed)
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.phase_changed.connect(_on_phase_changed)
	GameManager.round_ended.connect(_on_round_ended)
	GameManager.kill_logged.connect(_on_kill_logged)
	jump_button.button_down.connect(func(): Input.action_press("jump"))
	jump_button.button_up.connect(func(): Input.action_release("jump"))
	shield_button.button_down.connect(func(): Input.action_press("shield"))
	shield_button.button_up.connect(func(): Input.action_release("shield"))

func _on_kill_logged(attacker_label: String, victim_label: String, attacker_team: int) -> void:
	var row := Label.new()
	row.text = "%s  ☠  %s" % [attacker_label, victim_label]
	row.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_theme_constant_override("outline_size", 6)
	row.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	var col := Color(0.4, 0.85, 0.5) if attacker_team == Global.Team.TORTOISE else Color(1.0, 0.6, 0.35)
	row.add_theme_color_override("font_color", col)
	kill_feed.add_child(row)
	while kill_feed.get_child_count() > 5:
		kill_feed.get_child(0).free()
	var tw := row.create_tween()
	tw.tween_interval(3.5)
	tw.tween_property(row, "modulate:a", 0.0, 1.0)
	tw.tween_callback(row.queue_free)
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
