class Sms16Client
  class Money
    include SAXMachine
    attribute :currency
    value :text
  end

  class Sms
    include SAXMachine
    attribute :area
    value :text
  end

  class Information
    include SAXMachine
    attribute :number_sms
    attribute :id_sms
    attribute :parts
    attribute :cost
    value :text
  end

  class State
    include SAXMachine
    attribute :id_sms
    attribute :time
    attribute :err
    value :text
  end

  class Response
    include SAXMachine
    element :error
    element :money, :class => Money
    elements :sms, :class => Sms
    element :information, :class => Information
    element :state, :class => State

    # helpers to determine response case
    def error?
      @error ? true : false
    end

    def money?
      @money ? true : false
    end

    def information?
      @information ? true : false
    end

    def state?
      @state ? true : false
    end
  end
end
