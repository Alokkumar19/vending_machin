`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2025 00:07:15
// Design Name: 
// Module Name: vending_machine_mealy
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


module vending_machine_mealy(
   input clk, // Clock signal
 input reset, // Reset signal
 input [7:0] insert_cash, // Cash inserted by user (8-bit value)
 input [7:0] item_price, // Price of the selected item
 input item_available, // Item availability flag
 input select_item, // Item selection input
 input cancel, // Transaction cancel input
 output reg [7:0] dispensed_item, // Dispensed item value (if any)
 output reg [7:0] dispensed_change, // Change to be dispensed (if any)
 output reg error // Error flag (insufficient cash or unavailable item)

    );
    
   // Define states with regular registers
reg [2:0] current_state, next_state;

 // State definitions
 parameter READY = 3'b000,
 CASH_COLLECTED = 3'b001,
 DISPENSE_CHANGE = 3'b010,
 DISPENSE_ITEM = 3'b011,
 TRANSACTION_CANCELLED = 3'b100;

 // Sequential logic to update the state on clock edges (sensitive to clk and reset)
 always @(posedge clk or posedge reset) begin
 if (reset) begin
 // Default outputs
 dispensed_item = 8'b0;
 dispensed_change = 8'b0;
 error = 1'b0;
 current_state <= READY; // Reset to READY state

 end
 else
 current_state <= next_state; // Otherwise update the current state
 end

// Combinational logic to determine next state and outputs (sensitive to inputs and current state)

 always @(insert_cash or item_price or item_available or select_item or cancel or current_state) begin //ignore item_price & item_available


 // Logic based on the current state
 case (current_state)
 READY: begin

 if (insert_cash > 0 && dispensed_change == 0 && dispensed_item == 0) begin
 $display("Cash collected select an Item");
 next_state = CASH_COLLECTED ;// Move to CASH_COLLECTED state S1
 end  

else
 next_state = READY ; //REMAIN AT THE SAME STATE S0

 end

 CASH_COLLECTED: begin

 if (select_item && item_available && !cancel) begin
 $display("Item Selected");
 // Dispense the item
 if (insert_cash > item_price) begin
 $display("Cash Inserted is greater than Item price please collect change");
 next_state = DISPENSE_CHANGE; // Dispense change
 end
 else if(insert_cash == item_price) begin
 next_state = DISPENSE_ITEM; // Proceed to dispense item
 end
 else begin
 $display("Insufficient cash");
 error = 1'b1;
 next_state = TRANSACTION_CANCELLED; // Insufficient cash, error in validation, Transaction will be cancelled
 end
end
 else if (cancel) begin
 $display("User Cancelled the transaaction");
 next_state = TRANSACTION_CANCELLED; // Transaction cancelled, return cash
 end
 else if (select_item && !item_available) begin
 $display("Selected Item is Unavailable");
 next_state = TRANSACTION_CANCELLED; // Transacti
    error = 1'b1;

 end
 end
 // if (insert_cash >= item_price) begin

 DISPENSE_CHANGE: begin
 dispensed_change = insert_cash - item_price; // Dispense change to the user

 $display("Change : %0d",dispensed_change);
 next_state = DISPENSE_ITEM; // After dispensing change, dispense Item
 end

 DISPENSE_ITEM: begin
 $display("Dispensing Item");
 dispensed_item = 8'b1; // Dispense the item, Dummy Item for now
 next_state = READY; // After dispensing the item, return to READY state
 dispensed_change = 0; //Reset
 end

 TRANSACTION_CANCELLED: begin
 $display("Transaction Cancelled,Collect Cash");
     dispensed_change = insert_cash;
 next_state = READY; // Return to READY state
 end

 default: begin next_state = READY; // Default state is READY
 dispensed_item = 8'b0;
 dispensed_change = 8'b0;
 error = 1'b0;
 end
 endcase
 end

endmodule
