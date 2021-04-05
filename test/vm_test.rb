require 'test_helper'

class VMTest < Minitest::Test
  def test_ADD
    asm = [
      'ADD R0 R1 R2',
      'ADD R0 R0 $1'
    ]
    vm = VM::Main.new({
                        registers: {
                          R1: 0xF,
                          R2: 0xF
                        },
                        data: asm
                      })
    vm.run
    registers = vm.registers

    assert { registers[:R0] == 0x1F }
  end

  def test_AND
    asm = [
      'AND R0 R1 R2',
      'AND R3 R4 $0'
    ]
    vm = VM::Main.new({
                        registers: {
                          R1: 0xF,
                          R2: 0x9,
                          R4: 0xA
                        },
                        data: asm
                      })
    vm.run
    registers = vm.registers

    assert { registers[:R0] == 0x9 }
    assert { registers[:R3].zero? }
  end

  def test_NOT
    asm = [
      'NOT R0 R1'
    ]
    vm = VM::Main.new({
                        registers: {
                          R1: 0xF
                        },
                        data: asm
                      })
    vm.run
    registers = vm.registers

    assert { registers[:R0] == 0xFFF0 }
  end
end
