extends Node

@export var mob_scene: PackedScene;
var score;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass;

	
func game_over():
	$ScoreTimer.stop();
	$MobTimer.stop();
	$HUD.show_game_over();
	$DeathSound.play();
	
	
func new_game():
	get_tree().call_group("mobs","queue_free");
	score = 0;
	$Player.start($StartPosition.position);
	$StartTimer.start();
	$HUD.update_score(score);
	$HUD.show_message("Get Ready");
	$Music.play();
	
func _on_score_timer_timeout():
	score += 1;
	$HUD.update_score(score);
	
func _on_start_timer_timeout():
	$MobTimer.start();
	$ScoreTimer.start();
	
func _on_mob_timer_timeout():
	var mob: Node = mob_scene.instantiate();
	
	var mob_spawn_location = $MobPath/MobSpawnLocation;
	mob_spawn_location.progress_ratio = randf();
	
	var direction = mob_spawn_location.rotation + PI / 2 + randf_range(
		(-PI / 4),
		(PI /4));
	
	var velocity: Vector2 = Vector2(randf_range(150, 250), 0);
	var rotated_velocity: Vector2 = velocity.rotated(direction);
	
	mob.position = mob_spawn_location.position;
	mob.rotation = direction;
	mob.linear_velocity = rotated_velocity;
	
	add_child(mob);
	
	