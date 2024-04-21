local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREWORK_RED)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)



function onCastSpell(creature, variant)
	local teleportDistance = 4;
	local dir = creature:getDirection()

	--Loops through the 4 tiles infront of player and moves player to any tile not blocked by something.
    --As soon as a blocked file is found it breaks the loop and leaves player on the previous tile.
    for i = 1, teleportDistance do 
        local currPos = creature:getPosition()
        currPos:getNextPosition(dir, 1)
        local tile = Tile(currPos)
        if tile then
            if tile:hasFlag(TILESTATE_BLOCKSOLID) == false and tile:hasFlag(TILESTATE_FLOORCHANGE) == false then
                local pathing = creature:getPathTo(currPos,0,0,true,false)
                if pathing then
                    creature:move(dir)
                    currPos:sendMagicEffect(CONST_ME_FIREWORK_RED) --where the effect in the video would go, just using red firework for show
                else
                    break
                end
            else
                break
            end
        else
            break
        end
    end



	return combat:execute(creature, variant)
end

