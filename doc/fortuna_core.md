
# Entity: fortuna_core 
- **File**: fortuna_core.vhd

## Diagram
![Diagram](fortuna_core.svg "Diagram")
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
| load_i_signal      | std_logic                      |             |
| key_i_buffer       | std_logic_vector(255 downto 0) |             |
| counter_o_signal   | std_logic_vector(127 downto 0) |             |
| data_o_buffer      | std_logic_vector(127 downto 0) |             |
| enable_signal      | std_logic                      |             |
| random_data_signal | std_logic_vector(127 downto 0) |             |
| encrypt_busy_o     | std_logic                      |             |
| encrypt_schedule   | integer range 0 to 3           |             |
| current_state      | state_type                     |             |
| next_state         | state_type                     |             |
| cipher_buffer      | buffer_type                    |             |

## Types

| Name        | Type                                                                                                                                         | Description |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| state_type  | (idle,<br><span style="padding-left:20px"> seed,<br><span style="padding-left:20px"> increment,<br><span style="padding-left:20px"> encrypt) |             |
| buffer_type |                                                                                                                                              |             |

## Processes
- unnamed: ( clk, rst )
- unnamed: ( current_state, start, encrypt_busy_o )

## Instantiations

- aes_instance: component aes_core
- counter_instance: component counter

## State machines

![Diagram_state_machine_0]( fsm_fortuna_core_00.svg "Diagram")