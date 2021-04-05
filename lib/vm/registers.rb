module VM
  class Registers
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
        IR: 0
      }.merge(default)
    end

    def [](k)
      @registers[transform(k)]
    end

    def []=(k, v)
      @registers[transform(k)] = v
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
