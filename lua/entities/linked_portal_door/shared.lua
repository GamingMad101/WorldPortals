ENT.Type				= "anim"
ENT.Spawnable			= false
ENT.AdminOnly			= false
ENT.Editable			= false
ENT.Thickness			= 0 //(1/10000000000000000000)


--ENT.Model = Model("models/props/cs_office/microwave.mdl")

function ENT:Initialize()

	if CLIENT then

		self:SetTexture( GetRenderTarget("portal" .. self:EntIndex(),
			ScrW(),
			ScrH(),
			false
		) )
		
		local renderBounds = Vector( 1, self:GetWidth(), self:GetHeight() )
		
		self:SetRenderBounds( -renderBounds , renderBounds )

	else

		self:SetTrigger(true)

	end

	local physicsBounds = Vector( self.Thickness, self:GetWidth(), self:GetHeight() )

	physicsBounds:Rotate(self:GetAngles())

	self:PhysicsInitBox( -physicsBounds, physicsBounds )
	//self:SetMoveType(MOVETYPE_NONE)

	self:SetNotSolid( true )
	self:EnableCustomCollisions( true )
	self:DrawShadow( false )

end


--[[ Temporatily disabled
// Following code teleports traces going through the portal
local sent_contents = CONTENTS_GRATE

function ENT:TestCollision(startpos, delta, isbox, extents, mask)
	// Delta is the direction of travel
	if (bit.band( mask, sent_contents ) != 0 ) then return true end
	
	local exit	= self:GetExit()
	
	local hitPoint			= util.IntersectRayWithPlane( startpos, delta, self:GetPos() , self:GetForward() )
	//print( hitPoint )
	if(IsValid(hitPoint)) then
		localHitpoint		= self:WorldToLocal(hitPoint)
		exitStartPoint		= exit:LocalToWorld(localHitpoint)
		//print( exitStartPoint )

		delta:Rotate( exit:GetAngles() - self:GetAngles	() )
		
		local trace	= util.QuickTrace(  exitStartPoint , delta:GetNormalized() * 16384 )
		//print("--- \n")
		//PrintTable( trace )
		
		local melon = ents.Create("prop_physics")
		melon:SetModel("models/props_junk/watermelon01.mdl")
		melon:SetPos(trace.HitPos)
		melon:Spawn()

		return 
		{
			Hitpos		= trace.HitPos,
			Fraction	= trace.Fraction,
			Normal		= trace.Normal
		}
	end

end
]]--

function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "Exit" )
	self:NetworkVar( "Int", 1, "Width" )
	self:NetworkVar( "Int", 2, "Height" )
	self:NetworkVar( "Int", 3, "DisappearDist" )
	
	self:NetworkVar( "Bool", 0, "OneSided" )

end
