-- получаем ширину и высоту экрана игрока
screenW, screenH = guiGetScreenSize()
-- создаем текстуру логотипу
logo = dxCreateTexture("logo.png")
-- Выставляем ширину и высоту текстуры логотипа
logoWidth,logoHeight = 300, 150
-- делаем функцию заднего фона
function Area(x,y,width,height,texture,color,startRandomPosition)
    local private = {}
    local self = {}
    private.x = x or 0
    private.y = y or 0
    private.width = width or 0
    private.height = height or 0
    private.movingObject = Logo(x,y,logoWidth,logoHeight,texture)
    self.color = color or tocolor(0,0,0)

    function private:generatePosition()

        private.movingObject.x = math.random(x,x+(width-logoWidth))
        private.movingObject.y = math.random(y,y+(height-logoHeight))
    end
    function private:updateObject()

        private.movingObject.x = private.movingObject.x + private.movingObject.xOffset;
        private.movingObject.y = private.movingObject.y + private.movingObject.yOffset;

        if(private.movingObject.x + logoWidth >= (private.width + private.x) or private.movingObject.x <= private.x) then
            private.movingObject.xOffset = private.movingObject.xOffset * -1;
            private.movingObject.color = tocolor(math.random(255),math.random(255),math.random(255));
        end

        if(private.movingObject.y + logoHeight >= (private.height + private.y) or private.movingObject.y <= private.y) then
            private.movingObject.yOffset = private.movingObject.yOffset * -1;
            private.movingObject.color = tocolor(math.random(255),math.random(255),math.random(255));
        end
    end

    function self:render()
        dxDrawRectangle(private.x,private.y,private.width,private.height,self.color,false)
        private:updateObject()
        private.movingObject:render()
    end

    if startRandomPosition then
        private:generatePosition()
    end
    setmetatable(self,{})
    self.__index = self
    return self
end
-- функция отрисовки логотипа
function Logo(x,y,width,height,texture)
    local self = {}
    self.x = x or 0
    self.y = y or 0
    self.width = width or 0
    self.height = height or 0
    self.texture = texture or false
    self.xOffset = 5  -- скорость движения логотипа по оси x
    self.yOffset = 5  -- скорость движения логотипа по оси y
    self.color = tocolor(math.random(255),math.random(255),math.random(255))

    function self:render()
        dxDrawImage(self.x,self.y,self.width,self.height,texture,0,0,0,self.color,false)
    end
    setmetatable(self, {})
    self.__index = self
    return self
end
-- создаем 2 фона 1й слева, 2й справа
local areasTable = {
    Area(0,0,screenW/2,screenH,logo,tocolor(0,0,0,255),true),
    Area(screenW/2,0,screenW/2,screenH,logo,backgroundColor,true),
}
--Добавляем функцию рендера в автозапуск
addEventHandler("onClientRender",root,function() 
    for k,v in ipairs(areasTable) do 
        v:render()
    end
end)