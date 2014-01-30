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

ALLOWMESSAGETOGGLE = true

-- Globals

PLUGIN = {}
LOGPREFIX = ""
PLAYERLOCATIONS = {}
MESSAGE = {}

-- Plugin Start

function Initialize( Plugin )

        PLUGIN = Plugin

        Plugin:SetName( "SpawnPlus" )
        Plugin:SetVersion( 1 )

	LOGPREFIX = "["..Plugin:GetName().."] "

	-- Hooks
        cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving)

	-- Commands
	if ALLOWMESSAGETOGGLE then
	        cPluginManager.BindCommand("/togglespawnmessage", "spawnplus.togglemessage", ToggleMessages, " - Toggle the message upon entering and leaving spawn.")
	end

	LOG( LOGPREFIX .. "Plugin v" .. Plugin:GetVersion() .. " Enabled!" )
        return true
end

function OnDisable()
	LOG( LOGPREFIX .. "Plugin Disabled!" )
end

function ToggleMessages(Split, Player)
	if MESSAGE[Player:GetName()] == nil or MESSAGE[Player:GetName()] == true then
		MESSAGE[Player:GetName()] = false
		SendMessageSuccess(Player, "Spawn entry messages disabled!")
	else
		MESSAGE[Player:GetName()] = true	
		SendMessageSuccess(Player, "Spawn entry messages enabled!")
	end
	return true
end

function OnPlayerMoving(Player)

	local world = Player:GetWorld():GetName()
	local playerx = Player:GetPosX()
	local playery = Player:GetPosY()
	local playerz = Player:GetPosZ()
	local name = Player:GetName()
	
	if PLAYERLOCATIONS[name] ~= nil then
		if not IsInSpawn(PLAYERLOCATIONS[name]["x"], PLAYERLOCATIONS[name]["y"], PLAYERLOCATIONS[name]["z"], PLAYERLOCATIONS[name]["world"]) then
			if IsInSpawn(playerx, playery, playerz, world) then
				else if not MESSAGE[Player:GetName()] == false then
					Player:SendMessage("You have entered spawn!")
				end
			end
		else
			if not IsInSpawn(playerx, playery, playerz, world) then
				if not MESSAGE[Player:GetName()] == false then
					Player:SendMessage("You have exited spawn!")
				end
			end
		end
	end

	PLAYERLOCATIONS[name] = {x = playerx, y = playery, z = playerz, world = world}

end

function IsInSpawn(x, y, z, worldName)
	
	-- Get Spawn Coordinates for the World
	local world = cRoot:Get():GetWorld(worldName)
	local spawnx = world:GetSpawnX()
	local spawny = world:GetSpawnY()
	local spawnz = world:GetSpawnZ()
	
	-- Get protection radius from the Core plugin.
	local protectRadius = cPluginManager:CallPlugin("Core", "getSpawnProtectRadius", worldName)
	
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
