module CustomException
  class NamedException < StandardError
    attr_reader :reason
    def initialize(reason=nil)
      if reason.nil?
        @reason = I18n.t('flash.base.unknown')
      else
        @reason = reason
      end
    end
  end

  class ExpectedException < StandardError
    attr_reader :msg, :redirect
    def initialize(msg, redirect)
      @msg = msg
      @redirect = redirect
    end
  end

  class ApiNamedException < StandardError
    attr_reader :reason
    def initialize(reason=nil)
      if reason.nil?
        @reason = I18n.t('flash.base.unknown')
      else
        @reason = reason
      end
    end
  end

  class ApiCustomJsonException < StandardError
      attr_reader :json
      def initialize(json)
        @json = json
      end
  end

end


