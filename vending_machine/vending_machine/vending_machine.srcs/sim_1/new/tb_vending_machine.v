`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2025 00:21:43
// Design Name: 
// Module Name: tb_vending_machine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_vending_machine;


    // Testbench signals for vending machine
    reg clk;
    reg reset;
    reg [7:0] insert_cash;
    reg [7:0] item_price;
    reg item_available;
    reg select_item;
    reg cancel;
    wire [7:0] dispensed_item;
    wire [7:0] dispensed_change;
    wire error;

    // Instantiate the vending machine module
    vending_machine_mealy vm (
        .clk(clk),
        .reset(reset),
        .insert_cash(insert_cash),
        .item_price(item_price),
        .item_available(item_available),
        .select_item(select_item),
        .cancel(cancel),
        .dispensed_item(dispensed_item),
        .dispensed_change(dispensed_change),
        .error(error)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Initial block to run test cases
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        insert_cash = 0;
        item_price = 0;
        item_available = 0;
        select_item = 0;
        cancel = 0;

        // Reset the machine
        #10 reset = 1;
        #10 reset = 0;

        // Test Case 1: Insert cash and select item
        #10 insert_cash = 50;  // Insert 50 units
        #10 select_item = 1;   // Select item
        item_available = 1;    // Item available
        item_price = 30;      // Price = 30

        #30;

        // Check if item dispensed correctly
        if (dispensed_item != 8'b1 || error != 0)
            $display("Test Case 1 Failed");
        else
            $display("Test Case 1 Passed");

        // Reset for next test
        #10 reset = 1;
        #10 reset = 0;

        // Test Case 2: Insufficient cash
        insert_cash = 20;      // Insert 20 units
        #10 select_item = 1;   // Select item
        item_price = 30;       // Price = 30
        item_available = 1;    // Item available

        #30;

        // Check for error (insufficient cash)
        if (error != 1)
            $display("Test Case 2 Failed");
        else
            $display("Test Case 2 Passed");

        // Reset for next test
        #10 reset = 1;
        #10 reset = 0;

        // Test Case 3: Cancel transaction
        insert_cash = 40;      // Insert 40 units
        #10 cancel = 1;        // Cancel transaction
        #30;

        // Check if cash is returned
        if (dispensed_change != 40)
            $display("Test Case 3 Failed");
        else
            $display("Test Case 3 Passed");

        // Reset for next test
        #10 reset = 1;
        #10 reset = 0;

        // Test Case 4: Item unavailable
        insert_cash = 50;      // Insert 50 units
        #10 select_item = 1;   // Select item
        item_price = 30;       // Price = 30
        item_available = 0;    // Item unavailable

        #30;

        // Check for error (item unavailable)
        if (error != 1)
            $display("Test Case 4 Failed");
        else
            $display("Test Case 4 Passed");

        #10 $finish;
    end




endmodule
