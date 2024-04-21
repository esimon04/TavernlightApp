--Callback to continually cause ice toranado animation 'count' times
function frigoCallback(cid, position, count)
	if Creature(cid) then
		if count > 0 then
			position:sendMagicEffect(CONST_ME_ICETORNADO)
			doAreaCombat(cid, COMBAT_ICEDAMAGE, position, 0, -100, -100, CONST_ME_ICETORNADO)
		end

		if count < 3 then
			count = count + 1
			addEvent(frigoCallback, 1000, cid, position, count)
		end
	end
end

--Needed to set 'count' to 0
function onTargetTile(creature, position)
	frigoCallback(creature:getId(), position, 0)
end

local combat = Combat()
--Pretty sure to get the area to be exactly how it was in the question video I would have to take apart the sprite.
--This was about the best area I could make to match it without doing it.
combat:setArea(createCombatArea(AREA_DIAMOND))
--Setting callback
combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")


function onCastSpell(creature, variant, isHotkey)
	return combat:execute(creature, variant)
end