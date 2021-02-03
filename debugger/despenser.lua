local sales = {
    [1] = {screen=slot1, container=slot2, item="Container L",      mass=14840, cost=160000 },
    [2] = {screen=slot6, container=slot3, item="Container Hub",    mass=55.8,  cost=25000  },
    [3] = {screen=slot7, container=slot4, item="Territory Scanner",mass=66460, cost=1200000 },
    [4] = {screen=slot8, container=slot5, item="Nitron Fuel",      quantity=5000, unit = "ℓ", density=4, cost=50000 },
}

function format_int(number)
  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
  int = int:reverse():gsub("(%d%d%d)", "%1,")
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

function display(id)
    sales[id].screen.clear()
    sales[id].screen.addText(10, 10, 10, sales[id].item)
    if sales[id].quantity then
        sales[id].screen.addText(10, 30, 10, sales[id].quantity..(sales[id].unit or ""))
    end
    sales[id].screen.addText(10, 60,  8, format_int(sales[id].cost).."ћ")
    local mass = sales[id].mass or sales[id].quantity * sales[id].density
    local count = sales[id].container.getItemsMass() / mass
    --system.print(sales[id].item.." count "..count)
    local stock = math.floor(count+.5)
    if stock > 0 then
        sales[id].screen.addText(10, 80,  8, stock.." batches in stock")
    else
        sales[id].screen.addText(10, 80,  8, "Out of stock")
    end
    sales[id].screen.activate()
end

function update()
    --system.print("update")
    display(1)
    display(2)
    display(3)
    display(4)
end

update()

unit.setTimer("Live", 4)