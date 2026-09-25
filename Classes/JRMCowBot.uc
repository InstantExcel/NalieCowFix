//=============================================================================
// TCowBot.
//=============================================================================
class JRMCowBot extends CustomBot;

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
	MatchingPlayerClass=Class'CowFixJRM26.JRMCowPlayer'
	CarcassType=Class'tcowcarcass'
	drown=Sound'UnrealShare.Male.MDrown1'
	breathagain=Sound'UnrealShare.Nali.cough1n'
	Footstep1=Sound'UnrealShare.Cow.walkC'
	Footstep2=Sound'UnrealShare.Cow.walkC'
	Footstep3=Sound'UnrealShare.Cow.walkC'
	HitSound3=Sound'UnrealShare.Cow.injurC1c'
	HitSound4=Sound'UnrealShare.Cow.cMoo2c'
	Deaths(0)=Sound'UnrealShare.Cow.DeathC1c'
	Deaths(1)=Sound'UnrealShare.Cow.DeathC1c'
	Deaths(2)=Sound'UnrealShare.Cow.DeathC1c'
	Deaths(3)=Sound'UnrealShare.Cow.DeathC1c'
	Deaths(4)=Sound'UnrealShare.Cow.cMoo2c'
	Deaths(5)=Sound'UnrealShare.Cow.cMoo2c'
	GaspSound=Sound'UnrealShare.Nali.breath1n'
	UWHit1=Sound'UnrealShare.Male.MUWHit1'
	UWHit2=Sound'UnrealShare.Male.MUWHit2'
	LandGrunt=Sound'UnrealShare.Male.lland01'
	JumpSound=Sound'UnrealShare.Male.MJump1'
	HitSound1=Sound'UnrealShare.Cow.injurC1c'
	HitSound2=Sound'UnrealShare.Cow.injurC2c'
	MenuName="Nali Cow Fixed"
	VoiceType="MultiMesh.CowVoice"
	Mesh=LodMesh'CowFixJRM26.TCowNewJRM'
	SelectionMesh="CowFixJRM26.TCowNewJRM"

	  DefaultSkinName="CowFixJRM26Skins.ATMC"
      DefaultPackage="CowFixJRM26Skins."
	  DefaultCustomPackage="CowFixJRM26Skins."
      DefaultFace="Default"
      TeamSkin="ATMC1T_"
      HighestSkinNumber=2
      ChangesWithTeam(1)=1
      ChangesWithFace(0)=0
	  ChangesWithFace(1)=0
	  ChangesWithFace(2)=0
	  ChangesWithFace(3)=0
      DefaultFace="Default"
      bIsMultiSkinned=True
	  
	  MultiSkins(0)=Texture'CowFixJRM26Skins.ATMC0'
	  MultiSkins(1)=Texture'CowFixJRM26Skins.ATMC1'
	  MultiSkins(2)=Texture'CowFixJRM26Skins.ATMC2Default'

}