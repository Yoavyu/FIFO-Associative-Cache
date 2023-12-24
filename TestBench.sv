`timescale 1ms/1ns  // 1000 Time delays = 1 sec

module Associative_Cache_tb ;
  reg clk, read_en, write_en, reset;
  reg [11:0] tag_num;
  reg  [11:0] write_num;
  reg [31:0] block_in;
  int i;
 
 
  
  always #5 clk = ~clk; // 100Hz clock
  always@(read_en)
    write_en = !read_en;
  
  
  Associative_Cache uut1(block_out, tag_num,block_in,write_num, read_en, write_en, reset, clk);
  
  
  initial
    
      begin
        clk = 0;
        reset = 0;
        i=0;
        read_en = 0; 
        
        
    
        while (i<100) // loading values to MM[0:99] cells 
        begin
         write_num <= i;
         block_in  <= i;
         #10 i = i + 1 ;
        end
        
        #10 read_en = 1; 
        for (int j =0; j<100; j++) // reading them from MM[0:99]
          begin
            #10 tag_num <= j;
          end
        for (int j =99; j>0; j--) // reading them from MM[99:1]
          // expected hits: 36 to 99
          begin
            #10 tag_num <= j;
          end
        
        #10 read_en = 0; //re-writing MM[0:99]
        //expected hits: 1 to 35 and 71 to 99 due to FIFO replacement policy
        for (int k =0; k<100; k++)
          begin
            #10 write_num <= k;
        	    block_in  <= 10*k;
         	
          end
         
        // reset check
        #10 read_en = 1;
        #10 reset = 1;
        #10 reset = 0; 
        $display("----- reset ------"); 
        #10 tag_num <= 50;  // reading MM[50]
        for (int m =0; m<100; m++) // reading  from MM[0:99]
          //expected hits: ONLY MM[50] (because of reset)
          begin
            #10 tag_num <= m;
          end
         #10 $stop;
      end
  
       initial
         begin
           $dumpfile("Associative_Cache_tb.vcd");
           $dumpvars(0,Associative_Cache_tb); 
         end 
  
       
endmodule 
