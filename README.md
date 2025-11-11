# FIFO-Associative-Cache
This code simulates the interaction between 16kb Main Memory and 256byte Cache Memory.
On read mode: It gets a 12-bit number that represents a block number (0 to 4095), Each block size is 4 bytes. The output is the asked block delivered from the MM or cache.
On write mode: It gets a 12-bit number representing a block number (0 to 4095), and a 4-byte value to write as the block's value.

# Cache placement policy - FIFO
If Miss - No Reread, Write No Allocate.
If Hit - Write Through  

Full project: https://www.edaplayground.com/x/ivXD
![image](https://github.com/Yoavyu/FIFO-Associative-Cache/assets/140505276/a1b4fa96-ce60-43f3-9909-75dddb284711)
