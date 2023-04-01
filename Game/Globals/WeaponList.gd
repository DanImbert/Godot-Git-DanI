extends Node
#preloads all weapons in game so they can be requested by player
#When making a new weapon, add it to the enum in Enums and the _weapons array below in the same order. This way, the enum corresponds to the position in the _weapons array

const Weap_Pistol = preload("res://Weapons/Player/Weap_Pistol.tscn")
const Weap_MachineGun = preload("res://Weapons/Player/Weap_MachineGun.tscn")
const Weap_MiniGun = preload("res://Weapons/Player/Weap_MiniGun.tscn")
const Weap_BurstRifle = preload("res://Weapons/Player/Weap_BurstRifle.tscn")
const Weap_Shotgun = preload("res://Weapons/Player/Weap_Shotgun.tscn")
const Weap_Bazooka = preload("res://Weapons/Player/Weap_Bazooka.tscn")
const Weap_Melee = preload("res://Weapons/Player/Weap_Melee.tscn")
const Weap_Mine = preload("res://Weapons/Player/Weap_Mine.tscn")
const Weap_DiscGun = preload("res://Weapons/Player/Weap_DiscGun.tscn")
const Weap_Boomerang = preload("res://Weapons/Player/Weap_Boomerang.tscn")

const _weapons = [ Weap_Pistol, Weap_MachineGun, Weap_MiniGun, Weap_BurstRifle, Weap_Shotgun, Weap_Bazooka, Weap_Melee, Weap_Mine, Weap_DiscGun, Weap_Boomerang]

func GetPreloadedWeapon(weapon_type = Enums.EPlayerWeaponTypes.PISTOL): 
	return _weapons[weapon_type]
	
func GetNextWeaponType(weapon_type = Enums.EPlayerWeaponTypes.PISTOL):
	var weapon_number = int(weapon_type) + 1
	weapon_number %= _weapons.size()
	return weapon_number

func GetRandomWeaponType(last_weapon_type = Enums.EPlayerWeaponTypes.PISTOL):
	var weapon_number = randi() % _weapons.size()  # get random 32-bit integer, and 'wrap' it between 0 and size
	if weapon_number != int(last_weapon_type):
		return weapon_number
	else:
#		If we get a random type that is the same as the one we had, just getnextweapon
		return GetNextWeaponType(last_weapon_type)

