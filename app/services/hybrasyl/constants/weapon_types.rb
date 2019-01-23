module Hybrasyl
  module Constants
    class WeaponTypes
      NOTWEAPON = 0
      ONEHAND = 1
      TWOHAND = 2
      DAGGER = 3
      STAFF = 4
      CLAW = 5

      HASH = {'Non-weapon' => 0, 'One-handed' => 1, 'Two-handed' => 2, 'Dagger' => 3,
              'Staff' => 4, 'Claw' => 5 }
      REVERSEHASH = HASH.invert

    end
  end
end
