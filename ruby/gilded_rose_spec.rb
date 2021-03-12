require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe "#update_quality" do

    context "Aged Brie" do

      let(:aged_brie) {
        Item.new('Aged Brie', 10, 10)
      }

      it "increases in quality at the end of each day" do
        GildedRose.new([aged_brie]).update_quality
        expect(aged_brie.quality).to eq(11)
      end

      it "decreases sell by date at the end of each day" do
        GildedRose.new([aged_brie]).update_quality
        expect(aged_brie.sell_in).to eq(9)
      end

      it "never increases the quality to over 50" do
        aged_brie = Item.new('Aged Brie', 10, 50)
        GildedRose.new([aged_brie]).update_quality
        expect(aged_brie.quality).to eq(50)
      end

      it "increases quality twice as fast at sell by date" do
        aged_brie = Item.new('Aged Brie', 0, 15)
        GildedRose.new([aged_brie]).update_quality
        expect(aged_brie.quality).to eq(17)
      end

      it "increases quality twice as fast after sell by date" do
        aged_brie = Item.new('Aged Brie', -1, 15)
        GildedRose.new([aged_brie]).update_quality
        expect(aged_brie.quality).to eq(17)
      end
    end

    context "Backstage passes" do
      it "increases in Quality by 1 when there are 11 days left" do
        backstage_passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 15)
        GildedRose.new([backstage_passes]).update_quality
        expect(backstage_passes.quality).to eq(16)
      end

      it "increases in Quality by 2 when there are 10-6 days left" do
        backstage_passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 15)
        GildedRose.new([backstage_passes]).update_quality
        expect(backstage_passes.quality).to eq(17)
      end

      it "increases in Quality by 2 when there are 6 days left" do
        backstage_passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 6, 15)
        GildedRose.new([backstage_passes]).update_quality
        expect(backstage_passes.quality).to eq(17)
      end

      it "increases in Quality by 3 when there are 5 days" do
        backstage_passes = Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 15)
        GildedRose.new([backstage_passes]).update_quality
        expect(backstage_passes.quality).to eq(18)
      end

      it "increases in Quality by 3 when there are less than 5 days" do
        backstage_passes = Item.new('Backstage passes to a TAFKAL80ETC concert', rand(4) + 1, 15)
        GildedRose.new([backstage_passes]).update_quality
        expect(backstage_passes.quality).to eq(18)
        # (1..4).each do |s|
        #   backstage_passes = Item.new('Backstage passes to a TAFKAL80ETC concert', s, 15)
        #   GildedRose.new([backstage_passes]).update_quality
        #   expect(backstage_passes.quality).to eq(18)
        # end
      end
    end
  end
end

# - All items have a SellIn value which denotes the number of days we have to sell the item
# - All items have a Quality value which denotes how valuable the item is
# - At the end of each day our system lowers both values for every item
#
# Pretty simple, right? Well this is where it gets interesting:
#
# - Once the sell by date has passed, Quality degrades twice as fast
# - The Quality of an item is never negative
# - "Aged Brie" actually increases in Quality the older it gets
# - The Quality of an item is never more than 50
# - "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
# - "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches;
# Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
# Quality drops to 0 after the concert
#
# We have recently signed a supplier of conjured items. This requires an update to our system:
#
# - "Conjured" items degrade in Quality twice as fast as normal items