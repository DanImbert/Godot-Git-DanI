extends Node
class_name NME_List
#preloads all enemies in game so they can be requested by spawners
#When making a new enemy, add it to the enum in Enums and the _enemies array below in the same order

const NME_Swarmer = preload("res://Enemies/NME_Swarmer.tscn")
const NME_Liner = preload("res://Enemies/NME_Liner.tscn")
const NME_Ranger = preload("res://Enemies/NME_Ranger.tscn")
const NME_Blob = preload("res://Enemies/NME_Blob.tscn")
const NME_Blobette = preload("res://Enemies/NME_Blobette.tscn")
const NME_FlagSwarmer = preload("res://Enemies/NME_FlagSwarmer.tscn")
const _enemies = [NME_Swarmer, NME_Liner, NME_Ranger, NME_Blob, NME_Blobette, NME_FlagSwarmer]

func GetPreloadedEnemy(NME_type = Enums.ENME_Types.SWARMER): 
	return _enemies[NME_type]

func GetRandomEnemyType():
	return _enemies[rand_range(0,_enemies.size())]
