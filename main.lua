-- Copyright (c) 2012-2014 Alexander Harkness

-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:

-- The above copyright notice and this permission notice shall be included
-- in all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


-- Configuration

-- Sorry, there isn't any yet :(

-- Globals

PLUGIN = {}
LOGPREFIX = ""
PLAYERLOCATIONS = {}

-- Plugin Start

function Initialize( Plugin )

        PLUGIN = Plugin

        Plugin:SetName( "SpawnPlus" )
        Plugin:SetVersion( 1 )

	LOGPREFIX = "["..Plugin:GetName().."] "

        cPluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving)

	LOG( LOGPREFIX .. "Plugin v" .. Plugin:GetVersion() .. " Enabled!" )
        return true
end

function OnDisable()
	LOG( LOGPREFIX .. "Plugin Disabled!" )
end

function OnPlayerMoving(Player)

	local world = Player:GetWorld()
	local playerx = Player:GetPosX()
	local playery = Player:GetPosY()
	local playerz = Player:GetPosZ()
	local name = Player:GetName()
	
	if PLAYERLOCATIONS[name] ~= nil then
		if not IsInSpawn(PLAYERLOCATIONS[name]["x"], PLAYERLOCATIONS[name]["y"], PLAYERLOCATIONS[name]["z"], PLAYERLOCATIONS[name]["world"])
			if not IsInSpawn(playerx, playery, playerz, world) then
				-- Do nothing, the player isn't in spawn, and they weren't
			else
				Player:SendMessage("You have entered spawn!")
			end
		else
			if not IsInSpawn(playerx, playery, playerz, world) then
				Player:SendMessage("You have exited spawn!")
			else
				-- Do nothing, the player was in spawn, they still are.
			end
		end
	end

	PLAYERLOCATIONS[name] = {x = playerx, y = playery, z = playerz, world = world}

end

function IsInSpawn(x, y, z, world)
	
	-- Get Spawn Coordinates for the World
	local spawnx = world:GetSpawnX()
	local spawny = world:GetSpawnY()
	local spawnz = world:GetSpawnZ()
	
	-- Get protection radius from the Core plugin.
	local protectRadius = cPluginManager:CallPlugin("Core", "getSpawnProtectRadius", world)
	
	-- Check if the specified coords are in the spawn.
	if not ((x <= (spawnx + protectRadius)) and (x >= (spawnx - protectRadius))) then
                return false -- Not in spawn area.
        end
        if not ((y <= (spawny + protectRadius)) and (y >= (spawny - protectRadius))) then 
                return false -- Not in spawn area.
        end
        if not ((z <= (spawnz + protectRadius)) and (z >= (spawnz - protectRadius))) then 
                return false -- Not in spawn area.
        end
        
        -- They must be in spawn now :)
        return true
end
