//=============================================================================
// TCowBot.
//=============================================================================
class CowFixJRM26 extends CustomBot;

simulated function SetMyMesh()
{
	Super.SetMyMesh();
	bIsMultiSkinned = true;
}
static function SetMultiSkin(Actor SkinActor, string SkinName, string FaceName, byte TeamNum)
{
	local string SkinItem, SkinPackage;

	if ( SkinName == "" )
		SkinName = default.DefaultSkinName;
	else
	{
		SkinItem = SkinActor.GetItemName(SkinName);
		SkinPackage = Left(SkinName, Len(SkinName) - Len(SkinItem));
	
		if( SkinPackage == "" )
		{
			SkinPackage = default.DefaultCustomPackage;
			SkinName = SkinPackage $ SkinName;
		}
	}
	
	// Slot 1: Body (Not team-based)
	if( !SetSkinElement(SkinActor, 1, SkinName$"1", default.DefaultSkinName$"1") )
		SkinName = default.DefaultSkinName;

	// Slot 2: Backpack (Team-based)
	if( TeamNum < 4 )
		SetSkinElement(SkinActor, 2, SkinName$"2T_"$String(TeamNum), SkinName$"2");
	else
		SetSkinElement(SkinActor, 2, SkinName$"2", SkinName$"2");

	// Slot 3: Face (Customizable, non-team)
	SetSkinElement(SkinActor, 3, SkinName$"3"$FaceName, default.DefaultSkinName$"3"$default.DefaultFace);

	// Set the TalkTexture (UI Portrait)
	if( Pawn(SkinActor) != None )
	{
		if ( FaceName != "" )
			Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject(SkinName$"5"$FaceName, class'Texture'));
		
		if ( Pawn(SkinActor).PlayerReplicationInfo.TalkTexture == None )
			Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject(default.DefaultFace, class'Texture'));
	}
}

// special animation functions
function PlayDying(name DamageType, vector HitLoc)
{
	if ( Mesh == FallBackMesh )
	{
		Super.PlayDying(DamageType, HitLoc);
		return;
	}
	BaseEyeHeight = Default.BaseEyeHeight;
	PlayDyingSound();
			
	if ( DamageType == 'Suicided' )
	{
		PlayAnim('Dead2',, 0.1);
		return;
	}

	// check for head hit
	if ( DamageType == 'Decapitated' )
	{
		PlayCowDecap();
		return;
	}

	// check for big hit
	if ( Velocity.Z > 200 )
	{
		PlayAnim('Dead3',,0.1);
		return;
	}

	if ( HitLoc.Z - Location.Z > 0.7 * CollisionHeight )
	{
		PlayAnim('Dead2',, 0.1);
		return;
	}
	
	PlayAnim('Dead1',, 0.1);
}

function PlayCowDecap()
{
	local carcass carc;

	if ( class'GameInfo'.Default.bVeryLowGore )
	{
		PlayAnim('Dead2',, 0.1);
		return;
	}

	PlayAnim('Dead4',, 0.1);
	if ( Level.NetMode != NM_Client )
	{
		carc = Spawn(class 'TCowHead',,, Location + CollisionHeight * vect(0,0,0.8), Rotation + rot(3000,0,16384) );
		if (carc != None)
		{
			carc.Initfor(self);
			carc.RemoteRole = ROLE_SimulatedProxy;
			carc.Velocity = Velocity + VSize(Velocity) * VRand();
			carc.Velocity.Z = FMax(carc.Velocity.Z, Velocity.Z);
		}
	}
}

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=LODMESH'TCowNewJRM'
	DefaultSkinName ="ATOMIC"
	DefaultCustomPackage="CowFixJRM26Skins"
}