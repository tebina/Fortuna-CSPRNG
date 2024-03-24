from Crypto.Cipher import AES
from Crypto.Hash import SHA256
import os


# Function to generate a 256-bit key using SHA256
def generate_key(seed):
    sha256 = SHA256.new()
    sha256.update(seed)
    return sha256.digest()


# Function to encrypt using AES
def aes_encrypt(key, data):
    cipher = AES.new(key, AES.MODE_ECB)
    ciphertext = cipher.encrypt(data)
    return ciphertext


# Main function
def main():
    # Generate a random 256-bit seed

    seed = bytes([0] * 32)
    print("Seed:", seed.hex())

    # Generate AES key using SHA256
    aes_key = generate_key(seed)
    aes_key = generate_key(aes_key)  # double hash
    print("AES Initial Key:", aes_key.hex())

    print("First encrypt the hashed seed with 0 of counter")
    plaintext = b"\x00" * 15 + b"\x00"  # 1st encrypt
    print("Plaintext:", plaintext.hex())

    print("First random vector")
    ciphertext = aes_encrypt(aes_key, plaintext)
    print("Ciphertext:", ciphertext.hex())

    print("AES CTR : Encrypt two more vectors to use as key")

    plaintext1 = b"\x00" * 15 + b"\x01"  # 1st encrypt
    plaintext2 = b"\x00" * 15 + b"\x02"  # 1st encrypt
    aes_cipher1 = aes_encrypt(aes_key, plaintext1)
    print("1st ciphertext:", aes_cipher1.hex())
    aes_cipher2 = aes_encrypt(aes_key, plaintext2)
    print("2nd ciphertext:", aes_cipher2.hex())
    print("new key to be used : ")
    new_key = aes_cipher1 + aes_cipher2
    print((aes_cipher1 + aes_cipher2).hex())

    plaintext3 = b"\x00" * 15 + b"\x04"
    print("generate second random vector")
    random = aes_encrypt(new_key, plaintext3)
    print("Second random vector")
    print("Ciphertext", random.hex())


if __name__ == "__main__":
    main()
