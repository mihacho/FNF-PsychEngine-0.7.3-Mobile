function onCreate()
  makeLuaSprite('blackScreen', 'nil', 0, 0)
  setObjectOrder('blackScreen', 80000);
  makeGraphic('blackScreen', screenWidth, screenHeight, '000000')
  addLuaSprite('blackScreen', true)
  setProperty('blackScreen.alpha', 1)
  setObjectCamera('blackScreen', 'other')
  end

function showBlackScreen(duration)
    doTweenAlpha('blackFadeIn', 'blackScreen', 1, duration, 'linear')
end

function hideBlackScreen(duration)
    doTweenAlpha('blackFadeOut', 'blackScreen', 0, duration, 'linear')
end

function onStartCountdown()
hideBlackScreen(2)
end

function onEvent(name,v1,v2)
    if name == 'Play Animation' then
        if v1 == 'black' then
            showBlackScreen(1)
		elseif v1 == 'bye' then
		    hideBlackScreen(0.01)
			end
		end
	end
	
function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'broblack' then
		runTimer('START', 3)
		showBlackScreen(1.4)
	end
	if tag == 'START' then
		hideBlackScreen(1)
	end
end
