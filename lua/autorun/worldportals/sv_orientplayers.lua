hook.Add("OnEntExitPortal", "reorientPlayer", function( ply , portal)
    // If the entity isn't a player, do nothing.
    if( !ply:IsPlayer() ) then return end

    local plyAngles = ply:EyeAngles()
    
    if(plyAngles.r != 0) then
        // if the player is not already upright, do stuff to make them upright

        local absUp     = Angle( plyAngles.p , plyAngles.y, 0 )
        local relAngle  = absUp - plyAngles

        local divisions = 40

        timer.Create("reorientPlayer" .. ply:UserID(), (1/60),  divisions , function()    
            ply:SetEyeAngles( ply:EyeAngles() + ( relAngle / divisions ) )
        end)
    else

        // if the player is already upright, do nothing
        return 
    
    end
end)