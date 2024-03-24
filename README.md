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

| Port name   | Direction | Type                           | Description                                                                     |
| ----------- | --------- | ------------------------------ | ------------------------------------------------------------------------------- |
| clk         | in        | std_logic                      | clock signal                                                                    |
| rst         | in        | std_logic                      | reset to idle state                                                             |
| start       | in        | std_logic                      | start fortuna algorithm : random keep generating as long as start is asserted   |
| seed_data   | in        | std_logic_vector(255 downto 0) | random seed input for the Fortuna algorithm                                     |
| done        | out       | std_logic                      | the 128-bit random generated vector is ready to be read as long as done is high |
| random_data | out       | std_logic_vector(127 downto 0) | output random data vector                                                       |

## Signals

| Name               | Type                           | Description                                            |
| ------------------ | ------------------------------ | ------------------------------------------------------ |
| local_hashed_seed  | std_logic_vector(255 downto 0) | local hash vector that is used to double hash the seed |
| local_sampled_seed | std_logic_vector(255 downto 0) | buffer that hold the input seed to SHA256              |
| local_sha_start    | std_logic                      | start SHA encryption                                   |
| local_fcore_start  | std_logic                      | start Fortuna Core encryption                          |
| local_sha_done     | std_logic                      | SHA done encrypting                                    |
| local_fcore_done   | std_logic                      | Fortuna Core done encrypting                           |
| reset_np           | std_logic                      | SHA256 module reset low                                |
| current_state      | state_type                     | mealy fsm current_state register                       |
| next_state         | state_type                     | mealy fsm next_state register                          |

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

| Port name   | Direction | Type                           | Description                                                                                 |
| ----------- | --------- | ------------------------------ | ------------------------------------------------------------------------------------------- |
| clk         | in        | std_logic                      | clock signal                                                                                |
| rst         | in        | std_logic                      | global reset signal                                                                         |
| start       | in        | std_logic                      | start fortuna algorithm : random keep generating as long as start is asserted               |
| seed_data   | in        | std_logic_vector(255 downto 0) | seed 256-bit input                                                                          |
| done        | out       | std_logic                      | done is asserted as long as the random vector is present at the output and ready to be read |
| random_data | out       | std_logic_vector(127 downto 0) | random 128-bit chunks that correspond to the generated random data                          |

## Signals

| Name               | Type                           | Description                                                                                     |
| ------------------ | ------------------------------ | ----------------------------------------------------------------------------------------------- |
| load_i_signal      | std_logic                      | load input into AES block cipher                                                                |
| key_i_buffer       | std_logic_vector(255 downto 0) | used to hold two successive AES encryptions to be used as key for the counter mode              |
| counter_o_signal   | std_logic_vector(127 downto 0) | counter output value as a 128-bit vector                                                        |
| data_o_buffer      | std_logic_vector(127 downto 0) | buffer of the encrypted 128-bit vector from the AES                                             |
| enable_signal      | std_logic                      | enable signal used to increment the counter                                                     |
| random_data_signal | std_logic_vector(127 downto 0) | output register that hold the PRNG random output vector                                         |
| encrypt_busy_o     | std_logic                      | If high, the AES is still busy encrypting                                                       |
| encrypt_schedule   | integer range 0 to 3           | variable to schedule 3 succesive encryptions: one for the output and two more to be used as key |
| current_state      | state_type                     | mealy fsm current_state register                                                                |
| next_state         | state_type                     | mealy fsm next_state register                                                                   |
| cipher_buffer      | buffer_type                    | buffer holding three encrpyted vectors : one for the output and two more to be used as key      |

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
