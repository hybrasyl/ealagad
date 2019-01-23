module Hybrasyl
  module Constants
    class ItemTypes
      USABLE = 0
      UNUSABLE = 1
      EQUIPPABLE = 2

      HASH = {'Usable item' => 0, 'Unusable item' => 1, 'Equippable' => 2 }
      REVERSEHASH = HASH.invert

    end
  end
end
