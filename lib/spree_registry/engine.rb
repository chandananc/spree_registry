module SpreeRegistry
  class Engine < Rails::Engine
    require 'spree/core'
   
    engine_name 'spree_registry'
    
     config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
   

    def self.activate
      cache_klasses = %W(#{config.root}/app/**/*_decorator*.rb #{config.root}/app/overrides/*.rb)
      Dir.glob(cache_klasses) do |klass|
        Rails.configuration.cache_classes ? require(klass) : load(klass)
      end
      Spree::Ability.register_ability(RegistryAbility)
    end

    config.to_prepare &method(:activate).to_proc
  end
end
