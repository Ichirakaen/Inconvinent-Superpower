_G.love = require ('love')
Button_height = 64

  local 
    function newbutton (text, fn)
        return{
            text = text,
            fn = fn,

            now = false,
            last = false
        }
        
    end
  local buttons = {}
  local font = nil
function love.load()
  
    font =  love.graphics.newFont(32)
    table.insert(buttons, newbutton("Start Game",
  function ()
    print("Starting game")
    end))
  
    table.insert(buttons, newbutton("Settings", 
    function ()
        print("Opening Settings") 
        end))

   table.insert(buttons, newbutton("Quit Game", 
   function ()
    print("Quiting game")
    love.event.quit(0)
    end))

    
  
    camera = require 'libraries.camera.camera'
    cam =camera()

    anim8= require 'libraries.anim8.anim8'
    love.graphics.setDefaultFilter("nearest","nearest")

    sti = require 'libraries.sti'
    gamemap = sti('Snowy Asset Pack/Map.lua')
    player={}
    player.x=200
    player.y=200
    player.walk=4
    player.image=love.graphics.newImage("char/char.png")
    player.spriteSheet=love.graphics.newImage("char/sprite sheet.png")
    player.grid=anim8.newGrid(24,32, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations= {}
    player.animations.down = anim8.newAnimation(player.grid('1-4',1), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-4',3), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-4',4), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4',2), 0.2)
    player.anim=player.animations.down
    
end

function love.update(dt)
    local isMoving=false
    
    if love.keyboard.isDown("right","d") then
        player.x=player.x+player.walk
        player.anim=player.animations.right
        isMoving=true
    end

    if love.keyboard.isDown("up","w") then
        player.y=player.y-player.walk
        player.anim=player.animations.up
        isMoving=true
    end

    if love.keyboard.isDown("down","s") then
        player.y=player.y+player.walk
        player.anim=player.animations.down
        isMoving=true
    end

    if love.keyboard.isDown("left","a") then
        player.x=player.x-player.walk
        player.anim=player.animations.left
        isMoving=true
    
    end

    if isMoving ==false then
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)

    cam:lookAt(player.x,player.y)

end

function love.draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local button_width = ww * (1/3)
    local margin = 16

    local total_height = (Button_height + margin)* #buttons

    for i, button in ipairs(buttons) do
        button.last = button.now


        local bx =  (ww*0.5)-(button_width*0.5)
        local by = (wh * 0.5)-(total_height * 0.5) +cursor_y

        local color = {0.4, 0.4, 0.5, 1.0}

        local mx, my = love.mouse.getPosition()

        local hot = mx>bx and mx<bx + button_width and my >by and my<by + Button_height

        if hot then
            color = {0.9,0.8,0.9,1.0}
        end

        button.now = love.mouse.isDown(1)
        if button.now and not button.last and hot then
            button.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
        "fill",
        bx,
        by,
        button_width,
        Button_height
        )
      
        love.graphics.setColor(0 , 0, 0, 1)

        local textW = font:getWidth(button.text)
        local textH = font:getHeight(button.text)
        love.graphics.print(
            button.text,
            font,
            (ww*0.5) - textW * 0.5,
            by + textH * 0.5

        )
        cursor_y =  cursor_y + (Button_height + margin)

    end
    cam:attach()
    gamemap:draw()
    player.anim:draw(player.spriteSheet,player.x,player.y,nil , 6)
    cam:detach()
end