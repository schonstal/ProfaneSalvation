extends Node

signal wave_completed(name)
signal halo_collected
signal upgrade_collected
signal health_collected

signal chapter_complete
signal enemy_died(wave, enemy)
signal shield_failure

signal boss_hurt(new_health)
signal boss_pattern_complete
signal boss_start(hp)
signal boss_defeated

signal player_defend
signal clear_projectiles
