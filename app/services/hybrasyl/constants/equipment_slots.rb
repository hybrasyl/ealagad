module Hybrasyl
  module Constants
    class EquipmentSlots
      WEAPON = 1
      ARMOR = 2
      SHIELD = 3
      HELMET = 4
      EARRING = 5
      NECKLACE = 6
      LHAND = 7
      RHAND = 8
      LARM = 9
      RARM = 10
      WAIST = 11
      LEG = 12
      BOOTS = 13
      FIRSTACC = 14
      TROUSERS = 15
      COAT = 16
      SECONDACC = 17
      THIRDACC = 18
      GAUNTLET = 19
      RING = 20

      HASH = {"Weapon" => 1, "Armor" => 2, "Shield" => 3, "Helmet" => 4,
              "Earring" => 5, "Necklace" => 6, "Left Hand" => 7, "Right Hand" => 8,
              "Left Arm" => 9, "Right Arm" => 10, "Waist" => 11, "Legs" => 12,
              "Boots" => 13, "First Accessory" => 14, "Trousers" => 15,
              "Coat" => 16, "Second Accessory" => 17, "Third Accessory" => 18,
              "Gauntlet" => 19, "Ring" => 20 }
      REVERSEHASH = HASH.invert

      DISPLAY_SPRITE_REQUIRED = [HASH['Weapon'], HASH['Armor'], HASH['Shield'],
                                 HASH['Boots'], HASH['Helmet'], HASH['Trousers'],
                                 HASH['Coat'], HASH['First Accessory'],
                                 HASH['Second Accessory'], HASH['Third Accessory']]

    end
  end
end
