import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge


@cocotb.test()
async def test_project(dut):
    """Cocotb testbench for rectangular to cylindrical conversion."""

    dut._log.info("Starting testbench for Rectangular to Cylindrical Conversion")

    # Generate a 100MHz clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset the DUT
    dut._log.info("Applying reset...")
    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    dut._log.info("Reset complete.")

    # Test cases: (x, y, expected_r)
    test_cases = [
        (3, 4, 5),
        (5, 12, 13),
        (0, 10, 10),
        (10, 0, 10),
        (7, 24, 25)
    ]

    for x, y, expected_r in test_cases:
        # Apply inputs
        dut.ui_in.value = x
        dut.uio_in.value = y
        await ClockCycles(dut.clk, 10)  # Allow processing time

        # Read output
        r_output = dut.uo_out.value.integer

        # Log results
        if r_output == expected_r:
            dut._log.info(f"PASS: x={x}, y={y} -> r={r_output} (Expected: {expected_r})")
        else:
            dut._log.error(f"FAIL: x={x}, y={y} -> r={r_output} (Expected: {expected_r})")

        # Assertion for verification
        assert r_output == expected_r, f"Test failed for inputs x={x}, y={y}"

    dut._log.info("All tests completed successfully.")
