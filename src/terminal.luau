local UserInputService = game:GetService("UserInputService")

local terminal = {}

export type TerminalStruct = {
	Background: GuiBase,
	Lines: { [number]: { [number]: TextLabel } },
	XPos: number,
	YPos: number,
	Height: number,
	Width: number,
	BackgroundColor: Color3,
	TextColor: Color3,
}

export type Terminal = typeof(setmetatable(
	{} :: TerminalStruct,
	{ __index = terminal }
))

local function GetLine(self: Terminal, x: number, y: number): TextLabel
	local Line = self.Lines[y][x]

	if Line == nil then
		Line = Instance.new("TextLabel")
		Line.Parent = self.Background
	end

	return Line
end

function terminal.gotoxy(self: Terminal, x: number, y: number)
	self.XPos = x
	self.YPos = y
end

function terminal.getxy(self: Terminal): (number, number)
	return self.XPos, self.YPos
end

function terminal.print(self: Terminal, ...: string)
	local Line = GetLine(self, self.XPos, self.YPos)

	Line.BackgroundColor3 = self.BackgroundColor
	Line.TextColor3 = self.TextColor

	local t = Line.Text

	local toPrint = ""

	for _, v in pairs({ ... }) do
		toPrint ..= tostring(v)
	end

	local t = t:sub(1, self.XPos) .. toPrint .. t:sub(self.XPos)

	if t:len() > self.Width then
		
	else
		Line.Text = t
	end
end

function terminal.println(self: Terminal, ...: string)
	self:print(..., "\n")
end

function terminal.scan(self: Terminal): string
	local input = ""

	return input
end

function terminal.ReCalcY(self: Terminal)
	local h = 1 / (self.Height - 1)

	for i, line in pairs(self.Lines) do
		for _, label in pairs(line) do
			label.Position = UDim2.fromScale(label.Position.X.Scale, h * i)
			label.Size = UDim2.fromScale(label.Size.X.Scale, h)
		end
	end
end

function terminal.new(background: GuiBase): Terminal
	local self: TerminalStruct = {
		Background = background,
		Lines = {},
		XPos = 0,
		YPos = 0,
		Width = 80,
		Height = 30,
		BackgroundColor = Color3.new(),
		TextColor = Color3.new(1, 1, 1),
	}

	setmetatable(self, { __index = terminal })

	self.Background:GetPropertyChangedSignal("Size"):Connect(function()
		self:ReCalcY()
	end)

	return self
end

return terminal
