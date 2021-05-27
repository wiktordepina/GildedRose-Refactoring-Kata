class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      update_quality_of(item)
    end
  end

  private

  def update_quality_of(item)
    if ["Aged Brie", "Backstage passes to a TAFKAL80ETC concert"].include?(item.name)
      item.increase_quality
      if item.name == "Backstage passes to a TAFKAL80ETC concert"
        if item.sell_in < 11
          item.increase_quality
        end
        if item.sell_in < 6
          item.increase_quality
        end
      end
    else
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.decrease_quality
      end
    end

    if item.name != "Sulfuras, Hand of Ragnaros"
      item.sell_in = item.sell_in - 1
    end
    if item.expired?
      if item.name != "Aged Brie"
        if item.name != "Backstage passes to a TAFKAL80ETC concert"
          if item.name != "Sulfuras, Hand of Ragnaros"
            item.decrease_quality
          end
        else
          item.quality = 0
        end
      else
        item.increase_quality
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end

  def expired?
    @sell_in < 0
  end

  def increase_quality(by: 1)
    return if max_quality?

    @quality += 1
  end

  def decrease_quality(by: 1)
    return if @quality <= 0

    @quality -= 1
  end

  def max_quality?
    @quality >= 50
  end
end
