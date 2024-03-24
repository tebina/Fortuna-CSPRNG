
# Entity: fortuna_top 
- **File**: fortuna_top.vhd

## Diagram
![Diagram](fortuna_top.svg "Diagram")
## Ports

| Port name   | Direction | Type                           | Description |
| ----------- | --------- | ------------------------------ | ----------- |
| clk         | in        | std_logic                      |             |
| rst         | in        | std_logic                      |             |
| start       | in        | std_logic                      |             |
| seed_data   | in        | std_logic_vector(255 downto 0) |             |
| done        | out       | std_logic                      |             |
| random_data | out       | std_logic_vector(127 downto 0) |             |

## Signals

| Name               | Type                           | Description |
| ------------------ | ------------------------------ | ----------- |
| local_hashed_seed  | std_logic_vector(255 downto 0) |             |
| local_sampled_seed | std_logic_vector(255 downto 0) |             |
| local_sha_start    | std_logic                      |             |
| local_fcore_start  | std_logic                      |             |
| local_sha_done     | std_logic                      |             |
| local_fcore_done   | std_logic                      |             |
| reset_np           | std_logic                      |             |
| current_state      | state_type                     |             |
| next_state         | state_type                     |             |

## Types

| Name       | Type                                                                                                    | Description |
| ---------- | ------------------------------------------------------------------------------------------------------- | ----------- |
| state_type | (idle,<br><span style="padding-left:20px"> hash_seed,<br><span style="padding-left:20px"> encrypt_seed) |             |

## Processes
- unnamed: ( clk, rst )
- unnamed: ( current_state, start, local_fcore_done, local_sha_done )

## Instantiations

- fortuna_core_inst: component fortuna_core
- sha256d_inst: component sha256d

## State machines

![Diagram_state_machine_0]( fsm_fortuna_top_00.svg "Diagram")