module VM
  module Helpers
    def to_signed(v)
      if v > 2**(MEMORY_ADDRESS_SPACE - 1)
        v - 2**MEMORY_ADDRESS_SPACE
      else
        v
      end
    end

    def to_hex(v)
      (VM::MEMORY_ADDRESS_SPACE - 1).downto(0).map { |n| v[n] }.join.to_i(2)
    end
  end
end
