local placeId = game.PlaceId

if placeId == 137630300324059 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/moddevelopinglabs/storage/refs/heads/main/secret-universe.lua"))()
elseif placeId == 14450842299 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/moddevelopinglabs/storage/refs/heads/main/secret-multiverse-acbas.lua"))()
else
    error("Invalid game, please join Secret Universe/start Secret Multiverse!")
end
