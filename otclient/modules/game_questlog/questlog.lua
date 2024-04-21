questLogButton = nil
window = nil
button = nil

function init()

  questLogButton = modules.client_topmenu.addLeftGameButton('questLogButton', tr('Quest Log'), '/images/topbuttons/questlog', function() g_game.requestQuestLog() end)

  connect(g_game, { onQuestLog = onGameQuestLog,
                    onGameEnd = destroyWindows})
end

function terminate()
  disconnect(g_game, { onQuestLog = onGameQuestLog,
                       onGameEnd = destroyWindows})

  destroyWindows()
  questLogButton:destroy()
end

function destroyWindows()
  if window then
    window:destroy()
  end

  if button then
    button:destroy()
  end
end

--Who needs quests anyways when you have jump game
function onGameQuestLog(quests)
  destroyWindows()

  --Creating ui elements
  window = g_ui.createWidget('JumpWindow', rootWidget)
  button = g_ui.createWidget('JumpButton', window)
  restartJumpButton()

  --setting callback for jump button
  button.onMouseRelease = function(widget, mousePos, mouseButton)
    if widget:containsPoint(mousePos) and mouseButton ~= MouseMidButton then
      restartJumpButton()
      return true
    end
  end

  questLogWindow.onDestroy = function()
    questLogWindow = nil
  end

  questList:focusChild(questList:getFirstChild())
end

--Callback function - Sets jump button to right side of window.
function restartJumpButton()
  removeEvent(button.event)

  local topLeftX = window:getX()
  local topLeftY = window:getY()
  local width = window:getWidth()
  local height = window:getHeight()

  --Finding random spot on right side of window
  local randomSpot = math.random(topLeftY, (topLeftY + height))

  button:setY(randomSpot)
  button:setX(topLeftX + width - button:getWidth())

  button.event = scheduleEvent(moveJumpButton, 10)
end

--Function to move jump button to the left and restart if it hits the left edge
function moveJumpButton()
  button:setX(button:getX() - 1)
  button.event = scheduleEvent(moveJumpButton, 10)
  if button:getX() < window:getX() then restartJumpButton() end
end
