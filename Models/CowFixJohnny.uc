//=============================================================================
// CowFixJohnny.
//=============================================================================
class CowFixJohnny expands actor;

#exec MESH IMPORT MESH=TCowNewJRM ANIVFILE=Models\CowFixJohnny_a.3d DATAFILE=Models\CowFixJohnny_d.3d X=0 Y=0 Z=0 LODSTYLE=10 LODFRAME=0 
#exec MESH ORIGIN MESH=TCowNewJRM X=0 Y=0 Z=0 YAW=-64 PITCH=0 ROLL=0

#exec MESH SEQUENCE MESH=TCowNewJRM SEQ=ALL    STARTFRAME=0 NUMFRAMES=281 RATE=24
#exec MESH SEQUENCE MESH=TCowNewJRM SEQ=Still    STARTFRAME=0 NUMFRAMES=1 RATE=24

#exec MESHMAP NEW MESHMAP=TCowNewJRM MESH=TCowNewJRM
#exec MESHMAP SCALE MESHMAP=TCowNewJRM X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=LoSpec500.png FILE=Textures\LoSpec500.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SETTEXTURE MESHMAP=TCowNewJRM NUM=0 TEXTURE=LoSpec500.png

#exec TEXTURE IMPORT NAME=Texture FILE=Textures\Texture.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SETTEXTURE MESHMAP=TCowNewJRM NUM=1 TEXTURE=Texture

#exec TEXTURE IMPORT NAME=BakeFaceCow FILE=Textures\BakeFaceCow.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SETTEXTURE MESHMAP=TCowNewJRM NUM=2 TEXTURE=BakeFaceCow

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=TCowNewJRM
}