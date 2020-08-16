AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

AccessorFunc( ENT, "partnername", "PartnerName" )

-- Collect properties
function ENT:KeyValue( key, value )

	if ( key == "partnername" ) then
		self:SetPartnerName( value )
		self:SetExit( ents.FindByName( value )[1] )

	elseif ( key == "width" ) then
		self:SetWidth( tonumber(value) )

	elseif ( key == "height" ) then
		self:SetHeight( tonumber(value))

	elseif ( key == "DisappearDist" ) then
		self:SetDisappearDist( tonumber(value) )

	elseif ( key == "angles" ) then
		local args = value:Split( " " )

		for k, arg in pairs( args ) do
			args[k] = tonumber(arg)
		end

		self:SetAngles( Angle( unpack(args) ) )

	end
end


function ENT:OnEnterPortal(ent)
	self.teleportingEnts[ent:EntIndex()] = ent:GetPos() - self:GetPos()
end


function ENT:OnExitPortal(ent)
	self.teleportingEnts[ent:EntIndex()] = ent:GetPos() - self:GetPos()
	
	// Call the hook
	hook.Run("OnEntExitPortal", ent, self)
end



ENT.teleportingEnts = {}

// Ran when an entity first touches the portal
function ENT:StartTouch( ent )
	if(ent:IsValid()) then
		self:OnEnterPortal(ent)

		/*
		local mvtype = ent:GetMoveType() 
		print(mvtype)
		if(mvtype != MOVETYPE_NOCLIP ) then 
			ent.previousMoveType = mvtype
		end
		ent:SetMoveType( MOVETYPE_NOCLIP )
		*/
	end

end

// ran every 'tick' while ent is touching
function ENT:Touch( ent )

	local offsetFromPortal = ent:GetPos() - self:GetPos()
	local portalSide	= self:SideOfPortal( offsetFromPortal )
	local portalSideOld = self:SideOfPortal( self.teleportingEnts[ent:EntIndex()] )
	
	if(portalSide != portalSideOld) then
		// ran if they have crossed through the portal
		local exit		= self:GetExit()

		local localPos	= self:WorldToLocal(ent:GetPos())
		local localAng	= self:WorldToLocalAngles(ent:GetAngles())

		local newPos	= exit:LocalToWorld(localPos)
		local newAng	= exit:LocalToWorldAngles(localAng)

		local localVel = ent:GetVelocity() - self:GetVelocity()
		
		local newVel = localVel
		newVel:Rotate(exit:GetAngles() - self:GetAngles())
		newVel = newVel + exit:GetVelocity()

		local oldMoveType = ent:GetMoveType()

		ent:SetLocalVelocity( newVel )

		// Actually does the teleportation :D
		ent:SetPos( newPos )
	
		// Players are annoying to set angles on
		if( ent:IsPlayer() ) then 
			ent:SetEyeAngles( newAng )
		else
			ent:SetAngles( newAng )
		end

		ent:SetMoveType( oldMoveType )

		self:OnExitPortal(ent)
			
		self.teleportingEnts[ent:EntIndex()] = NULL
	else
		// Ran every tick if they havent crossed portal
		self.teleportingEnts[ent:EntIndex()] = ent:GetPos() - self:GetPos()

	end
end

function ENT:EndTouch( ent )
	/*
	if(IsValid(ent)) then 

		// Remove Noclip

		if(ent:IsPlayer()) then
			ent:SetMoveType( MOVETYPE_WALK )
		else
			if( IsValid( ent:GetPhysicsObject()) ) then
				ent:SetMoveType( MOVETYPE_VPHYSICS )
			else
				ent:SetMoveType( MOVETYPE_NONE )
			end
		end
		
	end
	*/
	
	if(	IsValid( ent, self.teleportingEnts[ent:EntIndex()] ) ) then
		self.teleportingEnts[ent:EntIndex()] = NULL
	end
end
 
/// Returns true if the point is infront of the portal, false if they are not.
function ENT:SideOfPortal( relpos )
	local normal = self:GetForward()

	local dot = normal:Dot( relpos )

	if( dot > 0 ) then
		return true
	else
		return false
	end

end