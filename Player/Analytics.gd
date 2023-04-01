extends Node
class_name Analytics
#This class is used to log data in the build for playtesting or debugging purposes. It logs data each time PlayState is entered.
#Files are stored in Appdata folder. For instance C:\Users\Rene\AppData\Roaming\Godot\app_userdata\TSJ

export var store_only_builds = false

var activesession = false
var session_start_time = {}
var weapon_fires = 0
var bullets_hit = 0
var enemies_killed = 0
var ability_used = 0
var weapons_used = []
var score_achieved = 0
var player_hitting_enemy = ""
var time_played = 0 
var time_start_play = 0
var messages = []

# The play state is entered.
func start_session():
	if activesession:
		store_session()
	reset_variables()
	time_played = OS.get_unix_time()
	session_start_time = OS.get_datetime()
	activesession = true
#	add_message("hello")
#	add_message("world")

#call this function from anywhere in the game to store multiple messages or events
func add_message(_message):
	messages.append(_message)

# Reset all variables for the next time the player starts playing.
func reset_variables():
	session_start_time = {}
	weapon_fires = 0
	bullets_hit = 0
	enemies_killed = 0
	ability_used = 0
	weapons_used = []
	score_achieved = 0
	player_hitting_enemy = ""
	time_played = 0

# The player went game over or the application is quit
func store_session():
	if store_only_builds:
		if OS.is_debug_build():
			return #We're running only in the build and this is a debug build so we don't do anything.
	
	var file = File.new()
	var date = OS.get_datetime()
	var sessionnum = 0
	while file.file_exists("user://Date " + str(date["month"]) + " " + str(date["day"]) + " Session " + str(sessionnum) + ".txt"):
		sessionnum += 1
	
	file.open("user://Date " + str(date["month"]) + " " + str(date["day"]) + " Session " + str(sessionnum) + ".txt", file.WRITE)
	
	file.store_line("Session start: " + str(session_start_time["hour"]) + "H " + str(session_start_time["minute"]) + "M")
	file.store_line("Session end: " + str(date["hour"]) + "H " + str(date["minute"]) + "M")
	file.store_line("Time played (sec): " + str(OS.get_unix_time() - time_played))
	file.store_line("")
	file.store_line("Ability used: " + str(ability_used))
	file.store_line("Weapons used: " + str(weapons_used))
	file.store_line("Bullets shot: " + str(weapon_fires))
	file.store_line("Bullets hit: " + str(bullets_hit))
	if weapon_fires != 0 && bullets_hit != 0:
		file.store_line("Accuracy: " + str(stepify((100.0 / weapon_fires) * bullets_hit, 0.01)) + "%")
	file.store_line("")
	file.store_line("Enemies killed: " + str(enemies_killed))
	file.store_line("Killed by: " + str(player_hitting_enemy) + " at: " + str(Globals.player.position))
	file.store_line("Score achieved: " + str(score_achieved))
	file.store_line("")
	file.store_line("Start time (unix): " + str(time_played))
	file.store_line("End time (unix): " + str(OS.get_unix_time()))
	file.store_line("")
	file.store_line("Messages:")
	for message in messages:
		file.store_line(message)
	file.close()
	messages = []
	activesession = false

############ BINDINGS ############
func on_state_changed(new_state):
	if new_state == "Play":
		start_session()

func on_game_over(total_score):
	score_achieved = total_score
	store_session()

func on_ability_used(duration):
	ability_used += 1

func on_enemy_death(enemy, score, location):
	enemies_killed += 1

func on_bullet_hit_enemy():
	bullets_hit += 1

func on_weapon_fired():
	weapon_fires += 1

func on_hit_player(bullet_owner):
	player_hitting_enemy = bullet_owner

func on_weapon_changed(display_name, position):
	weapons_used.append(display_name)
