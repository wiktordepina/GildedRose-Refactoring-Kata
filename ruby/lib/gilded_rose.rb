class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      update_quality_of(item)
    end
  end

  AGED_BRIE = "Aged Brie"
  BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert"
  SULFURAS = "Sulfuras, Hand of Ragnaros"

  private

  def update_quality_of(item)
    case item.name
    when SULFURAS
    when BACKSTAGE_PASSES
      BackstagePasses.new(item).update_quality
    when AGED_BRIE
      item.increase_quality
      item.sell_in = item.sell_in - 1
      item.increase_quality if item.expired?
    else
      item.sell_in = item.sell_in - 1
      item.decrease_quality
      item.decrease_quality if item.expired?
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

  def normal_item?
    [GildedRose::AGED_BRIE, GildedRose::BACKSTAGE_PASSES, GildedRose::SULFURAS].none? { |name| name == @name }
  end
end

class BackstagePasses
  def initialize(item)
    @item = item
  end

  attr_reader :item

  def update_quality
    item.increase_quality
    item.increase_quality if item.sell_in < 11
    item.increase_quality if item.sell_in < 6
    item.sell_in = item.sell_in - 1
    item.quality = 0 if item.expired?
  end
end
