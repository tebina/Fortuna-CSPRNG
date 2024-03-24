# Fortuna-CSPRNG

Hardware implementation of a simplified version of the Cryptographically Secure Pseudorandom Number Generator Fortuna such as described in the book of N. Ferguson and B. Schneier:

> N. Ferguson and B. Schneier, Practical Cryptography, Wiley Publishing, Inc., 2003

However this implementation doesn't include the entropy accumulator such as described by the authors, the designer is free to implement their own entropy source in order to seed the PRNG.

The design of the top module of Fortuna-CSPRNG is depicted in the following figure :

<div style="display: flex; justify-content: center; align-items: center;">
  <img src="doc/fortuna.svg" alt="fortuna design" width="1920" height="500">
</div>

<div style="display: flex; justify-content: center; align-items: center;">
  <img src="doc/fortuna_bench.png" alt="fortuna bench">
</div>

The design generates 16 random bytes at a time:

```
Throughput = 8.65 MB/s
```

# How to run

To run the self-testing test-benches
If you have modelsim added to `$PATH` just run :

```
make
```

In the desired root directory.

# Entity: fortuna_top

- **File**: fortuna_top.vhd

## Diagram

![Diagram](doc/fortuna_top.svg "Diagram")

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

![Diagram_state_machine_0](doc/fsm_fortuna_top_00.svg "Diagram")

# Entity: fortuna_core

- **File**: fortuna_core.vhd

## Diagram

![Diagram](doc/fortuna_core.svg "Diagram")

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

![Diagram_state_machine_0](doc/fsm_fortuna_core_00.svg "Diagram")
