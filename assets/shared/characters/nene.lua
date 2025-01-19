local pupilState = 0

local PUPIL_STATE_NORMAL = 0
local PUPIL_STATE_LEFT = 1

function onCreatePost()
luaDebugMode = true;
makeLuaSprite('stereoBG', "characters/abot/stereoBG", 0, 0);

makeLuaSprite('eyeWhites')
makeGraphic('eyeWhites', 160, 60, 'FFFFFF')

makeFlxAnimateSprite('pupil', 0, 0)
loadAnimateAtlas('pupil',"characters/abot/systemEyes")
setProperty('pupil.x',getProperty('gf.x'))
setProperty('pupil.y',getProperty('gf.y'))

makeFlxAnimateSprite('abot', 0, 0)
loadAnimateAtlas('abot',"characters/abot/abotSystem")
setProperty('abot.x',getProperty('gf.x'))
setProperty('abot.y',getProperty('gf.y'))

visFrms = "aBotViz"
visStr = "viz"

positionX = {0, 59, 56, 66, 54, 52, 51}
positionY = {0, -8, -3.5, -0.4, 0.5, 4.7, 7}

makeAnimatedLuaSprite('viz1', visFrms, 0, 0)

addAnimationByPrefix('viz1', 'VIZ', visStr..1, 0);
playAnim('viz1', 'VIZ', false, false, 6);

makeAnimatedLuaSprite('viz2', visFrms, 59, -8)

addAnimationByPrefix('viz2', 'VIZ', visStr..2, 0);
playAnim('viz2', 'VIZ', false, false, 6);

makeAnimatedLuaSprite('viz3', visFrms, 115, -11.5)

addAnimationByPrefix('viz3', 'VIZ', visStr..3, 0);
playAnim('viz3', 'VIZ', false, false, 6);

makeAnimatedLuaSprite('viz4', visFrms, 181, -11.9)

addAnimationByPrefix('viz4', 'VIZ', visStr..4, 0);
playAnim('viz4', 'VIZ', false, false, 6);

makeAnimatedLuaSprite('viz5', visFrms, 235, -11.4)

addAnimationByPrefix('viz5', 'VIZ', visStr..5, 0);
playAnim('viz5', 'VIZ', false, false, 6);

makeAnimatedLuaSprite('viz6', visFrms, 287, -6.7)

addAnimationByPrefix('viz6', 'VIZ', visStr..6, 0);
playAnim('viz6', 'VIZ', false, false, 6);

makeAnimatedLuaSprite('viz7', visFrms, 338, 0.3)

addAnimationByPrefix('viz7', 'VIZ', visStr..7, 0);
playAnim('viz7', 'VIZ', false, false, 6);
end

local refershedLol = false
local VULTURE_THRESHOLD = 0.25 * 2
local STATE_DEFAULT = 0
local STATE_PRE_RAISE = 1
local STATE_RAISE = 2
local STATE_READY = 3
local STATE_LOWER = 4
local currentState = STATE_DEFAULT
local MIN_BLINK_DELAY = 3
local MAX_BLINK_DELAY = 7
local blinkCountdown = MIN_BLINK_DELAY

local start = false

function onUpdatePost()
setProperty('abot.visible',getProperty('gf.visible'))
setProperty('eyeWhites.visible',getProperty('gf.visible'))
setProperty('pupil.visible',getProperty('gf.visible'))
setProperty('stereoBG.visible',getProperty('gf.visible'))
for i = 1,7 do
setProperty('viz'..i..'.visible',getProperty('gf.visible'))
end

if start then
drawFFT()
end

if getProperty('pupil.anim.isPlaying') then
if pupilState == PUPIL_STATE_NORMAL then
if getProperty('pupil.anim.curFrame') >= 17 then
pupilState = PUPIL_STATE_LEFT
runHaxeCode([[
game.getLuaObject('pupil').anim.pause();
]])
end
elseif pupilState == PUPIL_STATE_LEFT then
if getProperty('pupil.anim.curFrame') >= 31 then
pupilState = PUPIL_STATE_NORMAL
runHaxeCode([[
game.getLuaObject('pupil').anim.pause();
]])
end
end
end

if not refershedLol then
setProperty('abot.x',getProperty('gf.x') - 100)
setProperty('abot.y',getProperty('gf.y') + 316)

for i = 1,7 do
setProperty('viz'..i..'.x',getProperty('viz'..i..'.x') + getProperty('gf.x') + 100)
setProperty('viz'..i..'.y',getProperty('viz'..i..'.y') + getProperty('gf.y') + 400)
end

setProperty('abot.x',getProperty('gf.x') - 100)
setProperty('abot.y',getProperty('gf.y') + 316)

setProperty('eyeWhites.x',getProperty('abot.x') + 40)
setProperty('eyeWhites.y',getProperty('abot.y') + 250)

setProperty('pupil.x',getProperty('gf.x') - 607)
setProperty('pupil.y',getProperty('gf.y') - 176)

setProperty('stereoBG.x',getProperty('abot.x') + 150)
setProperty('stereoBG.y',getProperty('abot.y') + 30)

addLuaSprite('stereoBG', false);
for i = 1,7 do
addLuaSprite('viz'..i, false)
end
addLuaSprite('eyeWhites', false);
addLuaSprite('pupil', false);
addLuaSprite('abot', false);

refershedLol = true
end

if shouldTransitionState() then
transitionState()
end

if getProperty('gf.animation.curAnim.finished') then
onAnimationFinished(getProperty('gf.animation.curAnim.name'))
end

if getProperty('gf.animation.curAnim') ~= nil then
onAnimationFrame(getProperty('gf.animation.curAnim.name'), getProperty('gf.animation.curAnim.curFrame'), getProperty('gf.animation.curAnim.frameIndex'))
end
end

