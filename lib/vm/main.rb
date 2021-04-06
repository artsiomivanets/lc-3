module VM
  PROGRAM_ADDRESS = 0x0
  MEMORY_ADDRESS_SPACE = 2**4
  WORD_LENGTH = 2**4

  class Main
    include VM::Helpers
    attr_accessor :memory, :registers

    def initialize(registers:, data:)
      @registers = VM::Registers.new(registers)
      @memory = VM::Memory.new
      @halted = false

      binary = Assembly.call(data)
      load_program(binary)
    end

    def run
      until halted?
        fetch!
        opcode, data = decode(registers[:IR])
        evaluate(opcode, data)
      end
    end

    private

    def instructions
      {
        add: {
          immediate: {
            pattern: /(...)(...)(.)(.....)/,
            perform: lambda do |dr, sr1, _, sr2|
              value = to_signed(registers[sr1] + sr2)
              registers[dr] = value
              set_condition_registers!(value)
            end
          },
          literal: {
            pattern: /(...)(...)(...)(...)/,
            perform: lambda do |dr, sr1, _, sr2|
              value = to_signed(registers[sr1] + registers[sr2])
              registers[dr] = value
              set_condition_registers!(value)
            end
          }
        },
        and: {
          immediate: {
            pattern: /(...)(...)(.)(.....)/,
            perform: lambda do |dr, sr1, _, sr2|
              value = to_signed(registers[sr1] & sr2)
              registers[dr] = value
              set_condition_registers!(value)
            end
          },
          literal: {
            pattern: /(...)(...)(...)(...)/,
            perform: lambda do |dr, sr1, _, sr2|
              value = to_signed(registers[sr1] & registers[sr2])
              registers[dr] = value
              set_condition_registers!(value)
            end
          }
        },
        not: {
          pattern: /(...)(...)/,
          perform: lambda do |dr, sr, *_other|
            value = to_signed((WORD_LENGTH - 1).downto(0).map { |n| (~registers[sr])[n] }.join.to_i(2))
            registers[dr] = to_signed(value)
            set_condition_registers!(value)
          end
        }
      }
    end

    def halted?
      @halted
    end

    def halt!
      @halted = true
    end

    def fetch!
      registers[:IR] = memory[registers[:PC]]
      registers[:PC] += 1
    end

    def decode(instruction)
      instruction.to_s(2).rjust(MEMORY_ADDRESS_SPACE, '0').scan(/(.{4})(.*)/).first
    end

    def evaluate(opcode, data)
      case opcode
      when '0001', 'ADD'
        mode = addressing_mode(data)
        pattern = instructions[:add][mode][:pattern]
        perform = instructions[:add][mode][:perform]
        arguments = extract_arguments(data, pattern)
        perform.call(*arguments)
      when '0101', 'AND'
        mode = addressing_mode(data)
        pattern = instructions[:and][mode][:pattern]
        perform = instructions[:and][mode][:perform]
        arguments = extract_arguments(data, pattern)
        perform.call(*arguments)
      when '1001', 'NOT'
        pattern = instructions[:not][:pattern]
        perform = instructions[:not][:perform]
        arguments = extract_arguments(data, pattern)
        perform.call(*arguments)
      else
        halt!
      end
    end

    def addressing_mode(data)
      data[6].to_i(2).zero? ? :literal : :immediate
    end

    def set_condition_registers!(v)
      registers.set!({ N: 1, Z: 0, P: 0 }) if v.negative?
      registers.set!({ N: 0, Z: 1, P: 0 }) if v.zero?
      registers.set!({ N: 0, Z: 0, P: 1 }) if v.positive?
    end

    def extract_arguments(str, pattern)
      str.scan(pattern).flatten.map { |i| i.to_i(2) }
    end

    def load_program(data, address = 0)
      data.each_with_index { |el, i| memory[address + i] = el }
    end
  end
end
