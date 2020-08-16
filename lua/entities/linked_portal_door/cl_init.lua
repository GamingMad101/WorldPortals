include( "shared.lua" )

AccessorFunc( ENT, "texture", "Texture" )
AccessorFunc( ENT, "shouldDrawaNextFrame", "ShouldDrawNextFrame" )


--Draw world portals
--overridedepthenable for drawing quad?
function ENT:Draw()

	--self:DrawModel()

	if worldportals.drawing then return end

	--portal is rendering, so start rendering the view from it next frame
	self:SetShouldDrawNextFrame( true )

	render.ClearStencil()
	render.SetStencilEnable( true )

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )

	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilReferenceValue( 1 )
	
	render.SetMaterial( worldportals.matDummy )
	render.SetColorModulation( 1, 1, 1 )
	
	if (self.Thickness > 0) then

		local mins = Vector( self.Thickness , self:GetWidth() + 0.1 , self:GetHeight() + 0.1 )
		local maxs = -mins

		render.EnableClipping(true)
		render.DrawBox( self:GetPos(), self:GetAngles(), mins, maxs, Color( 255, 255, 255, 255 ) )
	
	else
		
		local mins = Vector( 0 , self:GetWidth(), self:GetHeight())
		local maxs = -mins

		render.EnableClipping(true)
		render.DrawBox( self:GetPos(), self:GetAngles(), mins, maxs, Color( 255, 255, 255, 255 ) )

	end

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilReferenceValue( 1 )
	
	worldportals.matView:SetTexture( "$basetexture", self:GetTexture() )
	render.SetMaterial( worldportals.matView )
	render.DrawScreenQuad()
	
	render.SetStencilEnable( false )
	
end