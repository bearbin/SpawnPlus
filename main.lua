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


-- Global Variables

PLUGIN = {}
PROTECTRADIUS = 10

-- Plugin Start

function Initialize( Plugin )

        PLUGIN = Plugin
        
        Plugin:SetName( "SpawnProtect" )
        Plugin:SetVersion( 3 )        

        PluginManager = cRoot:Get():GetPluginManager()
        PluginManager:AddHook(Plugin, cPluginManager.HOOK_BLOCK_PLACE)
        PluginManager:AddHook(Plugin, cPluginManager.HOOK_BLOCK_DIG)
        
	function file_exists(file)
		local f = io.open(file, "r")
		if f then f:close() end
		return f ~= nil
	end

	if file_exists('Plugins/SpawnProtect/radius.txt') then
		local radiusFile = io.open('Plugins/SpawnProtect/radius.txt', 'r')		
		local radius = tonumber(radiusFile:read('*all'))
		radiusFile:close()
		if radius > 0 then
			LOG("[SpawnProtect] Spawn radius overridden!")
			LOG("[SpawnProtect] Radius is now "..PROTECTRADIUS.."!")
		else
			LOG("[SpawnProtect] Misformed radius.txt, please try again.")
		end
	end

	LOG( "Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion() )
        return true
end

