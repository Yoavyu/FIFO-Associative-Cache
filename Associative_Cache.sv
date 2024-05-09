
module Associative_Cache(block_out, tag_num,block_in,write_num,  read_en, write_en, reset, clk);
  input  read_en, write_en, reset;
  input  [11:0] tag_num; // wanted block number from MM
  input  [11:0] write_num; // wanted block number to write in MM
  input   clk; 
  input  [31:0] block_in;
  output reg [31:0] block_out;
  
  reg[5:0] head; // FIFO head
  reg[5:0] tail; // FIFO tail
  reg[6:0] size; // number of objects in FIFO queue
  int res[$];int res1[$];
  logic [31:0] MM[4095:0]; // 16kb main memory: 4096 blocks of 4byte. 
  logic [31:0] cache [63:0]; // 256 bytes cache: 64 blocks of 4byte.
  logic [11:0] tag [63:0]; // 12-bit represent 4096 options, for 64 cache blocks
  logic [63:0] valid_bit ; 
  
  initial
    begin  
       head = 6'd0;
       tail = 6'd0;
       size = 7'd0;
      valid_bit = valid_bit * 0 ;  
    end
  
  
  always@(posedge clk or posedge reset)
    begin
    if(!reset)
      begin  
        if(read_en)
          begin
            res = tag.find_index with (item == tag_num); // search tag_num in tag

            if ((res.size !=0) & (valid_bit[res[0]])) 
              // if tag_num is in tag - read the wanted block from Cache
              begin
                block_out = cache[res[0]];
                $display("HIT!  blk number:", tag_num, " val is:",  block_out );
              end
            else
              begin
                // if tag_num is not in tag - read the wanted block from MM
                block_out = MM[tag_num];
                $display("MISS...  blk number:", tag_num, " val is:",  block_out);
                // then: write the block in Cache (USE FIFO replacement policy)
                if(size < 64) // if Cache is not full yet
                  begin
                    cache[tail] <=  MM[tag_num];
                    tag [tail] <= tag_num ; 
                    valid_bit[tail] <= 1 ; 
                    tail <= tail + 1 ;
                    size <= size + 1 ;
                  end
                else
                  begin
                    cache[head] <=  MM[tag_num]; //if Cache is  full
                    tag [head] <= tag_num ; 
                    valid_bit[head] <= 1 ; 
                    head <= head + 1 ;
                  end
              end
          end
        if(write_en)
          begin
            res1 = tag.find_index with (item == write_num); // search write_num in tag

            if ((res1.size !=0) & (valid_bit[res[0]])) 
              // if write_num is in the tag: re-write the wanted block in Cache and also in MM
              begin
                MM[write_num] <= block_in;
                cache[res1[0]] <= block_in;
                tag [res1[0]] <= write_num ; 
                valid_bit[res1[0]] <= 1 ; 
                $display("HIT! blk number",  write_num,  " updated to val", block_in );
                
              end
            else
              begin // else: write only in MM
                MM[write_num] <= block_in;
                $display("MISS... blk number",  write_num,  " updated to val" ,block_in);
              end
          end
       end 
  	else
        begin
          //  reset :
           head <= 6'd0;
           tail <= 6'd0;
           size <= 6'd0;
      	   valid_bit <= valid_bit * 0 ;
        end
    end
    

  
  
  
  
endmodule 






