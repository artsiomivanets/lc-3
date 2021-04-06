module VM
  class Registers
    include VM::Helpers
    def initialize(default)
      @registers = {
        R0: 0,
        R1: 0,
        R2: 0,
        R3: 0,
        R4: 0,
        R5: 0,
        R6: 0,
        R7: 0,
        PC: 0,
        N: 0,
        Z: 0,
        P: 0,
        IR: 0
      }.merge(default)
    end

    def [](k)
      @registers[transform(k)]
    end

    def []=(k, v)
      register_name = transform(k)
      @registers[register_name] = v
    end

    def set!(values)
      @registers.merge!(values)
    end

    private

    def transform(k)
      case k
      when Symbol
        k
      when String, Integer
        "R#{k}".to_sym
      end
    end
  end
end
