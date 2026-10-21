local TAGGED_RAW = "https://raw.githubusercontent.com/jphcyv4rxx-cmd/Tagged/main/Tagged"

local gameId = game.GameId
if gameId == 1087859240 then
    pcall(function()
        loadstring(game:HttpGet(
            TAGGED_RAW .. "?nonce=" .. tostring(math.random()),
            true
        ))()
    end)
end
