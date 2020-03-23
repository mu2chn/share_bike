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
end


