module VM
  class Memory
    attr_accessor :memory

    def initialize
      @memory = Array.new(MEMORY_ADDRESS_SPACE).fill(empty_word)
    end

    def empty_word
      0
    end

    def [](i)
      @memory[i]
    end

    def []=(i, v)
      @memory[i] = v
    end
  end
end
