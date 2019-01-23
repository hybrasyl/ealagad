module Hybrasyl
  module Constants
    class MapFlags
      SNOW = 1
      RAIN = 2
      DARK = 3
      NOMAP = 64
      WINTER = 128

      HASH = { 'Snow' => 1, 'Rain' => 2, 'Dark' => 3, 'No Map' => 64, 'Winter' => 128 }
      REVERSEHASH = HASH.invert

    end
  end
end
