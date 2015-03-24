require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Hybrasyl
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_hash]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.paths += [File.join(Rails.root,
                                      "app/assets/stylesheets/hybrasyl/")]

    config.assets.precompile += ['jquery-old.js', 'jquery-ui-1.8.17.js',
      'jquery.annotate.js', 'jquery.tokeninput.js', 'news_post.js' ]

  end
end

module Hybrasyl
  module Constants
    class Integers
      MAX_INT32 = 4294967295
      MAX_SIGNED32 = 2147483647
      MIN_SIGNED32 = -2147483647
      MAX_SIGNED8 = 127
      MIN_SIGNED8 = -127
      MAX_INT8 = 255
      MAX_INT16 = 65535
      MAX_SIGNED16 = 32767
      MIN_SIGNED16 = -32767

      MAX_LEVEL = 99
      MAX_AB = 99

    end

    class MapFlags
      SNOW = 1
      RAIN = 2
      DARK = 3
      NOMAP = 64
      WINTER = 128

      HASH = { 'Snow' => 1, 'Rain' => 2, 'Dark' => 3, 'No Map' => 64, 'Winter' => 128 }
      REVERSEHASH = HASH.invert

    end

    class Elements
      NONE = 0
      FIRE = 1
      WATER = 2
      WIND = 3
      EARTH = 4
      LIGHT = 5
      DARK = 6
      WOOD = 7
      METAL = 8
      UNDEAD = 9
      RANDOM = 10
      HASH = {'None' => 0, 'Fire' => 1, 'Water' => 2, 'Wind' => 3, 'Earth' => 4,
        'Light' => 5, 'Dark' => 6, 'Wood' => 7, 'Metal' => 8, 'Undead' => 9, 'Random' => 10 }
      REVERSEHASH = HASH.invert

    end

    class Classes

      PEASANT = 0
      WARRIOR = 1
      ROGUE = 2
      WIZARD = 3
      PRIEST = 4
      MONK = 5

      HASH = {'Peasant' => 0, 'Warrior' => 1, 'Rogue' => 2, 'Wizard' => 3, 'Priest' => 4,
        'Monk' => 5 }
      REVERSEHASH = HASH.invert

    end

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

    class ItemTypes
      USABLE = 0
      UNUSABLE = 1
      EQUIPPABLE = 2

      HASH = {'Usable item' => 0, 'Unusable item' => 1, 'Equippable' => 2 }
      REVERSEHASH = HASH.invert

    end

    class Genders
      NEUTRAL = 0
      MALE = 1
      FEMALE = 2

      HASH = { 'Neutral' => 0, 'Male' => 1, 'Female' => 2 }
      REVERSEHASH = HASH.invert

    end

    class BodyColors
      INVISIBLE = 0
      BLACK = 1
      RED = 2
      ORANGE = 3
      YELLOW = 4
      TEAL = 5
      BLUE = 6
      PURPLE = 7
      DARK_GREEN = 8
      GREEN = 9
      LIGHT_ORANGE = 10
      BROWN = 11
      GREY = 12
      DARK_BLUE = 13
      FLESH = 14
      WHITE = 15

      HASH = { "Invisible" => 0, "Black" => 1, "Red" => 2, "Orange" => 3, "Yellow" => 4,
        "Teal" => 5, "Blue" => 6, "Purple" => 7, "Dark Green" => 8,
        "Green" => 9, "Light Orange" => 10, "Brown" => 11, "Grey" => 12,
        "Dark Blue" => 13, "Flesh" => 14, "White" => 15 }
      REVERSEHASH = HASH.invert

    end

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
