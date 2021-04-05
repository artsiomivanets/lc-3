module VM
  class Assembly
    def self.call(data)
      data.map do |instruction|
        instruction_to_binary(instruction).to_i(2)
      end
    end

    def self.instruction_to_binary(instruction)
      operator, *rest = instruction.split(' ')
      case operator
      when 'ADD'
        op, dr, sr1, sr2 = instruction.split(' ').map { |w| w2b(w) }
        return "#{op}#{dr}#{sr1}000#{sr2}" if sr2.length == 3

        imm = sr2
        "#{op}#{dr}#{sr1}1#{imm}"
      when 'AND'
        op, dr, sr1, sr2 = instruction.split(' ').map { |w| w2b(w) }
        return "#{op}#{dr}#{sr1}000#{sr2}" if sr2.length == 3

        imm = sr2
        "#{op}#{dr}#{sr1}1#{imm}"
      when 'NOT'
        op, dr, sr = instruction.split(' ').map { |w| w2b(w) }
        "#{op}#{dr}#{sr}#{'1' * 6}"
      end
    end

    def self.w2b(word)
      case word
      when /ADD/
        '0001'
      when /AND/
        '0101'
      when /NOT/
        '1001'
      when /R\d/
        format('%03b', word.chars[1].to_i)
      when /\$\d/
        format('%05b', word.chars[1].to_i)
      end
    end
  end
end
