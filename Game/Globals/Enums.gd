extends Node
class_name Enums
#Class that has Enums that need to be accessed by multiple objects

enum EPlayerWeaponTypes{
	PISTOL,
	MACHINEGUN,
	MINIGUN,
	BURSTRIFLE,
	SHOTGUN,
	BAZOOKA,
	MELEE,
	MINE,
	DISCGUN,
	BOOMERANG
}

enum EPlayerControllerType{
	GAMEPAD
	MOUSE
}

enum ENME_Types{
	SWARMER,
	LINER,
	RANGER,
	BLOB
	BLOBETTE
}

enum EPlayModes{
	FLAG,
	CRATEBOX,
	SURVIVAL,

}

enum EDifficulty{
	EASY,
	NORMAL,
	HARD,
}

enum ELevels{
	MAIN
	GYM_RENE
	GYM_DAN
}

enum EFollowType{ #enum for Move_FollowPath
	LOOP,
	STOPATEND,
	PINGPONG,
	}
