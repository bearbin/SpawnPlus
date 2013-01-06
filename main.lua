-- Copyright (c) 2012 Alexander Harkness

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

PROTECTRADIUS = 10
LOGBLOCKS     = true

-- Globals

PLUGIN = {}
LOGPREFIX = ""

-- Plugin Start

function Initialize( Plugin )

        PLUGIN = Plugin

        Plugin:SetName( "SpawnProtect" )
        Plugin:SetVersion( 5 )

	LOGPREFIX = "["..Plugin:GetName().."] "

        PluginManager = cRoot:Get():GetPluginManager()
        PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_PLACING_BLOCK)
        PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_BREAKING_BLOCK)
        
	LOG( LOGPREFIX .. "Plugin v" .. Plugin:GetVersion() .. " Enabled!" )
        return true
end

function OnDisable()
	LOG( LOGPREFIX .. "Plugin Disabled!" )
end

function WriteLog(breakPlace, X, Y, Z, player)
	local breaker = ""
	if breakPlace == 0 then
		breaker = "break"
	else
		breaker = "place"
	end
	local logFile = io.open('Plugins/SpawnProtect/blocks.log', 'a')
	logFile:write(player.." tried to "..breaker.." a block at : "..X..","..Y..","..Z.."!\n")
	logFile:close()
end
