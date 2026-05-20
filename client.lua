local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
 local MonitorEvent = ReplicatedStorage:WaitForChid("main")
local TEMPO_DE_ENVIO = 0.5
local contador = 0
RunService.HeartBeat:Connect(function(deltaTempo)
  contador += deltaTempo
    if contador >= TEMPO_DE_ENVIO then
      contador = 0
      MonitorEvent:FireServer()
    end
end)
