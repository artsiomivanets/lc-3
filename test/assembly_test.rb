require 'test_helper'

class AssemblyTest < Minitest::Test
  def test_literal_add
    asm = ['ADD R0 R1 R2']
    command = VM::Assembly.call(asm).first
    assert { command == 0x1042 }
  end

  def test_immediate_add
    asm = ['ADD R0 R1 $1']
    command = VM::Assembly.call(asm).first
    assert { command == 0x1061 }
  end

  def test_literal_and
    asm = ['AND R0 R1 R2']
    command = VM::Assembly.call(asm).first
    assert { command == 0x5042 }
  end

  def test_immediate_and
    asm = ['AND R0 R1 $1']
    command = VM::Assembly.call(asm).first
    assert { command == 0x5061 }
  end

  def test_not
    asm = ['NOT R0 R1']
    command = VM::Assembly.call(asm).first
    assert { command == 0x907F }
  end

  def test_br
    asm = ['BRn $1', 'BRz $2', 'BRp $3']
    neg, zer, pos = VM::Assembly.call(asm)
    assert { neg == 0x0801 }
    assert { zer == 0x0402 }
    assert { pos == 0x0203 }
  end
end
