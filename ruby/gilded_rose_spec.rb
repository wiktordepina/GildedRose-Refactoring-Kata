require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe "#update_quality" do

    context "Aged Brie" do

      let (:aged_brie) {
        Item.new('Aged Brie', 10, 10)
      }

      it "increases in quality at the end of each day" do
        GildedRose.new([aged_brie]).update_quality()
        expect(aged_brie.quality).to eq(11)
      end

      it "decreases sell by date at the end of each day" do
        GildedRose.new([aged_brie]).update_quality()
        expect(aged_brie.sell_in).to eq(9)
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