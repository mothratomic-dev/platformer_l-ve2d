function love.load()

    -- PLAYER --
    player = {
        x    = 100,
        y    = 100,
        w    = 32,
        h    = 32,

        speed    = 120,
        gravity  = 3200,
        jump     = 880,
        squash   = 1,
        slide    = false,

        vy       = 0,
        onGround = false,

        -- DOUBLE JUMP
        jumps    = 2
    }

    groundY = 480
    shakeY  = 0

    -- SOUND --
    sfx           = love.audio.newSource("sfx/01.wav", "static")
    sfxDoubleJump = love.audio.newSource("sfx/02.wav", "static")

end


-- -----------------------------------------------------

function love.update(dt)

    -- C O N T R O L L E R S --

    if love.keyboard.isDown("left") and
        player.x > 0 then

        player.x = player.x - player.speed * dt

    end

    if love.keyboard.isDown("right") and
        player.x < love.graphics.getWidth() - player.w then

        player.x = player.x + player.speed * dt

    end

    -- C R O U C H --

    if love.keyboard.isDown("down") and player.onGround then

        player.slide = true
        player.h = 16
        player.y = groundY - player.h

    else

        player.slide = false
        player.h = 32

        if player.onGround then
            player.y = groundY - player.h
        end

    end

    -- G R A V I T Y --

    player.vy = player.vy + player.gravity * dt
    player.y = player.y + player.vy * dt


    -- C O L L I S I O N --

    if player.y + player.h >= groundY then
        if not player.onGround then

            -- SOUND
            if player.jumps == 0 then
                love.audio.play(sfxDoubleJump:clone())
            else
                love.audio.play(sfx:clone())
            end

            -- SCREEN SHAKE
            if player.jumps == 0 then
                shakeY = 15 * 3
            else
                shakeY = 15
            end

            -- RESET SPEED
            player.speed = 120

            -- LANDING SQUASH
                if player.jumps == 0 then player.squash = 0.65 end

        end

        player.y = groundY - player.h
        player.vy = 0
        player.onGround = true

        -- RESET DOUBLE JUMP
        player.jumps = 2

    else

        player.onGround = false

    end

    -- SQUASH RECOVERY
    player.squash = player.squash + (1 - player.squash) * 12 * dt

    -- S C R E E N   S H A K E --

    shakeY = shakeY * 0.8

    if shakeY < 0.1 then
        shakeY = 0
    end

end


-- J U M P --

function love.keypressed(key)

    if key == "up" and player.jumps > 0 then

        -- JUMP
        player.vy = -player.jump

        -- REMOVE ONE JUMP
        player.jumps = player.jumps - 1

        -- SPEED BOOST
        player.speed = 420

    end

end

-- -----------------------------------------------------

function love.draw()

    love.graphics.push()

    love.graphics.translate(0, shakeY)


    -- S P R I T E   P L A Y E R --

    local mode = "fill"

    if not player.onGround then
        mode = "line"
    end

    love.graphics.rectangle(
        mode,
        player.x,
        player.y,
        player.w,
        player.h
    )


    -- G R O U N D --

    love.graphics.line(
        0,
        groundY,
        love.graphics.getWidth(),
        groundY
    )

    love.graphics.pop()

end