local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local MonitorEvent = Instance.new ("RemoteEvent")
MonitorEvent.Name = "NetworkHoneypotEvent"
MonitorEvent.Parent = ReplicatedStorage
-- ClientReplicator e ServerReplicator
-- RemoteEvent é uma ilusão. forçar isso para o honeypot
local playerData = {}
local JANELA_DE_TEMPO = 0.1
local LIMITE_DE_PACOTES = 5

Players.PlayerAdded:Connect(function(player)
	playerData[player.UserId] = {
		last_time = os.clock(),
		pacotesAcumulados = 0 
	} --struct zerada das informações de pacotes do player, clientreplicator based
end)

Players.PlayerRemoving:Connect(function(player)
	playerData[player.UserId] = nil
end)

MonitorEvent.OnServerEvent:Connect(function(player)
	local dados = playerData[player.UserId]
	if not dados then return end -- player indefinido ou bugado, da pra colocar uma função desconectando ele e pedindo para relogar, até que os dados dele sejam passados ao servidor

	local tempoAtual = os.clock()
	local deltaTempo = tempoAtual - dados.last_time

	if deltaTempo <= JANELA_DE_TEMPO then
		print("naosei")
		dados.pacotesAcumulados += 1
		if dados.pacotesAcumulados > LIMITE_DE_PACOTES then
			warn (string.format("ta com flag ou bugado"))
			warn (string.format("%d pacotes recebidos em %.3f segundos", dados.pacotesAcumulados, deltaTempo))
			-- :Kick()
			dados.pacotesAcumulados = 1
			dados.last_time = tempoAtual
		end
		
		if dados.pacotesAcumulados <= LIMITE_DE_PACOTES then
			warn (string.format("normal, %d pacotes em %.3f segundos", dados.pacotesAcumulados, deltaTempo))
		end
	end

end)
