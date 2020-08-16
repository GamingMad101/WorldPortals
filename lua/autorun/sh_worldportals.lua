worldportals = {}

// Include the files from the worldportals subfolder
if SERVER then
	
	AddCSLuaFile("worldportals/render_cl.lua")
	AddCSLuaFile("worldportals/sh_makegunswork.lua")
	include("worldportals/render_sv.lua")
	include("worldportals/sv_orientplayers.lua")

elseif CLIENT then

	include("worldportals/render_cl.lua")

end
include("worldportals/sh_makegunswork.lua")
