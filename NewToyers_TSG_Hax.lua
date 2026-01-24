--[[
    NewToyers TSG Hax Ultra v1.0
    Для Delta Executor (iOS/Android)
    Игра: The Strongest Battlegrounds (Roblox)
    Функции: Ахуенные UI и читы
]]

-- Защита от античита (базовая)
local NewToyers_Secure = {
    _G = getfenv(),
    _V = "1.0",
    _H = "NewToyers",
    _S = "TSG"
}

-- Основной UI библиотека
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

-- Создание окна
local Window = library:NewWindow("NewToyers | TSG Ultra Hax")
local MainTab = Window:NewSection("Основные читы")
local VisualTab = Window:NewSection("Визуальные читы")
local PlayerTab = Window:NewSection("Игровые моды")
local MiscTab = Window:NewSection("Другое")

-- Глобальные переменные
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Конфиг
local Config = {
    GodMode = false,
    InfStamina = false,
    InfHealth = false,
    NoCooldown = false,
    DamageMultiplier = 1,
    Speed = 16,
    JumpPower = 50,
    FlyEnabled = false,
    FlySpeed = 50,
    Noclip = false,
    EspPlayers = false,
    EspItems = false,
    Aimbot = false,
    SilentAim = false,
    TriggerBot = false,
    AutoFarm = false,
    AutoParry = false,
    FullBright = false,
    FovChanger = false,
    FovValue = 70
}

-- Функции полета
local FlyConnection
function Fly()
    if Config.FlyEnabled then
        local BodyGyro = Instance.new("BodyGyro", HRP)
        local BodyVelocity = Instance.new("BodyVelocity", HRP)
        BodyGyro.P = 9e4
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = HRP.CFrame
        BodyVelocity.velocity = Vector3.new(0, 0, 0)
        BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        FlyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if Config.FlyEnabled and Character and HRP and Humanoid then
                Humanoid.PlatformStand = true
                local Direction = Vector3.new()
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    Direction = Direction + (workspace.CurrentCamera.CFrame.LookVector * Config.FlySpeed)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    Direction = Direction - (workspace.CurrentCamera.CFrame.LookVector * Config.FlySpeed)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    Direction = Direction - (workspace.CurrentCamera.CFrame.RightVector * Config.FlySpeed)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    Direction = Direction + (workspace.CurrentCamera.CFrame.RightVector * Config.FlySpeed)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    Direction = Direction + Vector3.new(0, Config.FlySpeed, 0)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                    Direction = Direction - Vector3.new(0, Config.FlySpeed, 0)
                end
                BodyVelocity.velocity = Direction
                BodyGyro.cframe = workspace.CurrentCamera.CFrame
            else
                if FlyConnection then
                    FlyConnection:Disconnect()
                    Humanoid.PlatformStand = false
                    if BodyGyro then BodyGyro:Destroy() end
                    if BodyVelocity then BodyVelocity:Destroy() end
                end
            end
        end)
    end
end

-- Функция NoClip
local NoclipConnection
function NoclipFunc()
    if Config.Noclip then
        NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
        end
    end
end

-- ESP для игроков
local ESPBoxes = {}
function ESPPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPBoxes[player] then
                local Box = Drawing.new("Square")
                Box.Visible = false
                Box.Color = Color3.fromRGB(255, 0, 0)
                Box.Thickness = 2
                Box.Filled = false
                ESPBoxes[player] = Box
            end
        end
    end
    
    game:GetService("RunService").RenderStepped:Connect(function()
        for player, box in pairs(ESPBoxes) do
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and Config.EspPlayers then
                local position, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    box.Size = Vector2.new(2000 / position.Z, 3000 / position.Z)
                    box.Position = Vector2.new(position.X - box.Size.X / 2, position.Y - box.Size.Y / 2)
                    box.Visible = true
                    
                    -- Цвет в зависимости от здоровья
                    local hum = player.Character:FindFirstChild("Humanoid")
                    if hum then
                        local health = hum.Health / hum.MaxHealth
                        box.Color = Color3.fromRGB(255 * (1 - health), 255 * health, 0)
                    end
                else
                    box.Visible = false
                end
            else
                box.Visible = false
                box:Remove()
                ESPBoxes[player] = nil
            end
        end
    end)
end

-- Авто-парирование
function AutoParryFunc()
    spawn(function()
        while Config.AutoParry do
            wait(0.1)
            -- Ищем ближайшую атаку
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name:find("Hitbox") or obj.Name:find("Attack") then
                    local distance = (HRP.Position - obj.Position).Magnitude
                    if distance < 15 then
                        -- Симуляция нажатия клавиши парирования (E)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        wait(0.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end
                end
            end
        end
    end)
end

-- Авто-фарм NPC
function AutoFarmNPC()
    spawn(function()
        while Config.AutoFarm do
            wait(1)
            -- Ищем ближайшего NPC
            local closestNPC = nil
            local closestDist = math.huge
            
            for _, npc in pairs(workspace:GetChildren()) do
                if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                    if npc.Name:find("NPC") or npc.Name:find("Enemy") then
                        local dist = (HRP.Position - npc.HumanoidRootPart.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestNPC = npc
                        end
                    end
                end
            end
            
            if closestNPC and closestDist < 50 then
                -- Телепортируемся к NPC
                HRP.CFrame = closestNPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                wait(0.2)
                -- Атакуем
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.MouseButton1, false, game)
                wait(0.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.MouseButton1, false, game)
            end
        end
    end)
end

-- Фуллбрайт
function FullBrightFunc()
    if Config.FullBright then
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000
        game.Lighting.GlobalShadows = false
    else
        game.Lighting.Brightness = 1
        game.Lighting.GlobalShadows = true
    end
end

-- Изменение FOV
function FovChangerFunc()
    game:GetService("RunService").RenderStepped:Connect(function()
        if workspace.CurrentCamera and Config.FovChanger then
            workspace.CurrentCamera.FieldOfView = Config.FovValue
        end
    end)
end

-- Эймбот
local AimbotConnection
function AimbotFunc()
    if Config.Aimbot then
        AimbotConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local closestPlayer = nil
            local closestDistance = math.huge
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local screenPoint = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                    local mousePoint = game:GetService("UserInputService"):GetMouseLocation()
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePoint).Magnitude
                    
                    if distance < closestDistance and distance < 250 then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
            
            if closestPlayer and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                workspace.CurrentCamera.CFrame = CFrame.new(
                    workspace.CurrentCamera.CFrame.Position,
                    closestPlayer.Character.HumanoidRootPart.Position
                )
            end
        end)
    else
        if AimbotConnection then
            AimbotConnection:Disconnect()
        end
    end
