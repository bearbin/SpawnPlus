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

function OnPlayerPlacingBlock( Player, X, Y, Z, blockFace, cx, cy, cz, id, meta )

	if Player:HasPermission("SpawnProtect.bypass") then
		return false -- Player has permissions to build here.
	end

	local World = Player:GetWorld()
	local xcoord = World:GetSpawnX()
	local ycoord = World:GetSpawnY()
	local zcoord = World:GetSpawnZ()

	if not ((X <= (xcoord + PROTECTRADIUS)) and (X >= (xcoord - PROTECTRADIUS))) then
		return false -- Not in spawn area.
	end
	if not ((Y <= (ycoord + PROTECTRADIUS)) and (Y >= (ycoord - PROTECTRADIUS))) then 
                return false -- Not in spawn area.
        end
	if not ((Z <= (zcoord + PROTECTRADIUS)) and (Z >= (zcoord - PROTECTRADIUS))) then 
                return false -- Not in spawn area.
        end

	if WARNPLAYER then
		WarnPlayer(Player)
	end

	WriteLog(1, X, Y, Z, Player:GetName(), id, meta)

	return true

end
