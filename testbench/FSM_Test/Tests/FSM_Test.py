import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock
import logging

cocotb.log.setLevel(logging.INFO)

@cocotb.test()
async def fsm_test(dut):
    S_IDLE = 0
    S_Backward = 1
    S_Forward = 2
    S_Attack_start = 3
    S_Attack_active = 4
    S_Attack_recovery = 5

    cocotb.start_soon(Clock(dut.clk, 10, units="us").start())

    async def apply_input(left=0, right=0, attack=0):
        if (left + right + attack) > 1:
            cocotb.log.warning("Applying more than one input simultaneously - FSM behavior might be unexpected.")
        dut.left.value = left
        dut.right.value = right
        dut.attack.value = attack
        await RisingEdge(dut.clk)
        await Timer(1, units="us")

    async def check_state_and_outputs(expected_state, expected_move, expected_directional_attack, expected_attack):
        await Timer(1, units="us")

        state = int(dut.state.value)
        current_move = int(dut.move_flag.value)
        current_d_attack = int(dut.directional_attack_flag.value)
        current_attack = int(dut.attack_flag.value)

        cocotb.log.info(f"Checking State: Expected={expected_state}, Got={state}")
        cocotb.log.info(f"Checking Move Flag: Expected={expected_move}, Got={current_move}")
        cocotb.log.info(f"Checking Dir Attack Flag: Expected={expected_directional_attack}, Got={current_d_attack}")
        cocotb.log.info(f"Checking Attack Flag: Expected={expected_attack}, Got={current_attack}")

        assert state == expected_state, f"State mismatch: Expected {expected_state}, Got {state}"
        assert current_move == expected_move, f"Move flag mismatch: Expected {expected_move}, Got {current_move}"
        assert current_d_attack == expected_directional_attack, f"Directional attack flag mismatch: Expected {expected_directional_attack}, Got {current_d_attack}"
        assert current_attack == expected_attack, f"Attack flag mismatch: Expected {expected_attack}, Got {current_attack}"

        cocotb.log.info(f"State {state} and outputs checked successfully.")

    cocotb.log.info("Starting FSM test sequence")

    cocotb.log.info("Applying Reset...")
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    dut.reset.value = 0
    await RisingEdge(dut.clk)
    await Timer(1, units="us")

    cocotb.log.info("Checking state after reset")
    await check_state_and_outputs(S_IDLE, 0, 0, 0)
    cocotb.log.info("Reset test successful. FSM is in IDLE.")

    cocotb.log.info("Testing IDLE -> Backward transition")
    await apply_input(left=1)
    await check_state_and_outputs(S_Backward, 1, 0, 0)

    cocotb.log.info("Testing Backward -> Forward transition")
    await apply_input(right=1)
    await check_state_and_outputs(S_Forward, 1, 0, 0)

    cocotb.log.info("Testing Forward -> IDLE transition")
    await apply_input(left=0, right=0, attack=0)
    await check_state_and_outputs(S_IDLE, 0, 0, 0)

    cocotb.log.info("Testing IDLE -> Forward transition")
    await apply_input(right=1)
    await check_state_and_outputs(S_Forward, 1, 0, 0)

    cocotb.log.info("Testing Forward -> Backward transition")
    await apply_input(left=1)
    await check_state_and_outputs(S_Backward, 1, 0, 0)

    cocotb.log.info("Testing Backward -> Attack_start transition")
    await apply_input(attack=1)
    await check_state_and_outputs(S_Attack_start, 0, 0, 1)

    cocotb.log.info("Testing Attack_start -> Attack_active transition")
    for _ in range(5):
        await apply_input(left=0, right=0, attack=0)
    await check_state_and_outputs(S_Attack_active, 0, 0, 1)

    cocotb.log.info("Testing Attack_active -> Attack_recovery transition")
    for _ in range(2):
        await apply_input(left=0, right=0, attack=0)
    await check_state_and_outputs(S_Attack_recovery, 0, 0, 0)

    cocotb.log.info("Testing Attack_recovery -> IDLE transition")
    for _ in range(16):
        await apply_input(left=0, right=0, attack=0)
    await check_state_and_outputs(S_IDLE, 0, 0, 0)

    cocotb.log.info("Testing full directional attack from Forward state")
    await apply_input(right=1)
    await check_state_and_outputs(S_Forward, 1, 0, 0)

    await apply_input(attack=1)
    await check_state_and_outputs(S_Attack_start, 0, 0, 1)

    for _ in range(5):
        await apply_input()
    await check_state_and_outputs(S_Attack_active, 0, 0, 1)

    for _ in range(2):
        await apply_input()
    await check_state_and_outputs(S_Attack_recovery, 0, 0, 0)

    for _ in range(16):
        await apply_input()
    await check_state_and_outputs(S_IDLE, 0, 0, 0)

    cocotb.log.info("FSM test sequence completed successfully.")
