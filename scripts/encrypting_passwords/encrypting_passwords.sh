# For this to run you need to have OpenSSL and sshpass installed 

# 'yourpassword' -- your user password
# enc -aes-256-cbc -- this is an encoding type with 256-bit key cipher 
# -md sha512 -- is the cryptographic algorithm, type of hashing
# -a -- applying base-64 encoding after the encryption phase and before the decryption phase
# -pbkdf2 -- Password-Based Key Derivation Function 2 (PBKDF2) makes the encryption more difficult
# -iter 100000: number of computations used by PBKDF2
# -salt: randomly applied salt value, will allow you to encrypt the same text in different ways
# -pass pass:'encrypted.password' -- password for decrypting / encrypting your data
# > password.txt --  writes your hashed password to a txt file

# https://www.redhat.com/sysadmin/ssh-automation-sshpass


# command for encrypting
echo 'passw0rd' | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -salt -pass pass:'encrypted.password' > userpassword.txt

#command for decrypting
echo $(< password.txt) | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:'encrypted.password'