-- Copyright (c) 2012-2013 Alexander Harkness

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

LOADNB        = false
PROTECTRADIUS = 10
WARNPLAYER    = true
-- Logging
LOGTOCONSOLE  = true
LOGTOFILE     = true
LOGPLAYERNAME = true
LOGBLOCKNAMES = false

-- Globals

PLUGIN = {}
LOGPREFIX = ""
NAMEDBLOCKS = nil

-- Plugin Start

function Initialize( Plugin )

        PLUGIN = Plugin

        Plugin:SetName( "SpawnProtect" )
        Plugin:SetVersion( 7 )

	LOGPREFIX = "["..Plugin:GetName().."] "

        PluginManager = cRoot:Get():GetPluginManager()
        PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_PLACING_BLOCK)
        PluginManager:AddHook(Plugin, cPluginManager.HOOK_PLAYER_BREAKING_BLOCK)
        
	if LOADNB then
		NAMEDBLOCKS = PluginManager:GetPlugin("NamedBlocks")
	end

	if LOGBLOCKNAMES and (not LOADNB) then
		LOGWARN( LOGPREFIX .. "Logging of blocks is enabled, but NamedBlocks loading is not." )
		LOGWARN( LOGPREFIX .. "Logging of block names will not be done, then.")
	end

	LOG( LOGPREFIX .. "Plugin v" .. Plugin:GetVersion() .. " Enabled!" )
        return true
end

function OnDisable()
	LOG( LOGPREFIX .. "Plugin Disabled!" )
end

function WriteLog(breakPlace, X, Y, Z, player, id, meta)

	if not (LOGTOCONSOLE or LOGTOFILE) then
		return
	end

	local logText = {}

	if LOGPLAYERNAME then
		table.insert(logText, player)
	else
		table.insert(logText, "Player")
	end

	table.insert(logText, " tried to ")

	if breakPlace == 0 then
		table.insert(logText, "break ")
	else
		table.insert(logText, "place ")
	end

	if LOGBLOCKNAMES and NAMEDBLOCKS then
		table.insert(logText, NAMEDBLOCKS:Call("GetBlockName", id, meta))
	else
		table.insert(logText, "a block")
	end

	table.insert(logText, " at ")
	table.insert(logText, tostring(X))
	table.insert(logText, ", ")
	table.insert(logText, tostring(Y))
	table.insert(logText, ", ")
	table.insert(logText, tostring(Z))
	table.insert(logText, ".")

	if LOGTOCONSOLE then
		LOG(LOGPREFIX..table.concat(logText,''))
	end

	if LOGTOFILE then
		local logFile = io.open('Plugins/SpawnProtect/blocks.log', 'a')
		logFile:write(table.concat(logText,'').."\n")
		logFile:close()
	end

	return

end

function WarnPlayer(Player)
	Player:SendMessage("You don't have permission to build here - go further from spawn.")
	return
end