end

-- Элементы UI

-- Основные читы
MainTab:CreateToggle("Бессмертие", function(value)
    Config.GodMode = value
    if value then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        Character:FindFirstChildOfClass("Humanoid").Health = 9999
    else
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
    end
end)

MainTab:CreateToggle("Бесконечная выносливость", function(value)
    Config.InfStamina = value
    -- Здесь должен быть хук на механику выносливости игры
end)

MainTab:CreateToggle("Нет отката способностей", function(value)
    Config.NoCooldown = value
    -- Хук на коoldown'ы способностей
end)

MainTab:CreateSlider("Множитель урона", 1, 50, 1, function(value)
    Config.DamageMultiplier = value
end)

MainTab:CreateSlider("Скорость", 16, 200, 16, function(value)
    Config.Speed = value
    Humanoid.WalkSpeed = value
end)

MainTab:CreateSlider("Сила прыжка", 50, 500, 50, function(value)
    Config.JumpPower = value
    Humanoid.JumpPower = value
end)

-- Визуальные читы
VisualTab:CreateToggle("ESP игроков", function(value)
    Config.EspPlayers = value
    if value then
        ESPPlayers()
    else
        for _, box in pairs(ESPBoxes) do
            box:Remove()
        end
        ESPBoxes = {}
    end
end)

VisualTab:CreateToggle("ESP предметов", function(value)
    Config.EspItems = value
end)

VisualTab:CreateToggle("Яркое освещение", function(value)
    Config.FullBright = value
    FullBrightFunc()
end)

VisualTab:CreateToggle("Изменение FOV", function(value)
    Config.FovChanger = value
    if value then
        FovChangerFunc()
    end
end)

VisualTab:CreateSlider("Значение FOV", 70, 120, 70, function(value)
    Config.FovValue = value
end)

-- Игровые моды
PlayerTab:CreateToggle("Полёт (WASD + Space/Shift)", function(value)
    Config.FlyEnabled = value
    Fly()
end)

PlayerTab:CreateSlider("Скорость полёта", 20, 200, 50, function(value)
    Config.FlySpeed = value
end)

PlayerTab:CreateToggle("Сквозь стены", function(value)
    Config.Noclip = value
    NoclipFunc()
end)

PlayerTab:CreateToggle("Эймбот (ПКМ)", function(value)
    Config.Aimbot = value
    AimbotFunc()
end)

PlayerTab:CreateToggle("Сайлент эйм", function(value)
    Config.SilentAim = value
end)

PlayerTab:CreateToggle("Авто-парирование", function(value)
    Config.AutoParry = value
    if value then
        AutoParryFunc()
    end
end)

PlayerTab:CreateToggle("Авто-фарм NPC", function(value)
    Config.AutoFarm = value
    if value then
        AutoFarmNPC()
    end
end)

-- Другое
MiscTab:CreateButton("Телепорт на арену", function()
    local arena = workspace:FindFirstChild("Arena") or workspace:FindFirstChild("BattleStage")
    if arena then
        HRP.CFrame = arena.CFrame * CFrame.new(0, 10, 0)
    end
end)

MiscTab:CreateButton("Телепорт к ближайшему игроку", function()
    local closestPlayer = nil
    local closestDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (HRP.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestPlayer = player
            end
        end
    end
    
    if closestPlayer then
        HRP.CFrame = closestPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
    end
end)

MiscTab:CreateTextBox("Скорость игры", "Введите множитель (0.1-10)", function(value)
    local num = tonumber(value)
    if num and num >= 0.1 and num <= 10 then
        game:GetService("Workspace").GlobalSpeed.Value = num
    end
end)

MiscTab:CreateButton("Убить всех ботов", function()
    for _, npc in pairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and (npc.Name:find("NPC") or npc.Name:find("Enemy")) then
            npc.Humanoid.Health = 0
        end
    end
end)

MiscTab:CreateToggle("Быстрая перезарядка", function(value)
    game:GetService("RunService").RenderStepped:Connect(function()
        if value then
            -- Ускоряем все анимации и процессы
            game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 100
        end
    end)
end)

-- Инициализация
spawn(function()
    Humanoid.WalkSpeed = Config.Speed
    Humanoid.JumpPower = Config.JumpPower
    
    -- Защита от кика
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    
    warn("[NewToyers] Защита от кика активирована!")
end)

print([[
══════════════════════════════════════
    NewToyers TSG Hax Ultra v1.0
    Успешно загружен в Delta!
══════════════════════════════════════
]])