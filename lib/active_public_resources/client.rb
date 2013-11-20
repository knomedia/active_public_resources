module ActivePublicResources
  class Client
    
    def initialize(config={})
      raise ArgumentError.new("key/value pair must be provided") if config.blank?

      @drivers = {}
      ActivePublicResources.symbolize_keys(config).each do |k, v|
        klass = "ActivePublicResources::Drivers::#{k.to_s.split('_').map(&:capitalize).join}Driver".constantize
        @drivers[k.to_sym] = klass.new(v)
      end
    end

    def search(driver_name, criteria)
      @drivers[driver_name.to_sym].perform_request(criteria)
    end

    def initialized_drivers
      @drivers.keys
    end

  end
end