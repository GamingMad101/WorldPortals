hook.Add("EntityFireBullets", "worldPortalsBullets", function( ent, data) 
    //PrintTable(data)
   
   
    // loop through each portal and see if it is hit, if it is, then 'teleport' the bullet to the other side
    for _,portal in pairs(ents.FindByClass("linked_portal_door")) do
        local exit = portal:GetExit()
        if(IsValid( exit )) then

            local intersectPos = util.IntersectRayWithPlane(data.Src, data.Dir, portal:GetPos(), portal:GetForward())

            if(isvector(intersectPos)) then

                local localIntersectPoint = portal:WorldToLocal( intersectPos )
                if( math.abs(localIntersectPoint.y) < portal:GetHeight() &&
                    math.abs(localIntersectPoint.z) < portal:GetWidth() ) then
                    local localIntersectAngle = portal:WorldToLocalAngles(data.Dir:Angle())

                    data.Dir = exit:LocalToWorldAngles( localIntersectAngle ):Forward()
                    data.Src = exit:LocalToWorld( localIntersectPoint )
                
                    return true
                end
            end
        end
    end
end)