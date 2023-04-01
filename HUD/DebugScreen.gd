class_name DebugScreen
extends Control
#Debug class which contains functions only used for debugging purposes.

signal enemy_spawned(enemy)

onready var _spawners_button : CheckButton = $MarginContainer/VBoxContainer/HBoxContainer/SpawnersContainer/SpawnersButton
onready var _music_button : CheckButton = $MarginContainer/VBoxContainer/HBoxContainer/MusicContainer/MusicButton
onready var _god_mode_button : CheckButton = $MarginContainer/VBoxContainer/HBoxContainer/GodModeContainer/GodModeButton
onready var _weapon_select : OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/WeaponSelection
onready var _enemy_select : OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/EnemySelection
onready var _level_select : OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/LevelSelection
onready var _gamemode_select : OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/GameModeSelection
onready var _difficulty_select : OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/DifficultySelection

var _selected_enemy

func _ready():
	_spawners_button.pressed = Globals.debug_spawners_on
	_spawners_button.connect("toggled", self, "_on_SpawnersButton_toggled")
	_god_mode_button.pressed = Globals.debug_god_mode
	_god_mode_button.connect("toggled", self, "_on_GodModeButton_toggled")
	_music_button.pressed = !Globals.debug_mute_music
	_music_button.connect("toggled", self, "_on_MusicButton_toggled")
	Globals.debug_mute_music = Globals.debug_mute_music #set value to itself so that Globals actualy applies the value
	
	for i in Enums.ENME_Types.values():
		_enemy_select.add_item(Enums.ENME_Types.keys()[i])
	_selected_enemy = Enums.ENME_Types.keys()[0]
	
	for i in Enums.EPlayerWeaponTypes.values():
		_weapon_select.add_item(Enums.EPlayerWeaponTypes.keys()[i])
		
	for i in Enums.ELevels.values():
		_level_select.add_item(Enums.ELevels.keys()[i])
	
	for i in Enums.EPlayModes.values():
		_gamemode_select.add_item(Enums.EPlayModes.keys()[i])
	_gamemode_select.select(Globals.game_mode.initial_play_mode)
	
	for i in Enums.EDifficulty.values():
		_difficulty_select.add_item(Enums.EDifficulty.keys()[i])
	_difficulty_select.select(Globals.game_mode.difficulty)

func _unhandled_input(event):
	if event.is_action_pressed("DEBUG_god_mode"):
		_god_mode_button.pressed = !Globals.debug_god_mode
		get_tree().set_input_as_handled()
	if event.is_action_pressed("DEBUG_cycle_weapon"):
		cycle_weapon()
		get_tree().set_input_as_handled()
	if event.is_action_pressed("DEBUG_spawn_enemy"):
		if get_tree().paused: #Only spawn enemies while debugscreen is pausing
			spawn_enemy()
			get_tree().set_input_as_handled()

func toggle_god_mode():
	Globals.debug_god_mode = !Globals.debug_god_mode

func toggle_spawners():
	Globals.debug_spawners_on = !Globals.debug_spawners_on

func toggle_music():
	Globals.debug_mute_music = !Globals.debug_mute_music

func cycle_weapon():
	Globals.player.cycle_weapon()

func _on_Button_button_down():
	cycle_weapon()

func _on_SpawnersButton_toggled(_button_pressed):
	toggle_spawners()

func _on_MusicButton_toggled(_button_pressed):
	toggle_music()

func _on_GodModeButton_toggled(_button_pressed):
	toggle_god_mode()
	
func _on_WeaponSelection_item_selected(index):
	Globals.player.set_weapon(index)

func _on_EnemySelection_item_selected(index):
	_selected_enemy = Enums.ENME_Types.keys()[index]

func _on_GameModeSelection_item_selected(index):
	Globals.game_mode.set_play_mode(index)
	Globals.hud.open_screen(Globals.hud.debug_screen) #Reopen the hud when the game state has changed correctly.

func _on_DifficultySelection_item_selected(index):
	Globals.game_mode.set_difficulty(index)
	
func _on_LevelSelection_item_selected(index):
	Globals.level_loader.load_level(index)
	Globals.hud.open_screen(Globals.hud.debug_screen) #Reopen the hud when the level has changed correctly.

func spawn_enemy():
	#get random spawner
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand_index = rng.randi_range(0, get_tree().get_nodes_in_group("spawners").size() - 1)
	var rail = get_tree().get_nodes_in_group("spawners")[rand_index].rail
	var rail_node = get_tree().get_nodes_in_group("spawners")[rand_index].get_node(rail)
	
	# Spawn actual enemy
	# 1: Get the NUMBER of the enemy that is selected from the enum enemy types.
	var enemy_enum = Enums.ENME_Types.get(_selected_enemy)
	# 2: Spawn an instance (clone) of that enemy.
	var enemy = Utils.spawn(NMEList.GetPreloadedEnemy(enemy_enum), get_global_mouse_position(), 0.0)
	# 3: Add that instance to the level so it actually does something
	Globals.level.enemies_root.add_child(enemy)
	enemy.initialise({"rail" : rail_node}) #Add a rail because some enemies might need it such as the liner.
	# 4: Let the play state know this enemy exists so it despawns when the game ends. (The play state connects here when it's started)
	emit_signal("enemy_spawned", enemy)



