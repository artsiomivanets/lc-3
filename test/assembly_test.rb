require 'test_helper'

class AssemblyTest < Minitest::Test
  def test_assembly
    asm = [
      'ADD R0 R1 R2',
      'ADD R0 R1 $1',
      'AND R0 R1 R2',
      'AND R0 R1 $1'
    ]
    binary = VM::Assembly.call(asm)
    literal_add, immediate_add, literal_and, immediate_and = binary

    assert { literal_add == 0x1042 }
    assert { immediate_add == 0x1061 }
    assert { literal_and == 0x5042 }
    assert { immediate_and == 0x5061 }
  end
end