function onSongStart()
start = true
end

local gfSpeed = 1;

function onBeatHit()
if getProperty('gfSpeed') ~= 10000000 then
gfSpeed = getProperty('gfSpeed');
setProperty('gfSpeed',10000000)
end
if not getProperty('gf.specialAnim') then
if getProperty('gf') ~= nil and curBeat % math.floor(gfSpeed * getProperty('gf.danceEveryNumBeats')) == 0 and not getProperty('gf.stunned') then
dance(true)
end
end
end

function onMoveCamera(focus)
if focus == "boyfriend" then
movePupilsRight()
elseif focus == "dad" then
movePupilsLeft()
end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
if noteType == "weekend-1-lightcan" then
movePupilsLeft()
elseif noteType == "weekend-1-kickcan" or noteType == "weekend-1-kneecan" or noteType == "weekend-1-cockgun" then
movePupilsRight()
elseif noteType == "weekend-1-firegun" then
else
end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
if noteType == "weekend-1-lightcan" then
movePupilsLeft()
elseif noteType == "weekend-1-kickcan" or noteType == "weekend-1-kneecan" or noteType == "weekend-1-cockgun" then
movePupilsRight()
elseif noteType == "weekend-1-firegun" then
else
end
end

function noteMiss(id, direction, noteType, isSustainNote)
if noteType == "weekend-1-lightcan" then
movePupilsLeft()
elseif noteType == "weekend-1-kickcan" or noteType == "weekend-1-kneecan" or noteType == "weekend-1-cockgun" then
movePupilsRight()
elseif noteType == "weekend-1-firegun" then
else
end
end

local hasDanced = true

function dance(forceRestart)
if currentState == STATE_DEFAULT then
if hasDanced then
playAnim('gf',"danceRight", forceRestart)
else
playAnim('gf',"danceLeft", forceRestart)
end
hasDanced = not hasDanced
elseif currentState == STATE_PRE_RAISE then
playAnim('gf',"danceLeft", false)
hasDanced = false
elseif currentState == STATE_READY then
if blinkCountdown == 0 then
playAnim('gf',"idleKnife", false)
blinkCountdown = getRandomInt(MIN_BLINK_DELAY, MAX_BLINK_DELAY)
else
blinkCountdown = blinkCountdown - 1
end
else
end
end

function movePupilsLeft()
if pupilState == PUPIL_STATE_LEFT then return end
playAnim('pupil',"")
setProperty('pupil.anim.curFrame',0)
end

function movePupilsRight()
if pupilState == PUPIL_STATE_NORMAL then return end
playAnim('pupil',"")
setProperty('pupil.anim.curFrame',17)
end

function shouldTransitionState()
return getProperty('boyfriend.curCharacter') ~= "pico-blazin"
end

local animationFinished = false

function onAnimationFinished(name)
 if currentState == STATE_RAISE then
if name == "raiseKnife" then
animationFinished = true
transitionState()
end
elseif currentState == STATE_LOWER then
if name == "lowerKnife" then
animationFinished = true
transitionState()
end
else
end
end

function onAnimationFrame(name, frameNumber, frameIndex)
if currentState == STATE_PRE_RAISE then
if name == "danceLeft" and frameNumber == 14 then
animationFinished = true
transitionState()
end
else
end
end

function transitionState()
if currentState == STATE_DEFAULT then
if getProperty('health') <= VULTURE_THRESHOLD then
currentState = STATE_PRE_RAISE
else
currentState = STATE_DEFAULT
end
elseif currentState == STATE_PRE_RAISE then
if getProperty('health') > VULTURE_THRESHOLD then
currentState = STATE_DEFAULT
elseif animationFinished then
currentState = STATE_RAISE
playAnim('gf',"raiseKnife")
animationFinished = false
end
elseif currentState == STATE_RAISE then
if animationFinished then
currentState = STATE_READY
animationFinished = false
end
elseif currentState == STATE_READY then
if getProperty('health') > VULTURE_THRESHOLD then
currentState = STATE_LOWER
playAnim('gf',"lowerKnife")
end
elseif currentState == STATE_LOWER then
if animationFinished then
currentState = STATE_DEFAULT
animationFinished = false
end
else
currentState = STATE_DEFAULT
end
end

function drawFFT()
snd = getPropertyFromClass('flixel.FlxG', 'sound.music')
currentTime = getPropertyFromClass('flixel.FlxG', 'sound.music.time')

buffer = getPropertyFromClass('flixel.FlxG', 'sound.music._sound.__buffer')
bytes = getPropertyFromClass('flixel.FlxG', 'sound.music._sound.__buffer.data.buffer')

length = #bytes - 1
khz = runHaxeCode([[(FlxG.sound.music._sound.__buffer.sampleRate / 1000)]])
channels = runHaxeCode([[FlxG.sound.music._sound.__buffer.channels]])
stereo = channels > 1

index = math.floor(currentTime * khz)

sampl = {}

for i = index, index + 7 do
if i >= 0 then
byte = runHaxeCode([[FlxG.sound.music._sound.__buffer.data.buffer.getUInt16(]]..i..[[ * ]]..channels..[[ * 2)]])

if byte > 65535 / 2 then
byte = byte - 65535
end

table.insert(sampl, byte / 65535 * 10)
end
end

for i = 1, 7 do
animFrame = math.floor(sampl[i] * 5)
animFrame = math.floor(animFrame * getPropertyFromClass('flixel.FlxG', 'sound.volume'))

animFrame = math.floor(math.min(5, animFrame))
animFrame = math.floor(math.max(0, animFrame))

animFrame = math.abs(animFrame - 5)

setProperty('viz'..i..'.animation.curAnim.curFrame',animFrame)
end
end

