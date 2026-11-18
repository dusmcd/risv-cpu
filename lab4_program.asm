.text
# all integers are 32-bit fixed point with 18 whole bits, and 14 fractional bits
# step = half of the maximum possible answer
# initial guess = 0

#addi a7, zero, 5 	# loading syscall number for reading int
#ecall			# the raw input will be in register a0
#addi x1, a0, 0		# x1 = input

csrrw x1, 0xf00, x0	# read input from switches
slli x1, x1, 14		# shifting raw input value into whole bits

addi x2, zero, 256	# setting the step value, x2 = step
slli x2, x2, 14		# shifting raw value into whole bits
addi x3, zero, 0	# setting initial guess, x3 = guess

# start loop
loop: 	
mul x4, x3, x3		# squaring guess and loading lower bits, x4 = lower bits
mulhu x5, x3, x3	# squaring guess and loading higher bits, x5 = high bits
srli x4 ,x4, 14		# rounding down lower bits
slli x5, x5, 18		# moving the least significant 14 bits to the most significant position
or x6, x4, x5		# combining high and low (rounded), x6 = rounded fixed point number
beq x6, x1, done	# if squared guess equals input,then exit loop
bltu x6, x1, increment	# if squared guess is less than input, then add step to guess, otherwise subtract
sub x3, x3, x2
jal x0, half
increment: add x3, x3, x2 

half: srli x2, x2, 1  	# cut step in half
beq x2, zero, done	# loop stops when step = 0
jal x0, loop


# covert to decimal for display
done: addi a0, x3, 0		# load square root into a0 for processing below, 32-bit fixed point (32, 14)
lui a1, 0x1999a
addi a1, a1, -0x666             # get 1/10 (2^32 * 1/10) contstant (stored as fixed point (32, 32))
addi a2, zero, 10               # need constant 10 in a2
addi a3, zero, 0                # this will be the register that is given to hex displays

slli x1, a0, 18			# store fractional bits as 32-bit fixed point (32, 32)
srli x2, a0, 14			# store whole bits as 32-bit integer
addi x3, x0, 5			# number of loops for fractional portion
addi x4, x0, 3			# number of loops for whole portion
addi x5, x0, 16			# number of bits to shift when setting a3 for display

# loop for fractional portion
get_fraction: beq x3, x0, get_whole
mulhu x6, x1, a2		# multiply by 10 and get decimal digit
mul x1, x1, a2			# multiply by 10
sll x6, x6, x5			# shift left to correct grouping for 4 bits
or a3, a3, x6			# set register that will be displayed at the end
addi x5, x5, -4			# decrement shift amount by 4
addi x3, x3, -1			# decrement loop counter
jal x0, get_fraction

get_whole: addi x5, x0, 20
# loop for whole portion
whole_loop: beq x4, x0, exit
mul x7, x2, a1                  # get fractional bits and store in t0
mulhu x7, x7, a2                # multiply fractional part by 10 to get decimal digit
sll x7, x7, x5                  # shift left to set the correct grouping of 4 bits
or a3, a3, x7                   # set the register that will be displayed at end
mulhu x2, x2, a1                # get whole part
addi x5, x5, 4			# increment shift amount by 4
addi x4, x4, -1			# decrement loop counter
jal x0, whole_loop

exit: csrrw x0, 0xf02, a3       # write result to hex displays

